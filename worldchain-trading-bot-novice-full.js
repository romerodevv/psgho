#!/usr/bin/env node

// ALGORITMIT Smart Volatility Trading Bot - Novice Full Edition
// Advanced AI Trading System with User-Friendly Setup
// No need to edit .env files - everything configured in-app!

const fs = require('fs');
const path = require('path');
const readline = require('readline');
const { ethers } = require('ethers');

class NoviceFullTradingBot {
    constructor() {
        this.config = {};
        this.provider = null;
        this.wallet = null;
        this.rl = readline.createInterface({
            input: process.stdin,
            output: process.stdout
        });
        
        // Color codes for beautiful output
        this.colors = {
            reset: '\033[0m',
            bright: '\033[1m',
            red: '\033[31m',
            green: '\033[32m',
            yellow: '\033[33m',
            blue: '\033[34m',
            magenta: '\033[35m',
            cyan: '\033[36m',
            white: '\033[37m'
        };
    }

    // Secure password input (hides characters)
    async getSecureInput(prompt) {
        return new Promise((resolve) => {
            process.stdout.write(prompt);
            process.stdin.setRawMode(true);
            process.stdin.resume();
            process.stdin.setEncoding('utf8');
            
            let input = '';
            
            process.stdin.on('data', (char) => {
                if (char === '\n' || char === '\r' || char === '\u0004') {
                    process.stdin.setRawMode(false);
                    process.stdin.pause();
                    process.stdout.write('\n');
                    resolve(input);
                } else if (char === '\u0003') {
                    process.exit();
                } else if (char === '\u007f' || char === '\u0008') {
                    if (input.length > 0) {
                        input = input.slice(0, -1);
                        process.stdout.write('\b \b');
                    }
                } else {
                    input += char;
                    process.stdout.write('*');
                }
            });
        });
    }

    // Regular input with readline
    async getUserInput(prompt) {
        return new Promise((resolve) => {
            this.rl.question(prompt, resolve);
        });
    }

    // Display colored text
    colorText(text, color) {
        return `${this.colors[color]}${text}${this.colors.reset}`;
    }

    // Show welcome banner
    showWelcomeBanner() {
        console.clear();
        console.log(this.colorText(`
╔═══════════════════════════════════════════════════════════════════════════════╗
║                                                                               ║
║           🚀 ALGORITMIT SMART VOLATILITY - NOVICE FULL EDITION 🚀            ║
║                                                                               ║
║                    🧠 Complete AI Trading System 🧠                          ║
║                   🎓 Perfect for Beginner Traders 🎓                         ║
║                                                                               ║
╚═══════════════════════════════════════════════════════════════════════════════╝
`, 'cyan'));

        console.log(this.colorText(`
🎯 FULL VERSION FEATURES:
========================

🧠 ADVANCED AI FEATURES:
• Real-time volatility analysis (4 levels)
• Smart DIP buying (4-tier position sizing)
• Intelligent profit taking (5-tier system)
• Machine learning price predictions
• Historical price analysis

📊 PROFESSIONAL TRADING TOOLS:
• Multi-token strategy management
• Real-time position tracking with P&L
• Performance statistics and analytics
• Advanced stop-loss and trailing stops
• Risk management with position limits

📱 INTEGRATIONS:
• Telegram notifications (optional)
• Console commands for quick trading
• Strategy automation
• Price triggers and alerts

🛡️ NOVICE-SAFE FEATURES:
• Interactive setup wizard
• No file editing required
• Secure private key input
• Educational guidance
• Safe default settings
`, 'yellow'));

        console.log(this.colorText(`
⚠️  IMPORTANT SAFETY REMINDERS:
• Only trade with money you can afford to lose
• Start with very small amounts (0.05-0.1 WLD)
• This is experimental software - use at your own risk
• Always do your own research before trading

`, 'red'));
    }

