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
    
    // Check for DIP buying opportunity
    async checkForDipOpportunity(strategy, priceHistory, currentPrice) {
        if (priceHistory.length < 2) {
            return; // Need at least 2 price points
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
            console.log(`   🚀 Executing DIP buy...`);
            
            await this.executeDipBuy(strategy, currentPrice);
        }
    }
    
    // Execute a DIP buy trade
    async executeDipBuy(strategy, entryPrice) {
        try {
            console.log(`🔄 Executing DIP buy: ${strategy.tradeAmount} WLD → ${strategy.tokenSymbol}`);
            
            // Execute the trade using Sinclave Enhanced Engine
            const result = await this.sinclaveEngine.executeOptimizedSwap(
                strategy.walletObject,
                this.WLD_ADDRESS,
                strategy.targetToken,
                strategy.tradeAmount,
                strategy.maxSlippage
            );
            
            if (result && result.success) {
                // Create position record
                const position = {
                    id: `pos_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`,
                    strategyId: strategy.id,
                    tokenAddress: strategy.targetToken,
                    status: 'open',
                    
                    // Entry data
                    entryPrice: entryPrice,
                    entryAmountWLD: strategy.tradeAmount,
                    entryAmountToken: parseFloat(result.tokensReceived || result.amountOut || 0),
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
                
                console.log(`✅ DIP buy executed successfully!`);
                console.log(`   📊 Position: ${position.id}`);
                console.log(`   💰 Entry: ${strategy.tradeAmount} WLD → ${position.entryAmountToken} tokens`);
                console.log(`   📈 Entry Price: ${entryPrice.toFixed(8)} WLD per token`);
                console.log(`   🎯 Profit Target: ${position.targetPrice.toFixed(8)} WLD per token`);
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
    
    // Check position for profit target
    async checkPositionForProfit(strategy, position) {
        try {
            // Get current WLD value of the position using reverse swap quote
            const reverseQuote = await this.sinclaveEngine.getHoldStationQuote(
                strategy.targetToken,
                this.WLD_ADDRESS,
                position.entryAmountToken,
                strategy.walletObject.address
            );
            
            if (reverseQuote && reverseQuote.expectedOutput) {
                const currentWLDValue = parseFloat(reverseQuote.expectedOutput);
                const unrealizedPnL = currentWLDValue - position.entryAmountWLD;
                const unrealizedPnLPercent = (unrealizedPnL / position.entryAmountWLD) * 100;
                
                // Update position data
                position.unrealizedPnL = unrealizedPnL;
                position.unrealizedPnLPercent = unrealizedPnLPercent;
                
                // Check if profit target is reached
                if (unrealizedPnLPercent >= strategy.profitTarget) {
                    console.log(`🎯 PROFIT TARGET REACHED for ${strategy.name}!`);
                    console.log(`   📊 Profit: ${unrealizedPnLPercent.toFixed(2)}% (Target: ${strategy.profitTarget}%)`);
                    console.log(`   💰 Expected return: ${currentWLDValue.toFixed(6)} WLD`);
                    console.log(`   🚀 Executing profit sell...`);
                    
                    await this.executeProfitSell(strategy, position, currentWLDValue);
                }
            }
            
        } catch (error) {
            console.error(`❌ Error checking position ${position.id}:`, error.message);
        }
    }
    
    // Execute profit sell
    async executeProfitSell(strategy, position, expectedWLDReturn) {
        try {
            console.log(`🔄 Executing profit sell: ${position.entryAmountToken} ${strategy.tokenSymbol} → WLD`);
            
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