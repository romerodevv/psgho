const fs = require('fs');
const path = require('path');
const EventEmitter = require('events');

// Machine Learning Components
class SimpleLinearRegression {
    constructor() {
        this.slope = 0;
        this.intercept = 0;
        this.trained = false;
    }
    
    train(xData, yData) {
        if (xData.length !== yData.length || xData.length < 2) {
            throw new Error('Invalid training data');
        }
        
        const n = xData.length;
        const sumX = xData.reduce((a, b) => a + b, 0);
        const sumY = yData.reduce((a, b) => a + b, 0);
        const sumXY = xData.reduce((sum, x, i) => sum + x * yData[i], 0);
        const sumXX = xData.reduce((sum, x) => sum + x * x, 0);
        
        this.slope = (n * sumXY - sumX * sumY) / (n * sumXX - sumX * sumX);
        this.intercept = (sumY - this.slope * sumX) / n;
        this.trained = true;
    }
    
    predict(x) {
        if (!this.trained) {
            throw new Error('Model not trained');
        }
        return this.slope * x + this.intercept;
    }
}

class MovingAveragePredictor {
    constructor(window = 10) {
        this.window = window;
        this.values = [];
    }
    
    addValue(value) {
        this.values.push(value);
        if (this.values.length > this.window) {
            this.values.shift();
        }
    }
    
    predict() {
        if (this.values.length === 0) return 0;
        return this.values.reduce((a, b) => a + b, 0) / this.values.length;
    }
    
    getTrend() {
        if (this.values.length < 2) return 0;
        const recent = this.values.slice(-Math.min(5, this.values.length));
        const older = this.values.slice(0, Math.min(5, this.values.length));
        
        const recentAvg = recent.reduce((a, b) => a + b, 0) / recent.length;
        const olderAvg = older.reduce((a, b) => a + b, 0) / older.length;
        
        return (recentAvg - olderAvg) / olderAvg * 100;
    }
}

class PatternRecognition {
    constructor() {
        this.patterns = {
            bullish: [],
            bearish: [],
            neutral: []
        };
    }
    
    addPattern(priceSequence, outcome) {
        const pattern = {
            sequence: [...priceSequence],
            outcome: outcome, // 'bullish', 'bearish', 'neutral'
            timestamp: Date.now()
        };
        
        this.patterns[outcome].push(pattern);
        
        // Keep only recent patterns (last 1000 per type)
        if (this.patterns[outcome].length > 1000) {
            this.patterns[outcome] = this.patterns[outcome].slice(-1000);
        }
    }
    
    recognizePattern(currentSequence) {
        let bestMatch = { type: 'neutral', confidence: 0 };
        
        for (const [type, patterns] of Object.entries(this.patterns)) {
            for (const pattern of patterns) {
                const similarity = this.calculateSimilarity(currentSequence, pattern.sequence);
                if (similarity > bestMatch.confidence) {
                    bestMatch = { type, confidence: similarity };
                }
            }
        }
        
        return bestMatch;
    }
    
    calculateSimilarity(seq1, seq2) {
        if (seq1.length !== seq2.length) return 0;
        
        const normalize = (arr) => {
            const min = Math.min(...arr);
            const max = Math.max(...arr);
            const range = max - min;
            if (range === 0) return arr.map(() => 0);
            return arr.map(x => (x - min) / range);
        };
        
        const norm1 = normalize(seq1);
        const norm2 = normalize(seq2);
        
        let similarity = 0;
        for (let i = 0; i < norm1.length; i++) {
            similarity += 1 - Math.abs(norm1[i] - norm2[i]);
        }
        
        return similarity / norm1.length;
    }
}

