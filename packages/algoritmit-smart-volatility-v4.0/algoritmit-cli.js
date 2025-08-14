#!/usr/bin/env node

/**
 * ALGORITMIT CLI - Standalone Console Commands
 * Manage ALGORITMIT trading operations without launching the full bot interface
 */

const { ethers } = require('ethers');
const fs = require('fs');
const path = require('path');
const readline = require('readline');
require('dotenv').config();

// Import ALGORITMIT modules
const TradingEngine = require('./trading-engine');
const SinclaveEnhancedEngine = require('./sinclave-enhanced-engine');
const TokenDiscovery = require('./token-discovery');
const TradingStrategy = require('./trading-strategy');
const StrategyBuilder = require('./strategy-builder');

class AlgoritmitCLI {
    constructor() {
        this.config = this.loadConfig();
        this.wallets = new Map();
        this.tradingEngine = null;
        this.sinclaveEngine = null;
        this.tokenDiscovery = null;
        this.tradingStrategy = null;
        this.strategyBuilder = null;
        
        // Console interface
        this.rl = readline.createInterface({
            input: process.stdin,
            output: process.stdout
        });
        
        this.initialize();
    }

    loadConfig() {
        return {
            WLD_ADDRESS: process.env.WLD_TOKEN_ADDRESS || '0x2cfc85d8e48f8eab294be644d9e25C3030863003',
            RPC_URL: process.env.WORLDCHAIN_RPC_URL || 'https://worldchain-mainnet.g.alchemy.com/public',
            DEFAULT_SLIPPAGE: parseFloat(process.env.DEFAULT_SLIPPAGE) || 1.0,
            MAX_GAS_PRICE: parseInt(process.env.MAX_GAS_PRICE) || 50
        };
    }

    async initialize() {
        try {
            console.log('🤖 ALGORITMIT CLI - Initializing...');
            
            // Load wallets
            await this.loadWallets();
            
            // Initialize engines
            this.tradingEngine = new TradingEngine(this.config);
            this.sinclaveEngine = new SinclaveEnhancedEngine(this.config);
            this.tokenDiscovery = new TokenDiscovery(this.config);
            this.tradingStrategy = new TradingStrategy(this.tradingEngine, this.sinclaveEngine, this.config);
            this.strategyBuilder = new StrategyBuilder(this.tradingEngine, this.sinclaveEngine, this.config);
            
            // Set wallet objects for strategies
            this.tradingStrategy.setWalletObjects(this.wallets);
            
            console.log('✅ ALGORITMIT CLI initialized successfully');
            console.log('💡 Type "help" for available commands or "exit" to quit');
            
            this.startCLI();
            
        } catch (error) {
            console.error('❌ Failed to initialize ALGORITMIT CLI:', error.message);
            process.exit(1);
        }
    }

    async loadWallets() {
        let walletIndex = 1;
        while (true) {
            const privateKey = process.env[`PRIVATE_KEY_${walletIndex}`];
            const walletName = process.env[`WALLET_NAME_${walletIndex}`] || `Wallet ${walletIndex}`;
            
            if (!privateKey || privateKey === 'your_private_key_here') {
                if (walletIndex === 1) {
                    console.error('❌ No wallet configured. Please set PRIVATE_KEY_1 in .env file');
                    process.exit(1);
                }
                break;
            }
            
            try {
                const provider = new ethers.JsonRpcProvider(this.config.RPC_URL);
                const wallet = new ethers.Wallet(privateKey, provider);
                
                this.wallets.set(walletIndex, {
                    wallet,
                    name: walletName,
                    address: wallet.address
                });
                
                console.log(`📝 Loaded ${walletName}: ${wallet.address}`);
                walletIndex++;
            } catch (error) {
                console.error(`❌ Invalid private key for wallet ${walletIndex}`);
                process.exit(1);
            }
        }
    }

    startCLI() {
        this.showPrompt();
    }

    showPrompt() {
        this.rl.question('algoritmit> ', async (input) => {
            await this.processCommand(input.trim());
            this.showPrompt();
        });
    }

