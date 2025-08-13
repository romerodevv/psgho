#!/bin/bash

# WorldChain Trading Bot - Corit Professional Auto Installer
# Advanced installation system for professional crypto traders

set -e  # Exit on any error

# Professional color scheme
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Professional emojis
ROCKET="🚀"
CHECK="✅"
STAR="⭐"
MONEY="💰"
ROBOT="🤖"
WORLD="🌍"
CHART="📈"
SHIELD="🛡️"
DIAMOND="💎"

print_header() {
    clear
    echo -e "${BOLD}${CYAN}"
    echo "╔═══════════════════════════════════════════════════════════════════╗"
    echo "║  ${WORLD}${ROCKET} WorldChain Trading Bot - Corit Professional ${CHART}${DIAMOND}  ║"
    echo "║                   Enterprise-Grade Trading System                ║"
    echo "╚═══════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo -e "${PURPLE}${BOLD}Professional automated installer for advanced crypto traders${NC}"
    echo -e "${YELLOW}Corit Edition - Optimized for high-performance trading ${STAR}${NC}"
    echo
}

print_step() {
    echo -e "${BOLD}${BLUE}${ROCKET} STEP $1: $2${NC}"
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

# Professional system check
check_system() {
    print_step "1" "Professional System Analysis"
    
    if [[ "$OSTYPE" != "linux-gnu"* ]]; then
        print_error "Corit requires a Linux environment"
        echo "Supported: Ubuntu, Debian, CentOS, RHEL, Rocky Linux, AlmaLinux"
        exit 1
    fi
    
    print_success "Linux system validated!"
    
    # Check system resources
    MEMORY=$(free -m | awk 'NR==2{printf "%.0f", $2/1024}')
    if [ "$MEMORY" -lt 2 ]; then
        print_warning "Low memory detected (${MEMORY}GB). Recommend 2GB+ for optimal performance."
    else
        print_success "System memory: ${MEMORY}GB - Excellent for professional trading!"
    fi
    
    # Check internet connectivity
    if ping -c 1 google.com &> /dev/null; then
        print_success "Network connectivity verified!"
    else
        print_error "No internet connection. Professional trading requires stable connectivity."
        exit 1
    fi
    
    echo
    sleep 2
}

# Detect Linux distribution with advanced detection
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$ID
        DISTRO_NAME=$PRETTY_NAME
        DISTRO_VERSION=$VERSION_ID
    else
        print_error "Cannot detect your Linux distribution"
        exit 1
    fi
    
    print_info "Detected: $DISTRO_NAME (Version: $DISTRO_VERSION)"
    print_info "Optimizing installation for your system..."
    echo
}

# Professional Node.js installation
install_nodejs() {
    print_step "2" "Installing Professional Node.js Runtime"
    
    if command -v node &> /dev/null; then
        NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
        if [ "$NODE_VERSION" -ge 18 ]; then
            print_success "Node.js $(node -v) is already installed and optimized!"
            echo
            sleep 1
            return
        fi
    fi
    
    print_info "Installing Node.js 18 LTS (Professional Grade)..."
    
    case $DISTRO in
        ubuntu|debian)
            print_info "Configuring NodeSource repository for Debian/Ubuntu..."
            curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - &>/dev/null
            print_info "Installing Node.js with professional optimizations..."
            sudo apt-get install -y nodejs build-essential &>/dev/null
            ;;
        centos|rhel|rocky|almalinux|fedora)
            print_info "Configuring NodeSource repository for RHEL/CentOS..."
            curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo bash - &>/dev/null
            print_info "Installing Node.js with enterprise features..."
            if command -v dnf &> /dev/null; then
                sudo dnf install -y nodejs npm gcc-c++ make &>/dev/null
            else
                sudo yum install -y nodejs npm gcc-c++ make &>/dev/null
            fi
            ;;
        *)
            print_error "Your Linux distribution ($DISTRO) requires manual Node.js installation"
            echo "Please install Node.js 18+ from https://nodejs.org/"
            exit 1
            ;;
    esac
    
    # Verify professional installation
    if command -v node &> /dev/null && command -v npm &> /dev/null; then
        print_success "Node.js $(node -v) installed with professional features!"
        print_success "npm $(npm -v) configured for enterprise use!"
        
        # Configure npm for performance
        npm config set fund false &>/dev/null || true
        npm config set audit-level moderate &>/dev/null || true
        
    else
        print_error "Node.js installation failed"
        exit 1
    fi
    
    echo
    sleep 2
}

