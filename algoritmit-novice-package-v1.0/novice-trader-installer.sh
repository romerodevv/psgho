#!/bin/bash

# ALGORITMIT Smart Volatility v4.0 - Novice Trader Installer
# Designed specifically for beginners with step-by-step guidance

set -e

# Colors for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Function to show progress
show_progress() {
    echo -e "${CYAN}▶ $1${NC}"
    sleep 1
}

# Function to show success
show_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

# Function to show warning
show_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Function to show error
show_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Function to show info
show_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Function to wait for user confirmation
wait_for_user() {
    echo -e "${YELLOW}Press Enter to continue...${NC}"
    read -r
}

# ASCII Art Banner
clear
echo -e "${CYAN}"
cat << "EOF"
╔═══════════════════════════════════════════════════════════════════════════════╗
║                                                                               ║
║     🎓 ALGORITMIT SMART VOLATILITY v4.0 - NOVICE TRADER INSTALLER 🎓          ║
║                                                                               ║
║                    🚀 Your First Step Into AI Trading! 🚀                     ║
║                                                                               ║
║                      📚 Learn • 🛡️ Trade Safe • 💰 Profit                     ║
║                                                                               ║
╚═══════════════════════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

echo -e "${BOLD}${GREEN}Welcome to ALGORITMIT Smart Volatility Trading System!${NC}"
echo -e "${BLUE}This installer is designed specifically for novice traders.${NC}"
echo ""

# Introduction and Education
echo -e "${BOLD}${CYAN}📚 WHAT YOU'LL LEARN TODAY:${NC}"
echo -e "${GREEN}• How to set up an AI-powered trading bot${NC}"
echo -e "${GREEN}• Understanding smart volatility trading${NC}"
echo -e "${GREEN}• Safe trading practices for beginners${NC}"
echo -e "${GREEN}• How to start with small amounts and scale up${NC}"
echo ""

echo -e "${BOLD}${PURPLE}🧠 WHAT MAKES THIS SPECIAL:${NC}"
echo -e "${YELLOW}• AI automatically adapts to market volatility${NC}"
echo -e "${YELLOW}• Buys BIGGER on larger market crashes${NC}"
echo -e "${YELLOW}• Sells FASTER on big price jumps${NC}"
echo -e "${YELLOW}• Never buys above your average price${NC}"
echo -e "${YELLOW}• Automatic profit-taking (no manual selling!)${NC}"
echo ""

show_warning "IMPORTANT: This is educational software. Only trade with money you can afford to lose!"
echo ""
wait_for_user

# Safety and Risk Education
clear
echo -e "${BOLD}${RED}🛡️  TRADING SAFETY - PLEASE READ CAREFULLY 🛡️${NC}"
echo ""
echo -e "${BOLD}${YELLOW}GOLDEN RULES FOR NOVICE TRADERS:${NC}"
echo -e "${GREEN}1. 💰 Start SMALL: Begin with 0.05-0.1 WLD (about $1-2)${NC}"
echo -e "${GREEN}2. 🎯 Learn First: Understand how the bot works before scaling${NC}"
echo -e "${GREEN}3. 👀 Monitor: Watch your first trades to learn the patterns${NC}"
echo -e "${GREEN}4. 📱 Use Notifications: Set up Telegram for real-time alerts${NC}"
echo -e "${GREEN}5. 🔒 Secure Wallet: Use a dedicated trading wallet with limited funds${NC}"
echo ""

echo -e "${BOLD}${RED}WHAT TO EXPECT:${NC}"
echo -e "${BLUE}• The bot will auto-sell when profit targets are reached${NC}"
echo -e "${BLUE}• It adapts to market volatility automatically${NC}"
echo -e "${BLUE}• You'll see bigger buys on larger market dips${NC}"
echo -e "${BLUE}• Profits are taken faster during big price jumps${NC}"
echo ""

echo -e "${BOLD}${CYAN}EXAMPLE: If you set a 5% profit target...${NC}"
echo -e "${YELLOW}• Normal market: Sells at 5% profit${NC}"
echo -e "${YELLOW}• Volatile market: Sells at 7.5% profit${NC}"
echo -e "${YELLOW}• Extreme market: Sells at 12.5% profit${NC}"
echo ""

show_info "The bot gets SMARTER and MORE AGGRESSIVE when opportunities are BIGGER!"
echo ""
wait_for_user

