const fs = require('fs');
const path = require('path');
const EventEmitter = require('events');

class PriceDatabase extends EventEmitter {
    constructor(sinclaveEngine, config) {
        super();
        this.sinclaveEngine = sinclaveEngine;
        this.config = config;
        
        // Core settings
        this.WLD_ADDRESS = '0x2cfc85d8e48f8eab294be644d9e25c3030863003';
        this.updateInterval = 30000; // Update every 30 seconds
        this.maxHistoryAge = 7 * 24 * 60 * 60 * 1000; // 7 days
        
        // File paths
        this.priceDbPath = path.join(process.cwd(), 'price-database.json');
        this.triggersPath = path.join(process.cwd(), 'price-triggers.json');
        
        // In-memory data structures
        this.priceData = new Map(); // tokenAddress -> price history
        this.activeTriggers = new Map(); // triggerId -> trigger config
        this.trackedTokens = new Set(); // Set of token addresses to track
        
        // Background monitoring
        this.isRunning = false;
        this.monitoringInterval = null;
        
        // Load existing data
        this.loadPriceDatabase();
        this.loadTriggers();
        
        console.log('📊 Price Database initialized');
    }
    
    // Add token to tracking list
    addToken(tokenAddress, tokenInfo = {}) {
        if (!tokenAddress || tokenAddress.toLowerCase() === this.WLD_ADDRESS.toLowerCase()) {
            return; // Don't track WLD against itself
        }
        
        this.trackedTokens.add(tokenAddress.toLowerCase());
        
        // Initialize price history if not exists
        if (!this.priceData.has(tokenAddress.toLowerCase())) {
            this.priceData.set(tokenAddress.toLowerCase(), {
                address: tokenAddress,
                symbol: tokenInfo.symbol || 'Unknown',
                name: tokenInfo.name || 'Unknown Token',
                prices: [], // Array of {timestamp, price, volume?} objects
                smaCache: {
                    '5min': { values: [], average: 0, lastUpdate: 0 },
                    '1hour': { values: [], average: 0, lastUpdate: 0 },
                    '6hour': { values: [], average: 0, lastUpdate: 0 },
                    '24hour': { values: [], average: 0, lastUpdate: 0 },
                    '1day': { values: [], average: 0, lastUpdate: 0 },
                    '7day': { values: [], average: 0, lastUpdate: 0 }
                },
                lastPriceUpdate: 0,
                currentPrice: 0,
                priceChange24h: 0,
                volatility: 0
            });
        }
        
        console.log(`📈 Added ${tokenInfo.symbol || tokenAddress} to price tracking`);
    }
    
    // Remove token from tracking
    removeToken(tokenAddress) {
        this.trackedTokens.delete(tokenAddress.toLowerCase());
        console.log(`📉 Removed ${tokenAddress} from price tracking`);
    }
    
    // Start background price monitoring
    startBackgroundMonitoring() {
        if (this.isRunning) {
            console.log('📊 Price monitoring already running');
            return;
        }
        
        this.isRunning = true;
        console.log('🚀 Starting background price monitoring...');
        console.log(`   📊 Update interval: ${this.updateInterval / 1000}s`);
        console.log(`   🪙 Tracking ${this.trackedTokens.size} tokens`);
        console.log(`   🎯 Active triggers: ${this.activeTriggers.size}`);
        
        // Start monitoring loop
        this.monitoringInterval = setInterval(async () => {
            await this.updateAllPrices();
        }, this.updateInterval);
        
        // Initial price update
        setTimeout(() => this.updateAllPrices(), 2000);
        
        console.log('✅ Background price monitoring started');
    }
    
    // Stop background monitoring
    stopBackgroundMonitoring() {
        if (!this.isRunning) return;
        
        this.isRunning = false;
        
        if (this.monitoringInterval) {
            clearInterval(this.monitoringInterval);
            this.monitoringInterval = null;
        }
        
        // Save data before stopping
        this.savePriceDatabase();
        
        console.log('🛑 Background price monitoring stopped');
    }
    
