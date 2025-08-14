#!/bin/bash

# Cocoliso Ultra-Fast Trading Bot - SUPER SIMPLE INSTALLER
# One-command installation with zero configuration needed

set -e

# Simple colors
G='\033[0;32m' # Green
R='\033[0;31m' # Red  
Y='\033[1;33m' # Yellow
B='\033[0;34m' # Blue
NC='\033[0m'   # No Color

# Simple print functions
ok() { echo -e "${G}✅ $1${NC}"; }
err() { echo -e "${R}❌ $1${NC}"; }
info() { echo -e "${B}ℹ️  $1${NC}"; }
warn() { echo -e "${Y}⚠️  $1${NC}"; }

# Clear and show simple header
clear
echo -e "${B}🚀 COCOLISO ULTRA-FAST TRADING BOT - SIMPLE INSTALLER${NC}"
echo "=================================================="
echo
info "This will install the Ultra-Fast Trading Bot automatically"
info "Installation time: ~5 minutes"
echo
read -p "Press Enter to start installation (or Ctrl+C to cancel)..."
echo

# Auto-detect installation directory
if [[ $EUID -eq 0 ]]; then
    # Running as root - find a suitable user
    info "Running as root, selecting target user..."
    
    # Try to find a suitable non-root user
    if id "ubuntu" &>/dev/null; then
        TARGET_USER="ubuntu"
    elif id "debian" &>/dev/null; then
        TARGET_USER="debian"
    elif id "centos" &>/dev/null; then
        TARGET_USER="centos"
    else
        # Find first non-system user (UID >= 1000)
        TARGET_USER=$(getent passwd | awk -F: '$3 >= 1000 && $3 < 65534 { print $1; exit }')
        
        if [ -z "$TARGET_USER" ]; then
            # No suitable user found, create one
            warn "No suitable user found, creating 'trader' user..."
            useradd -m -s /bin/bash trader 2>/dev/null || true
            TARGET_USER="trader"
        fi
    fi
    
    INSTALL_DIR="/home/$TARGET_USER/trading-bot"
    info "Installing for user: $TARGET_USER"
else
    # Running as regular user
    TARGET_USER=$(whoami)
    INSTALL_DIR="$HOME/trading-bot"
    info "Installing for current user: $TARGET_USER"
fi

# Check if command exists
has_cmd() { command -v "$1" >/dev/null 2>&1; }

# Step 1: Fix any package management issues first
info "Checking system package manager..."
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Fix common dpkg issues
    if ! dpkg --configure -a >/dev/null 2>&1; then
        warn "Fixing interrupted package installation..."
        sudo dpkg --configure -a >/dev/null 2>&1 || true
        sudo apt-get update --fix-missing >/dev/null 2>&1 || true
        sudo apt-get install -f >/dev/null 2>&1 || true
    fi
    ok "Package manager ready"
fi

# Step 2: Install Node.js if needed
info "Checking Node.js..."
if has_cmd node; then
    NODE_VER=$(node --version | cut -d'v' -f2 | cut -d'.' -f1)
    if [ "$NODE_VER" -ge 18 ]; then
        ok "Node.js $(node --version) ready"
    else
        warn "Node.js too old, installing latest..."
        NEED_NODE=true
    fi
else
    warn "Node.js not found, installing..."
    NEED_NODE=true
fi

if [ "$NEED_NODE" = true ]; then
    info "Installing Node.js 20..."
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Update package lists first
        sudo apt-get update >/dev/null 2>&1 || {
            warn "Package update failed, trying system repair..."
            sudo dpkg --configure -a >/dev/null 2>&1 || true
            sudo apt-get update --fix-missing >/dev/null 2>&1 || true
            sudo apt-get install -f >/dev/null 2>&1 || true
            sudo apt-get update >/dev/null 2>&1 || true
        }
        
        # Install Node.js with better error handling
        if ! curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - >/dev/null 2>&1; then
            warn "NodeSource setup failed, trying alternative method..."
            # Alternative: Install from Ubuntu repos (older version but works)
            sudo apt-get install -y nodejs npm >/dev/null 2>&1 || {
                err "Failed to install Node.js. Please install manually from https://nodejs.org/"
                exit 1
            }
        else
            sudo apt-get install -y nodejs >/dev/null 2>&1 || {
                warn "NodeSource install failed, trying Ubuntu repos..."
                sudo apt-get install -y nodejs npm >/dev/null 2>&1 || {
                    err "Failed to install Node.js. Please install manually from https://nodejs.org/"
                    exit 1
                }
            }
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        if has_cmd brew; then
            brew install node >/dev/null 2>&1
        else
            err "Please install Node.js from https://nodejs.org/"
            exit 1
        fi
    fi
    
    # Verify Node.js installation
    if has_cmd node && has_cmd npm; then
        ok "Node.js $(node --version) installed successfully"
    else
        err "Node.js installation verification failed"
        info "Please install Node.js manually from https://nodejs.org/ and run this script again"
        exit 1
    fi
fi

