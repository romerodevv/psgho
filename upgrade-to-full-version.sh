#!/bin/bash

# ALGORITMIT Smart Volatility v4.0 - Full Version Upgrade Script
# Upgrades from embedded version to complete AI trading system

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Functions
show_progress() {
    echo -e "${CYAN}▶ $1${NC}"
    sleep 1
}

show_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

show_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Banner
clear
echo -e "${CYAN}"
cat << "EOF"
╔═══════════════════════════════════════════════════════════════════════════════╗
║                                                                               ║
║           🚀 ALGORITMIT SMART VOLATILITY v4.0 - FULL UPGRADE 🚀              ║
║                                                                               ║
║                    🧠 Complete AI Trading System 🧠                          ║
║                                                                               ║
╚═══════════════════════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

echo -e "${BOLD}${GREEN}Upgrading to Full ALGORITMIT Smart Volatility System!${NC}"
echo ""

# Detect current directory
CURRENT_DIR=$(pwd)
show_info "Current directory: $CURRENT_DIR"

# Create backup of current .env if it exists
if [[ -f ".env" ]]; then
    show_progress "Backing up your current configuration..."
    cp .env .env.backup
    show_success "Configuration backed up to .env.backup"
fi

# Download all full version files
show_progress "Downloading complete AI trading system..."

BASE_URL="https://raw.githubusercontent.com/romerodevv/psgho/main/packages/algoritmit-smart-volatility-v4.0"

# Core trading files
show_progress "Downloading main trading bot..."
curl -sL "$BASE_URL/worldchain-trading-bot.js" -o worldchain-trading-bot.js || wget -q "$BASE_URL/worldchain-trading-bot.js" -O worldchain-trading-bot.js

show_progress "Downloading strategy builder..."
curl -sL "$BASE_URL/strategy-builder.js" -o strategy-builder.js || wget -q "$BASE_URL/strategy-builder.js" -O strategy-builder.js

show_progress "Downloading enhanced trading engine..."
curl -sL "$BASE_URL/sinclave-enhanced-engine.js" -o sinclave-enhanced-engine.js || wget -q "$BASE_URL/sinclave-enhanced-engine.js" -O sinclave-enhanced-engine.js

show_progress "Downloading trading engine..."
curl -sL "$BASE_URL/trading-engine.js" -o trading-engine.js || wget -q "$BASE_URL/trading-engine.js" -O trading-engine.js

show_progress "Downloading trading strategy system..."
curl -sL "$BASE_URL/trading-strategy.js" -o trading-strategy.js || wget -q "$BASE_URL/trading-strategy.js" -O trading-strategy.js

show_progress "Downloading token discovery..."
curl -sL "$BASE_URL/token-discovery.js" -o token-discovery.js || wget -q "$BASE_URL/token-discovery.js" -O token-discovery.js

show_progress "Downloading Telegram notifications..."
curl -sL "$BASE_URL/telegram-notifications.js" -o telegram-notifications.js || wget -q "$BASE_URL/telegram-notifications.js" -O telegram-notifications.js

show_progress "Downloading price database..."
curl -sL "$BASE_URL/price-database.js" -o price-database.js || wget -q "$BASE_URL/price-database.js" -O price-database.js

show_progress "Downloading CLI interface..."
curl -sL "$BASE_URL/algoritmit-cli.js" -o algoritmit-cli.js || wget -q "$BASE_URL/algoritmit-cli.js" -O algoritmit-cli.js

show_progress "Downloading package configuration..."
curl -sL "$BASE_URL/package.json" -o package.json || wget -q "$BASE_URL/package.json" -O package.json

show_success "All core files downloaded!"

# Install/update dependencies
show_progress "Installing full dependencies..."
npm install --no-optional --legacy-peer-deps > /dev/null 2>&1 || {
    show_info "Trying alternative npm install..."
    npm install --force --ignore-scripts > /dev/null 2>&1 || {
        show_info "Installing critical packages individually..."
        npm install ethers@^6.0.0 --no-optional > /dev/null 2>&1 || true
        npm install @holdstation/worldchain-sdk --no-optional > /dev/null 2>&1 || true
        npm install @holdstation/worldchain-ethers-v6 --no-optional > /dev/null 2>&1 || true
        npm install axios dotenv node-telegram-bot-api --no-optional > /dev/null 2>&1 || true
    }
}

# Restore configuration if backed up
if [[ -f ".env.backup" ]]; then
    show_progress "Restoring your configuration..."
    cp .env.backup .env
    show_success "Your settings have been preserved!"
fi

# Update configuration with new options
show_progress "Updating configuration with new features..."
cat >> .env << 'EOF'

# 🚀 FULL VERSION FEATURES (Added by upgrade)
# ===========================================

# 📱 TELEGRAM NOTIFICATIONS (RECOMMENDED)
# Get your bot token from @BotFather on Telegram
# TELEGRAM_BOT_TOKEN=your_bot_token_here
# TELEGRAM_CHAT_ID=your_chat_id_here