    // Update prices for all tracked tokens
    async updateAllPrices() {
        if (this.trackedTokens.size === 0) {
            return;
        }
        
        const updatePromises = [];
        const tokensArray = Array.from(this.trackedTokens);
        
        console.log(`📊 Updating prices for ${tokensArray.length} tokens...`);
        
        // Update prices in parallel for better performance
        for (const tokenAddress of tokensArray) {
            updatePromises.push(this.updateTokenPrice(tokenAddress));
        }
        
        try {
            const results = await Promise.allSettled(updatePromises);
            const successful = results.filter(r => r.status === 'fulfilled').length;
            const failed = results.filter(r => r.status === 'rejected').length;
            
            console.log(`📊 Price update complete: ${successful} successful, ${failed} failed`);
            
            // Update SMA calculations
            await this.updateAllSMACalculations();
            
            // Check triggers
            await this.checkAllTriggers();
            
            // Save to disk every 5 minutes
            if (Date.now() % 300000 < this.updateInterval) {
                this.savePriceDatabase();
            }
            
        } catch (error) {
            console.error('❌ Error updating prices:', error.message);
        }
    }
    
    // Update price for a specific token
    async updateTokenPrice(tokenAddress) {
        try {
            const priceData = this.priceData.get(tokenAddress.toLowerCase());
            if (!priceData) return;
            
            // Get current price using HoldStation SDK
            const quote = await this.sinclaveEngine.getHoldStationQuote(
                tokenAddress,
                this.WLD_ADDRESS,
                1, // 1 token
                '0x0000000000000000000000000000000000000001' // dummy receiver
            );
            
            if (quote && quote.expectedOutput) {
                const currentPrice = parseFloat(quote.expectedOutput);
                const timestamp = Date.now();
                
                // Add to price history
                priceData.prices.push({
                    timestamp,
                    price: currentPrice
                });
                
                // Update current price
                priceData.currentPrice = currentPrice;
                priceData.lastPriceUpdate = timestamp;
                
                // Calculate 24h price change
                const price24hAgo = this.getPriceAtTime(tokenAddress, timestamp - 86400000); // 24 hours ago
                if (price24hAgo > 0) {
                    priceData.priceChange24h = ((currentPrice - price24hAgo) / price24hAgo) * 100;
                }
                
                // Clean old data
                this.cleanOldPriceData(tokenAddress);
                
                // Emit price update event
                this.emit('priceUpdate', {
                    tokenAddress,
                    symbol: priceData.symbol,
                    price: currentPrice,
                    timestamp,
                    change24h: priceData.priceChange24h
                });
                
            }
        } catch (error) {
            console.error(`❌ Error updating price for ${tokenAddress}:`, error.message);
        }
    }
    
    // Clean old price data to manage memory
    cleanOldPriceData(tokenAddress) {
        const priceData = this.priceData.get(tokenAddress.toLowerCase());
        if (!priceData) return;
        
        const cutoffTime = Date.now() - this.maxHistoryAge;
        const originalLength = priceData.prices.length;
        
        priceData.prices = priceData.prices.filter(p => p.timestamp >= cutoffTime);
        
        if (priceData.prices.length < originalLength) {
            console.log(`🧹 Cleaned ${originalLength - priceData.prices.length} old price records for ${priceData.symbol}`);
        }
    }
    
    // Update SMA calculations for all tokens
    async updateAllSMACalculations() {
        for (const [tokenAddress, priceData] of this.priceData) {
            this.calculateSMAs(tokenAddress, priceData);
        }
    }
    
    // Calculate SMAs for a token
    calculateSMAs(tokenAddress, priceData) {
        const now = Date.now();
        
        // SMA timeframes in milliseconds
        const smaTimeframes = {
            '5min': 5 * 60 * 1000,
            '1hour': 60 * 60 * 1000,
            '6hour': 6 * 60 * 60 * 1000,
            '24hour': 24 * 60 * 60 * 1000,
            '1day': 24 * 60 * 60 * 1000,
            '7day': 7 * 24 * 60 * 60 * 1000
        };
        
        for (const [period, timeframeMs] of Object.entries(smaTimeframes)) {
            const cutoffTime = now - timeframeMs;
            
            // Get prices within this timeframe
            const periodPrices = priceData.prices.filter(p => p.timestamp >= cutoffTime);
            
            if (periodPrices.length >= 3) { // Need at least 3 data points
                const prices = periodPrices.map(p => p.price);
                const sum = prices.reduce((a, b) => a + b, 0);
                const average = sum / prices.length;
                
                priceData.smaCache[period] = {
                    values: prices,
                    average: average,
                    dataPoints: prices.length,
                    timeframe: timeframeMs,
                    lastUpdate: now
                };
            }
        }
    }
    
