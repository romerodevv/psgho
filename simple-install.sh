#!/bin/bash

# ALGORITMIT - Simple Installation Script
# Machine Learning Trading Bot for Worldchain

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Simple banner
echo -e "${CYAN}"
echo "🤖 ALGORITMIT Trading Bot - Simple Installer"
echo "=============================================="
echo -e "${NC}"

# Check if running as root
if [[ $EUID -eq 0 ]]; then
    echo -e "${YELLOW}⚠️  Running as root. Consider using a regular user for better security.${NC}"
fi

echo -e "${BLUE}📋 Installing ALGORITMIT Machine Learning Trading Bot...${NC}"
echo ""

# Step 1: Install Node.js if needed
echo -e "${CYAN}Step 1: Checking Node.js...${NC}"
if command -v node >/dev/null 2>&1; then
    NODE_VERSION=$(node --version | cut -d'v' -f2 | cut -d'.' -f1)
    if [ "$NODE_VERSION" -ge 18 ]; then
        echo -e "${GREEN}✅ Node.js $(node --version) found${NC}"
    else
        echo -e "${YELLOW}⚠️  Node.js version too old, installing Node.js 20...${NC}"
        curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - >/dev/null 2>&1
        sudo apt-get install -y nodejs >/dev/null 2>&1
    fi
else
    echo -e "${YELLOW}📦 Installing Node.js 20...${NC}"
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - >/dev/null 2>&1
    sudo apt-get install -y nodejs >/dev/null 2>&1
fi

# Verify Node.js installation
if ! command -v node >/dev/null 2>&1; then
    echo -e "${RED}❌ Failed to install Node.js${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Node.js ready: $(node --version)${NC}"

# Step 2: Install Git if needed
echo -e "${CYAN}Step 2: Checking Git...${NC}"
if ! command -v git >/dev/null 2>&1; then
    echo -e "${YELLOW}📦 Installing Git...${NC}"
    sudo apt-get update >/dev/null 2>&1
    sudo apt-get install -y git >/dev/null 2>&1
fi
echo -e "${GREEN}✅ Git ready${NC}"

# Step 3: Download ALGORITMIT
echo -e "${CYAN}Step 3: Downloading ALGORITMIT...${NC}"
INSTALL_DIR="$HOME/algoritmit-bot"

if [ -d "$INSTALL_DIR" ]; then
    echo -e "${YELLOW}⚠️  Directory exists. Removing old version...${NC}"
    rm -rf "$INSTALL_DIR"
fi

git clone https://github.com/romerodevv/psgho.git "$INSTALL_DIR" >/dev/null 2>&1
cd "$INSTALL_DIR"
echo -e "${GREEN}✅ ALGORITMIT downloaded${NC}"

# Step 4: Install dependencies
echo -e "${CYAN}Step 4: Installing dependencies...${NC}"
npm install >/dev/null 2>&1
echo -e "${GREEN}✅ Dependencies installed${NC}"

# Step 5: Install HoldStation SDK
echo -e "${CYAN}Step 5: Installing HoldStation SDK...${NC}"
npm install @holdstation/worldchain-sdk@latest >/dev/null 2>&1
npm install @holdstation/worldchain-ethers-v6@latest >/dev/null 2>&1
npm install @worldcoin/minikit-js@latest >/dev/null 2>&1
echo -e "${GREEN}✅ HoldStation SDK installed${NC}"

# Step 6: Setup configuration
echo -e "${CYAN}Step 6: Setting up configuration...${NC}"
cp .env.example .env
echo -e "${GREEN}✅ Configuration template created${NC}"

# Step 7: Create startup script
cat > start.sh << 'EOF'
#!/bin/bash
echo "🤖 Starting ALGORITMIT Trading Bot..."
node worldchain-trading-bot.js
EOF
chmod +x start.sh

echo ""
echo -e "${GREEN}🎉 ALGORITMIT Installation Complete!${NC}"
echo ""
echo -e "${YELLOW}📍 Installation Location:${NC} $INSTALL_DIR"
echo ""
echo -e "${CYAN}🔧 NEXT STEPS:${NC}"
echo ""
echo -e "${WHITE}1. Configure your wallet:${NC}"
echo -e "   ${BLUE}cd $INSTALL_DIR${NC}"
echo -e "   ${BLUE}nano .env${NC}"
echo ""
echo -e "${WHITE}2. Add your private key to the .env file${NC}"
echo ""
echo -e "${WHITE}3. Start the bot:${NC}"
echo -e "   ${BLUE}./start.sh${NC}"
echo ""
echo -e "${WHITE}4. IMPORTANT - ALGORITMIT Safety Steps:${NC}"
echo -e "   ${YELLOW}• Go to Menu Option 7 (🤖 ALGORITMIT)${NC}"
echo -e "   ${YELLOW}• Enable ALGORITMIT Strategy${NC}"
echo -e "   ${YELLOW}• Turn on Learning Mode FIRST${NC}"
echo -e "   ${YELLOW}• Let it learn for 24+ hours${NC}"
echo -e "   ${YELLOW}• Only then enable auto-trading with 0.01 WLD${NC}"
echo ""
echo -e "${RED}⚠️  SAFETY REMINDER:${NC}"
echo -e "${RED}   • Start with Learning Mode for 24+ hours${NC}"
echo -e "${RED}   • Use tiny amounts (0.01 WLD) for testing${NC}"
echo -e "${RED}   • Never risk more than you can afford to lose${NC}"
echo ""
echo -e "${GREEN}🚀 Ready to start AI-powered trading!${NC}"
echo ""