# Step 3: Create directory
info "Setting up directory..."
if [ -d "$INSTALL_DIR" ]; then
    warn "Removing old installation..."
    rm -rf "$INSTALL_DIR"
fi

mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

# Set ownership if root
if [[ $EUID -eq 0 ]]; then
    if id "$TARGET_USER" &>/dev/null; then
        chown -R "$TARGET_USER:$TARGET_USER" "$INSTALL_DIR" 2>/dev/null || {
            chown -R "$TARGET_USER" "$INSTALL_DIR" 2>/dev/null || true
        }
        chmod 600 "$INSTALL_DIR/.env" 2>/dev/null || true
        ok "File ownership set to $TARGET_USER"
    else
        warn "User $TARGET_USER not found, files owned by root"
        info "To fix ownership later: sudo chown -R username:username $INSTALL_DIR"
    fi
fi

ok "Directory ready: $INSTALL_DIR"

# Step 4: Download bot
info "Downloading trading bot..."
if has_cmd git; then
    git clone https://github.com/romerodevv/psgho.git . >/dev/null 2>&1
elif has_cmd curl; then
    curl -sL https://github.com/romerodevv/psgho/archive/main.zip -o bot.zip
    unzip -q bot.zip && mv psgho-main/* . && rm -rf psgho-main bot.zip
elif has_cmd wget; then
    wget -q https://github.com/romerodevv/psgho/archive/main.zip -O bot.zip
    unzip -q bot.zip && mv psgho-main/* . && rm -rf psgho-main bot.zip
else
    err "No download tool found. Install git, curl, or wget"
    exit 1
fi
ok "Bot downloaded"

# Step 5: Install packages
info "Installing packages (this may take 3-5 minutes)..."

# Function to run npm as correct user
run_npm() {
    if [[ $EUID -eq 0 ]]; then
        sudo -u "$TARGET_USER" npm "$@" >/dev/null 2>&1
    else
        npm "$@" >/dev/null 2>&1
    fi
}

run_npm install
run_npm install @holdstation/worldchain-sdk@latest
run_npm install @holdstation/worldchain-ethers-v6@latest  
run_npm install @worldcoin/minikit-js@latest

ok "All packages installed"

# Step 6: Create simple config
info "Creating configuration..."
cat > .env << 'EOF'
# SIMPLE CONFIGURATION - EDIT YOUR PRIVATE KEY BELOW

# Your wallet private key (REQUIRED)
PRIVATE_KEY=your_private_key_here

# RPC endpoints (pre-configured)
WORLDCHAIN_RPC_URL=https://worldchain-mainnet.g.alchemy.com/public
BACKUP_RPC_URL=https://worldchain-mainnet.g.alchemy.com/v2/demo

# Token address (pre-configured)
WLD_TOKEN_ADDRESS=0x2cfc85d8e48f8eab294be644d9e25c3030863003

# Performance settings (optimized)
DEFAULT_GAS_PRICE=0.002
PRIORITY_FEE=0.0005
MAX_SLIPPAGE=1
EOF

# Step 7: Create simple start script
cat > start.sh << 'EOF'
#!/bin/bash
echo "🚀 Starting Ultra-Fast Trading Bot..."
echo "💡 Press Ctrl+C to stop"
echo
node worldchain-trading-bot.js
EOF

chmod +x start.sh

# Step 8: Create simple setup script
cat > setup.sh << 'EOF'
#!/bin/bash
echo "🔧 Quick Setup"
echo "=============="
echo
echo "Enter your wallet private key:"
read -s PRIVATE_KEY
echo
sed -i "s/your_private_key_here/$PRIVATE_KEY/" .env
echo "✅ Configuration saved!"
echo "🚀 Run ./start.sh to begin trading"
EOF

chmod +x setup.sh

# Set proper ownership
if [[ $EUID -eq 0 ]]; then
    chown -R "$TARGET_USER:$TARGET_USER" "$INSTALL_DIR"
    chmod 600 "$INSTALL_DIR/.env"
fi

ok "Configuration ready"

# Installation complete
echo
echo -e "${G}🎉 INSTALLATION COMPLETE! 🎉${NC}"
echo "=========================="
echo

if [[ $EUID -eq 0 ]]; then
    info "Next steps (run as $TARGET_USER):"
    echo "  1. su - $TARGET_USER"
    echo "  2. cd $INSTALL_DIR"
    echo "  3. ./setup.sh"
    echo "  4. ./start.sh"
    echo
    info "Or run directly:"
    echo "  sudo -u $TARGET_USER bash -c 'cd $INSTALL_DIR && ./setup.sh'"
    echo "  sudo -u $TARGET_USER bash -c 'cd $INSTALL_DIR && ./start.sh'"
else
    info "Next steps:"
    echo "  1. cd $INSTALL_DIR"
    echo "  2. ./setup.sh  (enter your private key)"
    echo "  3. ./start.sh  (start trading)"
fi

echo
ok "Ultra-Fast Trading Bot ready!"
info "Features: <3 second trades, color-coded profits, flexible config"
echo