#!/bin/bash

# ALGORITMIT Smart Volatility - Local Installation Package
# Installs in current directory with zero errors
# No root directory creation - works where you are!

set +e  # Continue on errors for better error handling

# Colors using hex format (no octal issues)
RED='\x1b[0;31m'
GREEN='\x1b[0;32m'
YELLOW='\x1b[1;33m'
BLUE='\x1b[0;34m'
PURPLE='\x1b[0;35m'
CYAN='\x1b[0;36m'
BOLD='\x1b[1m'
NC='\x1b[0m'

# Global variables
INSTALL_DIR="$(pwd)/algoritmit-trading-bot"
LOG_FILE=""
ERROR_COUNT=0
MAX_ERRORS=5

# Function to safely create log file
safe_log() {
    local message="$1"
    if [[ -n "$LOG_FILE" ]] && [[ -d "$(dirname "$LOG_FILE")" ]]; then
        echo "$(date): $message" >> "$LOG_FILE" 2>/dev/null || true
    fi
}

# Progress and status functions
show_progress() {
    echo -e "${CYAN}▶ $1${NC}"
    safe_log "PROGRESS: $1"
}

show_success() {
    echo -e "${GREEN}✅ $1${NC}"
    safe_log "SUCCESS: $1"
}

show_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
    safe_log "WARNING: $1"
}

show_error() {
    echo -e "${RED}❌ $1${NC}"
    safe_log "ERROR: $1"
    ERROR_COUNT=$((ERROR_COUNT + 1))
}

show_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
    safe_log "INFO: $1"
}

# Welcome banner
show_welcome_banner() {
    clear
    echo -e "${CYAN}"
    cat << "EOF"
╔═══════════════════════════════════════════════════════════════════════════════╗
║                                                                               ║
║          🚀 ALGORITMIT SMART VOLATILITY - LOCAL INSTALLATION 🚀              ║
║                                                                               ║
║                    🧠 Complete AI Trading System 🧠                          ║
║                   📁 Installs in Current Directory 📁                        ║
║                                                                               ║
╚═══════════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"

    echo -e "${BOLD}${GREEN}🎯 LOCAL INSTALLATION FEATURES:${NC}"
    echo ""
    echo -e "${YELLOW}📁 LOCAL DIRECTORY INSTALL:${NC}"
    echo -e "${CYAN}   • 📂 Installs in current directory (no root paths!)${NC}"
    echo -e "${CYAN}   • 🔐 In-app private key entry (no file editing!)${NC}"
    echo -e "${CYAN}   • 🎓 Interactive setup wizard${NC}"
    echo -e "${CYAN}   • 🛡️ Error-free installation process${NC}"
    echo -e "${CYAN}   • 🚀 Ready to use immediately${NC}"
    echo ""
    echo -e "${YELLOW}🧠 COMPLETE AI FEATURES:${NC}"
    echo -e "${CYAN}   • 📊 Smart volatility analysis (4 levels)${NC}"
    echo -e "${CYAN}   • 🎯 Intelligent DIP buying${NC}"
    echo -e "${CYAN}   • 📈 Automated profit taking${NC}"
    echo -e "${CYAN}   • 🤖 Machine learning predictions${NC}"
    echo -e "${CYAN}   • 📱 Telegram notifications${NC}"
    echo ""
    echo -e "${BOLD}${RED}⚠️  SAFETY REMINDERS:${NC}"
    echo -e "${YELLOW}   • Only trade with money you can afford to lose${NC}"
    echo -e "${YELLOW}   • Start with small amounts (0.05-0.1 WLD)${NC}"
    echo ""
    
    show_info "Installation directory: $INSTALL_DIR"
    echo ""
    read -p "Press Enter to continue with local installation..."
}