# System Check and Requirements
clear
echo -e "${BOLD}${CYAN}🔍 CHECKING YOUR SYSTEM${NC}"
echo ""

show_progress "Detecting operating system..."
OS="Unknown"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="Linux"
    DISTRO=$(lsb_release -si 2>/dev/null || echo "Unknown")
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macOS"
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    OS="Windows"
fi

show_success "System: $OS"
if [[ "$OS" == "Linux" ]]; then
    show_info "Distribution: $DISTRO"
fi
echo ""

# Check if running as root
if [[ $EUID -eq 0 ]]; then
    show_warning "Running as root detected. We'll create a safe user directory."
    INSTALL_DIR="/root/algoritmit-novice-trader"
else
    INSTALL_DIR="$HOME/algoritmit-novice-trader"
fi

show_info "Installation directory: $INSTALL_DIR"
echo ""

# Prerequisites Check
show_progress "Checking prerequisites..."

# Check Node.js
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    NODE_MAJOR=$(echo $NODE_VERSION | cut -d'.' -f1 | sed 's/v//')
    if [[ $NODE_MAJOR -ge 18 ]]; then
        show_success "Node.js: $NODE_VERSION (Perfect!)"
    else
        show_warning "Node.js: $NODE_VERSION (Need v18+)"
        NEED_NODE=true
    fi
else
    show_warning "Node.js not found - will install"
    NEED_NODE=true
fi

# Check npm
if command -v npm &> /dev/null; then
    NPM_VERSION=$(npm --version)
    show_success "npm: v$NPM_VERSION"
else
    show_warning "npm not found - will install with Node.js"
fi

# Check git
if command -v git &> /dev/null; then
    GIT_VERSION=$(git --version)
    show_success "$GIT_VERSION"
else
    show_warning "git not found - will install"
    NEED_GIT=true
fi

echo ""
wait_for_user

# Install Dependencies
if [[ "$NEED_NODE" == true ]] || [[ "$NEED_GIT" == true ]]; then
    clear
    echo -e "${BOLD}${CYAN}📦 INSTALLING REQUIRED SOFTWARE${NC}"
    echo ""
    
    show_info "We need to install some software for the trading bot to work."
    show_info "This is like installing the 'engine' that powers the bot."
    echo ""
    
    if [[ "$OS" == "Linux" ]]; then
        show_progress "Updating package lists..."
        sudo apt-get update > /dev/null 2>&1
        
        if [[ "$NEED_NODE" == true ]]; then
            show_progress "Installing Node.js v20 (JavaScript runtime)..."
            curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - > /dev/null 2>&1
            sudo apt-get install -y nodejs > /dev/null 2>&1
            show_success "Node.js installed!"
        fi
        
        if [[ "$NEED_GIT" == true ]]; then
            show_progress "Installing Git (version control)..."
            sudo apt-get install -y git > /dev/null 2>&1
            show_success "Git installed!"
        fi
        
        show_progress "Installing additional tools..."
        sudo apt-get install -y curl wget unzip build-essential > /dev/null 2>&1
        
    elif [[ "$OS" == "macOS" ]]; then
        if ! command -v brew &> /dev/null; then
            show_progress "Installing Homebrew (package manager)..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        
        if [[ "$NEED_NODE" == true ]]; then
            show_progress "Installing Node.js..."
            brew install node
            show_success "Node.js installed!"
        fi
        
        if [[ "$NEED_GIT" == true ]]; then
            show_progress "Installing Git..."
            brew install git
            show_success "Git installed!"
        fi
    fi
    
    show_success "All required software installed!"
    echo ""
    wait_for_user
fi

# Create Installation Directory
clear
echo -e "${BOLD}${CYAN}📁 SETTING UP YOUR TRADING WORKSPACE${NC}"
echo ""

show_progress "Creating your personal trading directory..."

if [[ -d "$INSTALL_DIR" ]]; then
    show_warning "Directory already exists. Creating backup..."
    mv "$INSTALL_DIR" "$INSTALL_DIR.backup.$(date +%s)"
fi

mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

show_success "Trading workspace created at: $INSTALL_DIR"
echo ""

# Download Files
show_progress "Downloading ALGORITMIT Smart Volatility files..."
show_info "This is like downloading the 'brain' of your trading bot."
echo ""

