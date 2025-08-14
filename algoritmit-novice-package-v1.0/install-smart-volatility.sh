#!/bin/bash

# ALGORITMIT Smart Volatility Trading System v4.0
# Advanced AI-Powered Trading Bot with Smart Volatility Management
# Installation Script

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ASCII Art Banner
echo -e "${CYAN}"
cat << "EOF"
╔═══════════════════════════════════════════════════════════════════════════════╗
║                                                                               ║
║      █████╗ ██╗      ██████╗  ██████╗ ██████╗ ██╗████████╗███╗   ███╗██╗████████╗ ║
║     ██╔══██╗██║     ██╔════╝ ██╔═══██╗██╔══██╗██║╚══██╔══╝████╗ ████║██║╚══██╔══╝ ║
║     ███████║██║     ██║  ███╗██║   ██║██████╔╝██║   ██║   ██╔████╔██║██║   ██║    ║
║     ██╔══██║██║     ██║   ██║██║   ██║██╔══██╗██║   ██║   ██║╚██╔╝██║██║   ██║    ║
║     ██║  ██║███████╗╚██████╔╝╚██████╔╝██║  ██║██║   ██║   ██║ ╚═╝ ██║██║   ██║    ║
║     ╚═╝  ╚═╝╚══════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝   ╚═╝   ╚═╝     ╚═╝╚═╝   ╚═╝    ║
║                                                                               ║
║                    🧠 SMART VOLATILITY TRADING SYSTEM v4.0 🧠                 ║
║                                                                               ║
║                    🚀 Seize Big Opportunities in Volatile Markets! 🚀         ║
║                                                                               ║
╚═══════════════════════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

echo -e "${GREEN}🎯 ALGORITMIT Smart Volatility Trading System v4.0${NC}"
echo -e "${YELLOW}   Advanced AI-Powered Trading Bot for Worldchain${NC}"
echo -e "${BLUE}   📊 Smart Volatility Analysis | 🧠 Adaptive Thresholds | ⚡ Lightning Execution${NC}"
echo ""

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   echo -e "${YELLOW}⚠️  Running as root detected. This is okay but not recommended for production.${NC}"
   echo ""
fi

# System detection
echo -e "${CYAN}🔍 Detecting system...${NC}"
OS="Unknown"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="Linux"
    DISTRO=$(lsb_release -si 2>/dev/null || echo "Unknown")
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macOS"
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    OS="Windows"
fi

echo -e "${GREEN}✅ System: $OS${NC}"
if [[ "$OS" == "Linux" ]]; then
    echo -e "${GREEN}   Distribution: $DISTRO${NC}"
fi
echo ""

# Check prerequisites
echo -e "${CYAN}🔧 Checking prerequisites...${NC}"

# Check Node.js
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    echo -e "${GREEN}✅ Node.js: $NODE_VERSION${NC}"
    
    # Check if version is >= 18
    NODE_MAJOR=$(echo $NODE_VERSION | cut -d'.' -f1 | sed 's/v//')
    if [[ $NODE_MAJOR -lt 18 ]]; then
        echo -e "${RED}❌ Node.js version 18+ required. Current: $NODE_VERSION${NC}"
        echo -e "${YELLOW}📥 Installing Node.js 20...${NC}"
        
        if [[ "$OS" == "Linux" ]]; then
            curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
            sudo apt-get install -y nodejs
        elif [[ "$OS" == "macOS" ]]; then
            if command -v brew &> /dev/null; then
                brew install node@20
            else
                echo -e "${RED}❌ Please install Homebrew first: https://brew.sh${NC}"
                exit 1
            fi
        fi
    fi
else
    echo -e "${YELLOW}📥 Installing Node.js 20...${NC}"
    
    if [[ "$OS" == "Linux" ]]; then
        # Update package list
        sudo apt-get update
        
        # Install Node.js 20
        curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
        sudo apt-get install -y nodejs
        
    elif [[ "$OS" == "macOS" ]]; then
        if command -v brew &> /dev/null; then
            brew install node
        else
            echo -e "${YELLOW}📥 Installing Homebrew...${NC}"
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            brew install node
        fi
    else
        echo -e "${RED}❌ Please install Node.js 18+ manually from https://nodejs.org${NC}"
        exit 1
    fi
fi

