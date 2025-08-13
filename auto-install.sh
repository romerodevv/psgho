#!/bin/bash

# WorldChain Trading Bot - Novice Auto Installer
# This script makes installation super easy for beginners

set -e  # Exit on any error

# Colors for pretty output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Fun emojis
ROCKET="🚀"
CHECK="✅"
STAR="⭐"
MONEY="💰"
ROBOT="🤖"
WORLD="🌍"

print_header() {
    clear
    echo -e "${CYAN}"
    echo "╔═══════════════════════════════════════════════════════════════════╗"
    echo "║  ${WORLD}${ROCKET} WorldChain Trading Bot - Super Easy Installer ${ROBOT}${MONEY}  ║"
    echo "║                    For Crypto Trading Beginners                  ║"
    echo "╚═══════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo -e "${PURPLE}This installer will set up everything automatically!${NC}"
    echo -e "${YELLOW}Just sit back and relax... ${STAR}${NC}"
    echo
}

print_step() {
    echo -e "${BLUE}${ROCKET} STEP $1: $2${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

print_success() {
    echo -e "${GREEN}${CHECK} $1${NC}"
}

print_info() {
    echo -e "${CYAN}ℹ️  $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ ERROR: $1${NC}"
}

# Check if we're on Linux
check_system() {
    print_step "1" "Checking your system"
    
    if [[ "$OSTYPE" != "linux-gnu"* ]]; then
        print_error "This installer only works on Linux systems"
        echo "Please use a Linux server (Ubuntu, Debian, CentOS, etc.)"
        exit 1
    fi
    
    print_success "Linux system detected!"
    
    # Check if we have internet
    if ping -c 1 google.com &> /dev/null; then
        print_success "Internet connection working!"
    else
        print_error "No internet connection. Please check your network."
        exit 1
    fi
    
    echo
    sleep 2
}

# Detect Linux distribution
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$ID
        DISTRO_NAME=$PRETTY_NAME
    else
        print_error "Cannot detect your Linux distribution"
        exit 1
    fi
    
    print_info "Detected: $DISTRO_NAME"
    echo
}

# Install Node.js if needed
install_nodejs() {
    print_step "2" "Installing Node.js (JavaScript runtime)"
    
    if command -v node &> /dev/null; then
        NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
        if [ "$NODE_VERSION" -ge 16 ]; then
            print_success "Node.js $(node -v) is already installed!"
            echo
            sleep 1
            return
        fi
    fi
    
    print_info "Installing Node.js... This might take a few minutes"
    
    case $DISTRO in
        ubuntu|debian)
            print_info "Setting up Node.js repository..."
            curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - &>/dev/null
            print_info "Installing Node.js..."
            sudo apt-get install -y nodejs &>/dev/null
            ;;
        centos|rhel|rocky|almalinux|fedora)
            print_info "Setting up Node.js repository..."
            curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo bash - &>/dev/null
            print_info "Installing Node.js..."
            if command -v dnf &> /dev/null; then
                sudo dnf install -y nodejs &>/dev/null
            else
                sudo yum install -y nodejs &>/dev/null
            fi
            ;;
        *)
            print_error "Your Linux distribution ($DISTRO) is not supported by auto-installer"
            echo "Please install Node.js 16+ manually from https://nodejs.org/"
            exit 1
            ;;
    esac
    
    # Verify installation
    if command -v node &> /dev/null && command -v npm &> /dev/null; then
        print_success "Node.js $(node -v) installed successfully!"
        print_success "npm $(npm -v) installed successfully!"
    else
        print_error "Node.js installation failed"
        exit 1
    fi
    
    echo
    sleep 2
}

# Install bot dependencies
install_dependencies() {
    print_step "3" "Installing trading bot components"
    
    print_info "Installing bot dependencies..."
    if [ -f "package.json" ]; then
        npm install --silent &>/dev/null
        print_success "All bot components installed!"
    else
        print_warning "package.json not found, creating basic setup..."
        # Create a basic package.json if missing
        cat > package.json << 'EOF'
{
  "name": "worldchain-trading-bot",
  "version": "1.0.0",
  "description": "WorldChain Trading Bot for Beginners",
  "main": "worldchain-trading-bot.js",
  "dependencies": {
    "ethers": "^6.9.0",
    "axios": "^1.6.0",
    "chalk": "^4.1.2",
    "figlet": "^1.7.0",
    "dotenv": "^16.3.1"
  }
}
EOF
        npm install --silent &>/dev/null
        print_success "Basic setup created and dependencies installed!"
    fi
    
    echo
    sleep 2
}

