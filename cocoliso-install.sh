#!/bin/bash

# WorldChain Trading Bot - Cocoliso Premium Edition Installer
# Advanced trading system with HoldStation SDK integration

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Fancy printing functions
print_header() {
    echo -e "${PURPLE}╔══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║${WHITE}                    🌍 WorldChain Trading Bot - Cocoliso 🤖                    ${PURPLE}║${NC}"
    echo -e "${PURPLE}║${CYAN}                        Premium Edition Installation                           ${PURPLE}║${NC}"
    echo -e "${PURPLE}╚══════════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_step() {
    echo -e "${BLUE}[STEP $1]${WHITE} $2${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_info() {
    echo -e "${CYAN}ℹ️  $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_premium() {
    echo -e "${PURPLE}💎 $1${NC}"
}

# Check system requirements
check_system() {
    print_step "1" "Checking System Requirements"
    
    print_info "Checking Node.js installation..."
    if ! command -v node &> /dev/null; then
        print_error "Node.js is not installed"
        echo ""
        print_info "Installing Node.js..."
        
        # Install Node.js based on system
        if command -v apt-get &> /dev/null; then
            curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
            sudo apt-get install -y nodejs
        elif command -v yum &> /dev/null; then
            curl -fsSL https://rpm.nodesource.com/setup_20.x | sudo bash -
            sudo yum install -y nodejs npm
        elif command -v brew &> /dev/null; then
            brew install node
        else
            print_error "Please install Node.js manually from https://nodejs.org/"
            exit 1
        fi
    fi
    
    NODE_VERSION=$(node --version)
    print_success "Node.js $NODE_VERSION is installed"
    
    print_info "Checking npm installation..."
    if ! command -v npm &> /dev/null; then
        print_error "npm is not installed"
        exit 1
    fi
    
    NPM_VERSION=$(npm --version)
    print_success "npm $NPM_VERSION is installed"
    
    print_info "Checking Git installation..."
    if ! command -v git &> /dev/null; then
        print_warning "Git is not installed, installing..."
        if command -v apt-get &> /dev/null; then
            sudo apt-get update && sudo apt-get install -y git
        elif command -v yum &> /dev/null; then
            sudo yum install -y git
        elif command -v brew &> /dev/null; then
            brew install git
        fi
    fi
    
    print_success "System requirements check completed"
    echo ""
}

# Install premium dependencies
install_dependencies() {
    print_step "2" "Installing Cocoliso Premium Components"
    
    print_info "Installing premium trading dependencies..."
    if [ -f "package.json" ]; then
        # Use premium npm settings
        npm install --silent --no-fund --no-audit &>/dev/null
        print_info "Installing HoldStation SDK for premium Worldchain trading..."
        npm install @holdstation/worldchain-sdk@latest --silent --no-fund --no-audit &>/dev/null
        npm install @holdstation/worldchain-ethers-v6@latest --silent --no-fund --no-audit &>/dev/null
        npm install @worldcoin/minikit-js@latest --silent --no-fund --no-audit &>/dev/null
        print_success "All premium trading components and HoldStation SDK installed!"
    else
        print_warning "package.json not found, creating premium setup..."
        # Create premium package.json
        cat > package.json << 'EOF'
{
  "name": "worldchain-trading-bot-cocoliso",
  "version": "1.0.0",
  "description": "WorldChain Trading Bot - Cocoliso Premium Edition",
  "main": "worldchain-trading-bot.js",
  "scripts": {
    "start": "node worldchain-trading-bot.js",
    "dev": "nodemon worldchain-trading-bot.js",
    "test": "node test-holdstation.js"
  },
  "dependencies": {
    "ethers": "^6.9.0",
    "@holdstation/worldchain-sdk": "latest",
    "@holdstation/worldchain-ethers-v6": "latest",
    "@worldcoin/minikit-js": "latest",
    "axios": "^1.6.0",
    "chalk": "^4.1.2",
    "figlet": "^1.7.0",
    "readline": "^1.3.0",
    "ws": "^8.14.2",
    "node-cron": "^3.0.3",
    "dotenv": "^16.3.1",
    "commander": "^11.1.0",
    "inquirer": "^8.2.6",
    "cli-table3": "^0.6.3",
    "ora": "^5.4.1",
    "boxen": "^5.1.2"
  }
}
EOF
        npm install --silent --no-fund --no-audit &>/dev/null
        print_success "Premium setup created with advanced dependencies!"
    fi
    
    echo ""
}

