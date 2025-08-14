#!/bin/bash

# ALGORITMIT - Manual Step-by-Step Installer
# Complete control over each installation step

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
WHITE='\033[1;37m'
NC='\033[0m'

# Helper functions
ask_continue() {
    echo -e "${YELLOW}Press Enter to continue or Ctrl+C to exit...${NC}"
    read -r
}

ask_yes_no() {
    local question="$1"
    local default="$2"
    while true; do
        if [ "$default" = "y" ]; then
            echo -e "${CYAN}$question (Y/n): ${NC}"
        else
            echo -e "${CYAN}$question (y/N): ${NC}"
        fi
        read -r answer
        case $answer in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            "" ) 
                if [ "$default" = "y" ]; then
                    return 0
                else
                    return 1
                fi
                ;;
            * ) echo -e "${RED}Please answer yes or no.${NC}";;
        esac
    done
}

print_step() {
    echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${WHITE}$1${NC}"
    echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# Welcome banner
clear
echo -e "${CYAN}"
cat << 'EOF'
╔══════════════════════════════════════════════════════════════════════════════════════╗
║                                                                                      ║
║     █████╗ ██╗      ██████╗  ██████╗ ██████╗ ██╗████████╗███╗   ███╗██╗████████╗   ║
║    ██╔══██╗██║     ██╔════╝ ██╔═══██╗██╔══██╗██║╚══██╔══╝████╗ ████║██║╚══██╔══╝   ║
║    ███████║██║     ██║  ███╗██║   ██║██████╔╝██║   ██║   ██╔████╔██║██║   ██║      ║
║    ██╔══██║██║     ██║   ██║██║   ██║██╔══██╗██║   ██║   ██║╚██╔╝██║██║   ██║      ║
║    ██║  ██║███████╗╚██████╔╝╚██████╔╝██║  ██║██║   ██║   ██║ ╚═╝ ██║██║   ██║      ║
║    ╚═╝  ╚═╝╚══════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝   ╚═╝   ╚═╝     ╚═╝╚═╝   ╚═╝      ║
║                                                                                      ║
║                   🔧 Manual Step-by-Step Installation Guide                         ║
║                            Complete Control Over Each Step                          ║
╚══════════════════════════════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

echo -e "${WHITE}🔧 Welcome to ALGORITMIT Manual Installation${NC}"
echo -e "${BLUE}This installer gives you complete control over each step.${NC}"
echo -e "${BLUE}You can review, skip, or customize each part of the installation.${NC}"
echo ""
echo -e "${YELLOW}⚠️  Important: This is a machine learning trading bot that handles real money.${NC}"
echo -e "${YELLOW}   Please read each step carefully and understand what you're installing.${NC}"
echo ""
ask_continue

# Step 1: System Information
print_step "STEP 1: System Information & Requirements Check"
echo -e "${BLUE}Let's check your system first...${NC}"
echo ""

echo -e "${CYAN}System Information:${NC}"
echo "  OS: $(uname -s)"
echo "  Kernel: $(uname -r)"
echo "  Architecture: $(uname -m)"
if command -v lsb_release >/dev/null 2>&1; then
    echo "  Distribution: $(lsb_release -d | cut -f2)"
fi

echo ""
echo -e "${CYAN}Current User: ${YELLOW}$(whoami)${NC}"
echo -e "${CYAN}Home Directory: ${YELLOW}$HOME${NC}"
echo -e "${CYAN}Current Directory: ${YELLOW}$(pwd)${NC}"

echo ""
echo -e "${CYAN}Checking system requirements...${NC}"

# Check available space
AVAILABLE_SPACE=$(df $HOME | tail -1 | awk '{print $4}')
SPACE_GB=$((AVAILABLE_SPACE / 1024 / 1024))
echo "  Available disk space: ${SPACE_GB}GB"
if [ $SPACE_GB -lt 2 ]; then
    echo -e "${RED}  ⚠️  Warning: Less than 2GB available. Consider freeing up space.${NC}"
fi

# Check memory
if command -v free >/dev/null 2>&1; then
    MEMORY_GB=$(free -g | awk '/^Mem:/{print $2}')
    echo "  Available memory: ${MEMORY_GB}GB"
    if [ $MEMORY_GB -lt 4 ]; then
        echo -e "${YELLOW}  ⚠️  Warning: Less than 4GB RAM. ML processing may be slower.${NC}"
    fi
fi

echo ""
if ask_yes_no "Continue with installation?" "y"; then
    echo -e "${GREEN}✅ Proceeding with installation${NC}"
else
    echo -e "${RED}Installation cancelled by user.${NC}"
    exit 1
fi

# Step 2: Installation Directory
print_step "STEP 2: Choose Installation Directory"
echo -e "${BLUE}Where would you like to install ALGORITMIT?${NC}"
echo ""
echo -e "${CYAN}Recommended locations:${NC}"
echo "  1. $HOME/algoritmit-bot (recommended)"
echo "  2. $HOME/trading-bot"
echo "  3. /opt/algoritmit (system-wide, requires sudo)"
echo "  4. Custom location"
echo ""

while true; do
    echo -e "${CYAN}Choose installation directory (1-4): ${NC}"
    read -r dir_choice
    case $dir_choice in
        1)
            INSTALL_DIR="$HOME/algoritmit-bot"
            break
            ;;
        2)
            INSTALL_DIR="$HOME/trading-bot"
            break
            ;;
        3)
            INSTALL_DIR="/opt/algoritmit"
            echo -e "${YELLOW}⚠️  This will require sudo privileges.${NC}"
            break
            ;;
        4)
            echo -e "${CYAN}Enter custom path: ${NC}"
            read -r INSTALL_DIR
            if [ -z "$INSTALL_DIR" ]; then
                echo -e "${RED}Please enter a valid path.${NC}"
                continue
            fi
            break
            ;;
        *)
            echo -e "${RED}Please choose 1, 2, 3, or 4.${NC}"
            ;;
    esac