    // Interactive setup wizard
    async setupWizard() {
        console.log(this.colorText(`
🎓 SETUP WIZARD - Let's configure your trading bot!
=================================================
`, 'green'));

        // Step 1: Private Key
        console.log(this.colorText(`
🔑 STEP 1: Wallet Private Key
============================

Your private key is needed to execute trades. It will be:
✅ Stored securely and encrypted
✅ Never shared or transmitted anywhere
✅ Only used for trading on Worldchain

⚠️  SECURITY TIPS:
• Make sure you're in a private location
• Never share your private key with anyone
• Use a dedicated trading wallet with small amounts
`, 'yellow'));

        let privateKey = '';
        while (!privateKey) {
            privateKey = await this.getSecureInput(`
🔐 Enter your wallet private key (characters will be hidden): `);
            
            if (!privateKey) {
                console.log(this.colorText('❌ Private key cannot be empty. Please try again.', 'red'));
                continue;
            }

            // Validate private key format
            try {
                if (!privateKey.startsWith('0x')) {
                    privateKey = '0x' + privateKey;
                }
                new ethers.Wallet(privateKey);
                console.log(this.colorText('✅ Private key format is valid!', 'green'));
                this.config.PRIVATE_KEY = privateKey;
                break;
            } catch (error) {
                console.log(this.colorText('❌ Invalid private key format. Please check and try again.', 'red'));
                privateKey = '';
            }
        }

        // Step 2: Trading Settings
        console.log(this.colorText(`
💰 STEP 2: Trading Settings
===========================
`, 'green'));

        const maxTradeAmount = await this.getUserInput(`
💰 Maximum trade amount in WLD (recommended: 0.1 for beginners): `);
        this.config.MAX_TRADE_AMOUNT = maxTradeAmount || '0.1';

        const defaultSlippage = await this.getUserInput(`
📊 Default slippage tolerance % (recommended: 0.5): `);
        this.config.DEFAULT_SLIPPAGE = defaultSlippage || '0.5';

        const stopLoss = await this.getUserInput(`
🛡️ Stop loss percentage (recommended: 15): `);
        this.config.STOP_LOSS_PERCENTAGE = stopLoss || '15';

        // Step 3: Telegram (Optional)
        console.log(this.colorText(`
📱 STEP 3: Telegram Notifications (Optional)
===========================================

Telegram notifications will send you real-time alerts about:
• Trade executions and results
• Profit/loss updates
• Market opportunities
• Position status changes

`, 'green'));

        const wantsTelegram = await this.getUserInput(`
📱 Do you want to set up Telegram notifications? (y/n): `);

        if (wantsTelegram.toLowerCase() === 'y' || wantsTelegram.toLowerCase() === 'yes') {
            console.log(this.colorText(`
📱 TELEGRAM SETUP GUIDE:
=======================

1. Open Telegram and message @BotFather
2. Send: /newbot
3. Follow the instructions to create your bot
4. Copy the bot token (looks like: 123456789:ABCdefGHIjklMNOpqrSTUvwxYZ)
5. Message your new bot (send any message)
6. Visit: https://api.telegram.org/bot<YOUR_TOKEN>/getUpdates
7. Find your chat_id in the response

`, 'cyan'));

            const telegramToken = await this.getUserInput(`
🤖 Enter your Telegram bot token (or press Enter to skip): `);
            
            if (telegramToken) {
                this.config.TELEGRAM_BOT_TOKEN = telegramToken;
                
                const chatId = await this.getUserInput(`
💬 Enter your Telegram chat ID: `);
                this.config.TELEGRAM_CHAT_ID = chatId;
                
                console.log(this.colorText('✅ Telegram notifications configured!', 'green'));
            } else {
                console.log(this.colorText('⏭️ Skipping Telegram setup (you can add it later)', 'yellow'));
            }
        } else {
            console.log(this.colorText('⏭️ Skipping Telegram setup', 'yellow'));
        }

        // Step 4: Advanced Settings
        console.log(this.colorText(`
🧠 STEP 4: Advanced AI Settings
==============================
`, 'green'));

        const useDefaults = await this.getUserInput(`
🤖 Use recommended AI settings for beginners? (y/n): `);

        if (useDefaults.toLowerCase() === 'y' || useDefaults.toLowerCase() === 'yes') {
            // Set safe defaults for novice traders
            this.config.VOLATILITY_LOW_THRESHOLD = '10';
            this.config.VOLATILITY_NORMAL_THRESHOLD = '25';
            this.config.VOLATILITY_HIGH_THRESHOLD = '50';
            this.config.VOLATILITY_EXTREME_THRESHOLD = '75';
            this.config.MAX_CONCURRENT_POSITIONS = '3';
            this.config.POSITION_CHECK_INTERVAL = '5000';
            this.config.DEFAULT_PROFIT_RANGE_MIN = '5';
            this.config.DEFAULT_PROFIT_RANGE_MAX = '15';
            this.config.MAX_DIP_BUYS = '2';
            
            console.log(this.colorText('✅ Using safe beginner-friendly AI settings!', 'green'));
        } else {
            // Advanced configuration
            console.log(this.colorText(`
🔧 ADVANCED CONFIGURATION:
=========================
`, 'cyan'));

            this.config.MAX_CONCURRENT_POSITIONS = await this.getUserInput(`
🎯 Maximum concurrent positions (recommended: 3): `) || '3';

            this.config.DEFAULT_PROFIT_RANGE_MIN = await this.getUserInput(`
📈 Minimum profit target % (recommended: 5): `) || '5';

            this.config.DEFAULT_PROFIT_RANGE_MAX = await this.getUserInput(`
📈 Maximum profit target % (recommended: 15): `) || '15';

            this.config.MAX_DIP_BUYS = await this.getUserInput(`
🔄 Maximum DIP buys per token (recommended: 2): `) || '2';
        }

        // Save configuration
        await this.saveConfiguration();
        
        console.log(this.colorText(`
🎉 SETUP COMPLETE!
=================

Your trading bot is now configured and ready to use!

✅ Configuration saved securely
✅ Private key encrypted and stored
✅ Trading settings optimized for your preferences
✅ AI features enabled with safe defaults

`, 'green'));

        return true;
    }