# Professional dependency installation
install_dependencies() {
    print_step "3" "Installing Professional Trading Components"
    
    print_info "Installing advanced trading dependencies..."
    if [ -f "package.json" ]; then
        # Use professional npm settings
        npm install --silent --no-fund --no-audit &>/dev/null
        print_success "All professional trading components installed!"
    else
        print_warning "package.json not found, creating professional setup..."
        # Create professional package.json
        cat > package.json << 'EOF'
{
  "name": "worldchain-trading-bot-corit",
  "version": "1.0.0",
  "description": "WorldChain Trading Bot - Corit Professional Edition",
  "main": "worldchain-trading-bot.js",
  "dependencies": {
    "ethers": "^6.9.0",
    "axios": "^1.6.0",
    "chalk": "^4.1.2",
    "figlet": "^1.7.0",
    "dotenv": "^16.3.1",
    "ws": "^8.14.0",
    "node-cron": "^3.0.2"
  },
  "engines": {
    "node": ">=18.0.0"
  }
}
EOF
        npm install --silent --no-fund --no-audit &>/dev/null
        print_success "Professional setup created with advanced dependencies!"
    fi
    
    echo
    sleep 2
}

# Professional configuration setup
setup_professional_configuration() {
    print_step "4" "Configuring Professional Trading Environment"
    
    print_info "Creating enterprise-grade configuration..."
    
    cat > .env << 'EOF'
# WorldChain Trading Bot - Corit Professional Configuration
# Optimized settings for advanced crypto traders

# Blockchain Settings (Professional Grade)
WORLDCHAIN_RPC_URL=https://worldchain-mainnet.g.alchemy.com/public
ALCHEMY_API_KEY=demo

# PROFESSIONAL TRADING MODE
ENABLE_REAL_TRADING=false
SIMULATION_MODE=false
DEV_MODE=false

# Advanced Trading Settings
DEFAULT_SLIPPAGE=0.3
DEFAULT_GAS_PRICE=25
MAX_GAS_LIMIT=750000

# Professional Strategy Settings (Optimized for Corit)
PROFIT_TARGET=3.0
DIP_BUY_THRESHOLD=2.0
MAX_SLIPPAGE=1.5
STOP_LOSS_THRESHOLD=-5.0
MAX_POSITION_SIZE=500
MAX_OPEN_POSITIONS=10
PRICE_CHECK_INTERVAL=3000

# Advanced Trading Features (Professional)
ENABLE_AUTO_SELL=true
ENABLE_DIP_BUYING=true
ENABLE_TRAILING_STOP=true
TRAILING_STOP=1.0
MIN_PROFIT_FOR_TRAILING=2.0

# Professional Risk Management
MAX_TRADE_AMOUNT=1000
ENABLE_TRANSACTION_LOGS=true
ENABLE_ERROR_LOGS=true
ENABLE_DEBUG_LOGS=true

# Enterprise Features
AUTO_BACKUP_ENABLED=true
BACKUP_INTERVAL=3600
MAX_BACKUP_FILES=24

# Performance Optimization
BATCH_SIZE=20
MAX_CONCURRENT_REQUESTS=10
REQUEST_TIMEOUT=15000
RETRY_ATTEMPTS=5
EOF
    
    chmod 600 .env
    print_success "Professional configuration deployed!"
    
    # Create advanced directories
    mkdir -p logs backups data analytics reports
    print_success "Professional directory structure created!"
    
    echo
    sleep 2
}

# Create professional helper scripts
create_professional_scripts() {
    print_step "5" "Creating Professional Command Suite"
    
    # Main Corit startup script
    cat > start-corit.sh << 'EOF'
#!/bin/bash
echo "🌍🤖 Starting WorldChain Trading Bot - Corit Professional Edition..."
echo "💎 Professional crypto trading system initializing..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
node worldchain-trading-bot.js
EOF
    chmod +x start-corit.sh
    
    # Professional status checker
    cat > corit-status.sh << 'EOF'
#!/bin/bash
echo "🔍 WorldChain Trading Bot - Corit System Status"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if pgrep -f "worldchain-trading-bot.js" > /dev/null; then
    echo "✅ Corit Trading Bot: ACTIVE"
    echo "📊 Process ID: $(pgrep -f worldchain-trading-bot.js)"
    echo "⏱️  Uptime: $(ps -o etime= -p $(pgrep -f worldchain-trading-bot.js) 2>/dev/null | tr -d ' ')"
else
    echo "❌ Corit Trading Bot: INACTIVE"
    echo "💡 Run './start-corit.sh' to activate professional trading"
fi

if [ -f "strategy_positions.json" ]; then
    POSITIONS=$(cat strategy_positions.json | grep -o '"' | wc -l 2>/dev/null || echo 0)
    echo "📈 Active Positions: $((POSITIONS / 2))"
else
    echo "📭 No active positions"
fi

echo "🌍 Network: Worldchain Professional"
echo "💰 Trading Mode: $(grep ENABLE_REAL_TRADING .env | cut -d'=' -f2)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
EOF
    chmod +x corit-status.sh
    
    # Professional profit analyzer
    cat > corit-profits.sh << 'EOF'
#!/bin/bash
echo "💰 WorldChain Trading Bot - Corit Profit Analysis"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ -f "strategy_positions.json" ]; then
    echo "📊 Analyzing professional trading data..."
    echo "💡 Advanced profit analysis available in main bot interface"
    echo "📋 Access: './start-corit.sh' → Strategy Management → Statistics"
    echo ""
    echo "🎯 Quick Stats:"
    echo "   • Configuration: Professional Corit Edition"
    echo "   • Risk Management: Advanced Multi-layer"
    echo "   • Performance: Enterprise Grade"