done

echo -e "${GREEN}✅ Selected directory: $INSTALL_DIR${NC}"

# Check if directory exists
if [ -d "$INSTALL_DIR" ]; then
    echo -e "${YELLOW}⚠️  Directory already exists.${NC}"
    if ask_yes_no "Remove existing directory and continue?" "n"; then
        rm -rf "$INSTALL_DIR"
        echo -e "${GREEN}✅ Old directory removed${NC}"
    else
        echo -e "${RED}Installation cancelled.${NC}"
        exit 1
    fi
fi

# Step 3: Node.js Installation
print_step "STEP 3: Node.js Installation"
echo -e "${BLUE}ALGORITMIT requires Node.js 18+ for optimal performance.${NC}"
echo ""

if command -v node >/dev/null 2>&1; then
    NODE_VERSION=$(node --version)
    NODE_MAJOR=$(echo $NODE_VERSION | cut -d'v' -f2 | cut -d'.' -f1)
    echo -e "${CYAN}Current Node.js version: ${GREEN}$NODE_VERSION${NC}"
    
    if [ "$NODE_MAJOR" -ge 18 ]; then
        echo -e "${GREEN}✅ Node.js version is compatible${NC}"
        if ask_yes_no "Keep current Node.js version?" "y"; then
            SKIP_NODE=true
        fi
    else
        echo -e "${YELLOW}⚠️  Node.js version is too old (need 18+)${NC}"
        echo -e "${BLUE}We need to install a newer version.${NC}"
    fi
else
    echo -e "${YELLOW}Node.js not found.${NC}"
fi

if [ "$SKIP_NODE" != true ]; then
    echo ""
    echo -e "${CYAN}Node.js installation options:${NC}"
    echo "  1. Install Node.js 20 (recommended)"
    echo "  2. Install Node.js 18 (minimum required)"
    echo "  3. Skip Node.js installation (manual install)"
    echo ""
    
    while true; do
        echo -e "${CYAN}Choose Node.js version (1-3): ${NC}"
        read -r node_choice
        case $node_choice in
            1)
                NODE_VER="20"
                break
                ;;
            2)
                NODE_VER="18"
                break
                ;;
            3)
                echo -e "${YELLOW}⚠️  You'll need to install Node.js 18+ manually before running ALGORITMIT.${NC}"
                SKIP_NODE=true
                break
                ;;
            *)
                echo -e "${RED}Please choose 1, 2, or 3.${NC}"
                ;;
        esac
    done
    
    if [ "$SKIP_NODE" != true ]; then
        echo ""
        echo -e "${BLUE}Installing Node.js $NODE_VER...${NC}"
        echo -e "${YELLOW}This may take a few minutes and requires sudo privileges.${NC}"
        ask_continue
        
        curl -fsSL https://deb.nodesource.com/setup_${NODE_VER}.x | sudo -E bash -
        sudo apt-get install -y nodejs
        
        if command -v node >/dev/null 2>&1; then
            echo -e "${GREEN}✅ Node.js $(node --version) installed successfully${NC}"
        else
            echo -e "${RED}❌ Node.js installation failed${NC}"
            exit 1
        fi
    fi