# Download all core files
show_progress "Downloading main trading bot..."
wget -q --show-progress https://raw.githubusercontent.com/romerodevv/psgho/main/packages/algoritmit-smart-volatility-v4.0/worldchain-trading-bot.js

show_progress "Downloading smart strategy system..."
wget -q --show-progress https://raw.githubusercontent.com/romerodevv/psgho/main/packages/algoritmit-smart-volatility-v4.0/strategy-builder.js

show_progress "Downloading Telegram notifications..."
wget -q --show-progress https://raw.githubusercontent.com/romerodevv/psgho/main/packages/algoritmit-smart-volatility-v4.0/telegram-notifications.js

show_progress "Downloading price database..."
wget -q --show-progress https://raw.githubusercontent.com/romerodevv/psgho/main/packages/algoritmit-smart-volatility-v4.0/price-database.js

show_progress "Downloading trading engines..."
wget -q --show-progress https://raw.githubusercontent.com/romerodevv/psgho/main/packages/algoritmit-smart-volatility-v4.0/sinclave-enhanced-engine.js
wget -q --show-progress https://raw.githubusercontent.com/romerodevv/psgho/main/packages/algoritmit-smart-volatility-v4.0/trading-engine.js
wget -q --show-progress https://raw.githubusercontent.com/romerodevv/psgho/main/packages/algoritmit-smart-volatility-v4.0/trading-strategy.js
wget -q --show-progress https://raw.githubusercontent.com/romerodevv/psgho/main/packages/algoritmit-smart-volatility-v4.0/token-discovery.js

show_progress "Downloading configuration files..."
wget -q --show-progress https://raw.githubusercontent.com/romerodevv/psgho/main/packages/algoritmit-smart-volatility-v4.0/package.json
wget -q --show-progress https://raw.githubusercontent.com/romerodevv/psgho/main/packages/algoritmit-smart-volatility-v4.0/.env.example

show_success "All files downloaded successfully!"
echo ""

# Install Dependencies
show_progress "Installing Node.js packages (this may take a few minutes)..."
show_info "Think of this as installing all the 'tools' the bot needs to work."
echo ""

npm install --no-optional --legacy-peer-deps > /dev/null 2>&1

show_success "All packages installed!"
echo ""

# Create Novice-Friendly Startup Scripts
show_progress "Creating easy-to-use startup scripts..."

# Main startup script with beginner guidance
cat > start-trading-bot.sh << 'EOF'
#!/bin/bash

# ALGORITMIT Smart Volatility - Novice Trader Launcher

clear
echo "🎓 ALGORITMIT Smart Volatility Trading Bot - Novice Edition"
echo "=========================================================="
echo ""

# Check if .env exists
if [[ ! -f ".env" ]]; then
    echo "❌ Configuration file not found!"
    echo ""
    echo "📝 FIRST TIME SETUP REQUIRED:"
    echo "1. Copy the example configuration: cp .env.example .env"
    echo "2. Edit your settings: nano .env"
    echo "3. Add your private key and other settings"
    echo ""
    echo "🆘 Need help? Run: ./setup-help.sh"
    exit 1
fi

echo "🚀 Starting your AI trading bot..."
echo "📊 Smart Volatility Management Active"
echo "🛡️ Novice-Safe Settings Enabled"
echo ""
echo "💡 TIP: Your bot will:"
echo "   • Auto-sell when profit targets are reached"
echo "   • Buy bigger on larger market dips"
echo "   • Adapt to market volatility automatically"
echo ""
echo "⚠️  REMEMBER: Start with small amounts (0.05-0.1 WLD)"
echo ""

# Start the bot
node worldchain-trading-bot.js
EOF

# Setup help script
cat > setup-help.sh << 'EOF'
#!/bin/bash

clear
echo "🆘 ALGORITMIT Setup Help - For Novice Traders"
echo "=============================================="
echo ""