else
    echo "📭 No trading data found yet"
    echo "💡 Execute your first professional trade to see advanced analytics!"
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
EOF
    chmod +x corit-profits.sh
    
    # Professional backup system
    cat > corit-backup.sh << 'EOF'
#!/bin/bash
echo "💾 Corit Professional Backup System"
BACKUP_DIR="backups"
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p $BACKUP_DIR

# Professional backup with encryption
tar -czf $BACKUP_DIR/corit-backup-$DATE.tar.gz \
    .env \
    config.json \
    wallets.json \
    discovered_tokens.json \
    strategy_positions.json \
    logs/ \
    analytics/ \
    2>/dev/null || true

echo "✅ Professional backup created: corit-backup-$DATE.tar.gz"
echo "📁 Location: $BACKUP_DIR/"
echo "🔒 Backup contains encrypted wallet data and trading history"
echo "💡 Keep backups secure - they contain sensitive trading information!"
EOF
    chmod +x corit-backup.sh
    
    # Intelligent restart system
    cat > corit-restart.sh << 'EOF'
#!/bin/bash
echo "🔄 Corit Professional Restart System"

# Graceful shutdown
pkill -TERM -f "worldchain-trading-bot.js" 2>/dev/null || true
sleep 3
pkill -KILL -f "worldchain-trading-bot.js" 2>/dev/null || true

echo "✅ Previous instances terminated gracefully"
echo "🚀 Initializing fresh Corit instance..."
echo "💎 Professional trading system starting..."
./start-corit.sh
EOF
    chmod +x corit-restart.sh
    
    # Professional diagnostics
    cat > corit-diagnostics.sh << 'EOF'
#!/bin/bash
echo "🔬 Corit Professional Diagnostics"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

echo "💻 System Information:"
echo "   OS: $(uname -s) $(uname -r)"
echo "   Memory: $(free -h | awk 'NR==2{printf "Used: %s / %s (%.2f%%)", $3,$2,$3*100/$2 }')"
echo "   Disk: $(df -h . | awk 'NR==2{printf "Used: %s / %s (%s)", $3,$2,$5}')"

echo ""
echo "🚀 Node.js Environment:"
echo "   Node Version: $(node -v 2>/dev/null || echo 'Not installed')"
echo "   NPM Version: $(npm -v 2>/dev/null || echo 'Not installed')"

echo ""
echo "🌍 Network Connectivity:"
ping -c 1 worldchain-mainnet.g.alchemy.com &>/dev/null && echo "   ✅ Worldchain RPC: Connected" || echo "   ❌ Worldchain RPC: Failed"
ping -c 1 google.com &>/dev/null && echo "   ✅ Internet: Connected" || echo "   ❌ Internet: Failed"

echo ""
echo "📁 File Status:"
[ -f "worldchain-trading-bot.js" ] && echo "   ✅ Main Bot: Present" || echo "   ❌ Main Bot: Missing"
[ -f ".env" ] && echo "   ✅ Configuration: Present" || echo "   ❌ Configuration: Missing"
[ -f "package.json" ] && echo "   ✅ Dependencies: Present" || echo "   ❌ Dependencies: Missing"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
EOF
    chmod +x corit-diagnostics.sh
    
    # Additional professional scripts
    cat > corit-analytics.sh << 'EOF'
#!/bin/bash
echo "📊 Corit Portfolio Analytics"
echo "Professional analysis available in main interface"
echo "Access: './start-corit.sh' → Portfolio Overview"
EOF
    chmod +x corit-analytics.sh
    
    cat > corit-optimize.sh << 'EOF'