# Check npm
if command -v npm &> /dev/null; then
    NPM_VERSION=$(npm --version)
    echo -e "${GREEN}✅ npm: v$NPM_VERSION${NC}"
else
    echo -e "${RED}❌ npm not found${NC}"
    exit 1
fi

# Check git
if command -v git &> /dev/null; then
    GIT_VERSION=$(git --version)
    echo -e "${GREEN}✅ $GIT_VERSION${NC}"
else
    echo -e "${YELLOW}📥 Installing git...${NC}"
    if [[ "$OS" == "Linux" ]]; then
        sudo apt-get install -y git
    elif [[ "$OS" == "macOS" ]]; then
        xcode-select --install
    fi
fi

echo ""

# Install additional system dependencies
echo -e "${CYAN}📦 Installing system dependencies...${NC}"

if [[ "$OS" == "Linux" ]]; then
    sudo apt-get update
    sudo apt-get install -y curl wget unzip build-essential python3 python3-pip
elif [[ "$OS" == "macOS" ]]; then
    if ! command -v brew &> /dev/null; then
        echo -e "${YELLOW}📥 Installing Homebrew...${NC}"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew install curl wget unzip
fi

echo -e "${GREEN}✅ System dependencies installed${NC}"
echo ""

# Create installation directory
INSTALL_DIR="$HOME/algoritmit-smart-volatility"
echo -e "${CYAN}📁 Creating installation directory: $INSTALL_DIR${NC}"

if [[ -d "$INSTALL_DIR" ]]; then
    echo -e "${YELLOW}⚠️  Directory exists. Creating backup...${NC}"
    mv "$INSTALL_DIR" "$INSTALL_DIR.backup.$(date +%s)"
fi

mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

echo -e "${GREEN}✅ Directory created${NC}"
echo ""

# Copy files
echo -e "${CYAN}📋 Installing ALGORITMIT Smart Volatility files...${NC}"

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