echo "📝 STEP-BY-STEP SETUP GUIDE:"
echo ""
echo "1️⃣  COPY CONFIGURATION FILE:"
echo "   cp .env.example .env"
echo ""
echo "2️⃣  EDIT YOUR SETTINGS:"
echo "   nano .env"
echo ""
echo "3️⃣  REQUIRED SETTINGS TO ADD:"
echo ""
echo "   🔑 PRIVATE_KEY=your_wallet_private_key_here"
echo "      ↳ This is your wallet's private key (keep it secret!)"
echo ""
echo "   🌐 WORLDCHAIN_RPC_URL=https://worldchain-mainnet.g.alchemy.com/public"
echo "      ↳ This connects to the blockchain (use the default)"
echo ""
echo "4️⃣  OPTIONAL TELEGRAM NOTIFICATIONS:"
echo "   📱 TELEGRAM_BOT_TOKEN=your_bot_token"
echo "   📱 TELEGRAM_CHAT_ID=your_chat_id"
echo "      ↳ Get real-time trading alerts on your phone"
echo ""
echo "5️⃣  SAFE TRADING SETTINGS (RECOMMENDED FOR BEGINNERS):"
echo "   💰 DEFAULT_SLIPPAGE=0.5"
echo "   ⚡ GAS_PRICE_MULTIPLIER=1.1"
echo "   🛡️ MAX_TRADE_AMOUNT=0.1"
echo ""
echo "🎯 AFTER SETUP:"
echo "   ./start-trading-bot.sh"
echo ""
echo "🆘 NEED MORE HELP?"
echo "   • Check the .env.example file for all options"
echo "   • Start with VERY small amounts first!"
echo "   • Monitor your first few trades closely"
echo ""
EOF

# Quick start script for experienced users
cat > quick-start.sh << 'EOF'
#!/bin/bash

echo "⚡ ALGORITMIT Quick Start"
echo "========================"
echo ""

if [[ ! -f ".env" ]]; then
    echo "📝 Setting up configuration..."
    cp .env.example .env
    echo "✅ Configuration file created (.env)"
    echo ""
    echo "🔧 NEXT STEPS:"
    echo "1. Edit .env file: nano .env"
    echo "2. Add your PRIVATE_KEY"
    echo "3. Run: ./start-trading-bot.sh"
    echo ""
else
    echo "🚀 Starting trading bot..."
    node worldchain-trading-bot.js
fi
EOF

# Make scripts executable
chmod +x start-trading-bot.sh setup-help.sh quick-start.sh

show_success "Startup scripts created!"
echo ""

# Create Configuration
show_progress "Setting up configuration file..."

cp .env.example .env

# Create a novice-friendly .env with comments
cat > .env << 'EOF'
# 🎓 ALGORITMIT Smart Volatility - Novice Trader Configuration
# ============================================================

# 🔑 WALLET CONFIGURATION (REQUIRED)
# Your wallet's private key - KEEP THIS SECRET!
# Example: PRIVATE_KEY=0x1234567890abcdef...
PRIVATE_KEY=your_private_key_here

# 🌐 BLOCKCHAIN CONNECTION (REQUIRED)
# This connects to Worldchain - use the default unless you have your own
WORLDCHAIN_RPC_URL=https://worldchain-mainnet.g.alchemy.com/public

# 📱 TELEGRAM NOTIFICATIONS (OPTIONAL but RECOMMENDED)
# Get real-time alerts on your phone - see setup-help.sh for instructions
TELEGRAM_BOT_TOKEN=
TELEGRAM_CHAT_ID=

# ⚙️ TRADING SETTINGS (NOVICE-SAFE DEFAULTS)
# How much price difference you'll accept (0.5% = very tight)
DEFAULT_SLIPPAGE=0.5

# How fast to process transactions (1.1 = slightly faster)
GAS_PRICE_MULTIPLIER=1.1

# Maximum amount to trade in one go (0.1 WLD = about $2-3)
MAX_TRADE_AMOUNT=0.1

# How often to check prices (30 seconds)
PRICE_CHECK_INTERVAL=30000

# 🛡️ SAFETY SETTINGS (HIGHLY RECOMMENDED FOR BEGINNERS)
# Maximum gas price to prevent expensive transactions
MAX_GAS_PRICE=50

# Stop loss percentage (sell if loss reaches 15%)
STOP_LOSS_PERCENTAGE=15

# 🎯 SMART VOLATILITY SETTINGS (ADVANCED)
# These control how the AI adapts to market conditions
# Leave as default unless you understand what they do

# Volatility detection sensitivity
VOLATILITY_LOW_THRESHOLD=10
VOLATILITY_NORMAL_THRESHOLD=25
VOLATILITY_HIGH_THRESHOLD=50