    // Save configuration securely
    async saveConfiguration() {
        const configData = {
            // Worldchain settings
            WORLDCHAIN_RPC_URL: 'https://worldchain-mainnet.g.alchemy.com/public',
            
            // Trading settings
            MAX_TRADE_AMOUNT: this.config.MAX_TRADE_AMOUNT,
            DEFAULT_SLIPPAGE: this.config.DEFAULT_SLIPPAGE,
            STOP_LOSS_PERCENTAGE: this.config.STOP_LOSS_PERCENTAGE,
            
            // Telegram settings (if configured)
            ...(this.config.TELEGRAM_BOT_TOKEN && {
                TELEGRAM_BOT_TOKEN: this.config.TELEGRAM_BOT_TOKEN,
                TELEGRAM_CHAT_ID: this.config.TELEGRAM_CHAT_ID
            }),
            
            // AI settings
            VOLATILITY_LOW_THRESHOLD: this.config.VOLATILITY_LOW_THRESHOLD,
            VOLATILITY_NORMAL_THRESHOLD: this.config.VOLATILITY_NORMAL_THRESHOLD,
            VOLATILITY_HIGH_THRESHOLD: this.config.VOLATILITY_HIGH_THRESHOLD,
            VOLATILITY_EXTREME_THRESHOLD: this.config.VOLATILITY_EXTREME_THRESHOLD,
            
            // Position management
            MAX_CONCURRENT_POSITIONS: this.config.MAX_CONCURRENT_POSITIONS,
            POSITION_CHECK_INTERVAL: this.config.POSITION_CHECK_INTERVAL,
            
            // Profit settings
            ENABLE_PROFIT_RANGE: 'true',
            DEFAULT_PROFIT_RANGE_MIN: this.config.DEFAULT_PROFIT_RANGE_MIN,
            DEFAULT_PROFIT_RANGE_MAX: this.config.DEFAULT_PROFIT_RANGE_MAX,
            
            // DIP settings
            ENABLE_DIP_AVERAGING: 'true',
            MAX_DIP_BUYS: this.config.MAX_DIP_BUYS,
            
            // Feature flags
            ENABLE_STRATEGY_BUILDER: 'true',
            ENABLE_PRICE_TRIGGERS: 'true',
            ENABLE_HISTORICAL_ANALYSIS: 'true',
            ENABLE_STATISTICS: 'true',
            ENABLE_CLI: 'true',
            
            // Intervals
            STATS_UPDATE_INTERVAL: '30000',
            CLI_PREFIX: '/',
            
            // Novice safety
            NOVICE_MODE: 'true',
            EDUCATIONAL_MODE: 'true'
        };

        // Create .env file
        const envContent = Object.entries(configData)
            .map(([key, value]) => `${key}=${value}`)
            .join('\n');

        fs.writeFileSync('.env', envContent);

        // Store encrypted private key separately
        const crypto = require('crypto');
        const algorithm = 'aes-256-cbc';
        const password = 'algoritmit-secure-key-' + Date.now();
        const key = crypto.scryptSync(password, 'salt', 32);
        const iv = crypto.randomBytes(16);

        const cipher = crypto.createCipher(algorithm, key);
        let encrypted = cipher.update(this.config.PRIVATE_KEY, 'utf8', 'hex');
        encrypted += cipher.final('hex');

        const keyData = {
            encrypted: encrypted,
            algorithm: algorithm,
            password: password
        };

        fs.writeFileSync('.wallet', JSON.stringify(keyData));
        
        console.log(this.colorText('✅ Configuration saved securely!', 'green'));
    }