fi

# Step 4: Download ALGORITMIT
print_step "STEP 4: Download ALGORITMIT Source Code"
echo -e "${BLUE}Now we'll download the ALGORITMIT trading bot from GitHub.${NC}"
echo ""
echo -e "${CYAN}Download options:${NC}"
echo "  1. Git clone (recommended - allows easy updates)"
echo "  2. Direct download (ZIP file)"
echo "  3. Skip download (use existing files)"
echo ""

while true; do
    echo -e "${CYAN}Choose download method (1-3): ${NC}"
    read -r download_choice
    case $download_choice in
        1)
            DOWNLOAD_METHOD="git"
            break
            ;;
        2)
            DOWNLOAD_METHOD="zip"
            break
            ;;
        3)
            DOWNLOAD_METHOD="skip"
            echo -e "${YELLOW}⚠️  Make sure ALGORITMIT files are already in $INSTALL_DIR${NC}"
            break
            ;;
        *)
            echo -e "${RED}Please choose 1, 2, or 3.${NC}"
            ;;
    esac
done

if [ "$DOWNLOAD_METHOD" != "skip" ]; then
    echo ""
    echo -e "${BLUE}Creating installation directory...${NC}"
    mkdir -p "$INSTALL_DIR"
    cd "$INSTALL_DIR"
    
    if [ "$DOWNLOAD_METHOD" = "git" ]; then
        # Check if git is available
        if ! command -v git >/dev/null 2>&1; then
            echo -e "${YELLOW}Git not found. Installing git...${NC}"
            sudo apt-get update >/dev/null 2>&1
            sudo apt-get install -y git >/dev/null 2>&1
        fi
        
        echo -e "${BLUE}Cloning ALGORITMIT repository...${NC}"
        git clone https://github.com/romerodevv/psgho.git .
        echo -e "${GREEN}✅ Repository cloned successfully${NC}"
        
    elif [ "$DOWNLOAD_METHOD" = "zip" ]; then
        echo -e "${BLUE}Downloading ALGORITMIT ZIP file...${NC}"
        if command -v curl >/dev/null 2>&1; then
            curl -sL https://github.com/romerodevv/psgho/archive/main.zip -o algoritmit.zip
        elif command -v wget >/dev/null 2>&1; then
            wget -q https://github.com/romerodevv/psgho/archive/main.zip -O algoritmit.zip
        else
            echo -e "${RED}❌ Neither curl nor wget found. Please install one of them.${NC}"
            exit 1
        fi
        
        if command -v unzip >/dev/null 2>&1; then
            unzip -q algoritmit.zip
            mv psgho-main/* .
            rm -rf psgho-main algoritmit.zip
        else
            echo -e "${YELLOW}Installing unzip...${NC}"
            sudo apt-get install -y unzip >/dev/null 2>&1
            unzip -q algoritmit.zip
            mv psgho-main/* .
            rm -rf psgho-main algoritmit.zip
        fi
        echo -e "${GREEN}✅ Files extracted successfully${NC}"
    fi
else
    cd "$INSTALL_DIR"
fi

# Step 5: Dependencies Installation
print_step "STEP 5: Install Dependencies"
echo -e "${BLUE}ALGORITMIT requires several Node.js packages to function.${NC}"
echo ""
echo -e "${CYAN}Dependencies to install:${NC}"
echo "  • Core Node.js packages (package.json)"
echo "  • HoldStation SDK for Worldchain trading"
echo "  • Ethers.js v6 for blockchain interaction"
echo "  • WorldCoin MiniKit for wallet operations"
echo ""

if ask_yes_no "Install all dependencies automatically?" "y"; then
    echo -e "${BLUE}Installing Node.js packages...${NC}"
    echo -e "${YELLOW}This may take 3-5 minutes depending on your internet connection.${NC}"
    ask_continue
    
    npm install
    echo -e "${GREEN}✅ Core packages installed${NC}"
    
    echo -e "${BLUE}Installing HoldStation SDK...${NC}"
    npm install @holdstation/worldchain-sdk@latest
    npm install @holdstation/worldchain-ethers-v6@latest
    npm install @worldcoin/minikit-js@latest
    echo -e "${GREEN}✅ HoldStation SDK installed${NC}"
    
else
    echo -e "${YELLOW}⚠️  You'll need to install dependencies manually:${NC}"
    echo "  npm install"
    echo "  npm install @holdstation/worldchain-sdk@latest"
    echo "  npm install @holdstation/worldchain-ethers-v6@latest"
    echo "  npm install @worldcoin/minikit-js@latest"
fi

# Step 6: Configuration Setup
print_step "STEP 6: Configuration Setup"
echo -e "${BLUE}Now let's set up your ALGORITMIT configuration.${NC}"
echo ""

if [ -f ".env.example" ]; then
    echo -e "${CYAN}Found configuration template.${NC}"
    cp .env.example .env
    echo -e "${GREEN}✅ Configuration file created (.env)${NC}"
else
    echo -e "${YELLOW}⚠️  No configuration template found. Creating basic .env file...${NC}"
    cat > .env << 'EOF'
# ALGORITMIT Configuration
PRIVATE_KEY_1=your_private_key_here
WALLET_NAME_1=Main Trading Wallet

# RPC Configuration
WORLDCHAIN_RPC_URL=https://worldchain-mainnet.g.alchemy.com/public
ALCHEMY_API_KEY=your_alchemy_api_key_here

# Trading Configuration
WLD_TOKEN_ADDRESS=0x2cfc85d8e48f8eab294be644d9e25C3030863003
DEFAULT_SLIPPAGE=1.0
MAX_GAS_PRICE=50

# ALGORITMIT ML Settings
ML_CONFIDENCE_THRESHOLD=75
ML_MAX_POSITION_SIZE=0.1
ML_LEARNING_MODE=true
ML_AUTO_TRADING=false
EOF
    echo -e "${GREEN}✅ Basic configuration file created${NC}"
fi

echo ""
echo -e "${YELLOW}⚠️  IMPORTANT: You need to edit the .env file with your wallet details.${NC}"
if ask_yes_no "Open configuration file for editing now?" "y"; then
    if command -v nano >/dev/null 2>&1; then
        echo -e "${BLUE}Opening configuration in nano editor...${NC}"
        echo -e "${YELLOW}Edit your PRIVATE_KEY_1 and save with Ctrl+X${NC}"
        ask_continue
        nano .env
    elif command -v vim >/dev/null 2>&1; then
        echo -e "${BLUE}Opening configuration in vim editor...${NC}"
        echo -e "${YELLOW}Edit your PRIVATE_KEY_1 and save with :wq${NC}"
        ask_continue
        vim .env
    else
        echo -e "${YELLOW}No text editor found. Please edit .env manually later.${NC}"
    fi
else
    echo -e "${YELLOW}Remember to edit $INSTALL_DIR/.env before running ALGORITMIT${NC}"
fi

# Step 7: Create Helper Scripts
print_step "STEP 7: Create Helper Scripts"
echo -e "${BLUE}Let's create some helpful scripts to make using ALGORITMIT easier.${NC}"
echo ""

# Create startup script
cat > start-algoritmit.sh << 'EOF'
#!/bin/bash
echo "🤖 Starting ALGORITMIT Machine Learning Trading Bot..."
echo "📊 Version 3.0 - AI-Powered Trading for Worldchain"
echo ""
echo "⚠️  SAFETY REMINDER:"
echo "   • Start with Learning Mode for 24+ hours"
echo "   • Use tiny amounts (0.01 WLD) for testing"
echo "   • Never risk more than you can afford to lose"
echo ""
node worldchain-trading-bot.js
EOF
chmod +x start-algoritmit.sh
echo -e "${GREEN}✅ Created start-algoritmit.sh${NC}"

# Create update script
cat > update-algoritmit.sh << 'EOF'
#!/bin/bash
echo "🔄 Updating ALGORITMIT..."
if [ -d ".git" ]; then
    git pull origin main
    npm install
    echo "✅ Update complete!"
else
    echo "❌ Not a git repository. Please download manually."
fi
EOF
chmod +x update-algoritmit.sh
echo -e "${GREEN}✅ Created update-algoritmit.sh${NC}"

# Create backup script
cat > backup-config.sh << 'EOF'
#!/bin/bash
echo "💾 Creating configuration backup..."
BACKUP_DIR="$HOME/algoritmit-backups"
mkdir -p "$BACKUP_DIR"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
cp .env "$BACKUP_DIR/.env_backup_$TIMESTAMP"
echo "✅ Configuration backed up to $BACKUP_DIR/.env_backup_$TIMESTAMP"
EOF
chmod +x backup-config.sh
echo -e "${GREEN}✅ Created backup-config.sh${NC}"

# Step 8: Final Setup and Testing
print_step "STEP 8: Final Setup and Testing"
echo -e "${BLUE}Let's verify that everything is installed correctly.${NC}"
echo ""

echo -e "${CYAN}Installation Summary:${NC}"
echo "  📁 Location: $INSTALL_DIR"
echo "  🔧 Node.js: $(node --version 2>/dev/null || echo 'Not found')"
echo "  📦 NPM: $(npm --version 2>/dev/null || echo 'Not found')"
echo "  📋 Config: $([ -f .env ] && echo 'Created' || echo 'Missing')"
echo "  🚀 Scripts: Created startup and helper scripts"

echo ""
echo -e "${CYAN}Available scripts:${NC}"
echo "  ./start-algoritmit.sh     - Start the trading bot"
echo "  ./update-algoritmit.sh    - Update to latest version"
echo "  ./backup-config.sh        - Backup your configuration"

echo ""
if ask_yes_no "Test the installation by running a quick check?" "y"; then
    echo -e "${BLUE}Running installation test...${NC}"
    if node -e "console.log('✅ Node.js working'); process.exit(0)" 2>/dev/null; then
        echo -e "${GREEN}✅ Node.js test passed${NC}"
    else
        echo -e "${RED}❌ Node.js test failed${NC}"
    fi
    
    if [ -f "worldchain-trading-bot.js" ]; then
        echo -e "${GREEN}✅ Main bot file found${NC}"
    else
        echo -e "${RED}❌ Main bot file missing${NC}"
    fi
    
    if [ -f ".env" ]; then
        echo -e "${GREEN}✅ Configuration file found${NC}"
    else
        echo -e "${RED}❌ Configuration file missing${NC}"
    fi
    
    if npm list @holdstation/worldchain-sdk >/dev/null 2>&1; then
        echo -e "${GREEN}✅ HoldStation SDK installed${NC}"
    else
        echo -e "${YELLOW}⚠️  HoldStation SDK may not be installed${NC}"
    fi
fi

# Final instructions
print_step "🎉 INSTALLATION COMPLETE!"
echo -e "${GREEN}ALGORITMIT Machine Learning Trading Bot has been successfully installed!${NC}"
echo ""
echo -e "${CYAN}📍 Installation Location:${NC} $INSTALL_DIR"
echo ""
echo -e "${WHITE}🚀 NEXT STEPS:${NC}"
echo ""
echo -e "${YELLOW}1. Configure your wallet (if not done already):${NC}"
echo -e "   cd $INSTALL_DIR"
echo -e "   nano .env"
echo -e "   (Add your wallet private key)"
echo ""
echo -e "${YELLOW}2. Start ALGORITMIT:${NC}"
echo -e "   ./start-algoritmit.sh"
echo ""
echo -e "${YELLOW}3. CRITICAL - Enable Learning Mode FIRST:${NC}"
echo -e "   • Go to Menu Option 7 (🤖 ALGORITMIT)"
echo -e "   • Enable ALGORITMIT Strategy"
echo -e "   • Turn on Learning Mode"
echo -e "   • Let it learn for 24+ hours (DO NOT SKIP!)"
echo ""
echo -e "${YELLOW}4. After 24+ hours - Enable Trading:${NC}"
echo -e "   • Check ML Statistics (aim for 60%+ accuracy)"
echo -e "   • Enable Auto-Trading with 0.01 WLD maximum"
echo -e "   • Monitor performance closely"
echo ""
echo -e "${RED}⚠️  CRITICAL SAFETY REMINDERS:${NC}"
echo -e "${RED}   • ALWAYS start with Learning Mode for 24+ hours${NC}"
echo -e "${RED}   • Use tiny amounts (0.01 WLD) for initial testing${NC}"
echo -e "${RED}   • Never risk more than you can afford to lose${NC}"
echo -e "${RED}   • Monitor all trades closely${NC}"
echo ""
echo -e "${BLUE}📚 For help and documentation:${NC}"
echo -e "   • In-app tutorial: ALGORITMIT menu → option 8"
echo -e "   • Repository: https://github.com/romerodevv/psgho"
echo -e "   • Issues: https://github.com/romerodevv/psgho/issues"
echo ""
echo -e "${GREEN}🎯 Ready to revolutionize your trading with AI! Good luck!${NC}"
echo ""