# Position sizing multipliers for different dip sizes
DIP_SMALL_MULTIPLIER=0.5
DIP_MEDIUM_MULTIPLIER=1.0
DIP_LARGE_MULTIPLIER=1.5
DIP_EXTREME_MULTIPLIER=2.0

# 📚 EDUCATIONAL NOTES:
# - Start with 0.05-0.1 WLD for your first trades
# - The bot will auto-sell when profit targets are reached
# - It buys bigger on larger market dips automatically
# - Monitor your first trades to understand the behavior
# - Never trade more than you can afford to lose!
EOF

show_success "Configuration file created with novice-safe defaults!"
echo ""

# Create Educational Materials
show_progress "Creating educational materials..."

# Create a beginner's guide
cat > NOVICE_TRADING_GUIDE.md << 'EOF'
# 🎓 ALGORITMIT Smart Volatility - Novice Trader Guide

## 🚀 Welcome to AI-Powered Trading!

This guide will help you understand how to use ALGORITMIT safely and effectively as a beginner.

## 🛡️ Safety First - Golden Rules

### 1. Start Small
- Begin with 0.05-0.1 WLD (about $1-3)
- Only use money you can afford to lose
- Scale up gradually as you gain experience

### 2. Understand Before You Trade
- The bot automatically buys and sells for you
- It adapts to market volatility in real-time
- Bigger market crashes = bigger buys
- Bigger price jumps = faster sells

### 3. Monitor Your Trades
- Watch your first few trades closely
- Learn how the bot behaves in different markets
- Set up Telegram notifications for real-time alerts

## 🧠 How Smart Volatility Works

### Normal Market Conditions
- 15% price drop → Small buy (0.5x your normal amount)
- 5% profit target → Sells at 5% profit

### Volatile Market Conditions  
- 30% price drop → Medium buy (1x your normal amount)
- 60% price drop → Large buy (1.5x your normal amount)
- 5% profit target → Sells at 7.5% profit (adapts higher)

### Extreme Market Conditions
- 90% price drop → Extreme buy (2x your normal amount)
- 5% profit target → Sells at 12.5% profit (much higher)

## 📱 Setting Up Telegram Notifications

1. Message @BotFather on Telegram
2. Send `/newbot` and follow instructions
3. Copy your bot token
4. Message your bot first
5. Visit: `https://api.telegram.org/bot<TOKEN>/getUpdates`
6. Find your chat ID
7. Add both to your .env file

## 🎯 Your First Strategy

### Recommended Beginner Settings:
- **Profit Target**: 5-10% (conservative)
- **DIP Threshold**: 15% (standard sensitivity)
- **Trade Amount**: 0.05-0.1 WLD (very safe)
- **Token**: Start with established tokens like YIELD or ORO

### What to Expect:
1. Bot monitors price constantly
2. When price drops 15% from recent high → Buys
3. When profit target reached → Auto-sells
4. In volatile markets → Adapts thresholds automatically

## 📊 Understanding Your Results

### Good Signs:
- Regular small profits (2-10%)
- Bot buying on dips and selling on peaks
- Telegram notifications showing successful trades

### Warning Signs:
- Consistent losses (check your settings)
- Bot not trading (check token liquidity)
- High gas fees (adjust GAS_PRICE_MULTIPLIER)

## 🆘 Common Issues and Solutions

### "No liquidity available"
- Try a different token with more trading volume
- Reduce your trade amount
- Increase slippage tolerance slightly

### "Private key invalid"
- Check your .env file format
- Make sure there are no spaces around the = sign
- Ensure your private key starts with 0x

### "High execution time"
- Normal for complex trades
- Consider increasing GAS_PRICE_MULTIPLIER for faster execution

## 📈 Scaling Up

### After 10+ Successful Small Trades:
1. Gradually increase trade amounts
2. Try different tokens
3. Experiment with different profit targets
4. Consider multiple strategies

### Advanced Features (After 1+ Month):
- Multiple token strategies
- Custom DIP thresholds
- Historical price analysis
- Price triggers

## 🎯 Success Tips

1. **Be Patient**: Good opportunities take time
2. **Stay Informed**: Understand the tokens you're trading
3. **Keep Learning**: Each trade teaches you something
4. **Stay Safe**: Never risk more than you can afford
5. **Have Fun**: Trading should be exciting, not stressful!