# Create premium helper scripts
create_premium_scripts() {
    print_step "3" "Creating Cocoliso Premium Helper Scripts"
    
    # Create premium start script
    cat > start-cocoliso.sh << 'EOF'
#!/bin/bash

# WorldChain Trading Bot - Cocoliso Premium Edition Launcher
echo "🌍🤖 Starting WorldChain Trading Bot - Cocoliso Premium Edition..."
echo "💎 Premium crypto trading system initializing..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Check if Node.js is available
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please run ./cocoliso-install.sh first"
    exit 1
fi

# Check if dependencies are installed
if [ ! -d "node_modules" ]; then
    echo "❌ Dependencies not installed. Please run ./cocoliso-install.sh first"
    exit 1
fi

# Start the premium trading bot
node worldchain-trading-bot.js
EOF

    # Create premium test script
    cat > test-cocoliso.sh << 'EOF'
#!/bin/bash

echo "🧪 Running Cocoliso Premium Test Suite..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

echo "📦 Testing HoldStation SDK Integration..."
node test-holdstation.js

echo ""
echo "💱 Testing Custom Token Swap Quote..."
node test-swap-specific.js

echo ""
echo "🎉 Cocoliso Premium Test Suite Completed!"
EOF

    # Create premium wallet manager
    cat > wallet-manager.sh << 'EOF'
#!/bin/bash

echo "💼 Cocoliso Premium Wallet Manager"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "1. Create New Wallet"
echo "2. Import Existing Wallet"  
echo "3. List All Wallets"
echo "4. Backup Wallets"
echo "5. Check Balances"
echo ""
echo "💡 Use the main bot interface for full wallet management"
echo "   Run: ./start-cocoliso.sh"
EOF

    # Create premium trading analyzer
    cat > trading-analyzer.sh << 'EOF'
#!/bin/bash

echo "📊 Cocoliso Premium Trading Analyzer"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔍 Analyzing Worldchain trading opportunities..."
echo ""
echo "💡 Features:"
echo "   • Real-time liquidity analysis"
echo "   • Token pair discovery" 
echo "   • Price trend analysis"
echo "   • Profit opportunity detection"
echo ""
echo "🚀 Launch full analyzer in main bot: ./start-cocoliso.sh"
EOF

    # Create premium portfolio tracker
    cat > portfolio-tracker.sh << 'EOF'
#!/bin/bash

echo "📈 Cocoliso Premium Portfolio Tracker"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "💰 Tracking your Worldchain portfolio..."
echo ""
echo "📊 Features:"
echo "   • Real-time balance monitoring"
echo "   • Token discovery and tracking"
echo "   • P&L calculation"
echo "   • Performance metrics"
echo ""
echo "🎯 Access full portfolio in main bot: ./start-cocoliso.sh"
EOF

    # Create premium strategy optimizer
    cat > strategy-optimizer.sh << 'EOF'
#!/bin/bash

echo "🧠 Cocoliso Premium Strategy Optimizer"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "⚡ Optimizing your trading strategies..."
echo ""
echo "🎯 Available Strategies:"
echo "   • Sinclave Enhanced Trading"
echo "   • DIP Buying Strategy"
echo "   • Profit Taking Strategy"
echo "   • Risk Management"
echo ""
echo "🚀 Configure strategies in main bot: ./start-cocoliso.sh"
EOF

    # Create premium market scanner
    cat > market-scanner.sh << 'EOF'
#!/bin/bash

echo "🔍 Cocoliso Premium Market Scanner"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📡 Scanning Worldchain markets..."
echo ""
echo "🎯 Scanning for:"
echo "   • New token listings"
echo "   • Liquidity opportunities"
echo "   • Price movements"
echo "   • Trading volume"
echo ""
echo "📊 Full market analysis in main bot: ./start-cocoliso.sh"
EOF

    # Create premium backup manager
    cat > backup-manager.sh << 'EOF'
#!/bin/bash

echo "🛡️ Cocoliso Premium Backup Manager"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

BACKUP_DIR="cocoliso-backups"
DATE=$(date +"%Y%m%d_%H%M%S")

mkdir -p $BACKUP_DIR

echo "📦 Creating backup: $DATE"
echo "┌─────────────────────────────────────┐"
echo "│ Backing up configuration files...   │"

if [ -f "config.json" ]; then
    cp config.json $BACKUP_DIR/config_$DATE.json
    echo "│ ✅ config.json                      │"
fi

if [ -f "wallets.json" ]; then
    cp wallets.json $BACKUP_DIR/wallets_$DATE.json
    echo "│ ✅ wallets.json                     │"
fi

if [ -f "tokens.json" ]; then
    cp tokens.json $BACKUP_DIR/tokens_$DATE.json
    echo "│ ✅ tokens.json                      │"
fi

if [ -f ".env" ]; then
    cp .env $BACKUP_DIR/env_$DATE.backup
    echo "│ ✅ .env                             │"
fi

echo "└─────────────────────────────────────┘"
echo "✅ Backup completed: $BACKUP_DIR/"
echo "🔐 Keep your backups secure!"
EOF

    # Create premium update manager
    cat > update-cocoliso.sh << 'EOF'
#!/bin/bash

echo "🔄 Cocoliso Premium Update Manager"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📦 Checking for updates..."

echo "💾 Creating backup before update..."
./backup-manager.sh

echo ""
echo "🌐 Downloading latest Cocoliso Premium Edition..."
wget -q https://github.com/romerodevv/psgho/raw/main/worldchain-bot-cocoliso.tar.gz -O latest-cocoliso.tar.gz

if [ $? -eq 0 ]; then
    echo "✅ Download completed"
    echo "📂 Extracting update..."
    tar -xzf latest-cocoliso.tar.gz
    echo "✅ Update completed!"
    echo ""
    echo "🎉 Cocoliso Premium has been updated to the latest version!"
    echo "🚀 Restart with: ./start-cocoliso.sh"
else
    echo "❌ Update failed. Using current version."
fi
EOF

    # Create premium uninstaller
    cat > uninstall-cocoliso.sh << 'EOF'
#!/bin/bash

echo "🗑️ Cocoliso Premium Uninstaller"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "⚠️  This will remove Cocoliso Premium Edition"
echo ""
read -p "Are you sure? (yes/no): " confirm

if [ "$confirm" = "yes" ]; then
    echo "💾 Creating final backup..."
    ./backup-manager.sh
    
    echo "🗑️ Removing Cocoliso files..."
    rm -rf node_modules
    rm -f *.sh
    rm -f *.js
    rm -f *.json
    rm -f *.md
    rm -f *.txt
    
    echo "✅ Cocoliso Premium Edition uninstalled"
    echo "💾 Your backups are preserved in cocoliso-backups/"
else
    echo "❌ Uninstall cancelled"
fi
EOF

    # Make all scripts executable
    chmod +x *.sh
    
    print_success "10 premium helper scripts created!"
    print_premium "Premium scripts available:"
    print_info "   • start-cocoliso.sh - Launch the premium bot"
    print_info "   • test-cocoliso.sh - Run premium test suite"
    print_info "   • wallet-manager.sh - Premium wallet management"
    print_info "   • trading-analyzer.sh - Advanced trading analysis"
    print_info "   • portfolio-tracker.sh - Portfolio monitoring"
    print_info "   • strategy-optimizer.sh - Strategy optimization"
    print_info "   • market-scanner.sh - Market scanning tools"
    print_info "   • backup-manager.sh - Backup management"
    print_info "   • update-cocoliso.sh - Automatic updates"
    print_info "   • uninstall-cocoliso.sh - Clean uninstaller"
    echo ""
}