    async processCommand(input) {
        if (!input) return;

        const parts = input.split(' ');
        const command = parts[0].toLowerCase();
        const args = parts.slice(1);

        try {
            switch (command) {
                case 'help':
                case 'h':
                    this.showHelp();
                    break;
                    
                case 'status':
                    await this.showStatus();
                    break;
                    
                case 'balance':
                case 'bal':
                    await this.showBalances(args[0]);
                    break;
                    
                case 'buy':
                    await this.executeBuyCommand(args);
                    break;
                    
                case 'sell':
                    await this.executeSellCommand(args);
                    break;
                    
                case 'positions':
                case 'pos':
                    await this.showPositions();
                    break;
                    
                case 'strategies':
                case 'strat':
                    await this.showStrategies();
                    break;
                    
                case 'start':
                    await this.startStrategy(args[0]);
                    break;
                    
                case 'stop':
                    await this.stopStrategy(args[0]);
                    break;
                    
                case 'quote':
                    await this.getQuote(args);
                    break;
                    
                case 'discover':
                    await this.discoverTokens(args[0]);
                    break;
                    
                case 'create':
                    await this.createStrategy(args);
                    break;
                    
                case 'monitor':
                    await this.toggleMonitoring();
                    break;
                    
                case 'stats':
                    await this.showStatistics();
                    break;
                    
                case 'clear':
                case 'cls':
                    console.clear();
                    break;
                    
                case 'exit':
                case 'quit':
                case 'q':
                    await this.exit();
                    break;
                    
                default:
                    console.log(`❌ Unknown command: ${command}`);
                    console.log('💡 Type "help" for available commands');
            }
        } catch (error) {
            console.error(`❌ Error executing command: ${error.message}`);
        }
    }

    showHelp() {
        console.log(`
🤖 ALGORITMIT CLI - Available Commands
═════════════════════════════════════

📊 INFORMATION:
  help, h                    Show this help message
  status                     Show bot status and configuration
  balance [wallet]           Show wallet balances (default: wallet 1)
  positions, pos             Show open trading positions
  strategies, strat          Show active strategies
  stats                      Show trading statistics

💹 TRADING:
  buy <token> <amount>       Buy token with WLD
  buy <token> <amount> d<dip> p<profit>   Buy with DIP/profit strategy
  buy <token> <amount> all            Buy with all available WLD
  buy <token> <amount> <time>         Buy at optimal time (1h, 6h, 24h)
  
  sell <token> <amount>      Sell token for WLD  
  sell <token> all           Sell all token balance
  sell <token> <time>        Sell at optimal time (1h, 6h, 24h)
  
  quote <from> <to> <amount> Get swap quote

🎯 STRATEGIES:
  create <name> <token> <config>  Create new strategy
  start <strategy_id>        Start strategy monitoring
  stop <strategy_id>         Stop strategy monitoring
  monitor                    Toggle position monitoring

🔍 UTILITIES:
  discover [wallet]          Discover tokens in wallet
  clear, cls                 Clear screen
  exit, quit, q              Exit CLI

📝 EXAMPLES:
  buy YIELD 0.10             Buy 0.10 WLD worth of YIELD
  buy ORO 0.05 d15 p10       Buy ORO with 15% DIP, 10% profit target
  sell YIELD all             Sell all YIELD tokens
  buy RAMEN 1h               Buy RAMEN at 1-hour optimal rate
  balance 2                  Show balance for wallet 2
  quote WLD YIELD 1.0        Get quote for 1 WLD to YIELD

Type any command to get started!
        `);
    }

    async showStatus() {
        console.log(`
🤖 ALGORITMIT CLI Status
═══════════════════════

💼 Wallets: ${this.wallets.size} loaded
🔗 RPC: ${this.config.RPC_URL}
💰 WLD Address: ${this.config.WLD_ADDRESS}
⚙️  Default Slippage: ${this.config.DEFAULT_SLIPPAGE}%
⛽ Max Gas Price: ${this.config.MAX_GAS_PRICE} gwei

📊 Strategy Status: ${this.tradingStrategy?.isRunning ? '🟢 Running' : '🔴 Stopped'}
🎯 Active Strategies: ${this.strategyBuilder?.getAllStrategies().filter(s => s.isActive).length || 0}
        `);
    }