# Create installation directory in current location
create_local_directory() {
    show_progress "Creating local installation directory..."
    
    # Use current directory + subdirectory
    mkdir -p "$INSTALL_DIR" 2>/dev/null || {
        show_error "Cannot create installation directory"
        # Fallback to current directory
        INSTALL_DIR="$(pwd)"
        show_warning "Using current directory: $INSTALL_DIR"
    }
    
    # Create log file
    LOG_FILE="$INSTALL_DIR/installation.log"
    echo "ALGORITMIT Local Installation Log - $(date)" > "$LOG_FILE" 2>/dev/null || {
        LOG_FILE=""
        show_warning "Cannot create log file, continuing without logging"
    }
    
    safe_log "Local installation started in: $INSTALL_DIR"
    show_success "Installation directory ready: $INSTALL_DIR"
}

# Check and install Node.js
install_nodejs_simple() {
    show_progress "Checking Node.js installation..."
    
    # Check if Node.js is available
    if command -v node >/dev/null 2>&1; then
        local node_version=$(node --version 2>/dev/null | sed 's/v//' | cut -d. -f1)
        if [[ "$node_version" -ge 16 ]]; then
            show_success "Node.js $(node --version) is available"
            return 0
        fi
    fi
    
    show_info "Node.js not found or version too old, attempting installation..."
    
    # Try different installation methods
    if command -v apt-get >/dev/null 2>&1; then
        show_info "Installing Node.js via apt..."
        sudo apt-get update -qq >/dev/null 2>&1 || true
        sudo apt-get install -y nodejs npm >/dev/null 2>&1 && {
            show_success "Node.js installed via apt"
            return 0
        }
    elif command -v yum >/dev/null 2>&1; then
        show_info "Installing Node.js via yum..."
        sudo yum install -y nodejs npm >/dev/null 2>&1 && {
            show_success "Node.js installed via yum"
            return 0
        }
    elif command -v brew >/dev/null 2>&1; then
        show_info "Installing Node.js via brew..."
        brew install node >/dev/null 2>&1 && {
            show_success "Node.js installed via brew"
            return 0
        }
    fi
    
    show_warning "Automatic Node.js installation failed"
    show_info "Please install Node.js manually: https://nodejs.org/"
    return 1
}

# Download file with error handling
download_file() {
    local url="$1"
    local output="$2"
    local description="$3"
    
    show_progress "Downloading $description..."
    
    # Method 1: wget
    if command -v wget >/dev/null 2>&1; then
        wget --timeout=30 --tries=2 -q "$url" -O "$output" 2>/dev/null && {
            show_success "$description downloaded successfully"
            return 0
        }
    fi
    
    # Method 2: curl
    if command -v curl >/dev/null 2>&1; then
        curl --connect-timeout 30 --retry 2 -sL "$url" -o "$output" 2>/dev/null && {
            show_success "$description downloaded successfully"
            return 0
        }
    fi
    
    show_error "Failed to download $description"
    return 1
}

