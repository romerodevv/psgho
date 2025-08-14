#!/bin/bash

# WorldChain Trading Bot V2.5 - Quick Setup Script
# Features: Price Database, Triggers, Fixed Stop Loss

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Banner
echo -e "${PURPLE}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║           🚀 WORLDCHAIN TRADING BOT V2.5 SETUP             ║"
echo "║                                                              ║"
echo "║  📊 Background Price Database                                ║"
echo "║  🎯 Automated Triggers System                               ║"
echo "║  🛑 Fixed Stop Loss (90% works perfectly!)                  ║"
echo "║  ⚡ Ultra-Fast Execution (<3 seconds)                       ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

print_step() {
    echo -e "\n${CYAN}[STEP] $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
    print_warning "Running as root. Will create files for user 'ubuntu' if available."
    TARGET_USER="ubuntu"
    if ! id "$TARGET_USER" &>/dev/null; then
        TARGET_USER="debian"
        if ! id "$TARGET_USER" &>/dev/null; then
            TARGET_USER="trader"
            if ! id "$TARGET_USER" &>/dev/null; then
                print_info "Creating user 'trader' for bot files..."
                useradd -m -s /bin/bash trader
            fi
        fi
    fi
    print_info "Using user: $TARGET_USER"
else
    TARGET_USER=$(whoami)
fi

# System check and fixes
print_step "Checking and fixing system packages..."
if command -v dpkg >/dev/null 2>&1; then
    dpkg --configure -a 2>/dev/null || true
    apt-get update --fix-missing 2>/dev/null || true
    apt-get install -f -y 2>/dev/null || true
fi
print_success "System packages checked"

# Install Node.js
print_step "Installing Node.js 20..."
if ! command -v node >/dev/null 2>&1; then
    print_info "Node.js not found. Installing..."
    
    # Try NodeSource repository
    if curl -fsSL https://deb.nodesource.com/setup_20.x | bash -; then
        apt-get install -y nodejs
        print_success "Node.js installed via NodeSource"
    else
        print_warning "NodeSource failed, trying Ubuntu repository..."
        apt-get update
        apt-get install -y nodejs npm
        print_success "Node.js installed via Ubuntu repository"
    fi
else
    NODE_VERSION=$(node --version)
    print_success "Node.js already installed: $NODE_VERSION"
fi

# Verify Node.js version
NODE_MAJOR=$(node --version | cut -d'.' -f1 | sed 's/v//')
if [ "$NODE_MAJOR" -lt 18 ]; then
    print_error "Node.js version $NODE_MAJOR is too old. Please install Node.js 18 or higher."
    exit 1
fi

# Install additional packages
print_step "Installing required system packages..."
apt-get install -y wget curl git tar gzip || true
print_success "System packages installed"

# Create bot directory
BOT_DIR="/home/$TARGET_USER/worldchain-bot-v2.5"
print_step "Creating bot directory: $BOT_DIR"

if [[ $EUID -eq 0 ]]; then
    mkdir -p "$BOT_DIR"
    cd "$BOT_DIR"
else
    mkdir -p "$HOME/worldchain-bot-v2.5"
    cd "$HOME/worldchain-bot-v2.5"
    BOT_DIR="$HOME/worldchain-bot-v2.5"
fi

print_success "Directory created: $BOT_DIR"

# Download bot package
print_step "Downloading WorldChain Bot V2.5..."
if [ -f "worldchain-bot-ultrafast-v2.5.tar.gz" ]; then
    print_info "Package already exists, extracting..."
else
    print_info "Package not found locally. Please ensure worldchain-bot-ultrafast-v2.5.tar.gz is available."
    print_info "You can create it by running: tar -czf worldchain-bot-ultrafast-v2.5.tar.gz *.js *.json *.md *.txt *.sh"
fi

# Extract if package exists
if [ -f "worldchain-bot-ultrafast-v2.5.tar.gz" ]; then
    print_info "Extracting bot files..."
    tar -xzf worldchain-bot-ultrafast-v2.5.tar.gz
    print_success "Bot files extracted"
elif [ -f "../worldchain-bot-ultrafast-v2.5.tar.gz" ]; then
    print_info "Found package in parent directory, extracting..."
    tar -xzf "../worldchain-bot-ultrafast-v2.5.tar.gz"
    print_success "Bot files extracted"
else
    print_warning "Package not found. Assuming files are already in current directory."
fi

# Install Node.js dependencies
print_step "Installing Node.js dependencies..."
if [ -f "package.json" ]; then
    npm install --no-audit --no-fund
    print_success "Core dependencies installed"
else
    print_warning "package.json not found. Creating minimal package.json..."
    cat > package.json << 'EOF'
{
  "name": "worldchain-trading-bot",
  "version": "2.5.0",
  "description": "Advanced Worldchain Trading Bot with Price Database and Triggers",
  "main": "worldchain-trading-bot.js",
  "scripts": {
    "start": "node worldchain-trading-bot.js",
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "dependencies": {
    "ethers": "^6.8.0",
    "axios": "^1.6.0",
    "chalk": "^4.1.2",
    "figlet": "^1.7.0",
    "dotenv": "^16.3.1"
  }
}
EOF
    npm install --no-audit --no-fund
    print_success "Dependencies installed with minimal package.json"
fi

# Install HoldStation SDK
print_step "Installing HoldStation SDK components..."
npm install @holdstation/worldchain-sdk@latest --no-audit --no-fund
npm install @holdstation/worldchain-ethers-v6@latest --no-audit --no-fund
npm install @worldcoin/minikit-js@latest --no-audit --no-fund
print_success "HoldStation SDK installed"

# Create .env file
print_step "Setting up configuration..."
if [ ! -f ".env" ]; then
    if [ -f ".env.example" ]; then
        cp .env.example .env
        print_success "Created .env from example"
    else
        print_info "Creating basic .env file..."
        cat > .env << 'EOF'
# WorldChain Trading Bot Configuration V2.5

# Required: Your private key (without 0x prefix)
PRIVATE_KEY=your_private_key_here

# Required: RPC URL for WorldChain
RPC_URL=https://worldchain-mainnet.g.alchemy.com/v2/YOUR_API_KEY

# Required: Alchemy API Key for portfolio data
ALCHEMY_API_KEY=your_alchemy_api_key_here

# Token Addresses (V2.5 - Updated)
WLD_TOKEN_ADDRESS=0x2cfc85d8e48f8eab294be644d9e25c3030863003

# Trading Configuration
DEFAULT_SLIPPAGE=2.0
MAX_GAS_PRICE=50
ENABLE_AUTO_SELL=true
PROFIT_TARGET=1.0
STOP_LOSS_THRESHOLD=-5.0

# Price Database Settings (NEW in V2.5)
PRICE_UPDATE_INTERVAL=30000
PRICE_HISTORY_DAYS=7
ENABLE_BACKGROUND_MONITORING=true

# Advanced Settings
ENABLE_TRAILING_STOP=false
TRAILING_STOP=0.5
MIN_PROFIT_FOR_TRAILING=2.0
MAX_POSITION_SIZE=100
MAX_OPEN_POSITIONS=5
EOF
        print_success "Created basic .env file"
    fi
    
    print_warning "⚠️  IMPORTANT: Edit .env file with your credentials!"
    print_info "Required: PRIVATE_KEY, RPC_URL, ALCHEMY_API_KEY"
else
    print_success ".env file already exists"
fi

# Make scripts executable
print_step "Setting script permissions..."
chmod +x *.sh 2>/dev/null || true
print_success "Scripts made executable"

# Set file ownership if running as root
if [[ $EUID -eq 0 ]] && [ "$TARGET_USER" != "root" ]; then
    print_step "Setting file ownership for user: $TARGET_USER"
    chown -R "$TARGET_USER:$TARGET_USER" "$BOT_DIR" || print_warning "Could not set ownership"
    print_success "File ownership set"
fi

# Create startup script
print_step "Creating startup helpers..."
cat > start-bot.sh << 'EOF'
#!/bin/bash
echo "🚀 Starting WorldChain Trading Bot V2.5..."
echo "📊 Features: Price Database, Triggers, Fixed Stop Loss"
echo ""
node worldchain-trading-bot.js
EOF

cat > check-status.sh << 'EOF'
#!/bin/bash
echo "📊 WorldChain Bot V2.5 Status Check"
echo "=================================="
echo ""

if [ -f "price-database.json" ]; then
    echo "✅ Price Database: $(wc -l < price-database.json) lines"
else
    echo "⚠️  Price Database: Not created yet"
fi

if [ -f "price-triggers.json" ]; then
    echo "✅ Triggers: $(grep -c '"id":' price-triggers.json || echo "0") triggers"
else
    echo "⚠️  Triggers: Not created yet"
fi

if [ -f "custom-strategies.json" ]; then
    echo "✅ Strategies: $(grep -c '"id":' custom-strategies.json || echo "0") strategies"
else
    echo "⚠️  Strategies: Not created yet"
fi

echo ""
echo "Node.js Version: $(node --version)"
echo "NPM Packages: $(npm list --depth=0 2>/dev/null | wc -l) installed"
echo ""
EOF

chmod +x start-bot.sh check-status.sh

print_success "Helper scripts created"

# Final setup summary
print_step "Installation Summary"
echo ""
print_success "🎉 WorldChain Trading Bot V2.5 installed successfully!"
echo ""
print_info "📊 NEW FEATURES IN V2.5:"
echo "   • Background Price Database (auto-tracks all tokens)"
echo "   • Automated Triggers System (buy/sell automation)"
echo "   • Fixed Stop Loss (90% stop loss works perfectly!)"
echo "   • Console Commands (trigger buy YIELD -30% 5min 0.1)"
echo "   • SMA-based triggers (technical analysis)"
echo ""
print_info "📍 Installation Location: $BOT_DIR"
print_info "🔧 Configuration File: $BOT_DIR/.env"
echo ""
print_warning "⚠️  NEXT STEPS:"
echo "1. Edit .env file with your credentials:"
echo "   nano $BOT_DIR/.env"
echo ""
echo "2. Add your private key, RPC URL, and Alchemy API key"
echo ""
echo "3. Start the bot:"
echo "   cd $BOT_DIR"
echo "   ./start-bot.sh"
echo ""
echo "4. Run token discovery to populate price database"
echo ""
echo "5. Create your first trigger:"
echo "   Main Menu → Price Triggers → Create Buy Trigger"
echo ""
print_success "🚀 Ready to start automated trading!"
print_info "📖 Read PRICE_DATABASE_TRIGGERS_GUIDE.md for detailed usage"
echo ""

# Test Node.js modules
print_step "Testing installation..."
if node -e "console.log('✅ Node.js working')" 2>/dev/null; then
    print_success "Node.js test passed"
else
    print_error "Node.js test failed"
fi

if [ -f "worldchain-trading-bot.js" ]; then
    print_success "Bot main file found"
else
    print_warning "Bot main file not found - ensure all files are extracted"
fi

print_success "🎉 Setup complete! Happy trading with V2.5!"