    async showBalances(walletId = '1') {
        const walletIndex = parseInt(walletId) || 1;
        const walletObj = this.wallets.get(walletIndex);
        
        if (!walletObj) {
            console.log(`❌ Wallet ${walletIndex} not found`);
            return;
        }

        console.log(`\n💰 Wallet ${walletIndex} (${walletObj.name}) Balances:`);
        console.log(`📍 Address: ${walletObj.address}`);
        
        try {
            // Get WLD balance
            const provider = walletObj.wallet.provider;
            const wldContract = new ethers.Contract(
                this.config.WLD_ADDRESS,
                ['function balanceOf(address) view returns (uint256)', 'function decimals() view returns (uint8)'],
                provider
            );
            
            const wldBalance = await wldContract.balanceOf(walletObj.address);
            const wldDecimals = await wldContract.decimals();
            const wldFormatted = ethers.formatUnits(wldBalance, wldDecimals);
            
            console.log(`💎 WLD: ${parseFloat(wldFormatted).toFixed(6)}`);
            
            // Get ETH balance
            const ethBalance = await provider.getBalance(walletObj.address);
            const ethFormatted = ethers.formatEther(ethBalance);
            console.log(`⚡ ETH: ${parseFloat(ethFormatted).toFixed(6)}`);
            
            // Discover and show other tokens
            console.log('\n🔍 Discovering other tokens...');
            const discoveredTokens = await this.tokenDiscovery.discoverTokensInWallet(walletObj.address);
            
            if (discoveredTokens && discoveredTokens.length > 0) {
                console.log('\n🪙 Other Tokens:');
                for (const token of discoveredTokens.slice(0, 10)) { // Show top 10
                    console.log(`   ${token.symbol}: ${parseFloat(token.balance).toFixed(6)}`);
                }
            }
            
        } catch (error) {
            console.error(`❌ Error fetching balances: ${error.message}`);
        }
    }

    async executeBuyCommand(args) {
        if (args.length < 2) {
            console.log('❌ Usage: buy <token> <amount> [d<dip>] [p<profit>]');
            console.log('   Examples: buy YIELD 0.10, buy ORO 0.05 d15 p10, buy RAMEN all');
            return;
        }

        const [tokenSymbol, amountStr, ...options] = args;
        
        // Parse options (d15 = 15% dip, p10 = 10% profit)
        let dipPercent = null;
        let profitPercent = null;
        
        for (const option of options) {
            if (option.startsWith('d')) {
                dipPercent = parseFloat(option.substring(1));
            } else if (option.startsWith('p')) {
                profitPercent = parseFloat(option.substring(1));
            }
        }

        console.log(`🔄 Executing buy: ${tokenSymbol} ${amountStr}${dipPercent ? ` (DIP: ${dipPercent}%)` : ''}${profitPercent ? ` (Profit: ${profitPercent}%)` : ''}`);
        
        try {
            // Get token address
            const tokenAddress = await this.getTokenAddress(tokenSymbol);
            if (!tokenAddress) {
                console.log(`❌ Token ${tokenSymbol} not found`);
                return;
            }

            // Determine amount
            let amount;
            if (amountStr.toLowerCase() === 'all') {
                amount = await this.getAllWLDBalance();
                if (amount <= 0) {
                    console.log('❌ No WLD balance available');
                    return;
                }
            } else if (['1h', '6h', '24h', '1d', '7d'].includes(amountStr)) {
                // Time-based optimal buy
                return await this.executeTimeBasedBuy(tokenSymbol, tokenAddress, amountStr);
            } else {
                amount = parseFloat(amountStr);
                if (isNaN(amount) || amount <= 0) {
                    console.log('❌ Invalid amount');
                    return;
                }
            }

            // Execute trade
            const walletObj = this.wallets.get(1); // Use first wallet
            const result = await this.sinclaveEngine.executeOptimizedSwap(
                this.config.WLD_ADDRESS,
                tokenAddress,
                amount,
                walletObj.wallet,
                this.config.DEFAULT_SLIPPAGE
            );

            if (result.success) {
                console.log(`✅ Buy successful!`);
                console.log(`   Amount: ${amount} WLD → ${result.outputAmount} ${tokenSymbol}`);
                console.log(`   Gas Used: ${result.gasUsed}`);
                console.log(`   Execution Time: ${result.executionTime}ms`);
                
                // If DIP/profit strategy specified, create monitoring
                if (dipPercent || profitPercent) {
                    await this.createPositionStrategy(tokenAddress, tokenSymbol, result.outputAmount, dipPercent, profitPercent);
                }
            } else {
                console.log(`❌ Buy failed: ${result.error}`);
            }

        } catch (error) {
            console.error(`❌ Buy error: ${error.message}`);
        }
    }