# Set up configuration
setup_configuration() {
    print_step "4" "Setting up beginner-friendly configuration"
    
    # Create novice-friendly .env file
    print_info "Creating safe configuration for beginners..."
    
    cat > .env << 'EOF'
# WorldChain Trading Bot - Beginner Configuration
# This file contains safe settings for new traders

# Blockchain Settings
WORLDCHAIN_RPC_URL=https://worldchain-mainnet.g.alchemy.com/public
ALCHEMY_API_KEY=demo

# SAFETY FIRST - Practice mode enabled!
ENABLE_REAL_TRADING=false
SIMULATION_MODE=true

# Beginner-Safe Trading Settings
DEFAULT_SLIPPAGE=0.5
DEFAULT_GAS_PRICE=20
MAX_GAS_LIMIT=500000

# Conservative Strategy Settings (Good for beginners)
PROFIT_TARGET=1.0
DIP_BUY_THRESHOLD=1.0
MAX_SLIPPAGE=1.0
STOP_LOSS_THRESHOLD=-3.0
MAX_POSITION_SIZE=10
MAX_OPEN_POSITIONS=3
PRICE_CHECK_INTERVAL=5000

# Auto-Trading Features (Start conservative)
ENABLE_AUTO_SELL=true
ENABLE_DIP_BUYING=false
ENABLE_TRAILING_STOP=false

# Security Settings
MAX_TRADE_AMOUNT=100
ENABLE_TRANSACTION_LOGS=true
ENABLE_ERROR_LOGS=true
EOF
    
    chmod 600 .env
    print_success "Safe configuration created!"
    
    # Create directories
    mkdir -p logs backups data
    print_success "Created data directories!"
    
    echo
    sleep 2
}

# Create helper scripts
create_helper_scripts() {
    print_step "5" "Creating easy-to-use helper scripts"
    
    # Start bot script
    cat > start-bot.sh << 'EOF'
#!/bin/bash
echo "🌍🤖 Starting WorldChain Trading Bot..."
echo "💡 Tip: This is your main control panel!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
node worldchain-trading-bot.js
EOF
    chmod +x start-bot.sh
    
    # Check status script
    cat > check-status.sh << 'EOF'
#!/bin/bash
echo "🔍 Checking WorldChain Trading Bot Status..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if pgrep -f "worldchain-trading-bot.js" > /dev/null; then
    echo "✅ Bot is RUNNING!"
    echo "📊 Process ID: $(pgrep -f worldchain-trading-bot.js)"
else
    echo "❌ Bot is STOPPED"
    echo "💡 Run './start-bot.sh' to start it"
fi

if [ -f "strategy_positions.json" ]; then
    echo "📈 Active positions found"
else
    echo "📭 No active positions"
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
EOF
    chmod +x check-status.sh
    
    # View profits script
    cat > view-profits.sh << 'EOF'
#!/bin/bash
echo "💰 WorldChain Trading Bot - Profit Summary"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ -f "strategy_positions.json" ]; then
    echo "📊 Reading your trading data..."
    # This would parse the JSON and show profits
    echo "💡 Detailed profit analysis coming soon!"
    echo "📋 For now, use the main bot menu: './start-bot.sh'"
    echo "   Then go to: Strategy Management → Strategy Statistics"
else
    echo "📭 No trading data found yet"
    echo "💡 Make your first trade to see profits here!"
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
EOF
    chmod +x view-profits.sh
    
    # Backup script
    cat > backup.sh << 'EOF'
#!/bin/bash
echo "💾 Creating backup of your trading data..."
BACKUP_DIR="backups"
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p $BACKUP_DIR

# Backup important files
tar -czf $BACKUP_DIR/worldchain-backup-$DATE.tar.gz \
    .env \
    config.json \
    wallets.json \
    discovered_tokens.json \
    strategy_positions.json \
    2>/dev/null || true