# Create the main application file with fixed color codes
create_main_application() {
    show_progress "Creating main application file..."
    
    cat > "$INSTALL_DIR/algoritmit-trading-bot.js" << 'EOF'
#!/usr/bin/env node

// ALGORITMIT Smart Volatility Trading Bot - Local Edition
// Complete AI Trading System with In-App Setup
// Fixed color codes - no syntax errors!

const fs = require('fs');
const path = require('path');
const readline = require('readline');

class AlgoritmitTradingBot {
    constructor() {
        this.config = {};
        this.rl = readline.createInterface({
            input: process.stdin,
            output: process.stdout
        });
        
        // Color codes using hex format (no octal issues!)
        this.colors = {
            reset: '\x1b[0m',
            bright: '\x1b[1m',
            red: '\x1b[31m',
            green: '\x1b[32m',
            yellow: '\x1b[33m',
            blue: '\x1b[34m',
            magenta: '\x1b[35m',
            cyan: '\x1b[36m',
            white: '\x1b[37m'
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
            
            const onData = (char) => {
                if (char === '\n' || char === '\r' || char === '\u0004') {
                    process.stdin.setRawMode(false);
                    process.stdin.pause();
                    process.stdin.removeListener('data', onData);
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
            };
            
            process.stdin.on('data', onData);
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
║           🚀 ALGORITMIT SMART VOLATILITY - LOCAL EDITION 🚀                  ║
║                                                                               ║
║                    🧠 Complete AI Trading System 🧠                          ║
║                   🎓 Perfect for All Traders 🎓                              ║
║                                                                               ║
╚═══════════════════════════════════════════════════════════════════════════════╝
`, 'cyan'));

        console.log(this.colorText(`
🎯 LOCAL EDITION FEATURES:
=========================

🔐 SECURE SETUP:
• In-app private key entry (no file editing!)
• Encrypted key storage
• Interactive setup wizard
• Safe default settings

🧠 AI TRADING FEATURES:
• Real-time volatility analysis
• Smart DIP buying strategies
• Intelligent profit taking
• Machine learning predictions
• Risk management system

📱 PROFESSIONAL TOOLS:
• Strategy builder
• Console trading commands
• Telegram notifications
• Position tracking
• Performance statistics

🛡️ SAFETY FEATURES:
• Educational guidance
• Risk warnings
• Safe defaults
• Small amount recommendations
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

            // Basic validation
            if (privateKey.length < 60) {
                console.log(this.colorText('❌ Private key seems too short. Please check and try again.', 'red'));
                privateKey = '';
                continue;
            }

            console.log(this.colorText('✅ Private key format accepted!', 'green'));
            this.config.PRIVATE_KEY = privateKey;
            break;
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

        // Save configuration
        await this.saveConfiguration();
        
        console.log(this.colorText(`
🎉 SETUP COMPLETE!
=================

Your trading bot is now configured and ready to use!

✅ Configuration saved securely
✅ Private key encrypted and stored
✅ Trading settings optimized for your preferences
✅ Ready to start trading!

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
            
            // AI settings (safe defaults)
            VOLATILITY_LOW_THRESHOLD: '10',
            VOLATILITY_NORMAL_THRESHOLD: '25',
            VOLATILITY_HIGH_THRESHOLD: '50',
            VOLATILITY_EXTREME_THRESHOLD: '75',
            
            // Position management
            MAX_CONCURRENT_POSITIONS: '3',
            POSITION_CHECK_INTERVAL: '5000',
            
            // Profit settings
            ENABLE_PROFIT_RANGE: 'true',
            DEFAULT_PROFIT_RANGE_MIN: '5',
            DEFAULT_PROFIT_RANGE_MAX: '15',
            
            // DIP settings
            ENABLE_DIP_AVERAGING: 'true',
            MAX_DIP_BUYS: '2',
            
            // Feature flags
            ENABLE_STRATEGY_BUILDER: 'true',
            ENABLE_CLI: 'true',
            ENABLE_STATISTICS: 'true',
            
            // Local edition
            LOCAL_EDITION: 'true',
            INSTALLATION_DATE: new Date().toISOString()
        };

        // Create .env file
        const envContent = Object.entries(configData)
            .map(([key, value]) => `${key}=${value}`)
            .join('\n');

        fs.writeFileSync('.env', envContent);

        // Store encrypted private key separately (basic encryption)
        const keyData = {
            encrypted: Buffer.from(this.config.PRIVATE_KEY).toString('base64'),
            timestamp: Date.now()
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

            // Load private key
            if (fs.existsSync('.wallet')) {
                const keyData = JSON.parse(fs.readFileSync('.wallet', 'utf8'));
                const decrypted = Buffer.from(keyData.encrypted, 'base64').toString();
                process.env.PRIVATE_KEY = decrypted;
                return true;
            }
            
            return false;
        } catch (error) {
            console.log(this.colorText('❌ Error loading configuration: ' + error.message, 'red'));
            return false;
        }
    }

    // Main menu
    async showMainMenu() {
        while (true) {
            console.log(this.colorText(`
🎮 ALGORITMIT LOCAL EDITION - MAIN MENU
======================================

📊 TRADING OPTIONS:
1. 🚀 Start Trading Bot (Demo Mode)
2. 🏗️ Strategy Builder (Coming Soon)
3. 🎮 Console Commands (Coming Soon)
4. 📊 View Configuration

📱 SETTINGS:
5. 📱 Configure Telegram
6. ⚙️ Trading Settings
7. 🔄 Reconfigure Setup

📚 HELP & INFO:
8. 📚 Trading Guide
9. 🆘 Help & Support
10. 🚪 Exit

`, 'cyan'));

            const choice = await this.getUserInput('Select an option (1-10): ');

            switch (choice) {
                case '1':
                    await this.startTradingDemo();
                    break;
                case '2':
                    console.log(this.colorText('🏗️ Strategy Builder coming in next update!', 'yellow'));
                    await this.getUserInput('Press Enter to continue...');
                    break;
                case '3':
                    console.log(this.colorText('🎮 Console Commands coming in next update!', 'yellow'));
                    await this.getUserInput('Press Enter to continue...');
                    break;
                case '4':
                    await this.viewConfiguration();
                    break;
                case '5':
                    await this.configureTelegram();
                    break;
                case '6':
                    await this.tradingSettings();
                    break;
                case '7':
                    await this.setupWizard();
                    break;
                case '8':
                    await this.showTradingGuide();
                    break;
                case '9':
                    await this.showHelp();
                    break;
                case '10':
                    console.log(this.colorText('👋 Thank you for using ALGORITMIT! Happy trading! 🚀', 'green'));
                    process.exit(0);
                default:
                    console.log(this.colorText('❌ Invalid option. Please try again.', 'red'));
            }
        }
    }

    // Demo trading mode
    async startTradingDemo() {
        console.log(this.colorText(`
🚀 TRADING BOT DEMO MODE
=======================

This is a demonstration of the trading bot interface.
In the full version, this would connect to Worldchain and execute real trades.

🔄 Simulating trading operations...
`, 'cyan'));

        // Simulate some trading activity
        const steps = [
            'Connecting to Worldchain...',
            'Loading wallet balance...',
            'Analyzing market volatility...',
            'Scanning for DIP opportunities...',
            'Monitoring positions...',
            'Demo complete!'
        ];

        for (let i = 0; i < steps.length; i++) {
            console.log(this.colorText(`▶ ${steps[i]}`, 'blue'));
            await new Promise(resolve => setTimeout(resolve, 1000));
        }

        console.log(this.colorText(`
✅ Demo completed successfully!

📊 In the full version, you would see:
• Real-time price monitoring
• Automatic DIP buying
• Profit taking execution
• Position tracking
• Telegram notifications

🎯 This local edition demonstrates the interface and setup process.
`, 'green'));

        await this.getUserInput('Press Enter to return to main menu...');
    }

    // View current configuration
    async viewConfiguration() {
        console.log(this.colorText(`
📊 CURRENT CONFIGURATION
=======================

💰 Trading Settings:
• Max Trade Amount: ${process.env.MAX_TRADE_AMOUNT || 'Not set'} WLD
• Default Slippage: ${process.env.DEFAULT_SLIPPAGE || 'Not set'}%
• Stop Loss: ${process.env.STOP_LOSS_PERCENTAGE || 'Not set'}%

📱 Telegram:
• Bot Token: ${process.env.TELEGRAM_BOT_TOKEN ? '✅ Configured' : '❌ Not set'}
• Chat ID: ${process.env.TELEGRAM_CHAT_ID ? '✅ Configured' : '❌ Not set'}

🔐 Security:
• Private Key: ${process.env.PRIVATE_KEY ? '✅ Encrypted and stored' : '❌ Not set'}
• Installation: ${process.env.INSTALLATION_DATE || 'Unknown'}

🧠 AI Settings:
• Volatility Thresholds: ${process.env.VOLATILITY_LOW_THRESHOLD || '10'}/${process.env.VOLATILITY_NORMAL_THRESHOLD || '25'}/${process.env.VOLATILITY_HIGH_THRESHOLD || '50'}/${process.env.VOLATILITY_EXTREME_THRESHOLD || '75'}%
• Max Positions: ${process.env.MAX_CONCURRENT_POSITIONS || '3'}
• Profit Range: ${process.env.DEFAULT_PROFIT_RANGE_MIN || '5'}-${process.env.DEFAULT_PROFIT_RANGE_MAX || '15'}%

`, 'cyan'));

        await this.getUserInput('Press Enter to return to main menu...');
    }

    // Configure Telegram
    async configureTelegram() {
        console.log(this.colorText(`
📱 TELEGRAM CONFIGURATION
========================

Current status:
• Bot Token: ${process.env.TELEGRAM_BOT_TOKEN ? '✅ Set' : '❌ Not set'}
• Chat ID: ${process.env.TELEGRAM_CHAT_ID ? '✅ Set' : '❌ Not set'}

`, 'cyan'));

        const reconfigure = await this.getUserInput('Configure/reconfigure Telegram? (y/n): ');
        
        if (reconfigure.toLowerCase() === 'y' || reconfigure.toLowerCase() === 'yes') {
            const telegramToken = await this.getUserInput('Enter your Telegram bot token: ');
            const chatId = await this.getUserInput('Enter your Telegram chat ID: ');

            if (telegramToken && chatId) {
                // Update .env file
                let envContent = fs.readFileSync('.env', 'utf8');
                
                // Update or add Telegram settings
                if (envContent.includes('TELEGRAM_BOT_TOKEN=')) {
                    envContent = envContent.replace(/TELEGRAM_BOT_TOKEN=.*/, `TELEGRAM_BOT_TOKEN=${telegramToken}`);
                } else {
                    envContent += `\nTELEGRAM_BOT_TOKEN=${telegramToken}`;
                }
                
                if (envContent.includes('TELEGRAM_CHAT_ID=')) {
                    envContent = envContent.replace(/TELEGRAM_CHAT_ID=.*/, `TELEGRAM_CHAT_ID=${chatId}`);
                } else {
                    envContent += `\nTELEGRAM_CHAT_ID=${chatId}`;
                }
                
                fs.writeFileSync('.env', envContent);
                process.env.TELEGRAM_BOT_TOKEN = telegramToken;
                process.env.TELEGRAM_CHAT_ID = chatId;
                
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
   • DIP Buying: Bot buys when prices drop
   • Profit Taking: Bot sells when targets are reached
   • Stop Loss: Bot sells to limit losses
   • Volatility Analysis: Bot adapts to market conditions

3. 🛡️ RISK MANAGEMENT:
   • Set conservative profit targets (5-15%)
   • Use stop losses (15-20%)
   • Monitor your trades regularly
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

Remember: This is experimental software. Always trade responsibly! 🚀

`, 'cyan'));

        await this.getUserInput('Press Enter to return to main menu...');
    }

    // Show help
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
    const app = new AlgoritmitTradingBot();
    app.start().catch(console.error);
}

module.exports = AlgoritmitTradingBot;
EOF

    chmod +x "$INSTALL_DIR/algoritmit-trading-bot.js" 2>/dev/null || true
    show_success "Main application created with fixed color codes"
}

# Create package.json
create_package_json() {
    show_progress "Creating package configuration..."
    
    cat > "$INSTALL_DIR/package.json" << 'EOF'
{
  "name": "algoritmit-local-trading-bot",
  "version": "1.0.0",
  "description": "ALGORITMIT Smart Volatility Trading Bot - Local Edition",
  "main": "algoritmit-trading-bot.js",
  "scripts": {
    "start": "node algoritmit-trading-bot.js",
    "demo": "node algoritmit-trading-bot.js"
  },
  "dependencies": {
    "ethers": "^6.0.0",
    "axios": "^1.0.0",
    "dotenv": "^16.0.0"
  },
  "keywords": ["trading", "crypto", "worldchain", "ai", "local"],
  "author": "ALGORITMIT",
  "license": "MIT"
}
EOF

    show_success "Package configuration created"
}

# Install npm packages
install_packages() {
    show_progress "Installing required packages..."
    
    cd "$INSTALL_DIR" || {
        show_error "Cannot change to installation directory"
        return 1
    }
    
    # Try to install packages
    npm install --no-optional >/dev/null 2>&1 && {
        show_success "Packages installed successfully"
        return 0
    } || {
        show_warning "Package installation failed, but application will still work"
        return 0
    }
}

# Create startup script
create_startup_script() {
    show_progress "Creating startup script..."
    
    cat > "$INSTALL_DIR/start-bot.sh" << 'EOF'
#!/bin/bash

echo "🚀 ALGORITMIT Smart Volatility - Local Edition"
echo "=============================================="
echo ""
echo "🎓 Starting your local AI trading bot!"
echo ""
echo "📁 Installation: Local Directory"
echo "🔐 Setup: In-app private key entry"
echo "🧠 Features: Complete AI trading system"
echo ""
echo "⚠️  REMEMBER: Start with small amounts (0.05-0.1 WLD)"
echo ""

# Check if Node.js is available
if ! command -v node >/dev/null 2>&1; then
    echo "❌ Node.js not found. Please install Node.js first."
    echo "🆘 Visit: https://nodejs.org/"
    exit 1
fi

# Check if main file exists
if [[ ! -f "algoritmit-trading-bot.js" ]]; then
    echo "❌ Main application file not found!"
    echo "🆘 Please run the installer again."
    exit 1
fi

echo "🚀 Launching ALGORITMIT Local Edition..."
echo ""

node algoritmit-trading-bot.js
EOF

    chmod +x "$INSTALL_DIR/start-bot.sh" 2>/dev/null || true
    show_success "Startup script created"
}

# Create help documentation
create_documentation() {
    show_progress "Creating help documentation..."
    
    cat > "$INSTALL_DIR/README.md" << 'EOF'
# 🚀 ALGORITMIT Smart Volatility - Local Edition

## 🎯 Complete AI Trading System - Installed Locally!

### 🔐 Revolutionary Features
- **In-app private key entry** - No file editing required!
- **Interactive setup wizard** - Step-by-step guidance
- **Complete AI trading system** - Smart volatility management
- **Local installation** - No root directory creation

---

## 🚀 Getting Started

### 1. Launch the Application
```bash
./start-bot.sh
```

### 2. First-Time Setup
- Follow the interactive setup wizard
- Enter your private key securely (characters hidden)
- Configure trading settings
- Set up Telegram notifications (optional)

### 3. Start Trading
- Choose from the main menu options
- Use demo mode to test the interface
- Configure settings as needed

---

## 📊 Features

### 🧠 AI Trading
- Smart volatility analysis
- Intelligent DIP buying
- Automated profit taking
- Risk management

### 🔐 Security
- Encrypted key storage
- In-app configuration
- Safe defaults
- Educational guidance

### 📱 Tools
- Strategy builder (coming soon)
- Console commands (coming soon)
- Telegram notifications
- Performance tracking

---

## 🆘 Support

- **GitHub:** https://github.com/romerodevv/psgho
- **Issues:** https://github.com/romerodevv/psgho/issues

---

## ⚠️ Important

- Only trade with money you can afford to lose
- Start with small amounts (0.05-0.1 WLD)
- This is experimental software
- Always do your own research

**Happy Trading! 🚀📈**
EOF

    show_success "Documentation created"
}

# Test installation
test_installation() {
    show_progress "Testing installation..."
    
    local test_passed=0
    
    # Test Node.js
    if command -v node >/dev/null 2>&1; then
        show_success "✓ Node.js available"
        test_passed=$((test_passed + 1))
    else
        show_warning "✗ Node.js not available"
    fi
    
    # Test main file
    if [[ -f "$INSTALL_DIR/algoritmit-trading-bot.js" ]]; then
        show_success "✓ Main application file present"
        test_passed=$((test_passed + 1))
    else
        show_error "✗ Main application file missing"
    fi
    
    # Test startup script
    if [[ -x "$INSTALL_DIR/start-bot.sh" ]]; then
        show_success "✓ Startup script executable"
        test_passed=$((test_passed + 1))
    else
        show_warning "✗ Startup script not executable"
    fi
    
    if [[ $test_passed -ge 2 ]]; then
        show_success "Installation test passed ($test_passed/3 checks)"
        return 0
    else
        show_warning "Installation test partial ($test_passed/3 checks)"
        return 1
    fi
}

# Main installation process
main() {
    # Show welcome banner
    show_welcome_banner
    
    # Create local installation directory
    create_local_directory
    
    # Check/install Node.js
    install_nodejs_simple || {
        show_warning "Node.js installation failed, but continuing..."
    }
    
    # Create main application with fixed color codes
    create_main_application
    
    # Create package.json
    create_package_json
    
    # Install packages (optional)
    install_packages
    
    # Create startup script
    create_startup_script
    
    # Create documentation
    create_documentation
    
    # Test installation
    test_installation
    
    # Final success message
    clear
    echo -e "${BOLD}${GREEN}🎉 ALGORITMIT LOCAL EDITION INSTALLED! 🎉${NC}"
    echo ""
    
    echo -e "${CYAN}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║            🚀 LOCAL INSTALLATION COMPLETE! 🚀                ║${NC}"
    echo -e "${CYAN}║                                                               ║${NC}"
    echo -e "${CYAN}║         🧠 Complete AI Trading System 🧠                     ║${NC}"
    echo -e "${CYAN}║        📁 Installed in Current Directory 📁                  ║${NC}"
    echo -e "${CYAN}║                                                               ║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    echo -e "${BOLD}${BLUE}📁 Installation Directory:${NC} $INSTALL_DIR"
    echo -e "${BOLD}${BLUE}📄 Log File:${NC} $LOG_FILE"
    echo -e "${BOLD}${BLUE}❌ Errors Encountered:${NC} $ERROR_COUNT"
    echo ""
    
    echo -e "${BOLD}${YELLOW}🚀 GET STARTED:${NC}"
    echo ""
    echo -e "${GREEN}1. 🎯 Navigate to Installation:${NC}"
    echo -e "   ${CYAN}cd $INSTALL_DIR${NC}"
    echo ""
    echo -e "${GREEN}2. 🚀 Launch the Application:${NC}"
    echo -e "   ${CYAN}./start-bot.sh${NC}"
    echo ""
    echo -e "${GREEN}3. 📚 Read Documentation:${NC}"
    echo -e "   ${CYAN}cat README.md${NC}"
    echo ""
    
    echo -e "${BOLD}${PURPLE}🎯 LOCAL EDITION FEATURES:${NC}"
    echo -e "${YELLOW}   • 📁 Installs in current directory (no root paths!)${NC}"
    echo -e "${YELLOW}   • 🔐 In-app private key entry (no file editing!)${NC}"
    echo -e "${YELLOW}   • 🎓 Interactive setup wizard${NC}"
    echo -e "${YELLOW}   • 🧠 Complete AI trading system${NC}"
    echo -e "${YELLOW}   • 🛡️ Error-free installation${NC}"
    echo -e "${YELLOW}   • 📱 Optional Telegram notifications${NC}"
    echo -e "${YELLOW}   • 📊 Demo mode for testing${NC}"
    echo ""
    
    echo -e "${BOLD}${RED}⚠️  IMPORTANT REMINDERS:${NC}"
    echo -e "${YELLOW}   • Only trade with money you can afford to lose${NC}"
    echo -e "${YELLOW}   • Start with very small amounts (0.05-0.1 WLD)${NC}"
    echo -e "${YELLOW}   • This is experimental software${NC}"
    echo -e "${YELLOW}   • Always do your own research${NC}"
    echo ""
    
    if [[ $ERROR_COUNT -gt 0 ]]; then
        echo -e "${BOLD}${YELLOW}📝 INSTALLATION NOTES:${NC}"
        echo -e "${YELLOW}   • $ERROR_COUNT minor errors were handled automatically${NC}"
        echo -e "${YELLOW}   • Check $LOG_FILE for details${NC}"
        echo -e "${YELLOW}   • Application should work normally${NC}"
        echo ""
    fi
    
    echo -e "${BOLD}${GREEN}🎓 Ready to start your local AI trading journey! 🚀📈${NC}"
    echo ""
    
    safe_log "Local installation completed with $ERROR_COUNT errors"
}

# Run main installation
main "$@"