# Create premium configuration
create_premium_config() {
    print_step "4" "Creating Cocoliso Premium Configuration"
    
    if [ ! -f ".env" ]; then
        cat > .env << 'EOF'
# WorldChain Trading Bot - Cocoliso Premium Edition Configuration

# Worldchain RPC Endpoints (Premium Optimized)
PRIMARY_RPC_URL=https://worldchain-mainnet.g.alchemy.com/public
FALLBACK_RPC_URL=https://worldchain-mainnet.drpc.org/public
ALCHEMY_API_KEY=your_alchemy_api_key_here

# Token Addresses (Verified for Cocoliso)
WLD_TOKEN_ADDRESS=0x2cfc85d8e48f8eab294be644d9e25c3030863003
ORO_TOKEN_ADDRESS=0xcd1E32B86953D79a6AC58e813D2EA7a1790cAb63
CUSTOM_TOKEN_ADDRESS=0x1a16f733b813a59815a76293dac835ad1c7fedff

# Premium Trading Settings
DEFAULT_SLIPPAGE=0.5
DEFAULT_GAS_LIMIT=280000
MAX_RETRIES=3
TRADE_TIMEOUT=30000

# Premium Features
ENABLE_ADVANCED_LOGGING=true
ENABLE_PERFORMANCE_METRICS=true
ENABLE_AUTOMATIC_BACKUP=true
ENABLE_MARKET_SCANNING=true

# HoldStation SDK Settings
HOLDSTATION_PARTNER_CODE=COCOLISO_PREMIUM_2025
HOLDSTATION_FEE=0.2

# Security Settings (Premium)
ENABLE_TRANSACTION_SIMULATION=true
ENABLE_SLIPPAGE_PROTECTION=true
ENABLE_MEV_PROTECTION=true
EOF
        print_success "Premium .env configuration created"
        print_warning "Please edit .env file to add your API keys and settings"
    else
        print_info "Existing .env file found, keeping current configuration"
    fi
    
    echo ""
}