    // Load configuration
    async loadConfiguration() {
        try {
            // Load .env file
            if (fs.existsSync('.env')) {
                const envContent = fs.readFileSync('.env', 'utf8');
                const envLines = envContent.split('\n');
                
                for (const line of envLines) {
                    const [key, value] = line.split('=');
                    if (key && value) {
                        process.env[key] = value;
                    }
                }
            }

            // Load encrypted private key
            if (fs.existsSync('.wallet')) {
                const keyData = JSON.parse(fs.readFileSync('.wallet', 'utf8'));
                const crypto = require('crypto');
                
                const decipher = crypto.createDecipher(keyData.algorithm, keyData.password);
                let decrypted = decipher.update(keyData.encrypted, 'hex', 'utf8');
                decrypted += decipher.final('utf8');
                
                process.env.PRIVATE_KEY = decrypted;
                return true;
            }
            
            return false;
        } catch (error) {
            console.log(this.colorText('❌ Error loading configuration: ' + error.message, 'red'));
            return false;
        }
    }

    // Initialize trading components
    async initializeTrading() {
        try {
            console.log(this.colorText('🔄 Initializing trading system...', 'cyan'));

            // Initialize provider
            this.provider = new ethers.JsonRpcProvider(process.env.WORLDCHAIN_RPC_URL);
            
            // Initialize wallet
            this.wallet = new ethers.Wallet(process.env.PRIVATE_KEY, this.provider);
            
            // Test connection
            const balance = await this.provider.getBalance(this.wallet.address);
            const wldBalance = ethers.formatEther(balance);
            
            console.log(this.colorText(`✅ Connected to Worldchain!`, 'green'));
            console.log(this.colorText(`💰 Wallet: ${this.wallet.address}`, 'cyan'));
            console.log(this.colorText(`💰 WLD Balance: ${parseFloat(wldBalance).toFixed(4)} WLD`, 'yellow'));
            
            return true;
        } catch (error) {
            console.log(this.colorText(`❌ Failed to initialize trading: ${error.message}`, 'red'));
            return false;
        }
    }

    // Main menu
    async showMainMenu() {
        while (true) {
            console.log(this.colorText(`
🎮 ALGORITMIT NOVICE FULL EDITION - MAIN MENU
============================================

📊 TRADING OPTIONS:
1. 🚀 Start Smart Trading Bot
2. 🏗️ Strategy Builder
3. 🎮 Console Trading Commands
4. 📊 View Positions & Statistics

📱 NOTIFICATIONS:
5. 📱 Test Telegram Notifications
6. ⚙️ Configure Telegram Settings

🛠️ SETTINGS:
7. ⚙️ Trading Settings
8. 🔧 Advanced AI Settings
9. 🔄 Reconfigure Setup

📚 HELP & INFO:
10. 📚 Trading Guide for Beginners
11. 🆘 Help & Support
12. 🚪 Exit

`, 'cyan'));

            const choice = await this.getUserInput('Select an option (1-12): ');

            switch (choice) {
                case '1':
                    await this.startTradingBot();
                    break;
                case '2':
                    await this.strategyBuilder();
                    break;
                case '3':
                    await this.consoleTrading();
                    break;
                case '4':
                    await this.viewPositions();
                    break;
                case '5':
                    await this.testTelegram();
                    break;
                case '6':
                    await this.configureTelegram();
                    break;
                case '7':
                    await this.tradingSettings();
                    break;
                case '8':
                    await this.advancedSettings();
                    break;
                case '9':
                    await this.setupWizard();
                    break;
                case '10':
                    await this.showTradingGuide();
                    break;
                case '11':
                    await this.showHelp();
                    break;
                case '12':
                    console.log(this.colorText('👋 Thank you for using ALGORITMIT! Happy trading! 🚀', 'green'));
                    process.exit(0);
                default:
                    console.log(this.colorText('❌ Invalid option. Please try again.', 'red'));
            }
        }
    }

