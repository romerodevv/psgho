const { ethers } = require('ethers');
const EventEmitter = require('events');
const fs = require('fs');
const path = require('path');

class StrategyBuilder extends EventEmitter {
    constructor(tradingEngine, sinclaveEngine, config) {
        super();
        this.tradingEngine = tradingEngine;
        this.sinclaveEngine = sinclaveEngine;
        this.config = config;
        
        // Strategy storage
        this.customStrategies = new Map(); // strategyId -> strategy config
        this.activeStrategies = new Map(); // strategyId -> execution state
        this.strategyPositions = new Map(); // strategyId -> positions array
        this.priceHistory = new Map(); // tokenAddress -> price history for DIP detection
        this.monitoringIntervals = new Map(); // strategyId -> interval ID
        
        // File paths
        this.strategiesPath = path.join(process.cwd(), 'custom-strategies.json');
        this.strategyPositionsPath = path.join(process.cwd(), 'strategy-positions.json');
        
        // WLD token address
        this.WLD_ADDRESS = '0x2cfc85d8e48f8eab294be644d9e25c3030863003';
        
        // Load existing strategies
        this.loadStrategies();
        
        console.log('🎯 Strategy Builder initialized');
    }
    
    // Create a new custom strategy
    createStrategy(config) {
        const strategyId = `strategy_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
        
        const strategy = {
            id: strategyId,
            name: config.name || `Strategy for ${config.tokenSymbol}`,
            
            // Pair configuration
            baseToken: this.WLD_ADDRESS, // Always WLD
            targetToken: config.targetToken,
            tokenSymbol: config.tokenSymbol,
            
            // Trading parameters
            dipThreshold: config.dipThreshold || 15, // % drop to trigger buy
            profitTarget: config.profitTarget || 1, // % gain to trigger sell
            tradeAmount: config.tradeAmount || 0.1, // WLD amount per trade
            maxSlippage: config.maxSlippage || 1, // Max slippage %
            
            // Monitoring settings
            priceCheckInterval: config.priceCheckInterval || 60000, // 1 minute for DIP detection
            dipTimeframe: config.dipTimeframe || 60000, // Look back 1 minute for DIP
            
            // Strategy state
            isActive: false,
            createdAt: Date.now(),
            lastExecuted: null,
            
            // Performance tracking
            totalTrades: 0,
            successfulTrades: 0,
            totalProfit: 0,
            positions: []
        };
        
        this.customStrategies.set(strategyId, strategy);
        this.saveStrategies();
        
        console.log(`✅ Strategy created: ${strategy.name} (${strategyId})`);
        console.log(`   📊 Pair: WLD → ${config.tokenSymbol}`);
        console.log(`   📉 DIP Trigger: ${config.dipThreshold}% drop`);
        console.log(`   📈 Profit Target: ${config.profitTarget}%`);
        console.log(`   💰 Trade Amount: ${config.tradeAmount} WLD`);
        
        return strategy;
    }
    
    // Start monitoring a strategy
    startStrategy(strategyId, walletObject) {
        const strategy = this.customStrategies.get(strategyId);
        if (!strategy) {
            throw new Error(`Strategy ${strategyId} not found`);
        }
        
        if (strategy.isActive) {
            throw new Error(`Strategy ${strategy.name} is already active`);
        }
        
        strategy.isActive = true;
        strategy.walletObject = walletObject;
        
        // Initialize price history
        if (!this.priceHistory.has(strategy.targetToken)) {
            this.priceHistory.set(strategy.targetToken, []);
        }
        
        // Start monitoring interval
        const intervalId = setInterval(async () => {
            try {
                await this.monitorStrategy(strategyId);
            } catch (error) {
                console.error(`❌ Error monitoring strategy ${strategy.name}:`, error.message);
            }
        }, strategy.priceCheckInterval);
        
        this.monitoringIntervals.set(strategyId, intervalId);
        this.activeStrategies.set(strategyId, {
            startTime: Date.now(),
            lastCheck: null,
            checksPerformed: 0
        });
        
        console.log(`🚀 Started strategy: ${strategy.name}`);
        console.log(`   🔄 Monitoring every ${strategy.priceCheckInterval / 1000} seconds`);
        console.log(`   📊 Looking for ${strategy.dipThreshold}% DIP in ${strategy.dipTimeframe / 1000}s timeframe`);
        console.log(`   ⏳ WAITING for price drop - will NOT buy until DIP detected`);
        
        this.saveStrategies();
        return strategy;
    }
    
    // Stop monitoring a strategy
    stopStrategy(strategyId) {
        const strategy = this.customStrategies.get(strategyId);
        if (!strategy) {
            throw new Error(`Strategy ${strategyId} not found`);
        }
        
        strategy.isActive = false;
        
        // Clear monitoring interval
        const intervalId = this.monitoringIntervals.get(strategyId);
        if (intervalId) {
            clearInterval(intervalId);
            this.monitoringIntervals.delete(strategyId);
        }
        
        this.activeStrategies.delete(strategyId);
        
        console.log(`🛑 Stopped strategy: ${strategy.name}`);
        this.saveStrategies();
        return strategy;
    }
    
    // Monitor a strategy for DIP opportunities and profit targets
    async monitorStrategy(strategyId) {
        const strategy = this.customStrategies.get(strategyId);
        const activeState = this.activeStrategies.get(strategyId);
        
        if (!strategy || !activeState) return;
        
        activeState.lastCheck = Date.now();
        activeState.checksPerformed++;
        
        try {
            // Get current price using HoldStation SDK
            const currentPrice = await this.getCurrentPrice(strategy.targetToken);
            
            // Store price in history
            const priceHistory = this.priceHistory.get(strategy.targetToken);
            priceHistory.push({
                timestamp: Date.now(),
                price: currentPrice
            });
            
            // Keep only relevant history (based on dipTimeframe)
            const cutoffTime = Date.now() - strategy.dipTimeframe;
            while (priceHistory.length > 0 && priceHistory[0].timestamp < cutoffTime) {
                priceHistory.shift();
            }
            
            // Check for open positions first
            const openPositions = strategy.positions.filter(p => p.status === 'open');
            
            if (openPositions.length > 0) {
                // Monitor existing positions for profit targets
                for (const position of openPositions) {
                    await this.checkPositionForProfit(strategy, position);
                }
            } else {
                // Look for DIP buying opportunities
                await this.checkForDipOpportunity(strategy, priceHistory, currentPrice);
            }
            
            // Periodic status update
            if (activeState.checksPerformed % 10 === 0) {
                console.log(`📊 Strategy ${strategy.name} status:`);
                console.log(`   🔄 Checks: ${activeState.checksPerformed}`);
                console.log(`   💰 Positions: ${openPositions.length} open`);
                console.log(`   📈 Current Price: ${currentPrice.toFixed(8)} WLD per token`);
                
                if (openPositions.length === 0) {
                    // No positions yet - show DIP detection status
                    if (priceHistory.length >= 2) {
                        const highestPrice = Math.max(...priceHistory.map(p => p.price));
                        const currentDrop = ((highestPrice - currentPrice) / highestPrice) * 100;
                        const remainingDrop = strategy.dipThreshold - currentDrop;
                        
                        if (remainingDrop > 0) {
                            console.log(`   📉 Need ${remainingDrop.toFixed(2)}% more drop for INITIAL DIP buy (${currentDrop.toFixed(2)}% / ${strategy.dipThreshold}%)`);
                        } else {
                            console.log(`   ⚠️ DIP threshold reached but no buy executed - checking conditions...`);
                        }
                    } else {
                        console.log(`   📊 Building price history... (${priceHistory.length}/2 points)`);
                    }
                } else {
                    // Show average price strategy status
                    const totalWLD = openPositions.reduce((sum, pos) => sum + pos.entryAmountWLD, 0);
                    const totalTokens = openPositions.reduce((sum, pos) => sum + pos.entryAmountToken, 0);
                    const averagePrice = totalWLD / totalTokens;
                    const targetPrice = averagePrice * (1 + strategy.profitTarget / 100);
                    
                    console.log(`   📊 AVERAGE PRICE STRATEGY:`);
                    console.log(`      💰 Total Investment: ${totalWLD.toFixed(6)} WLD`);
                    console.log(`      📊 Average Price: ${averagePrice.toFixed(8)} WLD per token`);
                    console.log(`      🎯 Target Price: ${targetPrice.toFixed(8)} WLD per token`);
                    
                    if (currentPrice <= averagePrice) {
                        console.log(`      ✅ Current price BELOW average - will buy on next ${strategy.dipThreshold}% DIP`);
                    } else {
                        console.log(`      ⏳ Current price ABOVE average - holding positions, no buying`);
                    }
                    
                    if (currentPrice >= targetPrice) {
                        console.log(`      🚀 PROFIT TARGET REACHED - will sell all positions!`);
                    } else {
                        const profitNeeded = ((targetPrice - currentPrice) / currentPrice) * 100;
                        console.log(`      📈 Need ${profitNeeded.toFixed(2)}% more gain for profit target`);
                    }
                }
            }
            
        } catch (error) {
            console.error(`❌ Error monitoring strategy ${strategy.name}:`, error.message);
        }
    }
    
    // Get current price for a token (WLD per token)
    async getCurrentPrice(tokenAddress) {
        if (this.sinclaveEngine) {
            try {
                // Get price using reverse swap quote: 1 token → WLD
                const quote = await this.sinclaveEngine.getHoldStationQuote(
                    tokenAddress,
                    this.WLD_ADDRESS,
                    1, // 1 token
                    '0x0000000000000000000000000000000000000001' // dummy receiver
                );
                
                if (quote && quote.expectedOutput) {
                    return parseFloat(quote.expectedOutput);
                }
            } catch (error) {
                console.log(`⚠️ Enhanced price discovery failed: ${error.message}`);
            }
        }
        
        // Fallback to standard engine
        const priceData = await this.tradingEngine.getTokenPrice(tokenAddress);
        return priceData.price;
    }
    
    // Check for DIP buying opportunity with AVERAGE PRICE PROTECTION
    async checkForDipOpportunity(strategy, priceHistory, currentPrice) {
        if (priceHistory.length < 2) {
            return; // Need at least 2 price points
        }
        
        // Calculate our current average price from existing positions
        const openPositions = strategy.positions.filter(p => p.status === 'open');
        let averagePrice = null;
        
        if (openPositions.length > 0) {
            // Calculate weighted average price from all open positions
            let totalWLD = 0;
            let totalTokens = 0;
            
            openPositions.forEach(pos => {
                totalWLD += pos.entryAmountWLD;
                totalTokens += pos.entryAmountToken;
            });
            
            // Average price = total WLD spent / total tokens received
            averagePrice = totalWLD / totalTokens;
            
            console.log(`📊 Current Average Price: ${averagePrice.toFixed(8)} WLD per token`);
            console.log(`📊 Current Market Price: ${currentPrice.toFixed(8)} WLD per token`);
            
            // CRITICAL: Only buy if current price is AT OR BELOW our average price
            if (currentPrice > averagePrice) {
                console.log(`⚠️  Price Protection: Current price (${currentPrice.toFixed(8)}) is HIGHER than average (${averagePrice.toFixed(8)})`);
                console.log(`   🚫 NOT buying - we only buy when price is same or lower than our average`);
                console.log(`   📊 We maintain our position and wait for:`);
                console.log(`      • Price to drop to/below average: ${averagePrice.toFixed(8)} WLD`);
                console.log(`      • OR profit target reached: ${(averagePrice * (1 + strategy.profitTarget / 100)).toFixed(8)} WLD`);
                return;
            }
            
            console.log(`✅ Price Protection: Current price (${currentPrice.toFixed(8)}) is LOWER than average (${averagePrice.toFixed(8)})`);
            console.log(`   📉 This will IMPROVE our average price - good DIP buy opportunity!`);
        }
        
        // Find the highest price in the timeframe
        const highestPrice = Math.max(...priceHistory.map(p => p.price));
        
        // Calculate percentage drop from highest price
        const priceDrop = ((highestPrice - currentPrice) / highestPrice) * 100;
        
        if (priceDrop >= strategy.dipThreshold) {
            console.log(`📉 DIP DETECTED for ${strategy.name}!`);
            console.log(`   📊 Price drop: ${priceDrop.toFixed(2)}% (Target: ${strategy.dipThreshold}%)`);
            console.log(`   📈 High: ${highestPrice.toFixed(8)} WLD`);
            console.log(`   📉 Current: ${currentPrice.toFixed(8)} WLD`);
            
            if (averagePrice) {
                const avgComparison = ((currentPrice - averagePrice) / averagePrice) * 100;
                console.log(`   📊 vs Average: ${avgComparison >= 0 ? '+' : ''}${avgComparison.toFixed(2)}% (${currentPrice <= averagePrice ? '✅ GOOD' : '❌ TOO HIGH'})`);
            }
            
            console.log(`   🚀 Executing DIP buy...`);
            await this.executeDipBuy(strategy, currentPrice, averagePrice);
        }
    }
    
    // Execute a DIP buy trade with AVERAGE PRICE TRACKING
    async executeDipBuy(strategy, entryPrice, previousAveragePrice) {
        try {
            console.log(`🔄 Executing DIP buy: ${strategy.tradeAmount} WLD → ${strategy.targetTokenSymbol}`);
            
            // Execute the trade using Sinclave Enhanced Engine
            const result = await this.sinclaveEngine.executeOptimizedSwap(
                strategy.walletObject,
                this.WLD_ADDRESS,
                strategy.targetToken,
                strategy.tradeAmount,
                strategy.maxSlippage
            );
            
            if (result && result.success) {
                const tokensReceived = parseFloat(result.tokensReceived || result.amountOut || 0);
                const actualEntryPrice = strategy.tradeAmount / tokensReceived; // Actual price paid
                
                // Create position record
                const position = {
                    id: `pos_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`,
                    strategyId: strategy.id,
                    tokenAddress: strategy.targetToken,
                    status: 'open',
                    
                    // Entry data
                    entryPrice: actualEntryPrice, // Use actual executed price
                    entryAmountWLD: strategy.tradeAmount,
                    entryAmountToken: tokensReceived,
                    entryTimestamp: Date.now(),
                    entryTxHash: result.transactionHash || result.txHash,
                    
                    // Target data
                    profitTarget: strategy.profitTarget,
                    targetPrice: entryPrice * (1 + strategy.profitTarget / 100),
                    
                    // Performance tracking
                    unrealizedPnL: 0,
                    unrealizedPnLPercent: 0
                };
                
                strategy.positions.push(position);
                strategy.totalTrades++;
                strategy.lastExecuted = Date.now();
                
                // Calculate new average price after this purchase
                const allPositions = strategy.positions.filter(p => p.status === 'open');
                const totalWLD = allPositions.reduce((sum, pos) => sum + pos.entryAmountWLD, 0);
                const totalTokens = allPositions.reduce((sum, pos) => sum + pos.entryAmountToken, 0);
                const newAveragePrice = totalWLD / totalTokens;
                const newTargetPrice = newAveragePrice * (1 + strategy.profitTarget / 100);
                
                console.log(`✅ DIP buy executed successfully!`);
                console.log(`   📊 Position: ${position.id}`);
                console.log(`   💰 Entry: ${strategy.tradeAmount} WLD → ${position.entryAmountToken.toFixed(6)} tokens`);
                console.log(`   📈 Entry Price: ${actualEntryPrice.toFixed(8)} WLD per token`);
                
                if (previousAveragePrice) {
                    console.log(`   📊 Previous Avg: ${previousAveragePrice.toFixed(8)} WLD per token`);
                    console.log(`   📊 New Average: ${newAveragePrice.toFixed(8)} WLD per token`);
                    const improvement = ((previousAveragePrice - newAveragePrice) / previousAveragePrice) * 100;
                    console.log(`   📉 Average improved by: ${improvement.toFixed(2)}%`);
                } else {
                    console.log(`   📊 Initial Average: ${newAveragePrice.toFixed(8)} WLD per token`);
                }
                
                console.log(`   🎯 New Profit Target: ${newTargetPrice.toFixed(8)} WLD per token (${strategy.profitTarget}%)`);
                console.log(`   💼 Total Positions: ${allPositions.length}`);
                console.log(`   💰 Total Investment: ${totalWLD.toFixed(6)} WLD`);
                console.log(`   🧾 TX: ${position.entryTxHash}`);
                
                this.saveStrategies();
                this.emit('dipBuyExecuted', { strategy, position, result });
                
            } else {
                throw new Error('DIP buy execution failed');
            }
            
        } catch (error) {
            console.error(`❌ DIP buy failed for ${strategy.name}:`, error.message);
            this.emit('dipBuyFailed', { strategy, error: error.message });
        }
    }
    
    // Check position for profit target based on AVERAGE PRICE
    async checkPositionForProfit(strategy, position) {
        try {
            // Calculate current average price from all open positions
            const openPositions = strategy.positions.filter(p => p.status === 'open');
            let totalWLD = 0;
            let totalTokens = 0;
            
            openPositions.forEach(pos => {
                totalWLD += pos.entryAmountWLD;
                totalTokens += pos.entryAmountToken;
            });
            
            const averagePrice = totalWLD / totalTokens;
            const targetPrice = averagePrice * (1 + strategy.profitTarget / 100);
            
            // Get current market price using a small test amount
            const testQuote = await this.sinclaveEngine.getHoldStationQuote(
                strategy.targetToken,
                this.WLD_ADDRESS,
                1, // 1 token to get price per token
                strategy.walletObject.address
            );
            
            if (testQuote && testQuote.expectedOutput) {
                const currentPrice = parseFloat(testQuote.expectedOutput); // WLD per token
                
                // Calculate total portfolio value at current price
                const totalCurrentValue = totalTokens * currentPrice;
                const unrealizedPnL = totalCurrentValue - totalWLD;
                const unrealizedPnLPercent = (unrealizedPnL / totalWLD) * 100;
                
                // Update position data
                position.unrealizedPnL = unrealizedPnL;
                position.unrealizedPnLPercent = unrealizedPnLPercent;
                
                console.log(`📊 Portfolio Status for ${strategy.name}:`);
                console.log(`   📊 Average Price: ${averagePrice.toFixed(8)} WLD per token`);
                console.log(`   📊 Current Price: ${currentPrice.toFixed(8)} WLD per token`);
                console.log(`   📊 Target Price: ${targetPrice.toFixed(8)} WLD per token`);
                console.log(`   💰 Total Investment: ${totalWLD.toFixed(6)} WLD`);
                console.log(`   📈 Current Value: ${totalCurrentValue.toFixed(6)} WLD`);
                console.log(`   💹 Unrealized P&L: ${unrealizedPnL.toFixed(6)} WLD (${unrealizedPnLPercent.toFixed(2)}%)`);
                
                // Check if profit target is reached BASED ON AVERAGE PRICE
                if (currentPrice >= targetPrice) {
                    console.log(`🎯 PROFIT TARGET REACHED for ${strategy.name}!`);
                    console.log(`   📊 Current price (${currentPrice.toFixed(8)}) >= Target (${targetPrice.toFixed(8)})`);
                    console.log(`   📊 Portfolio profit: ${unrealizedPnLPercent.toFixed(2)}% (Target: ${strategy.profitTarget}%)`);
                    console.log(`   💰 Expected return: ${totalCurrentValue.toFixed(6)} WLD`);
                    console.log(`   🚀 Executing profit sell for ALL positions...`);
                    
                    // Sell ALL positions since we calculate profit based on average
                    await this.executeProfitSellAll(strategy, openPositions, currentPrice);
                }
            }
            
        } catch (error) {
            console.error(`❌ Error checking position ${position.id}:`, error.message);
        }
    }
    
    // Execute profit sell for ALL positions (based on average price strategy)
    async executeProfitSellAll(strategy, positions, currentPrice) {
        try {
            // Calculate total tokens to sell
            let totalTokensToSell = 0;
            positions.forEach(pos => {
                totalTokensToSell += pos.entryAmountToken;
            });
            
            console.log(`🔄 Executing profit sell: ${totalTokensToSell} ${strategy.targetTokenSymbol} → WLD`);
            console.log(`   📊 Selling ${positions.length} positions at average profit target`);
            
            // Execute the reverse trade for ALL tokens
            const result = await this.sinclaveEngine.executeOptimizedSwap(
                strategy.walletObject,
                strategy.targetToken,
                this.WLD_ADDRESS,
                totalTokensToSell,
                strategy.maxSlippage
            );
            
            if (result && result.success) {
                const wldReceived = parseFloat(result.tokensReceived || result.amountOut || 0);
                const totalInvested = positions.reduce((sum, pos) => sum + pos.entryAmountWLD, 0);
                const realizedPnL = wldReceived - totalInvested;
                const realizedPnLPercent = (realizedPnL / totalInvested) * 100;
                
                // Mark ALL positions as closed
                positions.forEach(pos => {
                    pos.status = 'closed';
                    pos.exitPrice = currentPrice;
                    pos.exitAmountWLD = (pos.entryAmountWLD / totalInvested) * wldReceived; // Proportional
                    pos.exitTimestamp = Date.now();
                    pos.exitTxHash = result.transactionHash || result.txHash;
                    pos.realizedPnL = pos.exitAmountWLD - pos.entryAmountWLD;
                    pos.realizedPnLPercent = (pos.realizedPnL / pos.entryAmountWLD) * 100;
                });
                
                // Update strategy statistics
                strategy.successfulTrades++;
                strategy.totalProfit += realizedPnL;
                strategy.lastExecuted = Date.now();
                
                console.log(`✅ Profit sell executed successfully!`);
                console.log(`   📊 Sold: ${totalTokensToSell} tokens → ${wldReceived.toFixed(6)} WLD`);
                console.log(`   💰 Total Invested: ${totalInvested.toFixed(6)} WLD`);
                console.log(`   💹 Realized P&L: ${realizedPnL.toFixed(6)} WLD (${realizedPnLPercent.toFixed(2)}%)`);
                console.log(`   🧾 TX: ${result.transactionHash || result.txHash}`);
                
                this.saveStrategies();
                this.emit('profitSellExecuted', { strategy, positions, result, realizedPnL });
                
            } else {
                throw new Error('Profit sell execution failed');
            }
            
        } catch (error) {
            console.error(`❌ Profit sell failed for ${strategy.name}:`, error.message);
            this.emit('profitSellFailed', { strategy, error: error.message });
        }
    }

    // Execute profit sell (legacy - keeping for compatibility)
    async executeProfitSell(strategy, position, expectedWLDReturn) {
        try {
            console.log(`🔄 Executing profit sell: ${position.entryAmountToken} ${strategy.targetTokenSymbol} → WLD`);
            
            // Execute the reverse trade
            const result = await this.sinclaveEngine.executeOptimizedSwap(
                strategy.walletObject,
                strategy.targetToken,
                this.WLD_ADDRESS,
                position.entryAmountToken,
                strategy.maxSlippage
            );
            
            if (result && result.success) {
                const actualWLDReceived = parseFloat(result.tokensReceived || result.amountOut || 0);
                const realizedPnL = actualWLDReceived - position.entryAmountWLD;
                const realizedPnLPercent = (realizedPnL / position.entryAmountWLD) * 100;
                
                // Update position
                position.status = 'closed';
                position.exitTimestamp = Date.now();
                position.exitTxHash = result.transactionHash || result.txHash;
                position.exitAmountWLD = actualWLDReceived;
                position.realizedPnL = realizedPnL;
                position.realizedPnLPercent = realizedPnLPercent;
                
                // Update strategy stats
                strategy.successfulTrades++;
                strategy.totalProfit += realizedPnL;
                
                console.log(`✅ Profit sell executed successfully!`);
                console.log(`   💰 Return: ${actualWLDReceived.toFixed(6)} WLD`);
                console.log(`   📊 Profit: ${realizedPnL.toFixed(6)} WLD (${realizedPnLPercent.toFixed(2)}%)`);
                console.log(`   🧾 TX: ${position.exitTxHash}`);
                
                this.saveStrategies();
                this.emit('profitSellExecuted', { strategy, position, result });
                
            } else {
                throw new Error('Profit sell execution failed');
            }
            
        } catch (error) {
            console.error(`❌ Profit sell failed for position ${position.id}:`, error.message);
            this.emit('profitSellFailed', { strategy, position, error: error.message });
        }
    }
    
    // Get all strategies
    getAllStrategies() {
        return Array.from(this.customStrategies.values());
    }
    
    // Check if a strategy is active
    isStrategyActive(strategyId) {
        const strategy = this.customStrategies.get(strategyId);
        return strategy && strategy.isActive === true;
    }
    
    // Get strategy by ID
    getStrategy(strategyId) {
        return this.customStrategies.get(strategyId);
    }
    
    // Delete strategy
    deleteStrategy(strategyId) {
        const strategy = this.customStrategies.get(strategyId);
        if (!strategy) {
            throw new Error(`Strategy ${strategyId} not found`);
        }
        
        // Stop if active
        if (strategy.isActive) {
            this.stopStrategy(strategyId);
        }
        
        this.customStrategies.delete(strategyId);
        this.saveStrategies();
        
        console.log(`🗑️ Deleted strategy: ${strategy.name}`);
        return true;
    }
    
    // Save strategies to file
    saveStrategies() {
        try {
            const strategiesData = {};
            for (const [id, strategy] of this.customStrategies.entries()) {
                // Don't save wallet object (contains private key)
                const { walletObject, ...safeStrategy } = strategy;
                strategiesData[id] = safeStrategy;
            }
            
            fs.writeFileSync(this.strategiesPath, JSON.stringify(strategiesData, null, 2));
        } catch (error) {
            console.error('❌ Error saving strategies:', error.message);
        }
    }
    
    // Load strategies from file
    loadStrategies() {
        try {
            if (fs.existsSync(this.strategiesPath)) {
                const strategiesData = JSON.parse(fs.readFileSync(this.strategiesPath, 'utf8'));
                for (const [id, strategy] of Object.entries(strategiesData)) {
                    this.customStrategies.set(id, strategy);
                }
                console.log(`📂 Loaded ${Object.keys(strategiesData).length} custom strategies`);
            }
        } catch (error) {
            console.error('❌ Error loading strategies:', error.message);
        }
    }
    
    // Get strategy statistics
    getStrategyStatistics() {
        const strategies = this.getAllStrategies();
        const activeStrategies = strategies.filter(s => s.isActive);
        const totalTrades = strategies.reduce((sum, s) => sum + s.totalTrades, 0);
        const successfulTrades = strategies.reduce((sum, s) => sum + s.successfulTrades, 0);
        const totalProfit = strategies.reduce((sum, s) => sum + s.totalProfit, 0);
        
        return {
            totalStrategies: strategies.length,
            activeStrategies: activeStrategies.length,
            totalTrades,
            successfulTrades,
            successRate: totalTrades > 0 ? (successfulTrades / totalTrades * 100).toFixed(2) : '0.00',
            totalProfit: totalProfit.toFixed(6),
            strategies: strategies.map(s => ({
                id: s.id,
                name: s.name,
                tokenSymbol: s.tokenSymbol,
                isActive: s.isActive,
                totalTrades: s.totalTrades,
                successfulTrades: s.successfulTrades,
                totalProfit: s.totalProfit.toFixed(6),
                openPositions: s.positions.filter(p => p.status === 'open').length
            }))
        };
    }
}

module.exports = StrategyBuilder;