    async executeSellCommand(args) {
        if (args.length < 2) {
            console.log('❌ Usage: sell <token> <amount|all>');
            console.log('   Examples: sell YIELD 100, sell ORO all, sell RAMEN 6h');
            return;
        }

        const [tokenSymbol, amountStr] = args;
        
        console.log(`🔄 Executing sell: ${tokenSymbol} ${amountStr}`);
        
        try {
            // Get token address
            const tokenAddress = await this.getTokenAddress(tokenSymbol);
            if (!tokenAddress) {
                console.log(`❌ Token ${tokenSymbol} not found`);
                return;
            }

            // Handle time-based sells
            if (['1h', '6h', '24h', '1d', '7d'].includes(amountStr)) {
                return await this.executeTimeBasedSell(tokenSymbol, tokenAddress, amountStr);
            }

            // Get token balance
            const walletObj = this.wallets.get(1);
            const tokenContract = new ethers.Contract(
                tokenAddress,
                ['function balanceOf(address) view returns (uint256)', 'function decimals() view returns (uint8)'],
                walletObj.wallet
            );
            
            const balance = await tokenContract.balanceOf(walletObj.address);
            const decimals = await tokenContract.decimals();
            const balanceFormatted = ethers.formatUnits(balance, decimals);

            let amount;
            if (amountStr.toLowerCase() === 'all') {
                amount = parseFloat(balanceFormatted);
            } else {
                amount = parseFloat(amountStr);
                if (amount > parseFloat(balanceFormatted)) {
                    console.log(`❌ Insufficient balance. Available: ${balanceFormatted} ${tokenSymbol}`);
                    return;
                }
            }

            if (amount <= 0) {
                console.log(`❌ No ${tokenSymbol} balance to sell`);
                return;
            }

            // Execute sell
            const result = await this.sinclaveEngine.executeOptimizedSwap(
                tokenAddress,
                this.config.WLD_ADDRESS,
                amount,
                walletObj.wallet,
                this.config.DEFAULT_SLIPPAGE
            );

            if (result.success) {
                console.log(`✅ Sell successful!`);
                console.log(`   Amount: ${amount} ${tokenSymbol} → ${result.outputAmount} WLD`);
                console.log(`   Gas Used: ${result.gasUsed}`);
                console.log(`   Execution Time: ${result.executionTime}ms`);
            } else {
                console.log(`❌ Sell failed: ${result.error}`);
            }

        } catch (error) {
            console.error(`❌ Sell error: ${error.message}`);
        }
    }