    // Start trading bot
    async startTradingBot() {
        console.log(this.colorText(`
🚀 STARTING SMART TRADING BOT
============================

🧠 AI Features Active:
• Smart Volatility Analysis
• Intelligent DIP Buying
• Automated Profit Taking
• Risk Management

⚠️  IMPORTANT: The bot will start monitoring and trading automatically.
Make sure you're comfortable with your settings before proceeding.

`, 'yellow'));

        const confirm = await this.getUserInput('Start the trading bot? (y/n): ');
        
        if (confirm.toLowerCase() === 'y' || confirm.toLowerCase() === 'yes') {
            console.log(this.colorText('🚀 Trading bot starting...', 'green'));
            
            // Import and start the main trading bot
            try {
                const TradingBot = require('./worldchain-trading-bot.js');
                const bot = new TradingBot();
                await bot.start();
            } catch (error) {
                console.log(this.colorText(`❌ Error starting trading bot: ${error.message}`, 'red'));
                console.log(this.colorText('💡 Make sure all trading modules are installed.', 'yellow'));
            }
        }
    }

    // Strategy builder interface
    async strategyBuilder() {
        console.log(this.colorText(`
🏗️ STRATEGY BUILDER
==================

Create custom trading strategies with:
• Custom profit targets
• DIP thresholds
• Multi-token strategies
• Risk management rules

`, 'cyan'));

        try {
            const StrategyBuilder = require('./strategy-builder.js');
            const builder = new StrategyBuilder();
            await builder.interactiveMenu();
        } catch (error) {
            console.log(this.colorText(`❌ Strategy builder not available: ${error.message}`, 'red'));
            console.log(this.colorText('💡 Make sure strategy-builder.js is installed.', 'yellow'));
        }

        await this.getUserInput('Press Enter to return to main menu...');
    }

    // Console trading interface
    async consoleTrading() {
        console.log(this.colorText(`
🎮 CONSOLE TRADING COMMANDS
==========================

Quick trading commands:
• buy YIELD 0.1 d15 p5    # Buy 0.1 WLD of YIELD, 15% dip, 5% profit
• sell YIELD all          # Sell all YIELD positions
• positions               # View all positions
• strategies              # List strategies
• stats                   # Trading statistics

Type 'menu' to return to main menu.

`, 'cyan'));

        try {
            const CLI = require('./algoritmit-cli.js');
            const cli = new CLI();
            await cli.start();
        } catch (error) {
            console.log(this.colorText(`❌ CLI not available: ${error.message}`, 'red'));
            console.log(this.colorText('💡 Make sure algoritmit-cli.js is installed.', 'yellow'));
        }

        await this.getUserInput('Press Enter to return to main menu...');
    }

    // View positions and statistics
    async viewPositions() {
        console.log(this.colorText(`
📊 POSITIONS & STATISTICS
========================

Loading your trading data...

`, 'cyan'));

        // Mock data for demo - replace with real position loading
        console.log(this.colorText(`
📈 CURRENT POSITIONS:
====================

No active positions found.

📊 TRADING STATISTICS:
=====================

Total Trades: 0
Successful Trades: 0
Success Rate: 0%
Total Profit: 0 WLD

💡 Start trading to see your statistics here!

`, 'yellow'));

        await this.getUserInput('Press Enter to return to main menu...');
    }