# Copy all files from the package
cp "$SCRIPT_DIR"/*.js "$INSTALL_DIR/"
cp "$SCRIPT_DIR"/*.json "$INSTALL_DIR/"
cp "$SCRIPT_DIR"/.env.example "$INSTALL_DIR/"

echo -e "${GREEN}✅ Core files installed${NC}"
echo ""

# Install Node.js dependencies
echo -e "${CYAN}📦 Installing Node.js dependencies...${NC}"
echo -e "${YELLOW}   This may take a few minutes...${NC}"

npm install

echo -e "${GREEN}✅ Dependencies installed${NC}"
echo ""

# Setup environment file
echo -e "${CYAN}⚙️  Setting up environment configuration...${NC}"

if [[ ! -f ".env" ]]; then
    cp .env.example .env
    echo -e "${GREEN}✅ Environment file created (.env)${NC}"
else
    echo -e "${YELLOW}⚠️  Environment file already exists${NC}"
fi

echo ""

# Create startup scripts
echo -e "${CYAN}🚀 Creating startup scripts...${NC}"

# Full bot startup script
cat > start-bot.sh << 'EOF'
#!/bin/bash

# ALGORITMIT Smart Volatility Trading Bot Launcher

echo "🚀 Starting ALGORITMIT Smart Volatility Trading Bot..."
echo "📊 Advanced AI-Powered Trading with Smart Volatility Management"
echo ""

# Check if .env exists
if [[ ! -f ".env" ]]; then
    echo "❌ .env file not found! Please configure your environment first."
    echo "   Copy .env.example to .env and edit with your settings."
    exit 1
fi

# Start the bot
node worldchain-trading-bot.js
EOF

# CLI-only startup script
cat > start-cli.sh << 'EOF'
#!/bin/bash

# ALGORITMIT Smart Volatility CLI Launcher

echo "⚡ Starting ALGORITMIT Smart Volatility CLI..."
echo "🎯 Quick Trading Commands Interface"
echo ""

# Check if .env exists
if [[ ! -f ".env" ]]; then
    echo "❌ .env file not found! Please configure your environment first."
    echo "   Copy .env.example to .env and edit with your settings."
    exit 1
fi

# Start CLI mode
node worldchain-trading-bot.js --cli
EOF

# Make scripts executable
chmod +x start-bot.sh
chmod +x start-cli.sh

echo -e "${GREEN}✅ Startup scripts created${NC}"
echo "   📄 start-bot.sh - Full interactive bot"
echo "   📄 start-cli.sh - CLI commands only"
echo ""

# Create desktop shortcuts (Linux only)
if [[ "$OS" == "Linux" ]] && [[ -d "$HOME/Desktop" ]]; then
    echo -e "${CYAN}🖥️  Creating desktop shortcuts...${NC}"
    
    cat > "$HOME/Desktop/ALGORITMIT-Smart-Volatility.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=ALGORITMIT Smart Volatility
Comment=Advanced AI-Powered Trading Bot
Exec=$INSTALL_DIR/start-bot.sh
Icon=utilities-terminal
Terminal=true
Categories=Office;Finance;
EOF
    
    chmod +x "$HOME/Desktop/ALGORITMIT-Smart-Volatility.desktop"
    echo -e "${GREEN}✅ Desktop shortcut created${NC}"
fi

echo ""

# Installation complete
echo -e "${GREEN}🎉 INSTALLATION COMPLETE! 🎉${NC}"
echo ""
echo -e "${CYAN}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║                    🧠 SMART FEATURES ENABLED 🧠                ║${NC}"
echo -e "${CYAN}╠═══════════════════════════════════════════════════════════════╣${NC}"
echo -e "${CYAN}║${NC} 📊 ${YELLOW}Real-time Volatility Analysis${NC}                          ${CYAN}║${NC}"
echo -e "${CYAN}║${NC} 📉 ${YELLOW}Smart DIP Buying (4-tier system)${NC}                       ${CYAN}║${NC}"
echo -e "${CYAN}║${NC} 📈 ${YELLOW}Smart Profit Taking (5-tier system)${NC}                    ${CYAN}║${NC}"
echo -e "${CYAN}║${NC} 💰 ${YELLOW}Dynamic Position Sizing${NC}                               ${CYAN}║${NC}"
echo -e "${CYAN}║${NC} 🛡️ ${YELLOW}Average Price Protection${NC}                              ${CYAN}║${NC}"
echo -e "${CYAN}║${NC} ⚡ ${YELLOW}Lightning Fast Auto-Sell${NC}                              ${CYAN}║${NC}"
echo -e "${CYAN}║${NC} 📱 ${YELLOW}Telegram Notifications${NC}                               ${CYAN}║${NC}"
echo -e "${CYAN}║${NC} 🎯 ${YELLOW}Seize Big Market Opportunities${NC}                       ${CYAN}║${NC}"
echo -e "${CYAN}╚═══════════════════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${YELLOW}📋 NEXT STEPS:${NC}"
echo ""
echo -e "${BLUE}1. 📝 Configure your settings:${NC}"
echo -e "   ${CYAN}cd $INSTALL_DIR${NC}"
echo -e "   ${CYAN}nano .env${NC}  ${YELLOW}# Edit with your private key, RPC, etc.${NC}"
echo ""
echo -e "${BLUE}2. 🚀 Start the bot:${NC}"
echo -e "   ${GREEN}./start-bot.sh${NC}     ${YELLOW}# Full interactive trading bot${NC}"
echo -e "   ${GREEN}./start-cli.sh${NC}     ${YELLOW}# CLI commands only${NC}"
echo ""
echo -e "${BLUE}3. 🎯 Example Smart Strategy:${NC}"
echo -e "   ${YELLOW}• Create strategy with 5% profit target${NC}"
echo -e "   ${YELLOW}• Bot adapts to market volatility automatically${NC}"
echo -e "   ${YELLOW}• Buys bigger on larger dips (-50% = 2x size)${NC}"
echo -e "   ${YELLOW}• Sells faster on big jumps (+500% = immediate)${NC}"
echo ""

echo -e "${RED}⚠️  IMPORTANT SECURITY REMINDERS:${NC}"
echo -e "${YELLOW}   • Never share your private keys${NC}"
echo -e "${YELLOW}   • Start with small amounts for testing${NC}"
echo -e "${YELLOW}   • Monitor your trades regularly${NC}"
echo -e "${YELLOW}   • Keep your .env file secure${NC}"
echo ""

echo -e "${GREEN}📖 Documentation: Check README files in the installation directory${NC}"
echo -e "${GREEN}🆘 Support: Review the troubleshooting guides${NC}"
echo ""

echo -e "${PURPLE}🎯 Ready to seize big opportunities in volatile markets!${NC}"
echo -e "${CYAN}   Installation directory: $INSTALL_DIR${NC}"
echo ""