class AlgoritmitStrategy extends EventEmitter {
    constructor(tradingEngine, sinclaveEngine, priceDatabase, config) {
        super();
        
        this.tradingEngine = tradingEngine;
        this.sinclaveEngine = sinclaveEngine;
        this.priceDatabase = priceDatabase;
        this.config = config;
        
        // ML Models
        this.pricePredictor = new SimpleLinearRegression();
        this.volumePredictor = new MovingAveragePredictor(20);
        this.patternRecognizer = new PatternRecognition();
        
        // Strategy Configuration
        this.strategyConfig = {
            enabled: false,
            learningMode: true, // Learn from existing trades
            autoTradingMode: false, // Auto-execute based on ML predictions
            confidenceThreshold: 0.7, // Minimum confidence for auto-trading
            maxPositionSize: 1.0, // Maximum WLD per trade
            riskTolerance: 0.05, // 5% risk tolerance
            learningPeriod: 100, // Number of data points to learn from
            predictionWindow: 5, // Minutes to predict ahead
            retrainInterval: 24 * 60 * 60 * 1000, // Retrain every 24 hours
        };
        
        // Data Storage
        this.trainingData = {
            prices: [],
            volumes: [],
            trades: [],
            outcomes: []
        };
        
        // Model Performance Metrics
        this.metrics = {
            totalPredictions: 0,
            correctPredictions: 0,
            accuracy: 0,
            profitableTrades: 0,
            totalTrades: 0,
            totalProfit: 0,
            lastRetraining: 0
        };
        
        // Active Positions
        this.activePositions = new Map();
        
        // File Paths
        this.dataPath = path.join(process.cwd(), 'algoritmit-data.json');
        this.modelPath = path.join(process.cwd(), 'algoritmit-models.json');
        this.metricsPath = path.join(process.cwd(), 'algoritmit-metrics.json');
        
        // Load existing data
        this.loadData();
        this.loadMetrics();
        
        // Auto-retraining timer
        this.retrainingTimer = null;
        
        console.log('🤖 ALGORITMIT Strategy initialized');
    }
    
    // Enable/Disable Strategy
    setEnabled(enabled) {
        this.strategyConfig.enabled = enabled;
        
        if (enabled) {
            console.log('🤖 ALGORITMIT Strategy ENABLED');
            this.startMonitoring();
        } else {
            console.log('🤖 ALGORITMIT Strategy DISABLED');
            this.stopMonitoring();
        }
        
        this.saveData();
    }
    
    // Set Learning Mode
    setLearningMode(enabled) {
        this.strategyConfig.learningMode = enabled;
        console.log(`🧠 Learning Mode: ${enabled ? 'ENABLED' : 'DISABLED'}`);
        this.saveData();
    }
    
    // Set Auto-Trading Mode
    setAutoTradingMode(enabled) {
        this.strategyConfig.autoTradingMode = enabled;
        console.log(`⚡ Auto-Trading Mode: ${enabled ? 'ENABLED' : 'DISABLED'}`);
        
        if (enabled && !this.strategyConfig.enabled) {
            console.log('⚠️  Auto-trading requires strategy to be enabled');
            return false;
        }
        
        this.saveData();
        return true;
    }
    
    // Configure Strategy Parameters
    configure(params) {
        Object.assign(this.strategyConfig, params);
        console.log('⚙️  ALGORITMIT configuration updated');
        this.saveData();
    }
    
    // Start Monitoring
    startMonitoring() {
        if (this.monitoringInterval) {
            clearInterval(this.monitoringInterval);
        }
        
        // Monitor every minute
        this.monitoringInterval = setInterval(async () => {
            await this.processMarketData();
        }, 60000);
        
        // Setup retraining timer
        if (this.retrainingTimer) {
            clearInterval(this.retrainingTimer);
        }
        
        this.retrainingTimer = setInterval(async () => {
            await this.retrainModels();
        }, this.strategyConfig.retrainInterval);
        
        console.log('📊 ALGORITMIT monitoring started');
    }
    
    // Stop Monitoring
    stopMonitoring() {
        if (this.monitoringInterval) {
            clearInterval(this.monitoringInterval);
            this.monitoringInterval = null;
        }
        
        if (this.retrainingTimer) {
            clearInterval(this.retrainingTimer);
            this.retrainingTimer = null;
        }
        
        console.log('📊 ALGORITMIT monitoring stopped');
    }
    