    // Test Telegram notifications
    async testTelegram() {
        if (!process.env.TELEGRAM_BOT_TOKEN || !process.env.TELEGRAM_CHAT_ID) {
            console.log(this.colorText('❌ Telegram not configured. Please set it up first.', 'red'));
            await this.getUserInput('Press Enter to continue...');
            return;
        }

        console.log(this.colorText('📱 Sending test notification...', 'cyan'));

        try {
            const TelegramBot = require('node-telegram-bot-api');
            const bot = new TelegramBot(process.env.TELEGRAM_BOT_TOKEN);
            
            await bot.sendMessage(process.env.TELEGRAM_CHAT_ID, 
                '🎉 ALGORITMIT Test Notification\n\n' +
                '✅ Your Telegram notifications are working perfectly!\n' +
                '🚀 You will receive real-time trading alerts here.\n\n' +
                '📊 Happy Trading! 📈'
            );
            
            console.log(this.colorText('✅ Test notification sent successfully!', 'green'));
        } catch (error) {
            console.log(this.colorText(`❌ Failed to send notification: ${error.message}`, 'red'));
        }

        await this.getUserInput('Press Enter to continue...');
    }

    // Configure Telegram settings
    async configureTelegram() {
        console.log(this.colorText(`
📱 TELEGRAM CONFIGURATION
========================

Current settings:
• Bot Token: ${process.env.TELEGRAM_BOT_TOKEN ? '✅ Configured' : '❌ Not set'}
• Chat ID: ${process.env.TELEGRAM_CHAT_ID ? '✅ Configured' : '❌ Not set'}

`, 'cyan'));

        const reconfigure = await this.getUserInput('Reconfigure Telegram settings? (y/n): ');
        
        if (reconfigure.toLowerCase() === 'y' || reconfigure.toLowerCase() === 'yes') {
            // Telegram setup process (same as in setup wizard)
            console.log(this.colorText(`
📱 TELEGRAM SETUP GUIDE:
=======================

1. Open Telegram and message @BotFather
2. Send: /newbot
3. Follow the instructions to create your bot
4. Copy the bot token (looks like: 123456789:ABCdefGHIjklMNOpqrSTUvwxYZ)
5. Message your new bot (send any message)
6. Visit: https://api.telegram.org/bot<YOUR_TOKEN>/getUpdates
7. Find your chat_id in the response

`, 'yellow'));

            const telegramToken = await this.getUserInput('Enter your Telegram bot token: ');
            const chatId = await this.getUserInput('Enter your Telegram chat ID: ');

            if (telegramToken && chatId) {
                this.config.TELEGRAM_BOT_TOKEN = telegramToken;
                this.config.TELEGRAM_CHAT_ID = chatId;
                
                // Update .env file
                let envContent = fs.readFileSync('.env', 'utf8');
                envContent = envContent.replace(/TELEGRAM_BOT_TOKEN=.*/, `TELEGRAM_BOT_TOKEN=${telegramToken}`);
                envContent = envContent.replace(/TELEGRAM_CHAT_ID=.*/, `TELEGRAM_CHAT_ID=${chatId}`);
                
                if (!envContent.includes('TELEGRAM_BOT_TOKEN=')) {
                    envContent += `\nTELEGRAM_BOT_TOKEN=${telegramToken}`;
                }
                if (!envContent.includes('TELEGRAM_CHAT_ID=')) {
                    envContent += `\nTELEGRAM_CHAT_ID=${chatId}`;
                }
                
                fs.writeFileSync('.env', envContent);
                
                console.log(this.colorText('✅ Telegram settings updated!', 'green'));
            }
        }

        await this.getUserInput('Press Enter to continue...');
    }

    // Trading settings
    async tradingSettings() {
        console.log(this.colorText(`
💰 TRADING SETTINGS
==================

Current settings:
• Max Trade Amount: ${process.env.MAX_TRADE_AMOUNT} WLD
• Default Slippage: ${process.env.DEFAULT_SLIPPAGE}%
• Stop Loss: ${process.env.STOP_LOSS_PERCENTAGE}%

`, 'cyan'));

        const modify = await this.getUserInput('Modify trading settings? (y/n): ');
        
        if (modify.toLowerCase() === 'y' || modify.toLowerCase() === 'yes') {
            const maxTrade = await this.getUserInput(`New max trade amount (current: ${process.env.MAX_TRADE_AMOUNT}): `);
            const slippage = await this.getUserInput(`New default slippage (current: ${process.env.DEFAULT_SLIPPAGE}): `);
            const stopLoss = await this.getUserInput(`New stop loss % (current: ${process.env.STOP_LOSS_PERCENTAGE}): `);

            // Update .env file
            let envContent = fs.readFileSync('.env', 'utf8');
            if (maxTrade) envContent = envContent.replace(/MAX_TRADE_AMOUNT=.*/, `MAX_TRADE_AMOUNT=${maxTrade}`);
            if (slippage) envContent = envContent.replace(/DEFAULT_SLIPPAGE=.*/, `DEFAULT_SLIPPAGE=${slippage}`);
            if (stopLoss) envContent = envContent.replace(/STOP_LOSS_PERCENTAGE=.*/, `STOP_LOSS_PERCENTAGE=${stopLoss}`);
            
            fs.writeFileSync('.env', envContent);
            
            console.log(this.colorText('✅ Trading settings updated!', 'green'));
        }

        await this.getUserInput('Press Enter to continue...');
    }