# 🧠 ADVANCED AI SETTINGS
# Smart volatility detection thresholds
VOLATILITY_LOW_THRESHOLD=10
VOLATILITY_NORMAL_THRESHOLD=25
VOLATILITY_HIGH_THRESHOLD=50
VOLATILITY_EXTREME_THRESHOLD=75

# 📊 STRATEGY BUILDER SETTINGS
# Enable advanced strategy features
ENABLE_STRATEGY_BUILDER=true
ENABLE_PRICE_TRIGGERS=true
ENABLE_HISTORICAL_ANALYSIS=true

# 🎯 POSITION MANAGEMENT
# Maximum number of concurrent positions
MAX_CONCURRENT_POSITIONS=5
# Position monitoring interval (milliseconds)
POSITION_CHECK_INTERVAL=5000

# 📈 PROFIT RANGE SETTINGS
# Enable profit range selling
ENABLE_PROFIT_RANGE=true
# Default profit range (min-max %)
DEFAULT_PROFIT_RANGE_MIN=5
DEFAULT_PROFIT_RANGE_MAX=15

# 🔄 DIP AVERAGING
# Enable buying more on dips to improve average price
ENABLE_DIP_AVERAGING=true
# Maximum number of DIP buys per token
MAX_DIP_BUYS=3

# 📊 PERFORMANCE TRACKING
# Enable detailed statistics
ENABLE_STATISTICS=true
# Statistics update interval (milliseconds)
STATS_UPDATE_INTERVAL=30000

# 🎮 CONSOLE COMMANDS
# Enable CLI interface
ENABLE_CLI=true
# CLI command prefix
CLI_PREFIX="/"
EOF

# Create advanced startup scripts
show_progress "Creating advanced startup scripts..."

# Full bot launcher
cat > start-full-bot.sh << 'EOF'
#!/bin/bash

echo "🚀 ALGORITMIT Smart Volatility v4.0 - FULL VERSION"
echo "=================================================="
echo ""
echo "🧠 Advanced AI Trading System Starting..."
echo "📊 Smart Volatility Management: ACTIVE"
echo "🎯 Strategy Builder: ENABLED"
echo "📱 Telegram Notifications: READY"
echo "🎮 Console Commands: AVAILABLE"
echo ""

if [[ ! -f ".env" ]]; then
    echo "❌ Configuration file not found!"
    echo "🆘 Run: ./setup-help.sh"
    exit 1
fi

echo "💡 FULL VERSION FEATURES:"
echo "   • Real-time volatility analysis"
echo "   • Smart DIP buying (4-tier system)"
echo "   • Intelligent profit taking (5-tier system)"
echo "   • Advanced strategy builder"
echo "   • Telegram notifications"
echo "   • Console commands"
echo "   • Historical price analysis"
echo "   • Multi-token management"
echo ""
echo "⚠️  REMEMBER: Start with small amounts (0.05-0.1 WLD)"
echo ""

node worldchain-trading-bot.js
EOF

# CLI launcher
cat > start-cli.sh << 'EOF'
#!/bin/bash

echo "🎮 ALGORITMIT CLI - Console Trading Interface"
echo "============================================"
echo ""
echo "💡 QUICK COMMANDS:"
echo "   buy YIELD 0.1 d15 p5    # Buy 0.1 WLD of YIELD, 15% dip, 5% profit"
echo "   sell YIELD all          # Sell all YIELD positions"
echo "   positions               # View all positions"
echo "   strategies              # List strategies"
echo "   stats                   # Trading statistics"
echo ""

node algoritmit-cli.js
EOF

# Strategy builder launcher
cat > strategy-builder.sh << 'EOF'
#!/bin/bash

echo "🏗️ ALGORITMIT Strategy Builder"
echo "=============================="
echo ""
echo "🎯 Create custom trading strategies:"
echo "   • Set profit targets"
echo "   • Configure DIP thresholds"
echo "   • Multi-token strategies"
echo "   • Advanced risk management"
echo ""

node -e "
const StrategyBuilder = require('./strategy-builder.js');
const builder = new StrategyBuilder();
builder.interactiveMenu();
"
EOF

chmod +x start-full-bot.sh start-cli.sh strategy-builder.sh

# Update help script
cat > setup-help.sh << 'EOF'
#!/bin/bash

clear
echo "🆘 ALGORITMIT FULL VERSION - Setup Help"
echo "======================================="
echo ""