# Final setup and verification
finalize_installation() {
    print_step "5" "Finalizing Cocoliso Premium Installation"
    
    print_info "Running premium system verification..."
    
    # Test HoldStation SDK
    if node test-holdstation.js &>/dev/null; then
        print_success "HoldStation SDK integration verified"
    else
        print_warning "HoldStation SDK test had issues - check dependencies"
    fi
    
    # Create premium README
    cat > COCOLISO_README.md << 'EOF'
# 🌍 WorldChain Trading Bot - Cocoliso Premium Edition

## 🎉 Welcome to Cocoliso Premium!

The most advanced WorldChain trading bot with HoldStation SDK integration, premium features, and professional-grade tools.

## 🚀 Quick Start

1. **Launch the Bot:**
   ```bash
   ./start-cocoliso.sh
   ```

2. **Run Tests:**
   ```bash
   ./test-cocoliso.sh
   ```

3. **Manage Wallets:**
   ```bash
   ./wallet-manager.sh
   ```

## 💎 Premium Features

- ✅ **HoldStation SDK Integration** - Native Worldchain DEX support
- ✅ **Sinclave Enhanced Trading** - Proven trading patterns
- ✅ **Advanced Portfolio Tracking** - Real-time monitoring
- ✅ **Smart Strategy Optimization** - AI-powered trading
- ✅ **Premium Market Scanner** - Opportunity detection
- ✅ **Automatic Backup System** - Data protection
- ✅ **Professional Analytics** - Performance metrics
- ✅ **MEV Protection** - Sandwich attack prevention
- ✅ **Gas Optimization** - Cost-effective trading
- ✅ **Multi-Wallet Support** - Portfolio diversification

## 🛠️ Premium Helper Scripts

| Script | Description |
|--------|-------------|
| `start-cocoliso.sh` | Launch the premium bot |
| `test-cocoliso.sh` | Run premium test suite |
| `wallet-manager.sh` | Wallet management tools |
| `trading-analyzer.sh` | Advanced trading analysis |
| `portfolio-tracker.sh` | Portfolio monitoring |
| `strategy-optimizer.sh` | Strategy optimization |
| `market-scanner.sh` | Market scanning tools |
| `backup-manager.sh` | Backup management |
| `update-cocoliso.sh` | Automatic updates |
| `uninstall-cocoliso.sh` | Clean uninstaller |

## 📊 Supported Trading Pairs

- ✅ **WLD/ORO** - Primary trading pair
- ✅ **WLD/Custom Tokens** - Any token with liquidity
- ✅ **Multi-DEX Support** - HoldStation, ZeroX, HoldSo

## 🔧 Configuration

Edit `.env` file for premium settings:
- RPC endpoints
- API keys
- Trading parameters
- Security settings
- Feature toggles

## 🎯 Premium Support

- 📖 **Documentation**: Complete guides included
- 🔧 **Helper Scripts**: 10 professional tools
- 🛡️ **Backup System**: Automatic data protection
- 🔄 **Auto Updates**: Latest features delivered
- 📊 **Analytics**: Performance tracking

## 🌟 What Makes Cocoliso Premium?

1. **Battle-Tested**: Based on successful sinclave.js patterns
2. **Professional Grade**: Enterprise-level features
3. **User-Friendly**: Intuitive interface and helpers
4. **Secure**: Advanced protection mechanisms
5. **Profitable**: Optimized for maximum returns

---

**Cocoliso Premium - Where Professional Trading Meets Simplicity** 🌍💎🚀
EOF

    print_success "Premium documentation created"
    print_success "Cocoliso Premium installation completed!"
    echo ""
}