    // Process Market Data
    async processMarketData() {
        try {
            if (!this.priceDatabase || !this.priceDatabase.isRunning) {
                return;
            }
            
            // Get all tracked tokens
            const trackedTokens = Array.from(this.priceDatabase.trackedTokens);
            
            for (const tokenAddress of trackedTokens) {
                await this.analyzeToken(tokenAddress);
            }
            
        } catch (error) {
            console.error('❌ Error processing market data:', error.message);
        }
    }
    
    // Analyze Individual Token
    async analyzeToken(tokenAddress) {
        try {
            const priceData = this.priceDatabase.priceData.get(tokenAddress);
            if (!priceData || priceData.prices.length < 10) {
                return; // Need at least 10 data points
            }
            
            const currentPrice = priceData.currentPrice;
            const recentPrices = priceData.prices.slice(-20).map(p => p.price);
            
            // Add to training data if in learning mode
            if (this.strategyConfig.learningMode) {
                this.addTrainingData(tokenAddress, currentPrice, recentPrices);
            }
            
            // Make prediction if auto-trading is enabled
            if (this.strategyConfig.autoTradingMode) {
                await this.makePredictionAndTrade(tokenAddress, currentPrice, recentPrices);
            }
            
        } catch (error) {
            console.error(`❌ Error analyzing token ${tokenAddress}:`, error.message);
        }
    }
    
    // Add Training Data
    addTrainingData(tokenAddress, currentPrice, priceSequence) {
        if (priceSequence.length < 5) return;
        
        // Create features from price sequence
        const features = this.extractFeatures(priceSequence);
        
        // Store for training
        if (!this.trainingData[tokenAddress]) {
            this.trainingData[tokenAddress] = {
                features: [],
                targets: [],
                patterns: []
            };
        }
        
        this.trainingData[tokenAddress].features.push(features);
        this.trainingData[tokenAddress].targets.push(currentPrice);
        
        // Keep only recent data
        if (this.trainingData[tokenAddress].features.length > this.strategyConfig.learningPeriod) {
            this.trainingData[tokenAddress].features.shift();
            this.trainingData[tokenAddress].targets.shift();
        }
        
        // Pattern recognition
        if (priceSequence.length >= 5) {
            const pattern = priceSequence.slice(-5);
            const outcome = this.classifyOutcome(priceSequence);
            this.patternRecognizer.addPattern(pattern, outcome);
        }
    }
    
    // Extract Features from Price Data
    extractFeatures(prices) {
        if (prices.length < 5) return [];
        
        const features = [];
        
        // Price-based features
        const currentPrice = prices[prices.length - 1];
        const previousPrice = prices[prices.length - 2];
        const priceChange = (currentPrice - previousPrice) / previousPrice;
        
        features.push(priceChange); // Recent price change
        
        // Moving averages
        const sma5 = prices.slice(-5).reduce((a, b) => a + b, 0) / 5;
        const sma10 = prices.slice(-Math.min(10, prices.length)).reduce((a, b) => a + b, 0) / Math.min(10, prices.length);
        
        features.push((currentPrice - sma5) / sma5); // Distance from SMA5
        features.push((currentPrice - sma10) / sma10); // Distance from SMA10
        
        // Volatility
        const returns = [];
        for (let i = 1; i < prices.length; i++) {
            returns.push((prices[i] - prices[i-1]) / prices[i-1]);
        }
        const volatility = Math.sqrt(returns.reduce((sum, r) => sum + r * r, 0) / returns.length);
        features.push(volatility);
        
        // Trend strength
        const trend = (prices[prices.length - 1] - prices[0]) / prices[0];
        features.push(trend);
        
        return features;
    }
    
    // Classify Outcome for Pattern Recognition
    classifyOutcome(prices) {
        if (prices.length < 10) return 'neutral';
        
        const recent = prices.slice(-5);
        const older = prices.slice(-10, -5);
        
        const recentAvg = recent.reduce((a, b) => a + b, 0) / recent.length;
        const olderAvg = older.reduce((a, b) => a + b, 0) / older.length;
        
        const change = (recentAvg - olderAvg) / olderAvg;
        
        if (change > 0.02) return 'bullish';
        if (change < -0.02) return 'bearish';
        return 'neutral';
    }
    