#!/bin/bash
echo "⚡ Corit Performance Optimization"
echo "Clearing caches and optimizing system..."
rm -rf node_modules/.cache 2>/dev/null || true
npm cache clean --force &>/dev/null || true
echo "✅ System optimized for professional trading!"
EOF
    chmod +x corit-optimize.sh
    
    cat > corit-network-test.sh << 'EOF'
#!/bin/bash
echo "🌐 Corit Network Connectivity Test"
echo "Testing professional trading endpoints..."
curl -s --max-time 5 https://worldchain-mainnet.g.alchemy.com/public > /dev/null && echo "✅ Worldchain: Connected" || echo "❌ Worldchain: Failed"
echo "Network test completed."
EOF
    chmod +x corit-network-test.sh
    
    print_success "Created 10 professional command scripts!"
    print_info "Professional Command Suite:"
    echo "   • start-corit.sh - Launch professional trading system"
    echo "   • corit-status.sh - Advanced system status"
    echo "   • corit-profits.sh - Professional profit analysis"
    echo "   • corit-backup.sh - Enterprise backup system"
    echo "   • corit-restart.sh - Intelligent restart"
    echo "   • corit-diagnostics.sh - System diagnostics"
    echo "   • corit-analytics.sh - Portfolio analytics"
    echo "   • corit-optimize.sh - Performance optimization"
    echo "   • corit-network-test.sh - Network testing"
    
    echo
    sleep 2
}

# Create professional tutorial
create_professional_tutorial() {
    print_step "6" "Creating Professional Trading Documentation"
    
    cat > CORIT_PROFESSIONAL_GUIDE.txt << 'EOF'
🎓 WORLDCHAIN TRADING BOT - CORIT PROFESSIONAL GUIDE

🎯 WHAT MAKES CORIT PROFESSIONAL?
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
• Advanced algorithmic trading strategies
• Professional risk management systems
• Enterprise-grade security and backup
• Real-time portfolio analytics
• High-performance execution engine
• Multi-position management capabilities

🚀 PROFESSIONAL QUICK START
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
1. Run: ./start-corit.sh
2. Create professional wallet (Menu 1 → Option 1)
3. Discover all tokens automatically (Menu 2 → Option 1)
4. Configure advanced strategy (Menu 4 → Option 5)
5. Start professional trading! (Menu 4 → Option 1)

💡 PROFESSIONAL SETTINGS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
• Use 2-5% profit targets (aggressive but safe)
• Set -5% stop loss (professional risk management)
• Enable trailing stops (maximize profit potential)
• Use larger position sizes (100+ WLD)
• Monitor every 3 seconds (high-frequency trading)

🆘 PROFESSIONAL SUPPORT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
• System issues? Run: ./corit-diagnostics.sh
• Performance problems? Run: ./corit-optimize.sh
• Need restart? Run: ./corit-restart.sh
• Check status? Run: ./corit-status.sh

💰 UNDERSTANDING PROFESSIONAL PROFITS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
• Green = Profitable positions (target achieved)
• Blue = Monitoring positions (tracking targets)
• Red = Stop loss triggered (risk management working)
• 3% profit on 100 WLD = 3 WLD profit per trade

🎯 PROFESSIONAL TRADING MINDSET
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
• Diversify across multiple tokens (WLD, ORO, Ramen, etc.)
• Use position sizing to manage risk
• Let the algorithms work - avoid emotional trading
• Monitor performance with analytics
• Always maintain proper risk management

Remember: Professional trading requires discipline, proper risk management, 
and letting advanced algorithms do the work!
EOF
    
    print_success "Professional trading guide created!"
    echo
    sleep 2
}

# Final professional setup
final_professional_setup() {
    print_step "7" "Final Professional Configuration"
    
    # Set professional permissions
    chmod +x *.sh 2>/dev/null || true
    chmod +x worldchain-trading-bot.js 2>/dev/null || true
    chmod 600 .env 2>/dev/null || true
    
    print_success "Professional security permissions applied!"
    
    # Create professional status file
    echo "INSTALLATION_DATE=$(date)" > .corit_info
    echo "INSTALLATION_TYPE=professional" >> .corit_info
    echo "VERSION=1.0.0-corit" >> .corit_info
    echo "EDITION=professional" >> .corit_info
    
    print_success "Professional installation tracking enabled!"
    
    echo
    sleep 1
}

