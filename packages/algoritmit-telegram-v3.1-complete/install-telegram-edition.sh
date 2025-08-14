#!/bin/bash

# ALGORITMIT v3.1 - Telegram Edition Installer
# Complete installation with all features and fixes

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ASCII Banner
echo -e "${CYAN}"
cat << "BANNER"
╔══════════════════════════════════════════════════════════════════════════════════════╗
║                                                                                      ║
║ █████╗ ██╗      ██████╗  ██████╗ ██████╗ ██╗████████╗███╗   ███╗██╗████████╗       ║
║██╔══██╗██║     ██╔════╝ ██╔═══██╗██╔══██╗██║╚══██╔══╝████╗ ████║██║╚══██╔══╝       ║
║███████║██║     ██║  ███╗██║   ██║██████╔╝██║   ██║   ██╔████╔██║██║   ██║          ║
║██╔══██║██║     ██║   ██║██║   ██║██╔══██╗██║   ██║   ██║╚██╔╝██║██║   ██║          ║
║██║  ██║███████╗╚██████╔╝╚██████╔╝██║  ██║██║   ██║   ██║ ╚═╝ ██║██║   ██║          ║
║╚═╝  ╚═╝╚══════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝   ╚═╝   ╚═╝     ╚═╝╚═╝   ╚═╝          ║
║                                                                                      ║
║                    🤖 v3.1 Telegram Edition - Complete Package                      ║
║                                                                                      ║
╚══════════════════════════════════════════════════════════════════════════════════════╝
BANNER
echo -e "${NC}"

echo -e "${GREEN}🚀 ALGORITMIT v3.1 - Telegram Edition Installer${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}✨ NEW IN v3.1:${NC}"
echo -e "${WHITE}📱 Complete Telegram notifications system${NC}"
echo -e "${WHITE}🔧 Robust price monitoring with fallbacks${NC}"
echo -e "${WHITE}🎯 Fixed Price Triggers menu (fully functional)${NC}"
echo -e "${WHITE}🛡️ Enhanced error handling for HoldStation SDK${NC}"
echo -e "${WHITE}📊 Health monitoring and automatic cleanup${NC}"
echo -e "${WHITE}⚡ CLI interface for headless operation${NC}"
echo ""

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   echo -e "${RED}⚠️  WARNING: Running as root. Consider creating a dedicated user for security.${NC}"
   read -p "Continue anyway? (y/N): " -n 1 -r
   echo
   if [[ ! $REPLY =~ ^[Yy]$ ]]; then
       exit 1
   fi
fi

# Progress indicator function
show_progress() {
    echo -e "${BLUE}[STEP $1/8]${NC} $2"
}

# Check system requirements
show_progress 1 "Checking system requirements..."
echo "🔍 Checking system requirements..."

# Check for required commands
REQUIRED_COMMANDS=("curl" "wget" "unzip" "tar")
for cmd in "${REQUIRED_COMMANDS[@]}"; do
    if ! command -v $cmd &> /dev/null; then
        echo -e "${RED}❌ Required command '$cmd' not found. Please install it first.${NC}"
        exit 1
    fi
done

# Detect OS
OS="unknown"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
    OS="windows"
fi

echo "✅ Operating System: $OS"
echo "✅ System requirements check passed"

# Install Node.js if needed
show_progress 2 "Checking Node.js installation..."
if ! command -v node &> /dev/null; then
    echo "📦 Node.js not found. Installing..."
    
    if [[ "$OS" == "linux" ]]; then
        # Install Node.js on Linux
        if command -v apt-get &> /dev/null; then
            echo "🔧 Installing Node.js via apt..."
            curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
            sudo apt-get install -y nodejs
        elif command -v yum &> /dev/null; then
            echo "🔧 Installing Node.js via yum..."
            curl -fsSL https://rpm.nodesource.com/setup_20.x | sudo bash -
            sudo yum install -y nodejs npm
        else
            echo -e "${RED}❌ Unsupported Linux distribution. Please install Node.js manually.${NC}"
            exit 1
        fi
    elif [[ "$OS" == "macos" ]]; then
        if command -v brew &> /dev/null; then
            echo "🔧 Installing Node.js via Homebrew..."
            brew install node
        else
            echo -e "${RED}❌ Homebrew not found. Please install Node.js manually from nodejs.org${NC}"
            exit 1
        fi
    fi
else
    NODE_VERSION=$(node --version)
    echo "✅ Node.js found: $NODE_VERSION"
fi

# Verify Node.js version
NODE_MAJOR_VERSION=$(node --version | cut -d'.' -f1 | sed 's/v//')
if [[ $NODE_MAJOR_VERSION -lt 18 ]]; then
    echo -e "${RED}❌ Node.js version 18+ required. Current: $(node --version)${NC}"
    exit 1
fi

# Install Git if needed
show_progress 3 "Checking Git installation..."
if ! command -v git &> /dev/null; then
    echo "📦 Git not found. Installing..."
    
    if [[ "$OS" == "linux" ]]; then
        if command -v apt-get &> /dev/null; then
            sudo apt-get update && sudo apt-get install -y git
        elif command -v yum &> /dev/null; then
            sudo yum install -y git
        fi
    elif [[ "$OS" == "macos" ]]; then
        if command -v brew &> /dev/null; then
            brew install git
        fi
    fi
else
    echo "✅ Git found: $(git --version)"
fi

# Install dependencies
show_progress 4 "Installing Node.js dependencies..."
echo "📦 Installing npm dependencies..."

if [[ -f package.json ]]; then
    npm install --production
    echo "✅ Core dependencies installed"
else
    echo -e "${RED}❌ package.json not found in current directory${NC}"
    exit 1
fi

# Install HoldStation SDK
show_progress 5 "Installing HoldStation SDK..."
echo "🔗 Installing HoldStation SDK packages..."