    // Make Prediction and Execute Trade
    async makePredictionAndTrade(tokenAddress, currentPrice, priceSequence) {
        try {
            if (!this.trainingData[tokenAddress] || 
                this.trainingData[tokenAddress].features.length < 10) {
                return; // Not enough training data
            }
            
            // Extract current features
            const currentFeatures = this.extractFeatures(priceSequence);
            
            // Make price prediction
            const pricePrediction = this.predictPrice(tokenAddress, currentFeatures);
            
            // Pattern recognition
            const patternMatch = this.patternRecognizer.recognizePattern(priceSequence.slice(-5));
            
            // Combine predictions
            const signal = this.combineSignals(pricePrediction, patternMatch, currentPrice);
            
            // Execute trade if confidence is high enough
            if (signal.confidence >= this.strategyConfig.confidenceThreshold) {
                await this.executeMlTrade(tokenAddress, signal, currentPrice);
            }
            
            // Update metrics
            this.metrics.totalPredictions++;
            this.saveMetrics();
            
        } catch (error) {
            console.error(`❌ Error in ML prediction for ${tokenAddress}:`, error.message);
        }
    }
    
    // Predict Price using Linear Regression
    predictPrice(tokenAddress, features) {
        const data = this.trainingData[tokenAddress];
        
        if (data.features.length < 10) {
            return { prediction: 0, confidence: 0 };
        }
        
        try {
            // Simple prediction based on trend
            const recentTargets = data.targets.slice(-10);
            const timePoints = recentTargets.map((_, i) => i);
            
            const predictor = new SimpleLinearRegression();
            predictor.train(timePoints, recentTargets);
            
            const prediction = predictor.predict(timePoints.length);
            const confidence = Math.min(0.9, Math.max(0.1, 1 - Math.abs(predictor.slope) * 0.1));
            
            return { prediction, confidence };
            
        } catch (error) {
            return { prediction: 0, confidence: 0 };
        }
    }
    
    // Combine Multiple Signals
    combineSignals(pricePrediction, patternMatch, currentPrice) {
        const signals = [];
        
        // Price prediction signal
        if (pricePrediction.confidence > 0.3) {
            const priceChange = (pricePrediction.prediction - currentPrice) / currentPrice;
            if (priceChange > 0.01) {
                signals.push({ type: 'buy', strength: pricePrediction.confidence, reason: 'price_prediction' });
            } else if (priceChange < -0.01) {
                signals.push({ type: 'sell', strength: pricePrediction.confidence, reason: 'price_prediction' });
            }
        }
        
        // Pattern recognition signal
        if (patternMatch.confidence > 0.5) {
            if (patternMatch.type === 'bullish') {
                signals.push({ type: 'buy', strength: patternMatch.confidence, reason: 'pattern_bullish' });
            } else if (patternMatch.type === 'bearish') {
                signals.push({ type: 'sell', strength: patternMatch.confidence, reason: 'pattern_bearish' });
            }
        }
        
        // Combine signals
        if (signals.length === 0) {
            return { action: 'hold', confidence: 0, reasons: [] };
        }
        
        const buySignals = signals.filter(s => s.type === 'buy');
        const sellSignals = signals.filter(s => s.type === 'sell');
        
        const buyStrength = buySignals.reduce((sum, s) => sum + s.strength, 0) / Math.max(1, buySignals.length);
        const sellStrength = sellSignals.reduce((sum, s) => sum + s.strength, 0) / Math.max(1, sellSignals.length);
        
        if (buyStrength > sellStrength && buyStrength > 0.5) {
            return {
                action: 'buy',
                confidence: buyStrength,
                reasons: buySignals.map(s => s.reason)
            };
        } else if (sellStrength > buyStrength && sellStrength > 0.5) {
            return {
                action: 'sell',
                confidence: sellStrength,
                reasons: sellSignals.map(s => s.reason)
            };
        }
        
        return { action: 'hold', confidence: Math.max(buyStrength, sellStrength), reasons: [] };
    }
    