    // Get current price for a token
    getCurrentPrice(tokenAddress) {
        const priceData = this.priceData.get(tokenAddress.toLowerCase());
        return priceData ? priceData.currentPrice : 0;
    }
    
    // Get price at specific time (or closest available)
    getPriceAtTime(tokenAddress, timestamp) {
        const priceData = this.priceData.get(tokenAddress.toLowerCase());
        if (!priceData || priceData.prices.length === 0) return 0;
        
        // Find closest price to the requested timestamp
        let closestPrice = priceData.prices[0];
        let minTimeDiff = Math.abs(priceData.prices[0].timestamp - timestamp);
        
        for (const price of priceData.prices) {
            const timeDiff = Math.abs(price.timestamp - timestamp);
            if (timeDiff < minTimeDiff) {
                minTimeDiff = timeDiff;
                closestPrice = price;
            }
        }
        
        return closestPrice.price;
    }
    
    // Get price change percentage over a time period
    getPriceChange(tokenAddress, timeframeMs) {
        const currentPrice = this.getCurrentPrice(tokenAddress);
        const pastPrice = this.getPriceAtTime(tokenAddress, Date.now() - timeframeMs);
        
        if (currentPrice === 0 || pastPrice === 0) return 0;
        
        return ((currentPrice - pastPrice) / pastPrice) * 100;
    }
    
    // Get SMA for a token and timeframe
    getSMA(tokenAddress, timeframe) {
        const priceData = this.priceData.get(tokenAddress.toLowerCase());
        if (!priceData || !priceData.smaCache[timeframe]) return 0;
        
        return priceData.smaCache[timeframe].average;
    }
    