## 📚 Additional Resources

- Repository: https://github.com/romerodevv/psgho
- Worldchain Documentation: https://worldchain.org
- Trading Education: Start with small amounts and learn!

Remember: The goal is to learn and grow as a trader while the AI handles the complex volatility analysis for you!
EOF

# Create a troubleshooting guide
cat > TROUBLESHOOTING.md << 'EOF'
# 🔧 ALGORITMIT Troubleshooting Guide

## 🚨 Common Issues and Solutions

### Configuration Issues

#### ❌ "Configuration file not found"
**Solution:**
```bash
cp .env.example .env
nano .env  # Add your settings
```

#### ❌ "Private key invalid"
**Check:**
- Format: `PRIVATE_KEY=0x1234567890abcdef...`
- No spaces around the = sign
- Private key starts with 0x

#### ❌ "RPC connection failed"
**Solutions:**
1. Check internet connection
2. Try alternative RPC: `WORLDCHAIN_RPC_URL=https://worldchain-mainnet.g.alchemy.com/v2/your-api-key`
3. Restart the bot

### Trading Issues

#### ❌ "No liquidity available"
**Solutions:**
1. Reduce trade amount: `MAX_TRADE_AMOUNT=0.05`
2. Increase slippage: `DEFAULT_SLIPPAGE=1.0`
3. Try different token with more volume

#### ❌ "High execution time"
**Solutions:**
1. Increase gas multiplier: `GAS_PRICE_MULTIPLIER=1.3`
2. Reduce trade frequency: `PRICE_CHECK_INTERVAL=60000`
3. Normal for complex trades - be patient

#### ❌ "Bot not trading"
**Check:**
1. Token has enough liquidity
2. DIP threshold not too high
3. Price movement sufficient to trigger trades

### System Issues

#### ❌ "Node.js not found"
**Solution:**
```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs
```

#### ❌ "npm install fails"
**Solution:**
```bash
npm install --no-optional --legacy-peer-deps
```

#### ❌ "Permission denied"
**Solution:**
```bash
chmod +x start-trading-bot.sh
sudo chown -R $USER:$USER ~/algoritmit-novice-trader
```

### Telegram Issues

#### ❌ "Telegram notifications not working"
**Check:**
1. Bot token format: `123456789:ABC-DEF1234ghIkl-zyx57W2v1u123ew11`
2. Chat ID is numeric: `123456789`
3. You messaged the bot first
4. Test with: `curl -X POST "https://api.telegram.org/bot<TOKEN>/sendMessage" -d "chat_id=<CHAT_ID>&text=test"`

## 📞 Getting Help

1. **Check this guide first**
2. **Review your .env configuration**
3. **Start with smaller amounts**
4. **GitHub Issues**: https://github.com/romerodevv/psgho/issues
5. **Community Discussions**: https://github.com/romerodevv/psgho/discussions

## 🎯 Prevention Tips

1. **Always backup** your .env file
2. **Test with small amounts** first
3. **Monitor first trades** closely
4. **Keep system updated**: `sudo apt update && sudo apt upgrade`
5. **Regular restarts** if running 24/7

Remember: Most issues are configuration-related. Double-check your .env file!
EOF

show_success "Educational materials created!"
echo ""

# Create Desktop Shortcut (Linux only)
if [[ "$OS" == "Linux" ]] && [[ -d "$HOME/Desktop" ]]; then
    show_progress "Creating desktop shortcut..."
    
    cat > "$HOME/Desktop/ALGORITMIT-Novice-Trader.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=ALGORITMIT Novice Trader
Comment=AI-Powered Trading Bot for Beginners
Exec=$INSTALL_DIR/start-trading-bot.sh
Icon=utilities-terminal
Terminal=true
Categories=Office;Finance;Education;
EOF
    
    chmod +x "$HOME/Desktop/ALGORITMIT-Novice-Trader.desktop"
    show_success "Desktop shortcut created!"
fi

echo ""

# Final Success Message
clear
echo -e "${BOLD}${GREEN}🎉 INSTALLATION COMPLETE! 🎉${NC}"
echo ""