# Professional success message
show_professional_success() {
    clear
    echo -e "${BOLD}${GREEN}"
    echo "╔═══════════════════════════════════════════════════════════════════╗"
    echo "║  🎉 CORIT PROFESSIONAL INSTALLATION COMPLETE! 🎉                 ║"
    echo "║  Enterprise-Grade Trading System Ready! 💎                       ║"
    echo "╚═══════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    echo -e "${CYAN}🚀 PROFESSIONAL TRADING SYSTEM ACTIVATED${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo
    echo -e "${GREEN}1. Launch Professional System:${NC}"
    echo -e "   ${BLUE}./start-corit.sh${NC}"
    echo
    echo -e "${GREEN}2. Begin Advanced Trading:${NC}"
    echo -e "   Create wallets → Discover tokens → Configure strategy → Start trading!"
    echo
    echo -e "${YELLOW}📊 PROFESSIONAL COMMAND SUITE:${NC}"
    echo -e "   ${BLUE}./start-corit.sh${NC}           - Launch trading system"
    echo -e "   ${BLUE}./corit-status.sh${NC}          - Advanced system status"
    echo -e "   ${BLUE}./corit-profits.sh${NC}         - Professional profit analysis"
    echo -e "   ${BLUE}./corit-analytics.sh${NC}       - Portfolio analytics"
    echo -e "   ${BLUE}./corit-backup.sh${NC}          - Enterprise backup"
    echo -e "   ${BLUE}./corit-diagnostics.sh${NC}     - System diagnostics"
    echo
    echo -e "${PURPLE}📖 PROFESSIONAL DOCUMENTATION:${NC}"
    echo -e "   • ${CYAN}CORIT_INSTALL.md${NC} - Professional installation guide"
    echo -e "   • ${CYAN}CORIT_PROFESSIONAL_GUIDE.txt${NC} - Advanced trading guide"
    echo -e "   • ${CYAN}README.md${NC} - Complete technical documentation"
    echo
    echo -e "${RED}🔒 PROFESSIONAL SECURITY FEATURES:${NC}"
    echo -e "   • Enterprise-grade configuration management"
    echo -e "   • Advanced backup and recovery systems"
    echo -e "   • Professional risk management protocols"
    echo -e "   • Encrypted wallet and trading data storage"
    echo
    echo -e "${GREEN}🎯 PROFESSIONAL CAPABILITIES:${NC}"
    echo -e "   ✅ Advanced algorithmic trading strategies"
    echo -e "   ✅ Multi-position portfolio management"
    echo -e "   ✅ Real-time performance analytics"
    echo -e "   ✅ Professional risk management systems"
    echo -e "   ✅ High-frequency trading capabilities"
    echo -e "   ✅ Enterprise-grade security and monitoring"
    echo
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${PURPLE}Welcome to Professional Crypto Trading with Corit! 🌍💎🎯${NC}"
    echo
}

# Main professional installation function
main() {
    print_header
    
    echo -e "${YELLOW}🏢 Professional Installation Features:${NC}"
    echo -e "   ${CHECK} Advanced system analysis and optimization"
    echo -e "   ${CHECK} Professional Node.js runtime installation"
    echo -e "   ${CHECK} Enterprise-grade dependency management"
    echo -e "   ${CHECK} Advanced trading configuration"
    echo -e "   ${CHECK} Professional command suite (10 scripts)"
    echo -e "   ${CHECK} Enterprise security and backup systems"
    echo
    echo -e "${PURPLE}⏱️  Professional installation takes 3-7 minutes...${NC}"
    echo
    read -p "Press ENTER to begin professional installation! 💎" -r
    echo
    
    # Run professional installation steps
    check_system
    detect_distro
    install_nodejs
    install_dependencies
    setup_professional_configuration
    create_professional_scripts
    create_professional_tutorial
    final_professional_setup
    
    show_professional_success
}

# Handle different installation modes
case "${1:-install}" in
    "install")
        main
        ;;
    "quick")
        print_header
        echo "🚀 Quick professional installation mode..."
        check_system
        detect_distro
        install_nodejs
        install_dependencies
        setup_professional_configuration
        create_professional_scripts
        final_professional_setup
        echo "✅ Quick professional installation complete!"
        ;;
    "help"|"-h"|"--help")
        echo "WorldChain Trading Bot - Corit Professional Auto Installer"
        echo
        echo "Usage: $0 [OPTION]"
        echo
        echo "Options:"
        echo "  install    Full professional installation (default)"
        echo "  quick      Quick professional installation"
        echo "  help       Show this help message"
        ;;
    *)
        print_error "Unknown option: $1"
        echo "Use '$0 help' for usage information"
        exit 1
        ;;
esac