    // Create a price trigger
    createTrigger(config) {
        const triggerId = `trigger_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
        
        const trigger = {
            id: triggerId,
            name: config.name || `${config.action} ${config.tokenSymbol} trigger`,
            tokenAddress: config.tokenAddress.toLowerCase(),
            tokenSymbol: config.tokenSymbol,
            
            // Trigger conditions
            action: config.action, // 'buy' or 'sell'
            condition: config.condition, // 'price_drop', 'price_rise', 'below_sma', 'above_sma'
            threshold: config.threshold, // Percentage or absolute value
            timeframe: config.timeframe || 300000, // Time window for condition (5 minutes default)
            
            // Trade parameters
            amount: config.amount || 0.1, // WLD amount for buy, token amount for sell
            maxSlippage: config.maxSlippage || 2,
            
            // State
            isActive: true,
            createdAt: Date.now(),
            lastChecked: 0,
            triggerCount: 0,
            maxTriggers: config.maxTriggers || 1, // How many times this trigger can fire
            
            // Wallet
            walletAddress: config.walletAddress
        };
        
        this.activeTriggers.set(triggerId, trigger);
        this.saveTriggers();
        
        console.log(`🎯 Created trigger: ${trigger.name}`);
        console.log(`   📊 Condition: ${trigger.condition} ${trigger.threshold}% in ${this.formatTimeframe(trigger.timeframe)}`);
        console.log(`   💰 Action: ${trigger.action} ${trigger.amount} ${trigger.action === 'buy' ? 'WLD' : trigger.tokenSymbol}`);
        
        return trigger;
    }
    
    // Check all active triggers
    async checkAllTriggers() {
        if (this.activeTriggers.size === 0) return;
        
        for (const [triggerId, trigger] of this.activeTriggers) {
            if (trigger.isActive && trigger.triggerCount < trigger.maxTriggers) {
                await this.checkTrigger(trigger);
            }
        }
    }
    
    // Check a specific trigger
    async checkTrigger(trigger) {
        try {
            trigger.lastChecked = Date.now();
            
            const currentPrice = this.getCurrentPrice(trigger.tokenAddress);
            if (currentPrice === 0) return; // No price data available
            
            let conditionMet = false;
            let conditionDetails = '';
            
            switch (trigger.condition) {
                case 'price_drop':
                    const priceChange = this.getPriceChange(trigger.tokenAddress, trigger.timeframe);
                    conditionMet = priceChange <= -Math.abs(trigger.threshold);
                    conditionDetails = `Price dropped ${Math.abs(priceChange).toFixed(2)}% (need ${trigger.threshold}%)`;
                    break;
                    
                case 'price_rise':
                    const priceRise = this.getPriceChange(trigger.tokenAddress, trigger.timeframe);
                    conditionMet = priceRise >= trigger.threshold;
                    conditionDetails = `Price rose ${priceRise.toFixed(2)}% (need ${trigger.threshold}%)`;
                    break;
                    
                case 'below_sma':
                    const smaValue = this.getSMA(trigger.tokenAddress, trigger.timeframe);
                    if (smaValue > 0) {
                        const belowSMA = ((smaValue - currentPrice) / smaValue) * 100;
                        conditionMet = belowSMA >= trigger.threshold;
                        conditionDetails = `Price ${belowSMA.toFixed(2)}% below SMA (need ${trigger.threshold}%)`;
                    }
                    break;
                    
                case 'above_sma':
                    const smaValueAbove = this.getSMA(trigger.tokenAddress, trigger.timeframe);
                    if (smaValueAbove > 0) {
                        const aboveSMA = ((currentPrice - smaValueAbove) / smaValueAbove) * 100;
                        conditionMet = aboveSMA >= trigger.threshold;
                        conditionDetails = `Price ${aboveSMA.toFixed(2)}% above SMA (need ${trigger.threshold}%)`;
                    }
                    break;
            }
            
            if (conditionMet) {
                console.log(`🚨 TRIGGER ACTIVATED: ${trigger.name}`);
                console.log(`   📊 ${conditionDetails}`);
                console.log(`   💰 Executing ${trigger.action} order...`);
                
                await this.executeTrigger(trigger);
            }
            
        } catch (error) {
            console.error(`❌ Error checking trigger ${trigger.name}:`, error.message);
        }
    }
    
    // Execute a trigger
    async executeTrigger(trigger) {
        try {
            // Find wallet object (this would need to be passed from main bot)
            const wallet = this.findWalletByAddress(trigger.walletAddress);
            if (!wallet) {
                console.log(`❌ Wallet not found for trigger: ${trigger.walletAddress}`);
                return;
            }
            
            let result;
            
            if (trigger.action === 'buy') {
                // Execute buy order
                result = await this.sinclaveEngine.executeOptimizedSwap(
                    wallet,
                    this.WLD_ADDRESS,
                    trigger.tokenAddress,
                    trigger.amount,
                    trigger.maxSlippage
                );
            } else if (trigger.action === 'sell') {
                // Execute sell order
                result = await this.sinclaveEngine.executeOptimizedSwap(
                    wallet,
                    trigger.tokenAddress,
                    this.WLD_ADDRESS,
                    trigger.amount,
                    trigger.maxSlippage
                );
            }
            
            if (result && result.success) {
                trigger.triggerCount++;
                
                console.log(`✅ TRIGGER EXECUTED SUCCESSFULLY!`);
                console.log(`   💰 ${trigger.action === 'buy' ? 'Bought' : 'Sold'}: ${result.amountOut} ${trigger.action === 'buy' ? trigger.tokenSymbol : 'WLD'}`);
                console.log(`   🧾 TX Hash: ${result.txHash}`);
                console.log(`   🎯 Trigger count: ${trigger.triggerCount}/${trigger.maxTriggers}`);
                
                // Deactivate if max triggers reached
                if (trigger.triggerCount >= trigger.maxTriggers) {
                    trigger.isActive = false;
                    console.log(`🛑 Trigger deactivated (max executions reached)`);
                }
                
                // Emit trigger execution event
                this.emit('triggerExecuted', {
                    trigger,
                    result,
                    timestamp: Date.now()
                });
                
            } else {
                console.log(`❌ TRIGGER EXECUTION FAILED: ${result ? result.error : 'Unknown error'}`);
            }
            
            this.saveTriggers();
            
        } catch (error) {
            console.error(`❌ Error executing trigger:`, error.message);
        }
    }
    
    // Get price statistics for a token
    getPriceStats(tokenAddress) {
        const priceData = this.priceData.get(tokenAddress.toLowerCase());
        if (!priceData) return null;
        
        return {
            symbol: priceData.symbol,
            currentPrice: priceData.currentPrice,
            change24h: priceData.priceChange24h,
            change5min: this.getPriceChange(tokenAddress, 5 * 60 * 1000),
            change1hour: this.getPriceChange(tokenAddress, 60 * 60 * 1000),
            change6hour: this.getPriceChange(tokenAddress, 6 * 60 * 60 * 1000),
            sma5min: this.getSMA(tokenAddress, '5min'),
            sma1hour: this.getSMA(tokenAddress, '1hour'),
            sma6hour: this.getSMA(tokenAddress, '6hour'),
            sma24hour: this.getSMA(tokenAddress, '24hour'),
            lastUpdate: priceData.lastPriceUpdate,
            dataPoints: priceData.prices.length
        };
    }
    
    // Load price database from disk
    loadPriceDatabase() {
        try {
            if (fs.existsSync(this.priceDbPath)) {
                const data = JSON.parse(fs.readFileSync(this.priceDbPath, 'utf8'));
                
                // Restore price data
                if (data.priceData) {
                    for (const [tokenAddress, priceInfo] of Object.entries(data.priceData)) {
                        this.priceData.set(tokenAddress, priceInfo);
                        this.trackedTokens.add(tokenAddress);
                    }
                }
                
                console.log(`📊 Loaded price database: ${this.priceData.size} tokens, ${this.getTotalPricePoints()} price points`);
            }
        } catch (error) {
            console.error('❌ Error loading price database:', error.message);
        }
    }
    
    // Save price database to disk
    savePriceDatabase() {
        try {
            const data = {
                version: '1.0',
                timestamp: Date.now(),
                priceData: Object.fromEntries(this.priceData),
                trackedTokens: Array.from(this.trackedTokens)
            };
            
            fs.writeFileSync(this.priceDbPath, JSON.stringify(data, null, 2));
            console.log(`💾 Saved price database: ${this.priceData.size} tokens`);
        } catch (error) {
            console.error('❌ Error saving price database:', error.message);
        }
    }
    
    // Load triggers from disk
    loadTriggers() {
        try {
            if (fs.existsSync(this.triggersPath)) {
                const data = JSON.parse(fs.readFileSync(this.triggersPath, 'utf8'));
                
                if (data.triggers) {
                    for (const [triggerId, trigger] of Object.entries(data.triggers)) {
                        this.activeTriggers.set(triggerId, trigger);
                    }
                }
                
                console.log(`🎯 Loaded ${this.activeTriggers.size} price triggers`);
            }
        } catch (error) {
            console.error('❌ Error loading triggers:', error.message);
        }
    }
    
    // Save triggers to disk
    saveTriggers() {
        try {
            const data = {
                version: '1.0',
                timestamp: Date.now(),
                triggers: Object.fromEntries(this.activeTriggers)
            };
            
            fs.writeFileSync(this.triggersPath, JSON.stringify(data, null, 2));
        } catch (error) {
            console.error('❌ Error saving triggers:', error.message);
        }
    }
    
    // Helper methods
    getTotalPricePoints() {
        let total = 0;
        for (const [, priceData] of this.priceData) {
            total += priceData.prices.length;
        }
        return total;
    }
    
    formatTimeframe(timeframeMs) {
        const minutes = timeframeMs / (60 * 1000);
        const hours = minutes / 60;
        const days = hours / 24;
        
        if (days >= 1) return `${days}d`;
        if (hours >= 1) return `${hours}h`;
        return `${minutes}min`;
    }
    
    findWalletByAddress(address) {
        // This method would need to be implemented to find wallet by address
        // It should be connected to the main bot's wallet system
        return null;
    }
    
    // Get status summary
    getStatus() {
        return {
            isRunning: this.isRunning,
            trackedTokens: this.trackedTokens.size,
            activeTriggers: Array.from(this.activeTriggers.values()).filter(t => t.isActive).length,
            totalTriggers: this.activeTriggers.size,
            totalPricePoints: this.getTotalPricePoints(),
            updateInterval: this.updateInterval,
            lastUpdate: Math.max(...Array.from(this.priceData.values()).map(p => p.lastPriceUpdate || 0))
        };
    }
}

module.exports = PriceDatabase;