echo -e "${CYAN}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║                  🎓 NOVICE TRADER EDITION 🎓                   ║${NC}"
echo -e "${CYAN}║                                                               ║${NC}"
echo -e "${CYAN}║           🧠 Smart Volatility AI Trading System 🧠            ║${NC}"
echo -e "${CYAN}║                                                               ║${NC}"
echo -e "${CYAN}╚═══════════════════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${BOLD}${BLUE}📁 Installation Directory:${NC} $INSTALL_DIR"
echo ""

echo -e "${BOLD}${YELLOW}📋 NEXT STEPS FOR NOVICE TRADERS:${NC}"
echo ""
echo -e "${GREEN}1. 📖 Read the beginner's guide:${NC}"
echo -e "   ${CYAN}cat NOVICE_TRADING_GUIDE.md${NC}"
echo ""
echo -e "${GREEN}2. 📝 Configure your settings:${NC}"
echo -e "   ${CYAN}./setup-help.sh${NC}    ${YELLOW}# Get step-by-step help${NC}"
echo -e "   ${CYAN}nano .env${NC}          ${YELLOW}# Edit your configuration${NC}"
echo ""
echo -e "${GREEN}3. 🚀 Start trading (after configuration):${NC}"
echo -e "   ${CYAN}./start-trading-bot.sh${NC}  ${YELLOW}# Launch with beginner guidance${NC}"
echo ""

echo -e "${BOLD}${PURPLE}🎯 SMART FEATURES FOR BEGINNERS:${NC}"
echo -e "${YELLOW}   • 🛡️ Novice-safe default settings${NC}"
echo -e "${YELLOW}   • 📚 Built-in educational materials${NC}"
echo -e "${YELLOW}   • 🆘 Step-by-step setup help${NC}"
echo -e "${YELLOW}   • 💰 Recommended to start with 0.05-0.1 WLD${NC}"
echo -e "${YELLOW}   • 🧠 AI automatically adapts to market volatility${NC}"
echo -e "${YELLOW}   • ⚡ Auto-sells when profit targets are reached${NC}"
echo ""

echo -e "${BOLD}${RED}⚠️  IMPORTANT REMINDERS:${NC}"
echo -e "${YELLOW}   • Only trade with money you can afford to lose${NC}"
echo -e "${YELLOW}   • Start with VERY small amounts (0.05-0.1 WLD)${NC}"
echo -e "${YELLOW}   • Monitor your first trades to learn how it works${NC}"
echo -e "${YELLOW}   • Set up Telegram notifications for real-time alerts${NC}"
echo -e "${YELLOW}   • Read NOVICE_TRADING_GUIDE.md before starting${NC}"
echo ""

echo -e "${BOLD}${CYAN}📱 HELPFUL COMMANDS:${NC}"
echo -e "${GREEN}   ./setup-help.sh         ${YELLOW}# Get configuration help${NC}"
echo -e "${GREEN}   ./start-trading-bot.sh  ${YELLOW}# Start the bot${NC}"
echo -e "${GREEN}   ./quick-start.sh        ${YELLOW}# Quick start for experienced users${NC}"
echo ""

echo -e "${BOLD}${BLUE}📚 EDUCATIONAL FILES CREATED:${NC}"
echo -e "${GREEN}   • NOVICE_TRADING_GUIDE.md   ${YELLOW}# Complete beginner's guide${NC}"
echo -e "${GREEN}   • TROUBLESHOOTING.md        ${YELLOW}# Common issues and solutions${NC}"
echo -e "${GREEN}   • .env                      ${YELLOW}# Your configuration file${NC}"
echo ""

show_success "Ready to start your AI trading journey!"
echo ""
echo -e "${BOLD}${CYAN}🎯 Remember: The bot gets MORE aggressive when opportunities are BIGGER!${NC}"
echo -e "${BLUE}   • Bigger market crashes → Bigger buys (up to 2x size)${NC}"
echo -e "${BLUE}   • Bigger price jumps → Faster sells (immediate execution)${NC}"
echo -e "${BLUE}   • Your profit targets adapt to market volatility automatically${NC}"
echo ""

echo -e "${BOLD}${GREEN}Happy Learning and Trading! 🚀📈${NC}"
echo ""

# Change to installation directory
cd "$INSTALL_DIR"
echo -e "${CYAN}📁 You are now in your trading directory: $(pwd)${NC}"
echo -e "${YELLOW}💡 TIP: Run './setup-help.sh' to get started with configuration!${NC}"