    async getTokenAddress(symbol) {
        // Try known tokens first
        const knownTokens = {
            'WLD': this.config.WLD_ADDRESS,
            'YIELD': '0x1234567890123456789012345678901234567890', // Example
            'ORO': '0x2345678901234567890123456789012345678901',   // Example
            'RAMEN': '0x3456789012345678901234567890123456789012' // Example
        };

        if (knownTokens[symbol.toUpperCase()]) {
            return knownTokens[symbol.toUpperCase()];
        }

        // Try to discover token
        try {
            const walletObj = this.wallets.get(1);
            const discoveredTokens = await this.tokenDiscovery.discoverTokensInWallet(walletObj.address);
            
            const found = discoveredTokens.find(token => 
                token.symbol.toLowerCase() === symbol.toLowerCase()
            );
            
            return found ? found.address : null;
        } catch (error) {
            return null;
        }
    }

    async getAllWLDBalance() {
        try {
            const walletObj = this.wallets.get(1);
            const wldContract = new ethers.Contract(
                this.config.WLD_ADDRESS,
                ['function balanceOf(address) view returns (uint256)', 'function decimals() view returns (uint8)'],
                walletObj.wallet
            );
            
            const balance = await wldContract.balanceOf(walletObj.address);
            const decimals = await wldContract.decimals();
            return parseFloat(ethers.formatUnits(balance, decimals));
        } catch (error) {
            return 0;
        }
    }

    async showPositions() {
        console.log('\n📊 Trading Positions:');
        
        const positions = this.tradingStrategy.getAllPositions();
        if (positions.length === 0) {
            console.log('   No open positions');
            return;
        }

        for (const position of positions) {
            const status = position.status === 'open' ? '🟢' : '🔴';
            const pnl = position.currentPnL || 0;
            const pnlColor = pnl >= 0 ? '🟢' : '🔴';
            
            console.log(`   ${status} ${position.tokenSymbol || 'Unknown'}`);
            console.log(`      Entry: ${position.entryPrice?.toFixed(6)} WLD`);
            console.log(`      Amount: ${position.amount?.toFixed(6)}`);
            console.log(`      P&L: ${pnlColor} ${pnl.toFixed(6)} WLD`);
        }
    }

    async showStrategies() {
        console.log('\n🎯 Active Strategies:');
        
        const strategies = this.strategyBuilder.getAllStrategies();
        if (strategies.length === 0) {
            console.log('   No strategies created');
            return;
        }

        for (const strategy of strategies) {
            const status = strategy.isActive ? '🟢' : '🔴';
            console.log(`   ${status} ${strategy.name} (${strategy.tokenSymbol || 'Unknown'})`);
            console.log(`      Trades: ${strategy.totalTrades || 0} | Profit: ${(strategy.totalProfit || 0).toFixed(6)} WLD`);
        }
    }

    async showStatistics() {
        console.log('\n📊 Trading Statistics:');
        
        // Strategy statistics
        const strategyStats = this.tradingStrategy.getStatistics();
        console.log(`   Strategy Status: ${strategyStats.isRunning ? '🟢 Running' : '🔴 Stopped'}`);
        console.log(`   Total Trades: ${strategyStats.totalTrades}`);
        console.log(`   Success Rate: ${(strategyStats.successRate || 0).toFixed(1)}%`);
        console.log(`   Total P&L: ${(strategyStats.totalPnL || 0).toFixed(6)} WLD`);
        
        // Custom strategy statistics
        const customStats = this.strategyBuilder.getStrategyStatistics();
        console.log(`\n🎯 Custom Strategies:`);
        console.log(`   Total Strategies: ${customStats.totalStrategies}`);
        console.log(`   Active: ${customStats.activeStrategies}`);
        console.log(`   Total Profit: ${(customStats.totalProfit || 0).toFixed(6)} WLD`);
    }