# Make install script executable and run it
if [[ -f install-holdstation-sdk.sh ]]; then
    chmod +x install-holdstation-sdk.sh
    ./install-holdstation-sdk.sh
    echo "✅ HoldStation SDK installed"
else
    echo "⚠️  HoldStation SDK installer not found, installing manually..."
    npm install @holdstation/worldchain-sdk@latest @holdstation/worldchain-ethers-v6@latest @worldcoin/minikit-js@latest
fi

# Setup configuration
show_progress 6 "Setting up configuration..."
echo "⚙️  Setting up configuration files..."

if [[ ! -f .env ]]; then
    if [[ -f .env.example ]]; then
        cp .env.example .env
        echo "✅ Created .env file from template"
        echo ""
        echo -e "${YELLOW}🔧 IMPORTANT: You must edit the .env file with your credentials:${NC}"
        echo -e "${WHITE}   - PRIVATE_KEY: Your wallet private key${NC}"
        echo -e "${WHITE}   - RPC_URL: Your Worldchain RPC endpoint${NC}"
        echo -e "${WHITE}   - TELEGRAM_BOT_TOKEN: Your Telegram bot token (optional)${NC}"
        echo -e "${WHITE}   - TELEGRAM_CHAT_ID: Your Telegram chat ID (optional)${NC}"
        echo ""
    else
        echo -e "${RED}❌ .env.example not found${NC}"
        exit 1
    fi
else
    echo "✅ .env file already exists"
fi

# Create helper scripts
show_progress 7 "Creating helper scripts..."
echo "📝 Creating helper scripts..."

# Create start script
cat > start-algoritmit.sh << 'STARTSCRIPT'
#!/bin/bash
echo "🚀 Starting ALGORITMIT v3.1 - Telegram Edition..."
echo "═══════════════════════════════════════════════════════"

# Check if .env exists and has required variables
if [[ ! -f .env ]]; then
    echo "❌ .env file not found!"
    echo "Please copy .env.example to .env and configure your settings."
    exit 1
fi

# Check for required environment variables
if ! grep -q "PRIVATE_KEY=" .env || ! grep -q "RPC_URL=" .env; then
    echo "❌ Missing required configuration in .env file!"
    echo "Please configure PRIVATE_KEY and RPC_URL at minimum."
    exit 1
fi

# Start the bot
node worldchain-trading-bot.js
STARTSCRIPT

# Create CLI start script
cat > start-cli.sh << 'CLISCRIPT'
#!/bin/bash
echo "⚡ Starting ALGORITMIT CLI..."
echo "═══════════════════════════════"

# Check if .env exists
if [[ ! -f .env ]]; then
    echo "❌ .env file not found!"
    echo "Please copy .env.example to .env and configure your settings."
    exit 1
fi

# Start the CLI
node algoritmit-cli.js
CLISCRIPT

# Create update script
cat > update-algoritmit.sh << 'UPDATESCRIPT'
#!/bin/bash
echo "🔄 Updating ALGORITMIT dependencies..."
npm update
echo "🔗 Updating HoldStation SDK..."
npm install @holdstation/worldchain-sdk@latest @holdstation/worldchain-ethers-v6@latest @worldcoin/minikit-js@latest
echo "✅ Update complete!"
UPDATESCRIPT

# Make scripts executable
chmod +x start-algoritmit.sh
chmod +x start-cli.sh
chmod +x update-algoritmit.sh
if [[ -f cli.sh ]]; then
    chmod +x cli.sh
fi

echo "✅ Helper scripts created:"
echo "   - start-algoritmit.sh: Start the full bot interface"
echo "   - start-cli.sh: Start the CLI interface"
echo "   - update-algoritmit.sh: Update dependencies"

# Final setup
show_progress 8 "Finalizing installation..."
echo "🎉 Finalizing installation..."

# Create logs directory
mkdir -p logs
echo "✅ Logs directory created"

# Installation complete
echo ""
echo -e "${GREEN}🎉 ALGORITMIT v3.1 - Telegram Edition Installation Complete!${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}📋 NEXT STEPS:${NC}"
echo -e "${WHITE}1. Configure your .env file with your credentials${NC}"
echo -e "${WHITE}2. (Optional) Set up Telegram notifications${NC}"
echo -e "${WHITE}3. Start ALGORITMIT with: ./start-algoritmit.sh${NC}"
echo ""
echo -e "${CYAN}🚀 QUICK START:${NC}"
echo -e "${WHITE}   ./start-algoritmit.sh    # Start full bot interface${NC}"
echo -e "${WHITE}   ./start-cli.sh          # Start CLI interface${NC}"
echo -e "${WHITE}   ./update-algoritmit.sh  # Update dependencies${NC}"
echo ""
echo -e "${CYAN}📚 DOCUMENTATION:${NC}"
echo -e "${WHITE}   README.md                        # Main documentation${NC}"
echo -e "${WHITE}   TELEGRAM_NOTIFICATIONS_GUIDE.md # Telegram setup${NC}"
echo -e "${WHITE}   ALGORITMIT_GUIDE.md             # ML trading guide${NC}"
echo -e "${WHITE}   CLI_GUIDE.md                    # CLI documentation${NC}"
echo ""
echo -e "${YELLOW}⚠️  SECURITY REMINDERS:${NC}"
echo -e "${WHITE}   - Never share your private key${NC}"
echo -e "${WHITE}   - Keep your .env file secure${NC}"
echo -e "${WHITE}   - Start with small amounts for testing${NC}"
echo -e "${WHITE}   - Trading involves risk - use at your own discretion${NC}"
echo ""
echo -e "${GREEN}Happy Trading with ALGORITMIT v3.1! 🤖📱💹${NC}"