    // Execute ML-Based Trade
    async executeMlTrade(tokenAddress, signal, currentPrice) {
        try {
            const priceData = this.priceDatabase.priceData.get(tokenAddress);
            if (!priceData) return;
            
            console.log(`🤖 ALGORITMIT Signal: ${signal.action.toUpperCase()} ${priceData.symbol}`);
            console.log(`   🎯 Confidence: ${(signal.confidence * 100).toFixed(1)}%`);
            console.log(`   📊 Reasons: ${signal.reasons.join(', ')}`);
            console.log(`   💰 Price: ${currentPrice.toFixed(8)} WLD`);
            
            // Check if we already have a position
            const existingPosition = this.activePositions.get(tokenAddress);
            
            if (signal.action === 'buy' && !existingPosition) {
                await this.executeBuy(tokenAddress, currentPrice, signal);
            } else if (signal.action === 'sell' && existingPosition) {
                await this.executeSell(tokenAddress, currentPrice, signal, existingPosition);
            }
            
        } catch (error) {
            console.error(`❌ Error executing ML trade:`, error.message);
        }
    }
    
    // Execute Buy Order
    async executeBuy(tokenAddress, currentPrice, signal) {
        try {
            // Calculate position size based on confidence and risk tolerance
            const baseAmount = this.strategyConfig.maxPositionSize;
            const confidenceMultiplier = signal.confidence;
            const riskAdjustedAmount = baseAmount * confidenceMultiplier * (1 - this.strategyConfig.riskTolerance);
            
            const tradeAmount = Math.max(0.01, Math.min(baseAmount, riskAdjustedAmount));
            
            // Find a wallet to use (use first available)
            const wallets = Object.values(this.priceDatabase.findWalletByAddress ? {} : {});
            if (wallets.length === 0) {
                console.log('❌ No wallets available for ML trading');
                return;
            }
            
            // For now, we'll simulate the trade execution
            // In a real implementation, you'd use the trading engine
            console.log(`🤖 ML BUY EXECUTED (SIMULATED)`);
            console.log(`   💰 Amount: ${tradeAmount.toFixed(6)} WLD`);
            console.log(`   📊 Expected tokens: ~${(tradeAmount / currentPrice).toFixed(2)}`);
            
            // Record the position
            const position = {
                tokenAddress,
                entryPrice: currentPrice,
                entryAmount: tradeAmount,
                entryTime: Date.now(),
                signal: signal,
                status: 'open'
            };
            
            this.activePositions.set(tokenAddress, position);
            this.metrics.totalTrades++;
            
            // Emit event
            this.emit('mlTradeExecuted', {
                type: 'buy',
                tokenAddress,
                amount: tradeAmount,
                price: currentPrice,
                confidence: signal.confidence
            });
            
        } catch (error) {
            console.error('❌ Error executing ML buy:', error.message);
        }
    }
    
    // Execute Sell Order
    async executeSell(tokenAddress, currentPrice, signal, position) {
        try {
            const profit = (currentPrice - position.entryPrice) / position.entryPrice;
            const holdTime = Date.now() - position.entryTime;
            
            console.log(`🤖 ML SELL EXECUTED (SIMULATED)`);
            console.log(`   💰 Entry: ${position.entryPrice.toFixed(8)} WLD`);
            console.log(`   💰 Exit: ${currentPrice.toFixed(8)} WLD`);
            console.log(`   📊 Profit: ${(profit * 100).toFixed(2)}%`);
            console.log(`   ⏰ Hold Time: ${Math.round(holdTime / 60000)} minutes`);
            
            // Update metrics
            if (profit > 0) {
                this.metrics.profitableTrades++;
                this.metrics.correctPredictions++;
            }
            this.metrics.totalProfit += profit * position.entryAmount;
            
            // Close position
            this.activePositions.delete(tokenAddress);
            
            // Emit event
            this.emit('mlTradeExecuted', {
                type: 'sell',
                tokenAddress,
                profit: profit,
                holdTime: holdTime,
                confidence: signal.confidence
            });
            
        } catch (error) {
            console.error('❌ Error executing ML sell:', error.message);
        }
    }
    