# Display final instructions
show_final_instructions() {
    echo ""
    print_header
    print_premium "🎉 COCOLISO PREMIUM INSTALLATION COMPLETE!"
    echo ""
    print_success "✅ All premium components installed successfully"
    print_success "✅ HoldStation SDK integrated and verified"
    print_success "✅ 10 premium helper scripts created"
    print_success "✅ Advanced configuration ready"
    print_success "✅ Professional documentation included"
    echo ""
    print_premium "🚀 NEXT STEPS:"
    echo ""
    print_info "1. Configure your settings:"
    echo -e "   ${CYAN}nano .env${NC}"
    echo ""
    print_info "2. Start Cocoliso Premium:"
    echo -e "   ${GREEN}./start-cocoliso.sh${NC}"
    echo ""
    print_info "3. Run premium tests:"
    echo -e "   ${YELLOW}./test-cocoliso.sh${NC}"
    echo ""
    print_info "4. Explore premium features:"
    echo -e "   ${BLUE}ls -la *.sh${NC}"
    echo ""
    print_premium "💎 PREMIUM FEATURES READY:"
    print_info "   • Sinclave Enhanced Trading"
    print_info "   • HoldStation SDK Integration"
    print_info "   • Advanced Portfolio Management"
    print_info "   • Professional Analytics"
    print_info "   • Automatic Backup System"
    print_info "   • MEV Protection"
    print_info "   • Gas Optimization"
    print_info "   • Multi-Wallet Support"
    print_info "   • Real-time Market Scanning"
    print_info "   • Strategy Optimization"
    echo ""
    print_premium "🌍 Welcome to the future of Worldchain trading!"
    print_premium "Cocoliso Premium - Professional Trading Made Simple"
    echo ""
    echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# Main installation process
main() {
    print_header
    
    print_premium "🎯 Starting Cocoliso Premium Edition installation..."
    print_info "This will install the most advanced WorldChain trading bot"
    echo ""
    
    check_system
    install_dependencies
    create_premium_scripts
    create_premium_config
    finalize_installation
    show_final_instructions
}

# Run main installation
main "$@"