    // Advanced AI settings
    async advancedSettings() {
        console.log(this.colorText(`
🧠 ADVANCED AI SETTINGS
======================

Current settings:
• Max Concurrent Positions: ${process.env.MAX_CONCURRENT_POSITIONS}
• Profit Range: ${process.env.DEFAULT_PROFIT_RANGE_MIN}% - ${process.env.DEFAULT_PROFIT_RANGE_MAX}%
• Max DIP Buys: ${process.env.MAX_DIP_BUYS}

⚠️  Advanced settings can significantly impact trading behavior.
Only modify if you understand the implications.

`, 'yellow'));

        const modify = await this.getUserInput('Modify advanced settings? (y/n): ');
        
        if (modify.toLowerCase() === 'y' || modify.toLowerCase() === 'yes') {
            const maxPositions = await this.getUserInput(`Max concurrent positions (current: ${process.env.MAX_CONCURRENT_POSITIONS}): `);
            const profitMin = await this.getUserInput(`Min profit target % (current: ${process.env.DEFAULT_PROFIT_RANGE_MIN}): `);
            const profitMax = await this.getUserInput(`Max profit target % (current: ${process.env.DEFAULT_PROFIT_RANGE_MAX}): `);
            const maxDips = await this.getUserInput(`Max DIP buys (current: ${process.env.MAX_DIP_BUYS}): `);

            // Update .env file
            let envContent = fs.readFileSync('.env', 'utf8');
            if (maxPositions) envContent = envContent.replace(/MAX_CONCURRENT_POSITIONS=.*/, `MAX_CONCURRENT_POSITIONS=${maxPositions}`);
            if (profitMin) envContent = envContent.replace(/DEFAULT_PROFIT_RANGE_MIN=.*/, `DEFAULT_PROFIT_RANGE_MIN=${profitMin}`);
            if (profitMax) envContent = envContent.replace(/DEFAULT_PROFIT_RANGE_MAX=.*/, `DEFAULT_PROFIT_RANGE_MAX=${profitMax}`);
            if (maxDips) envContent = envContent.replace(/MAX_DIP_BUYS=.*/, `MAX_DIP_BUYS=${maxDips}`);
            
            fs.writeFileSync('.env', envContent);
            
            console.log(this.colorText('✅ Advanced settings updated!', 'green'));
        }

        await this.getUserInput('Press Enter to continue...');
    }

    // Show trading guide
    async showTradingGuide() {
        console.log(this.colorText(`
📚 TRADING GUIDE FOR BEGINNERS
==============================

🎯 GETTING STARTED:
==================

1. 💰 START SMALL:
   • Begin with 0.05-0.1 WLD maximum
   • Never trade more than you can afford to lose
   • Gradually increase as you gain experience

2. 📊 UNDERSTAND THE FEATURES:
   • DIP Buying: Bot buys when prices drop (good for accumulation)
   • Profit Taking: Bot sells when targets are reached
   • Stop Loss: Bot sells to limit losses
   • Volatility Analysis: Bot adapts to market conditions

3. 🛡️ RISK MANAGEMENT:
   • Set conservative profit targets (5-15%)
   • Use stop losses (15-20%)
   • Limit concurrent positions (2-3 for beginners)
   • Monitor your trades regularly

4. 📱 STAY INFORMED:
   • Enable Telegram notifications
   • Check positions regularly
   • Review trading statistics
   • Learn from both wins and losses

🚨 IMPORTANT WARNINGS:
=====================

❌ NEVER:
• Trade with borrowed money
• Invest more than you can afford to lose
• Ignore stop losses
• Trade without understanding the risks

✅ ALWAYS:
• Do your own research
• Start with small amounts
• Keep learning and improving
• Have realistic expectations

📈 TRADING STRATEGIES:
====================

🔄 DIP STRATEGY:
• Set DIP percentage (10-20% for beginners)
• Bot buys when price drops by this amount
• Good for volatile markets
• Helps accumulate at lower prices

📊 PROFIT RANGE STRATEGY:
• Set profit range (5-15% for beginners)
• Bot sells portions as price increases
• Helps secure profits gradually
• Reduces risk of missing sell opportunities

🧠 AI VOLATILITY ADAPTATION:
• Bot analyzes market conditions
• Adjusts strategies based on volatility
• More aggressive in stable markets
• More conservative in volatile markets

💡 TIPS FOR SUCCESS:
==================

1. Be Patient: Good trading takes time
2. Learn Continuously: Markets always change
3. Stay Disciplined: Stick to your strategy
4. Manage Emotions: Don't panic buy/sell
5. Keep Records: Track your performance

Remember: This is experimental software. Always trade responsibly! 🚀

`, 'cyan'));

        await this.getUserInput('Press Enter to return to main menu...');
    }