    // Retrain Models
    async retrainModels() {
        try {
            console.log('🧠 Retraining ALGORITMIT models...');
            
            let totalDataPoints = 0;
            for (const [tokenAddress, data] of Object.entries(this.trainingData)) {
                if (data.features && data.features.length > 10) {
                    totalDataPoints += data.features.length;
                }
            }
            
            console.log(`📊 Retraining with ${totalDataPoints} data points`);
            
            // Update accuracy metrics
            if (this.metrics.totalPredictions > 0) {
                this.metrics.accuracy = this.metrics.correctPredictions / this.metrics.totalPredictions;
            }
            
            this.metrics.lastRetraining = Date.now();
            this.saveMetrics();
            
            console.log(`✅ Model retraining complete. Accuracy: ${(this.metrics.accuracy * 100).toFixed(1)}%`);
            
        } catch (error) {
            console.error('❌ Error retraining models:', error.message);
        }
    }
    
    // Get Strategy Statistics
    getStatistics() {
        const winRate = this.metrics.totalTrades > 0 ? 
            (this.metrics.profitableTrades / this.metrics.totalTrades * 100) : 0;
        
        return {
            enabled: this.strategyConfig.enabled,
            learningMode: this.strategyConfig.learningMode,
            autoTradingMode: this.strategyConfig.autoTradingMode,
            totalPredictions: this.metrics.totalPredictions,
            accuracy: (this.metrics.accuracy * 100).toFixed(1) + '%',
            totalTrades: this.metrics.totalTrades,
            profitableTrades: this.metrics.profitableTrades,
            winRate: winRate.toFixed(1) + '%',
            totalProfit: this.metrics.totalProfit.toFixed(6) + ' WLD',
            activePositions: this.activePositions.size,
            lastRetraining: this.metrics.lastRetraining > 0 ? 
                new Date(this.metrics.lastRetraining).toLocaleString() : 'Never',
            trainingDataPoints: Object.values(this.trainingData)
                .reduce((sum, data) => sum + (data.features ? data.features.length : 0), 0)
        };
    }
    
    // Save Training Data
    saveData() {
        try {
            const data = {
                strategyConfig: this.strategyConfig,
                trainingData: this.trainingData,
                timestamp: Date.now()
            };
            
            fs.writeFileSync(this.dataPath, JSON.stringify(data, null, 2));
        } catch (error) {
            console.error('❌ Error saving ALGORITMIT data:', error.message);
        }
    }
    
    // Load Training Data
    loadData() {
        try {
            if (fs.existsSync(this.dataPath)) {
                const data = JSON.parse(fs.readFileSync(this.dataPath, 'utf8'));
                
                if (data.strategyConfig) {
                    Object.assign(this.strategyConfig, data.strategyConfig);
                }
                
                if (data.trainingData) {
                    this.trainingData = data.trainingData;
                }
                
                console.log('📊 ALGORITMIT data loaded');
            }
        } catch (error) {
            console.error('❌ Error loading ALGORITMIT data:', error.message);
        }
    }
    
    // Save Metrics
    saveMetrics() {
        try {
            fs.writeFileSync(this.metricsPath, JSON.stringify(this.metrics, null, 2));
        } catch (error) {
            console.error('❌ Error saving ALGORITMIT metrics:', error.message);
        }
    }
    
    // Load Metrics
    loadMetrics() {
        try {
            if (fs.existsSync(this.metricsPath)) {
                const data = JSON.parse(fs.readFileSync(this.metricsPath, 'utf8'));
                Object.assign(this.metrics, data);
                console.log('📊 ALGORITMIT metrics loaded');
            }
        } catch (error) {
            console.error('❌ Error loading ALGORITMIT metrics:', error.message);
        }
    }
    
    // Cleanup
    cleanup() {
        this.stopMonitoring();
        this.saveData();
        this.saveMetrics();
        console.log('🤖 ALGORITMIT Strategy cleaned up');
    }
}

module.exports = AlgoritmitStrategy;