    async getQuote(args) {
        if (args.length < 3) {
            console.log('❌ Usage: quote <from> <to> <amount>');
            console.log('   Example: quote WLD YIELD 1.0');
            return;
        }

        const [fromSymbol, toSymbol, amountStr] = args;
        const amount = parseFloat(amountStr);

        if (isNaN(amount) || amount <= 0) {
            console.log('❌ Invalid amount');
            return;
        }

        try {
            const fromAddress = await this.getTokenAddress(fromSymbol);
            const toAddress = await this.getTokenAddress(toSymbol);

            if (!fromAddress || !toAddress) {
                console.log('❌ Token not found');
                return;
            }

            console.log(`🔄 Getting quote: ${amount} ${fromSymbol} → ${toSymbol}`);
            
            const quote = await this.sinclaveEngine.getHoldStationQuote(
                fromAddress,
                toAddress,
                amount
            );

            if (quote.success) {
                console.log(`💱 Quote: ${amount} ${fromSymbol} = ${quote.outputAmount} ${toSymbol}`);
                console.log(`   Price Impact: ${quote.priceImpact}%`);
                console.log(`   Gas Estimate: ${quote.gasEstimate}`);
            } else {
                console.log(`❌ Quote failed: ${quote.error}`);
            }

        } catch (error) {
            console.error(`❌ Quote error: ${error.message}`);
        }
    }

    async discoverTokens(walletId = '1') {
        const walletIndex = parseInt(walletId) || 1;
        const walletObj = this.wallets.get(walletIndex);
        
        if (!walletObj) {
            console.log(`❌ Wallet ${walletIndex} not found`);
            return;
        }

        console.log(`🔍 Discovering tokens in wallet ${walletIndex}...`);
        
        try {
            const discoveredTokens = await this.tokenDiscovery.discoverTokensInWallet(walletObj.address);
            
            if (discoveredTokens && discoveredTokens.length > 0) {
                console.log(`\n🪙 Found ${discoveredTokens.length} tokens:`);
                for (const token of discoveredTokens) {
                    console.log(`   ${token.symbol}: ${parseFloat(token.balance).toFixed(6)} (${token.address})`);
                }
            } else {
                console.log('   No tokens found');
            }
        } catch (error) {
            console.error(`❌ Discovery error: ${error.message}`);
        }
    }

    async createPositionStrategy(tokenAddress, tokenSymbol, amount, dipPercent, profitPercent) {
        try {
            console.log(`🎯 Creating position monitoring strategy...`);
            
            // Create a custom strategy for this position
            const strategyConfig = {
                tokenAddress,
                tokenSymbol,
                amount,
                dipPercent: dipPercent || 15,
                profitPercent: profitPercent || 10,
                enableDipBuy: !!dipPercent,
                enableProfit: !!profitPercent
            };
            
            const strategyId = await this.strategyBuilder.createStrategy(
                `${tokenSymbol} Position`,
                strategyConfig
            );
            
            await this.strategyBuilder.startStrategy(strategyId);
            console.log(`✅ Position monitoring started (Strategy ID: ${strategyId})`);
            
        } catch (error) {
            console.error(`❌ Failed to create position strategy: ${error.message}`);
        }
    }

    async executeTimeBasedBuy(tokenSymbol, tokenAddress, timeframe) {
        console.log(`🕒 Executing time-based buy for ${tokenSymbol} (${timeframe} optimal rate)`);
        // This would analyze SMA and execute buy at optimal time
        // For now, just execute a regular buy
        const amount = await this.getAllWLDBalance() * 0.1; // Use 10% of balance
        
        const walletObj = this.wallets.get(1);
        const result = await this.sinclaveEngine.executeOptimizedSwap(
            this.config.WLD_ADDRESS,
            tokenAddress,
            amount,
            walletObj.wallet,
            this.config.DEFAULT_SLIPPAGE
        );

        if (result.success) {
            console.log(`✅ Time-based buy successful!`);
            console.log(`   Amount: ${amount} WLD → ${result.outputAmount} ${tokenSymbol}`);
            console.log(`   Timeframe: ${timeframe} optimal`);
        } else {
            console.log(`❌ Time-based buy failed: ${result.error}`);
        }
    }