echo "✅ Backup created: worldchain-backup-$DATE.tar.gz"
echo "📁 Location: $BACKUP_DIR/"
echo "💡 Keep these backups safe - they contain your wallet data!"
EOF
    chmod +x backup.sh
    
    # Restart script
    cat > restart-bot.sh << 'EOF'
#!/bin/bash
echo "🔄 Restarting WorldChain Trading Bot..."

# Stop any running instances
pkill -f "worldchain-trading-bot.js" 2>/dev/null || true
sleep 2

echo "✅ Stopped old instances"
echo "🚀 Starting fresh instance..."
./start-bot.sh
EOF
    chmod +x restart-bot.sh
    
    # View logs script
    cat > view-logs.sh << 'EOF'
#!/bin/bash
echo "📋 WorldChain Trading Bot - Recent Activity"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ -d "logs" ] && [ "$(ls -A logs)" ]; then
    echo "📄 Recent log entries:"
    tail -20 logs/*.log 2>/dev/null || echo "No log files found"
else
    echo "📭 No logs found yet"
    echo "💡 Logs will appear after you start trading"
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "💡 Press Ctrl+C to exit"
EOF
    chmod +x view-logs.sh
    
    # Fix permissions script
    cat > fix-permissions.sh << 'EOF'
#!/bin/bash
echo "🔧 Fixing file permissions..."

chmod +x *.sh
chmod +x worldchain-trading-bot.js 2>/dev/null || true
chmod 600 .env 2>/dev/null || true
chmod -R 755 . 2>/dev/null || true

echo "✅ Permissions fixed!"
echo "💡 Try running your command again"
EOF
    chmod +x fix-permissions.sh
    
    print_success "Created 7 helpful scripts for you!"
    print_info "Scripts created:"
    echo "   • start-bot.sh - Start the trading bot"
    echo "   • check-status.sh - See if bot is running"
    echo "   • view-profits.sh - Check your profits"
    echo "   • backup.sh - Save your data"
    echo "   • restart-bot.sh - Fix most problems"
    echo "   • view-logs.sh - See what bot is doing"
    echo "   • fix-permissions.sh - Fix file errors"
    
    echo
    sleep 2
}

# Create beginner tutorial
create_tutorial() {
    print_step "6" "Creating beginner tutorial"
    
    cat > BEGINNER_TUTORIAL.txt << 'EOF'
🎓 WORLDCHAIN TRADING BOT - BEGINNER TUTORIAL

🎯 WHAT DOES THIS BOT DO?
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
• Automatically buys and sells tokens for profit
• Monitors prices 24/7 (even while you sleep!)
• Protects your money with stop-losses
• Finds good buying opportunities
• Tracks all your trades and profits

🚀 YOUR FIRST 5 MINUTES
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
1. Run: ./start-bot.sh
2. Create a wallet (Menu 1 → Option 1)
3. Add a token (Menu 2 → Option 2)  
4. Configure strategy (Menu 4 → Option 5)
5. Start trading! (Menu 4 → Option 1)

💡 BEGINNER TIPS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
• Start with SMALL amounts (1-5 WLD)
• Set profit target to 1% (safe for beginners)
• Always use stop-loss (-3% recommended)
• Practice mode is ON by default (safe!)
• Save your private keys somewhere safe!

🆘 IF SOMETHING GOES WRONG
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
• Bot won't start? Run: ./fix-permissions.sh
• Want to restart? Run: ./restart-bot.sh
• Check if running? Run: ./check-status.sh
• See what happened? Run: ./view-logs.sh

💰 UNDERSTANDING PROFITS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
• Green numbers = You made money! 🎉
• Red numbers = You lost money (normal in trading)
• 1% profit = If you trade 100 WLD, you make 1 WLD
• Stop-loss protects you from big losses

Remember: Start small, learn as you go, and never risk money you can't afford to lose!
EOF
    
    print_success "Beginner tutorial created!"
    echo
    sleep 2
}

# Final setup and permissions
final_setup() {
    print_step "7" "Final setup and security"
    
    # Set proper permissions
    chmod +x *.sh 2>/dev/null || true
    chmod +x worldchain-trading-bot.js 2>/dev/null || true
    chmod 600 .env 2>/dev/null || true
    
    print_success "File permissions set correctly!"
    
    # Create a simple status file
    echo "INSTALLATION_DATE=$(date)" > .install_info
    echo "INSTALLATION_TYPE=novice" >> .install_info
    echo "VERSION=1.0.0" >> .install_info
    
    print_success "Installation tracking created!"
    
    echo
    sleep 1
}

# Success message and instructions
show_success_message() {
    clear
    echo -e "${GREEN}"
    echo "╔═══════════════════════════════════════════════════════════════════╗"
    echo "║  🎉 CONGRATULATIONS! Installation Complete! 🎉                   ║"
    echo "║  Your WorldChain Trading Bot is ready to make money! 💰          ║"
    echo "╚═══════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    echo -e "${CYAN}🚀 WHAT'S NEXT? (Super Easy!)${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo
    echo -e "${GREEN}1. Start your bot:${NC}"
    echo -e "   ${BLUE}./start-bot.sh${NC}"
    echo
    echo -e "${GREEN}2. Create your first wallet and start trading!${NC}"
    echo -e "   Follow the easy menus - it's like a mobile app!"
    echo
    echo -e "${YELLOW}📚 HELPFUL COMMANDS:${NC}"
    echo -e "   ${BLUE}./start-bot.sh${NC}       - Start the bot (main command)"
    echo -e "   ${BLUE}./check-status.sh${NC}    - See if bot is running"
    echo -e "   ${BLUE}./view-profits.sh${NC}    - Check your profits"
    echo -e "   ${BLUE}./backup.sh${NC}          - Save your data"
    echo -e "   ${BLUE}./restart-bot.sh${NC}     - Fix most problems"
    echo
    echo -e "${PURPLE}📖 READ THIS:${NC}"
    echo -e "   • ${CYAN}NOVICE_INSTALL.md${NC} - Step-by-step guide"
    echo -e "   • ${CYAN}BEGINNER_TUTORIAL.txt${NC} - Quick tutorial"
    echo
    echo -e "${RED}🔒 IMPORTANT SECURITY REMINDERS:${NC}"
    echo -e "   • Practice mode is ON (safe for learning)"
    echo -e "   • Start with small amounts (1-10 WLD)"
    echo -e "   • Save your wallet private keys safely!"
    echo -e "   • Never share your private keys with anyone"
    echo
    echo -e "${GREEN}🎯 Your bot will help you:${NC}"
    echo -e "   ✅ Make money while you sleep"
    echo -e "   ✅ Protect you from big losses"
    echo -e "   ✅ Find good trading opportunities"
    echo -e "   ✅ Track all your profits automatically"
    echo
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${PURPLE}Happy Trading! 🌍💰🎯 Welcome to the future of crypto trading!${NC}"
    echo
}

# Main installation function
main() {
    print_header
    
    echo -e "${YELLOW}🤖 This installer will:${NC}"
    echo -e "   ${CHECK} Check your system"
    echo -e "   ${CHECK} Install Node.js automatically"
    echo -e "   ${CHECK} Set up the trading bot"
    echo -e "   ${CHECK} Create beginner-friendly settings"
    echo -e "   ${CHECK} Make helpful scripts for you"
    echo -e "   ${CHECK} Set up security and safety features"
    echo
    echo -e "${PURPLE}⏱️  This will take about 2-5 minutes...${NC}"
    echo
    read -p "Press ENTER to start the magic! ✨" -r
    echo
    
    # Run installation steps
    check_system
    detect_distro
    install_nodejs
    install_dependencies
    setup_configuration
    create_helper_scripts
    create_tutorial
    final_setup
    
    show_success_message
}

# Handle different installation modes
case "${1:-install}" in
    "install")
        main
        ;;
    "quick")
        print_header
        echo "🚀 Quick installation mode..."
        check_system
        detect_distro
        install_nodejs
        install_dependencies
        setup_configuration
        create_helper_scripts
        final_setup
        echo "✅ Quick installation complete!"
        ;;
    "help"|"-h"|"--help")
        echo "WorldChain Trading Bot - Novice Auto Installer"
        echo
        echo "Usage: $0 [OPTION]"
        echo
        echo "Options:"
        echo "  install    Full installation with tutorial (default)"
        echo "  quick      Quick installation without tutorial"
        echo "  help       Show this help message"
        ;;
    *)
        print_error "Unknown option: $1"
        echo "Use '$0 help' for usage information"
        exit 1
        ;;
esac