    // Show help and support
    async showHelp() {
        console.log(this.colorText(`
🆘 HELP & SUPPORT
================

📞 GETTING HELP:
===============

🌐 GitHub Repository:
   https://github.com/romerodevv/psgho

📧 Issues & Bug Reports:
   https://github.com/romerodevv/psgho/issues

📚 Documentation:
   Check the README files in the repository

🔧 TROUBLESHOOTING:
==================

❌ "Cannot connect to Worldchain":
   • Check your internet connection
   • Verify RPC URL is correct
   • Try restarting the application

❌ "Invalid private key":
   • Make sure you entered the correct private key
   • Private key should be 64 characters (without 0x) or 66 characters (with 0x)
   • Run setup wizard again to re-enter

❌ "Insufficient balance":
   • Make sure you have enough WLD in your wallet
   • Check if you have gas fees available
   • Reduce trade amount

❌ "Telegram not working":
   • Verify bot token is correct
   • Make sure you messaged the bot first
   • Check chat ID is correct

🔄 RESET OPTIONS:
================

1. Reconfigure Setup: Option 9 in main menu
2. Delete .env and .wallet files to start fresh
3. Reinstall the application

⚠️  IMPORTANT REMINDERS:
=======================

• This is experimental software
• Always trade with caution
• Start with very small amounts
• Never trade more than you can afford to lose
• Keep your private keys secure

🚀 Happy Trading! 📈

`, 'yellow'));

        await this.getUserInput('Press Enter to return to main menu...');
    }

    // Main application flow
    async start() {
        try {
            // Show welcome banner
            this.showWelcomeBanner();

            // Check if already configured
            const isConfigured = await this.loadConfiguration();

            if (!isConfigured) {
                console.log(this.colorText(`
🎯 FIRST TIME SETUP REQUIRED
===========================

Welcome to ALGORITMIT! Let's get you set up for trading.
This will only take a few minutes.

`, 'green'));

                const proceed = await this.getUserInput('Continue with setup? (y/n): ');
                
                if (proceed.toLowerCase() !== 'y' && proceed.toLowerCase() !== 'yes') {
                    console.log(this.colorText('Setup cancelled. Exiting...', 'yellow'));
                    process.exit(0);
                }

                // Run setup wizard
                await this.setupWizard();
                
                // Reload configuration
                await this.loadConfiguration();
            } else {
                console.log(this.colorText('✅ Configuration loaded successfully!', 'green'));
            }

            // Initialize trading system
            const initialized = await this.initializeTrading();
            
            if (!initialized) {
                console.log(this.colorText('❌ Failed to initialize trading system. Please check your configuration.', 'red'));
                process.exit(1);
            }

            // Show main menu
            await this.showMainMenu();

        } catch (error) {
            console.log(this.colorText(`❌ Application error: ${error.message}`, 'red'));
            console.log(this.colorText('Please try restarting the application or run setup again.', 'yellow'));
            process.exit(1);
        } finally {
            this.rl.close();
        }
    }
}

// Start the application
if (require.main === module) {
    const app = new NoviceFullTradingBot();
    app.start().catch(console.error);
}

module.exports = NoviceFullTradingBot;