echo "📝 CONFIGURATION GUIDE:"
echo ""
echo "1️⃣  BASIC REQUIRED SETTINGS:"
echo "   🔑 PRIVATE_KEY=your_wallet_private_key_here"
echo "   🌐 WORLDCHAIN_RPC_URL=https://worldchain-mainnet.g.alchemy.com/public"
echo ""
echo "2️⃣  TELEGRAM NOTIFICATIONS (RECOMMENDED):"
echo "   📱 TELEGRAM_BOT_TOKEN=your_bot_token"
echo "   📱 TELEGRAM_CHAT_ID=your_chat_id"
echo ""
echo "   Setup: Message @BotFather on Telegram → /newbot → get token"
echo "          Message your bot → visit api.telegram.org/bot<TOKEN>/getUpdates"
echo ""
echo "3️⃣  TRADING SETTINGS:"
echo "   💰 MAX_TRADE_AMOUNT=0.1        # Start small!"
echo "   📊 DEFAULT_SLIPPAGE=0.5         # Conservative"
echo "   🛡️ STOP_LOSS_PERCENTAGE=15     # Safety net"
echo ""
echo "4️⃣  FULL VERSION FEATURES:"
echo "   🧠 ENABLE_STRATEGY_BUILDER=true"
echo "   📱 ENABLE_CLI=true"
echo "   📊 ENABLE_STATISTICS=true"
echo ""
echo "🚀 LAUNCHERS:"
echo "   ./start-full-bot.sh     # Full AI trading system"
echo "   ./start-cli.sh          # Console commands"
echo "   ./strategy-builder.sh   # Create strategies"
echo ""
echo "🆘 NEED MORE HELP?"
echo "   • Repository: https://github.com/romerodevv/psgho"
echo "   • Start with VERY small amounts!"
echo ""
EOF

chmod +x setup-help.sh

# Fix permissions
show_progress "Setting up permissions..."
chmod +x *.sh *.js 2>/dev/null || true

show_success "Permissions configured!"

# Final success message
clear
echo -e "${BOLD}${GREEN}🎉 FULL VERSION UPGRADE COMPLETE! 🎉${NC}"
echo ""

echo -e "${CYAN}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║               🚀 FULL AI TRADING SYSTEM 🚀                    ║${NC}"
echo -e "${CYAN}║                                                               ║${NC}"
echo -e "${CYAN}║          🧠 Advanced Smart Volatility v4.0 🧠                 ║${NC}"
echo -e "${CYAN}║                                                               ║${NC}"
echo -e "${CYAN}╚═══════════════════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${BOLD}${BLUE}📁 Installation Directory:${NC} $(pwd)"
echo -e "${BOLD}${BLUE}📄 Configuration:${NC} .env (your settings preserved)"
echo ""

echo -e "${BOLD}${YELLOW}🚀 LAUNCH OPTIONS:${NC}"
echo ""
echo -e "${GREEN}1. 🧠 Full AI Trading System:${NC}"
echo -e "   ${CYAN}./start-full-bot.sh${NC}     ${YELLOW}# Complete trading bot${NC}"
echo ""
echo -e "${GREEN}2. 🎮 Console Trading Interface:${NC}"
echo -e "   ${CYAN}./start-cli.sh${NC}          ${YELLOW}# Quick commands${NC}"
echo ""
echo -e "${GREEN}3. 🏗️ Strategy Builder:${NC}"
echo -e "   ${CYAN}./strategy-builder.sh${NC}   ${YELLOW}# Create custom strategies${NC}"
echo ""
echo -e "${GREEN}4. 🆘 Configuration Help:${NC}"
echo -e "   ${CYAN}./setup-help.sh${NC}        ${YELLOW}# Setup guidance${NC}"
echo ""

echo -e "${BOLD}${PURPLE}🎯 NEW FULL VERSION FEATURES:${NC}"
echo -e "${YELLOW}   • 🧠 Real-time volatility analysis (4 levels)${NC}"
echo -e "${YELLOW}   • 📊 Smart DIP buying (4-tier position sizing)${NC}"
echo -e "${YELLOW}   • 📈 Intelligent profit taking (5-tier system)${NC}"
echo -e "${YELLOW}   • 🏗️ Advanced strategy builder${NC}"
echo -e "${YELLOW}   • 📱 Telegram notifications${NC}"
echo -e "${YELLOW}   • 🎮 Console commands${NC}"
echo -e "${YELLOW}   • 📊 Historical price analysis${NC}"
echo -e "${YELLOW}   • 🎯 Multi-token management${NC}"
echo -e "${YELLOW}   • 📈 Performance statistics${NC}"
echo -e "${YELLOW}   • 🔄 DIP averaging strategies${NC}"
echo ""

echo -e "${BOLD}${RED}⚠️  IMPORTANT REMINDERS:${NC}"
echo -e "${YELLOW}   • Your .env configuration has been preserved${NC}"
echo -e "${YELLOW}   • Set up Telegram notifications for best experience${NC}"
echo -e "${YELLOW}   • Start with small amounts (0.05-0.1 WLD)${NC}"
echo -e "${YELLOW}   • Use ./setup-help.sh for configuration guidance${NC}"
echo ""

show_success "Ready to trade with the full AI system!"
echo ""
echo -e "${BOLD}${CYAN}🎯 Upgrade complete! You now have the most advanced AI trading system!${NC}"
echo ""

echo -e "${BOLD}${GREEN}Happy Advanced Trading! 🚀📈${NC}"