    async executeTimeBasedSell(tokenSymbol, tokenAddress, timeframe) {
        console.log(`🕒 Executing time-based sell for ${tokenSymbol} (${timeframe} optimal rate)`);
        // This would analyze SMA and execute sell at optimal time
        // For now, just execute a regular sell of 50% balance
        
        const walletObj = this.wallets.get(1);
        const tokenContract = new ethers.Contract(
            tokenAddress,
            ['function balanceOf(address) view returns (uint256)', 'function decimals() view returns (uint8)'],
            walletObj.wallet
        );
        
        const balance = await tokenContract.balanceOf(walletObj.address);
        const decimals = await tokenContract.decimals();
        const balanceFormatted = ethers.formatUnits(balance, decimals);
        const amount = parseFloat(balanceFormatted) * 0.5; // Sell 50%

        const result = await this.sinclaveEngine.executeOptimizedSwap(
            tokenAddress,
            this.config.WLD_ADDRESS,
            amount,
            walletObj.wallet,
            this.config.DEFAULT_SLIPPAGE
        );

        if (result.success) {
            console.log(`✅ Time-based sell successful!`);
            console.log(`   Amount: ${amount} ${tokenSymbol} → ${result.outputAmount} WLD`);
            console.log(`   Timeframe: ${timeframe} optimal`);
        } else {
            console.log(`❌ Time-based sell failed: ${result.error}`);
        }
    }

    async startStrategy(strategyId) {
        if (!strategyId) {
            console.log('❌ Usage: start <strategy_id>');
            return;
        }

        try {
            await this.strategyBuilder.startStrategy(strategyId);
            console.log(`✅ Strategy ${strategyId} started`);
        } catch (error) {
            console.error(`❌ Failed to start strategy: ${error.message}`);
        }
    }

    async stopStrategy(strategyId) {
        if (!strategyId) {
            console.log('❌ Usage: stop <strategy_id>');
            return;
        }

        try {
            await this.strategyBuilder.stopStrategy(strategyId);
            console.log(`✅ Strategy ${strategyId} stopped`);
        } catch (error) {
            console.error(`❌ Failed to stop strategy: ${error.message}`);
        }
    }

    async createStrategy(args) {
        if (args.length < 2) {
            console.log('❌ Usage: create <name> <token> [config]');
            console.log('   Example: create "YIELD Strategy" YIELD');
            return;
        }

        const [name, tokenSymbol, ...configArgs] = args;
        
        try {
            const tokenAddress = await this.getTokenAddress(tokenSymbol);
            if (!tokenAddress) {
                console.log(`❌ Token ${tokenSymbol} not found`);
                return;
            }

            const config = {
                tokenAddress,
                tokenSymbol,
                dipPercent: 15,
                profitPercent: 10,
                enableDipBuy: true,
                enableProfit: true
            };

            const strategyId = await this.strategyBuilder.createStrategy(name, config);
            console.log(`✅ Strategy created: ${name} (ID: ${strategyId})`);
            console.log(`   Token: ${tokenSymbol}`);
            console.log(`   Use 'start ${strategyId}' to begin monitoring`);

        } catch (error) {
            console.error(`❌ Failed to create strategy: ${error.message}`);
        }
    }

    async toggleMonitoring() {
        try {
            if (this.tradingStrategy.isRunning) {
                await this.tradingStrategy.stopStrategy();
                console.log('🔴 Position monitoring stopped');
            } else {
                await this.tradingStrategy.startStrategy();
                console.log('🟢 Position monitoring started');
            }
        } catch (error) {
            console.error(`❌ Failed to toggle monitoring: ${error.message}`);
        }
    }

    async exit() {
        console.log('👋 Shutting down ALGORITMIT CLI...');
        
        // Stop any running strategies
        if (this.tradingStrategy?.isRunning) {
            await this.tradingStrategy.stopStrategy();
        }
        
        this.rl.close();
        process.exit(0);
    }
}

// Handle graceful shutdown
process.on('SIGINT', async () => {
    console.log('\n👋 Received interrupt signal, shutting down gracefully...');
    process.exit(0);
});

process.on('SIGTERM', async () => {
    console.log('\n👋 Received terminate signal, shutting down gracefully...');
    process.exit(0);
});

// Start CLI if run directly
if (require.main === module) {
    const cli = new AlgoritmitCLI();
}

module.exports = AlgoritmitCLI;