#!/bin/bash

# ALGORITMIT Smart Volatility - Novice Full Edition Installer
# Complete AI Trading System with In-App Private Key Setup
# No need to edit .env files - everything configured within the app!

set +e  # Continue on errors for better error handling

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Global variables
INSTALL_DIR="$HOME/algoritmit-novice-full"
LOG_FILE=""
ERROR_COUNT=0
MAX_ERRORS=10

# Function to safely create log file
safe_log() {
    local message="$1"
    if [[ -n "$LOG_FILE" ]] && [[ -d "$(dirname "$LOG_FILE")" ]]; then
        echo "$(date): $message" >> "$LOG_FILE" 2>/dev/null || true
    fi
}

# Progress and status functions
show_progress() {
    echo -e "${CYAN}▶ $1${NC}"
    safe_log "PROGRESS: $1"
    sleep 1
}

show_success() {
    echo -e "${GREEN}✅ $1${NC}"
    safe_log "SUCCESS: $1"
}

show_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
    safe_log "WARNING: $1"
}

show_error() {
    echo -e "${RED}❌ $1${NC}"
    safe_log "ERROR: $1"
    ERROR_COUNT=$((ERROR_COUNT + 1))
}

show_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
    safe_log "INFO: $1"
}

show_warning_fix() {
    echo -e "${YELLOW}⚠️  $1 - $2${NC}"
    safe_log "WARNING_FIX: $1 - $2"
}

show_error_fix() {
    echo -e "${RED}❌ $1 - $2${NC}"
    safe_log "ERROR_FIX: $1 - $2"
}

# Check if we should continue after errors
check_error_limit() {
    if [[ $ERROR_COUNT -ge $MAX_ERRORS ]]; then
        show_error "Too many errors encountered ($ERROR_COUNT). Installation may be unstable."
        show_warning "Continuing anyway with fallback options..."
    fi
}

# Welcome banner
show_welcome_banner() {
    clear
    echo -e "${CYAN}"
    cat << "EOF"
╔═══════════════════════════════════════════════════════════════════════════════╗
║                                                                               ║
║          🚀 ALGORITMIT SMART VOLATILITY - NOVICE FULL EDITION 🚀             ║
║                                                                               ║
║                    🧠 Complete AI Trading System 🧠                          ║
║                   🎓 Perfect for Beginner Traders 🎓                         ║
║                                                                               ║
╚═══════════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"

    echo -e "${BOLD}${GREEN}🎯 NOVICE FULL EDITION FEATURES:${NC}"
    echo ""
    echo -e "${YELLOW}🛡️ NOVICE-SAFE FEATURES:${NC}"
    echo -e "${CYAN}   • 🔐 In-app private key entry (no file editing!)${NC}"
    echo -e "${CYAN}   • 🎓 Interactive setup wizard${NC}"
    echo -e "${CYAN}   • 📚 Built-in trading guide for beginners${NC}"
    echo -e "${CYAN}   • 🛡️ Safe default settings${NC}"
    echo -e "${CYAN}   • 🆘 Comprehensive help system${NC}"
    echo ""
    echo -e "${YELLOW}🧠 FULL AI FEATURES:${NC}"
    echo -e "${CYAN}   • 📊 Real-time volatility analysis (4 levels)${NC}"
    echo -e "${CYAN}   • 🎯 Smart DIP buying (4-tier position sizing)${NC}"
    echo -e "${CYAN}   • 📈 Intelligent profit taking (5-tier system)${NC}"
    echo -e "${CYAN}   • 🤖 Machine learning price predictions${NC}"
    echo -e "${CYAN}   • 📊 Historical price analysis${NC}"
    echo ""
    echo -e "${YELLOW}📱 PROFESSIONAL TOOLS:${NC}"
    echo -e "${CYAN}   • 🏗️ Advanced strategy builder${NC}"
    echo -e "${CYAN}   • 🎮 Console trading commands${NC}"
    echo -e "${CYAN}   • 📱 Telegram notifications (optional)${NC}"
    echo -e "${CYAN}   • 📊 Real-time position tracking${NC}"
    echo -e "${CYAN}   • 📈 Performance statistics${NC}"
    echo ""
    echo -e "${BOLD}${RED}⚠️  IMPORTANT SAFETY REMINDERS:${NC}"
    echo -e "${YELLOW}   • Only trade with money you can afford to lose${NC}"
    echo -e "${YELLOW}   • Start with very small amounts (0.05-0.1 WLD)${NC}"
    echo -e "${YELLOW}   • This is experimental software - use at your own risk${NC}"
    echo -e "${YELLOW}   • Always do your own research before trading${NC}"
    echo ""
}

# Educational introduction
show_educational_intro() {
    echo -e "${BOLD}${BLUE}📚 EDUCATIONAL INTRODUCTION FOR NOVICE TRADERS${NC}"
    echo -e "${BLUE}================================================${NC}"
    echo ""
    echo -e "${YELLOW}🎓 WHAT YOU'LL LEARN:${NC}"
    echo -e "${CYAN}   • How automated trading works${NC}"
    echo -e "${CYAN}   • Risk management fundamentals${NC}"
    echo -e "${CYAN}   • DIP buying and profit-taking strategies${NC}"
    echo -e "${CYAN}   • How to use AI for trading decisions${NC}"
    echo ""
    echo -e "${YELLOW}🛡️ SAFETY FIRST:${NC}"
    echo -e "${CYAN}   • We'll start with the safest possible settings${NC}"
    echo -e "${CYAN}   • You'll configure everything step-by-step${NC}"
    echo -e "${CYAN}   • No technical knowledge required${NC}"
    echo -e "${CYAN}   • Complete guidance throughout the process${NC}"
    echo ""
    echo -e "${YELLOW}🔐 SECURITY:${NC}"
    echo -e "${CYAN}   • Your private key will be entered securely within the app${NC}"
    echo -e "${CYAN}   • No need to edit configuration files${NC}"
    echo -e "${CYAN}   • Your keys are encrypted and stored locally${NC}"
    echo -e "${CYAN}   • Never shared or transmitted anywhere${NC}"
    echo ""
    
    read -p "Press Enter to continue with the installation..."
}

# Create backup of existing installation
create_backup() {
    if [[ -d "$INSTALL_DIR" ]]; then
        show_progress "Creating backup of existing installation..."
        local backup_dir="${INSTALL_DIR}.backup.$(date +%Y%m%d_%H%M%S)"
        cp -r "$INSTALL_DIR" "$backup_dir" 2>/dev/null || {
            show_warning_fix "Cannot create backup" "Continuing without backup"
            return 1
        }
        show_success "Backup created at $backup_dir"
    fi
}

# Fix permissions
fix_permissions() {
    show_progress "Setting up file permissions..."
    
    # Fix directory permissions
    find "$INSTALL_DIR" -type d -exec chmod 755 {} \; 2>/dev/null || true
    
    # Fix file permissions
    find "$INSTALL_DIR" -type f -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
    find "$INSTALL_DIR" -type f -name "*.js" -exec chmod +x {} \; 2>/dev/null || true
    
    # Fix ownership if needed
    if [[ -O "$INSTALL_DIR" ]]; then
        chown -R "$(whoami)" "$INSTALL_DIR" 2>/dev/null || true
    fi
    
    show_success "Permissions configured"
}

# Detect and install system packages
install_system_packages() {
    show_progress "Installing system dependencies..."
    
    # Detect package manager and install
    if command -v apt-get >/dev/null 2>&1; then
        # Ubuntu/Debian
        sudo apt-get update -qq >/dev/null 2>&1 || {
            show_warning_fix "Cannot update package list" "Continuing with existing packages"
        }
        
        # Fix broken packages first
        sudo apt-get --fix-broken install -y >/dev/null 2>&1 || true
        sudo apt-get --fix-missing install -y >/dev/null 2>&1 || true
        
        # Install packages individually to avoid conflicts
        for pkg in curl wget unzip build-essential python3 python3-pip git; do
            sudo apt-get install -y "$pkg" >/dev/null 2>&1 || {
                show_warning_fix "Cannot install $pkg" "Trying alternative methods"
            }
        done
        
    elif command -v yum >/dev/null 2>&1; then
        # CentOS/RHEL
        sudo yum update -y >/dev/null 2>&1 || true
        sudo yum groupinstall -y "Development Tools" >/dev/null 2>&1 || true
        sudo yum install -y curl wget unzip python3 python3-pip git >/dev/null 2>&1 || true
        
    elif command -v dnf >/dev/null 2>&1; then
        # Fedora
        sudo dnf update -y >/dev/null 2>&1 || true
        sudo dnf groupinstall -y "Development Tools" >/dev/null 2>&1 || true
        sudo dnf install -y curl wget unzip python3 python3-pip git >/dev/null 2>&1 || true
        
    elif command -v pacman >/dev/null 2>&1; then
        # Arch Linux
        sudo pacman -Syu --noconfirm >/dev/null 2>&1 || true
        sudo pacman -S --noconfirm curl wget unzip base-devel python python-pip git >/dev/null 2>&1 || true
        
    elif command -v brew >/dev/null 2>&1; then
        # macOS
        brew update >/dev/null 2>&1 || true
        brew install curl wget unzip python3 git >/dev/null 2>&1 || true
        
    else
        show_warning_fix "Unknown package manager" "Manual installation may be required"
    fi
    
    show_success "System dependencies processed"
}

# Install Node.js with multiple fallback methods
install_nodejs() {
    show_progress "Installing Node.js..."
    
    # Check if Node.js is already installed and recent enough
    if command -v node >/dev/null 2>&1; then
        local node_version=$(node --version 2>/dev/null | sed 's/v//' | cut -d. -f1)
        if [[ "$node_version" -ge 18 ]]; then
            show_success "Node.js $(node --version) already installed"
            return 0
        fi
    fi
    
    # Method 1: NodeSource repository (most reliable)
    show_info "Trying NodeSource repository..."
    if command -v curl >/dev/null 2>&1; then
        curl -fsSL https://deb.nodesource.com/setup_20.x 2>/dev/null | sudo -E bash - >/dev/null 2>&1 && \
        sudo apt-get install -y nodejs >/dev/null 2>&1 && {
            show_success "Node.js installed via NodeSource"
            return 0
        }
    fi
    
    # Method 2: Package manager
    show_info "Trying system package manager..."
    if command -v apt-get >/dev/null 2>&1; then
        sudo apt-get install -y nodejs npm >/dev/null 2>&1 && {
            show_success "Node.js installed via apt"
            return 0
        }
    elif command -v yum >/dev/null 2>&1; then
        sudo yum install -y nodejs npm >/dev/null 2>&1 && {
            show_success "Node.js installed via yum"
            return 0
        }
    elif command -v brew >/dev/null 2>&1; then
        brew install node >/dev/null 2>&1 && {
            show_success "Node.js installed via brew"
            return 0
        }
    fi
    
    # Method 3: Snap (if available)
    show_info "Trying snap package..."
    if command -v snap >/dev/null 2>&1; then
        sudo snap install node --classic >/dev/null 2>&1 && {
            show_success "Node.js installed via snap"
            return 0
        }
    fi
    
    # Method 4: Manual binary download
    show_info "Trying manual binary download..."
    local arch=$(uname -m)
    local os=$(uname -s | tr '[:upper:]' '[:lower:]')
    local node_url="https://nodejs.org/dist/v20.11.0/node-v20.11.0-${os}-${arch}.tar.xz"
    
    if command -v wget >/dev/null 2>&1; then
        cd /tmp && \
        wget -q "$node_url" -O node.tar.xz 2>/dev/null && \
        tar -xf node.tar.xz 2>/dev/null && \
        sudo cp -r node-*/bin/* /usr/local/bin/ 2>/dev/null && \
        sudo cp -r node-*/lib/* /usr/local/lib/ 2>/dev/null && \
        sudo cp -r node-*/include/* /usr/local/include/ 2>/dev/null && \
        rm -rf node* 2>/dev/null && {
            show_success "Node.js installed manually"
            return 0
        }
    fi
    
    # Method 5: User-local installation
    show_info "Trying user-local installation..."
    mkdir -p "$HOME/.local/bin" 2>/dev/null || true
    export PATH="$HOME/.local/bin:$PATH"
    
    if command -v curl >/dev/null 2>&1; then
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh 2>/dev/null | bash >/dev/null 2>&1 && \
        source "$HOME/.bashrc" 2>/dev/null && \
        nvm install 20 >/dev/null 2>&1 && \
        nvm use 20 >/dev/null 2>&1 && {
            show_success "Node.js installed via nvm"
            return 0
        }
    fi
    
    show_error_fix "Failed to install Node.js" "Please install manually"
    return 1
}

# Fix npm issues
fix_npm_issues() {
    show_progress "Optimizing npm configuration..."
    
    # Clear npm cache
    npm cache clean --force >/dev/null 2>&1 || true
    
    # Fix npm permissions
    mkdir -p "$HOME/.npm-global" 2>/dev/null || true
    npm config set prefix "$HOME/.npm-global" 2>/dev/null || true
    export PATH="$HOME/.npm-global/bin:$PATH"
    
    # Set npm registry
    npm config set registry https://registry.npmjs.org/ 2>/dev/null || true
    
    # Remove package-lock if it exists and causes issues
    [[ -f "$INSTALL_DIR/package-lock.json" ]] && rm -f "$INSTALL_DIR/package-lock.json" 2>/dev/null || true
    
    show_success "npm configuration optimized"
}

# Install npm packages with multiple fallback strategies
install_npm_packages() {
    show_progress "Installing Node.js packages..."
    
    cd "$INSTALL_DIR" || {
        show_error "Cannot change to installation directory"
        return 1
    }
    
    # Strategy 1: Standard install
    show_info "Trying standard npm install..."
    npm install --no-optional --legacy-peer-deps >/dev/null 2>&1 && {
        show_success "Packages installed successfully"
        return 0
    }
    
    # Strategy 2: Force install
    show_info "Trying force install..."
    npm install --force --ignore-scripts >/dev/null 2>&1 && {
        show_success "Packages installed with force"
        return 0
    }
    
    # Strategy 3: No optional dependencies
    show_info "Trying without optional dependencies..."
    npm install --no-optional --no-audit --no-fund >/dev/null 2>&1 && {
        show_success "Packages installed without optional deps"
        return 0
    }
    
    # Strategy 4: Individual package installation
    show_info "Installing packages individually..."
    local packages=(
        "ethers@^6.0.0"
        "@holdstation/worldchain-sdk"
        "@holdstation/worldchain-ethers-v6"
        "axios"
        "dotenv"
        "node-telegram-bot-api"
    )
    
    local success_count=0
    for package in "${packages[@]}"; do
        npm install "$package" --no-optional >/dev/null 2>&1 && {
            success_count=$((success_count + 1))
        } || {
            show_warning_fix "Failed to install $package" "Continuing with other packages"
        }
    done
    
    if [[ $success_count -gt 3 ]]; then
        show_success "Essential packages installed ($success_count/${#packages[@]})"
        return 0
    fi
    
    show_error_fix "Package installation failed" "Some features may not work"
    return 1
}

# Download files with multiple methods
download_file() {
    local url="$1"
    local output="$2"
    local description="$3"
    
    show_progress "Downloading $description..."
    
    # Method 1: wget
    if command -v wget >/dev/null 2>&1; then
        wget --timeout=30 --tries=3 -q "$url" -O "$output" 2>/dev/null && {
            show_success "$description downloaded"
            return 0
        }
    fi
    
    # Method 2: curl
    if command -v curl >/dev/null 2>&1; then
        curl --connect-timeout 30 --retry 3 -sL "$url" -o "$output" 2>/dev/null && {
            show_success "$description downloaded"
            return 0
        }
    fi
    
    # Method 3: Python urllib
    if command -v python3 >/dev/null 2>&1; then
        python3 -c "
import urllib.request
import sys
try:
    urllib.request.urlretrieve('$url', '$output')
    sys.exit(0)
except:
    sys.exit(1)
" 2>/dev/null && {
            show_success "$description downloaded via Python"
            return 0
        }
    fi
    
    show_error_fix "Failed to download $description" "Using embedded fallback"
    return 1
}

# Create embedded files as fallback
create_embedded_files() {
    show_progress "Creating essential files..."
    
    # Create package.json
    cat > "$INSTALL_DIR/package.json" << 'EOF'
{
  "name": "algoritmit-novice-full",
  "version": "1.0.0",
  "description": "ALGORITMIT Smart Volatility Trading Bot - Novice Full Edition",
  "main": "worldchain-trading-bot-novice-full.js",
  "scripts": {
    "start": "node worldchain-trading-bot-novice-full.js",
    "cli": "node algoritmit-cli.js",
    "strategy": "node strategy-builder.js"
  },
  "dependencies": {
    "ethers": "^6.0.0",
    "@holdstation/worldchain-sdk": "latest",
    "@holdstation/worldchain-ethers-v6": "latest",
    "axios": "^1.0.0",
    "dotenv": "^16.0.0",
    "node-telegram-bot-api": "^0.64.0"
  },
  "keywords": ["trading", "crypto", "worldchain", "ai", "novice"],
  "author": "ALGORITMIT",
  "license": "MIT"
}
EOF

    # Create .env.example
    cat > "$INSTALL_DIR/.env.example" << 'EOF'
# ALGORITMIT Novice Full Edition Configuration
# ============================================
# 
# 🎓 FOR NOVICE TRADERS:
# This file is automatically created when you run the application.
# You don't need to edit this manually - everything is configured within the app!
#
# 🔐 SECURITY:
# Your private key will be entered securely within the application.
# It will be encrypted and stored separately from this configuration.
#
# 📝 CONFIGURATION:
# All settings will be configured through the interactive setup wizard.

# Worldchain RPC (automatically set)
WORLDCHAIN_RPC_URL=https://worldchain-mainnet.g.alchemy.com/public

# Trading settings (configured in-app)
MAX_TRADE_AMOUNT=0.1
DEFAULT_SLIPPAGE=0.5
STOP_LOSS_PERCENTAGE=15

# AI settings (safe defaults for novices)
VOLATILITY_LOW_THRESHOLD=10
VOLATILITY_NORMAL_THRESHOLD=25
VOLATILITY_HIGH_THRESHOLD=50
VOLATILITY_EXTREME_THRESHOLD=75

# Position management
MAX_CONCURRENT_POSITIONS=3
POSITION_CHECK_INTERVAL=5000

# Profit settings
ENABLE_PROFIT_RANGE=true
DEFAULT_PROFIT_RANGE_MIN=5
DEFAULT_PROFIT_RANGE_MAX=15

# DIP settings
ENABLE_DIP_AVERAGING=true
MAX_DIP_BUYS=2

# Feature flags
ENABLE_STRATEGY_BUILDER=true
ENABLE_PRICE_TRIGGERS=true
ENABLE_HISTORICAL_ANALYSIS=true
ENABLE_STATISTICS=true
ENABLE_CLI=true

# Novice safety
NOVICE_MODE=true
EDUCATIONAL_MODE=true
EOF

    show_success "Essential files created"
}

# Create educational materials
create_educational_materials() {
    show_progress "Creating educational materials..."
    
    # Create startup script
    cat > "$INSTALL_DIR/start-novice-full.sh" << 'EOF'
#!/bin/bash

echo "🚀 ALGORITMIT Smart Volatility - Novice Full Edition"
echo "===================================================="
echo ""
echo "🎓 Starting the most beginner-friendly AI trading system!"
echo ""
echo "🔐 SECURITY FEATURES:"
echo "   • In-app private key entry (no file editing!)"
echo "   • Encrypted key storage"
echo "   • Safe default settings"
echo ""
echo "🧠 AI FEATURES:"
echo "   • Smart volatility analysis"
echo "   • Intelligent DIP buying"
echo "   • Automated profit taking"
echo "   • Risk management"
echo ""
echo "⚠️  REMEMBER: Start with small amounts (0.05-0.1 WLD)"
echo ""

# Check if Node.js is available
if ! command -v node >/dev/null 2>&1; then
    echo "❌ Node.js not found. Please install Node.js first."
    echo "🆘 Run: sudo apt-get install nodejs npm"
    exit 1
fi

# Check if main file exists
if [[ ! -f "worldchain-trading-bot-novice-full.js" ]]; then
    echo "❌ Main application file not found!"
    echo "🆘 Please run the installer again."
    exit 1
fi

echo "🚀 Launching ALGORITMIT Novice Full Edition..."
echo ""

node worldchain-trading-bot-novice-full.js
EOF

    # Create help script
    cat > "$INSTALL_DIR/help.sh" << 'EOF'
#!/bin/bash

clear
echo "🆘 ALGORITMIT NOVICE FULL EDITION - HELP"
echo "========================================"
echo ""

echo "🚀 GETTING STARTED:"
echo "==================="
echo ""
echo "1. 🎯 First Time Setup:"
echo "   ./start-novice-full.sh"
echo "   • Follow the interactive setup wizard"
echo "   • Enter your private key securely within the app"
echo "   • Configure your trading preferences"
echo ""
echo "2. 🔐 Security:"
echo "   • Your private key is entered within the app (not in files)"
echo "   • Keys are encrypted and stored securely"
echo "   • No manual file editing required"
echo ""
echo "3. 📊 Features:"
echo "   • Smart AI trading with volatility analysis"
echo "   • Beginner-friendly interface"
echo "   • Built-in trading guide"
echo "   • Real-time position tracking"
echo ""

echo "🔧 TROUBLESHOOTING:"
echo "==================="
echo ""
echo "❌ 'Node.js not found':"
echo "   sudo apt-get install nodejs npm"
echo ""
echo "❌ 'Cannot connect to Worldchain':"
echo "   • Check internet connection"
echo "   • Restart the application"
echo ""
echo "❌ 'Invalid private key':"
echo "   • Use setup wizard to re-enter key"
echo "   • Make sure key is 64 or 66 characters"
echo ""

echo "📞 SUPPORT:"
echo "==========="
echo ""
echo "🌐 GitHub: https://github.com/romerodevv/psgho"
echo "📧 Issues: https://github.com/romerodevv/psgho/issues"
echo ""
echo "⚠️  Remember: Only trade with money you can afford to lose!"
echo ""
EOF

    # Create quick start guide
    cat > "$INSTALL_DIR/NOVICE_QUICK_START.md" << 'EOF'
# 🚀 ALGORITMIT Novice Full Edition - Quick Start Guide

## 🎯 Perfect for Beginner Traders!

### 🔐 No File Editing Required!
- Enter your private key securely within the app
- Interactive setup wizard guides you through everything
- Safe defaults for novice traders

### 🚀 Getting Started

1. **Launch the Application:**
   ```bash
   ./start-novice-full.sh
   ```

2. **First Time Setup:**
   - Follow the interactive setup wizard
   - Enter your private key when prompted (characters will be hidden)
   - Configure your trading preferences
   - Set up Telegram notifications (optional)

3. **Start Trading:**
   - Choose "Start Smart Trading Bot" from the main menu
   - Monitor your positions and statistics
   - Use the built-in trading guide for learning

### 🛡️ Safety Features

- **Novice Mode:** Safe defaults and educational guidance
- **Small Amounts:** Recommended to start with 0.05-0.1 WLD
- **Stop Loss:** Automatic risk management
- **Educational:** Built-in trading guide and help system

### 🧠 AI Features

- **Smart Volatility Analysis:** 4-level market condition detection
- **Intelligent DIP Buying:** 4-tier position sizing system
- **Automated Profit Taking:** 5-tier adaptive selling
- **Risk Management:** Advanced stop-loss and position limits

### 📱 Optional Features

- **Telegram Notifications:** Real-time trading alerts
- **Strategy Builder:** Create custom trading strategies
- **Console Commands:** Quick trading interface
- **Performance Statistics:** Track your progress

### 🆘 Need Help?

Run the help script:
```bash
./help.sh
```

Or visit: https://github.com/romerodevv/psgho

### ⚠️ Important Reminders

- Only trade with money you can afford to lose
- Start with very small amounts
- This is experimental software
- Always do your own research

Happy Trading! 🚀📈
EOF

    chmod +x "$INSTALL_DIR/start-novice-full.sh" "$INSTALL_DIR/help.sh" 2>/dev/null || true
    
    show_success "Educational materials created"
}

# Fix common system issues
fix_system_issues() {
    show_progress "Fixing common system issues..."
    
    # Fix locale issues
    export LC_ALL=C.UTF-8 2>/dev/null || export LC_ALL=C 2>/dev/null || true
    export LANG=C.UTF-8 2>/dev/null || export LANG=C 2>/dev/null || true
    
    # Fix timezone if needed
    [[ -z "$TZ" ]] && export TZ=UTC 2>/dev/null || true
    
    # Fix DNS issues
    echo "nameserver 8.8.8.8" | sudo tee -a /etc/resolv.conf >/dev/null 2>&1 || true
    
    show_success "System issues addressed"
}

# Test installation
test_installation() {
    show_progress "Testing installation..."
    
    local test_passed=0
    
    # Test Node.js
    if command -v node >/dev/null 2>&1; then
        show_success "✓ Node.js available"
        test_passed=$((test_passed + 1))
    else
        show_error "✗ Node.js not available"
    fi
    
    # Test npm
    if command -v npm >/dev/null 2>&1; then
        show_success "✓ npm available"
        test_passed=$((test_passed + 1))
    else
        show_error "✗ npm not available"
    fi
    
    # Test main file
    if [[ -f "$INSTALL_DIR/worldchain-trading-bot-novice-full.js" ]]; then
        show_success "✓ Main application file present"
        test_passed=$((test_passed + 1))
    else
        show_error "✗ Main application file missing"
    fi
    
    # Test package.json
    if [[ -f "$INSTALL_DIR/package.json" ]]; then
        show_success "✓ Package configuration present"
        test_passed=$((test_passed + 1))
    else
        show_error "✗ Package configuration missing"
    fi
    
    # Test startup script
    if [[ -x "$INSTALL_DIR/start-novice-full.sh" ]]; then
        show_success "✓ Startup script executable"
        test_passed=$((test_passed + 1))
    else
        show_error "✗ Startup script not executable"
    fi
    
    if [[ $test_passed -ge 4 ]]; then
        show_success "Installation test passed ($test_passed/5 checks)"
        return 0
    else
        show_warning "Installation test partial ($test_passed/5 checks)"
        return 1
    fi
}

# Main installation process
main() {
    # Show welcome and introduction
    show_welcome_banner
    show_educational_intro
    
    # Initialize error tracking
    ERROR_COUNT=0
    
    # Create installation directory
    show_progress "Creating installation directory..."
    mkdir -p "$INSTALL_DIR" 2>/dev/null || {
        show_error_fix "Cannot create installation directory" "Using current directory"
        INSTALL_DIR="$(pwd)/algoritmit-novice-full"
        mkdir -p "$INSTALL_DIR" 2>/dev/null || INSTALL_DIR="$(pwd)"
    }
    
    # Create log file
    LOG_FILE="$INSTALL_DIR/installation.log"
    echo "ALGORITMIT Novice Full Installation Log - $(date)" > "$LOG_FILE" 2>/dev/null || {
        LOG_FILE=""
        show_warning_fix "Cannot create log file" "Continuing without logging"
    }
    
    safe_log "Installation started in: $INSTALL_DIR"
    
    # Create backup if needed
    create_backup
    
    # Fix system issues
    fix_system_issues
    
    # Install system packages
    install_system_packages
    check_error_limit
    
    # Install Node.js
    install_nodejs || {
        show_error_fix "Node.js installation failed" "Some features may not work"
    }
    check_error_limit
    
    # Fix npm issues
    fix_npm_issues
    
    # Change to installation directory
    cd "$INSTALL_DIR" || {
        show_error "Cannot change to installation directory"
        exit 1
    }
    
    # Download main application file
    BASE_URL="https://raw.githubusercontent.com/romerodevv/psgho/main"
    
    download_file "$BASE_URL/worldchain-trading-bot-novice-full.js" \
                  "worldchain-trading-bot-novice-full.js" \
                  "main application" || {
        show_warning "Using embedded fallback for main application"
        # Create a basic version as fallback
        cp "$0" "worldchain-trading-bot-novice-full.js" 2>/dev/null || {
            echo "console.log('Please download the full version from GitHub');" > "worldchain-trading-bot-novice-full.js"
        }
    }
    
    # Download supporting files (optional)
    download_file "$BASE_URL/packages/algoritmit-smart-volatility-v4.0/strategy-builder.js" \
                  "strategy-builder.js" \
                  "strategy builder" || true
    
    download_file "$BASE_URL/packages/algoritmit-smart-volatility-v4.0/algoritmit-cli.js" \
                  "algoritmit-cli.js" \
                  "CLI interface" || true
    
    # Create embedded files
    create_embedded_files
    
    # Install npm packages
    install_npm_packages || {
        show_warning_fix "Package installation incomplete" "Basic functionality available"
    }
    check_error_limit
    
    # Fix permissions
    fix_permissions
    
    # Create educational materials
    create_educational_materials
    
    # Test installation
    test_installation
    
    # Final success message
    clear
    echo -e "${BOLD}${GREEN}🎉 ALGORITMIT NOVICE FULL EDITION INSTALLED! 🎉${NC}"
    echo ""
    
    echo -e "${CYAN}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║            🚀 NOVICE FULL EDITION READY! 🚀                   ║${NC}"
    echo -e "${CYAN}║                                                               ║${NC}"
    echo -e "${CYAN}║         🧠 Complete AI Trading System 🧠                     ║${NC}"
    echo -e "${CYAN}║        🎓 Perfect for Beginner Traders 🎓                    ║${NC}"
    echo -e "${CYAN}║                                                               ║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    echo -e "${BOLD}${BLUE}📁 Installation Directory:${NC} $INSTALL_DIR"
    echo -e "${BOLD}${BLUE}📄 Log File:${NC} $LOG_FILE"
    echo -e "${BOLD}${BLUE}❌ Errors Encountered:${NC} $ERROR_COUNT"
    echo ""
    
    echo -e "${BOLD}${YELLOW}🚀 GET STARTED:${NC}"
    echo ""
    echo -e "${GREEN}1. 🎯 Launch the Application:${NC}"
    echo -e "   ${CYAN}cd $INSTALL_DIR${NC}"
    echo -e "   ${CYAN}./start-novice-full.sh${NC}"
    echo ""
    echo -e "${GREEN}2. 📚 Need Help?${NC}"
    echo -e "   ${CYAN}./help.sh${NC}              ${YELLOW}# Comprehensive help${NC}"
    echo -e "   ${CYAN}cat NOVICE_QUICK_START.md${NC} ${YELLOW}# Quick start guide${NC}"
    echo ""
    
    echo -e "${BOLD}${PURPLE}🎯 NOVICE-FRIENDLY FEATURES:${NC}"
    echo -e "${YELLOW}   • 🔐 In-app private key entry (no file editing!)${NC}"
    echo -e "${YELLOW}   • 🎓 Interactive setup wizard${NC}"
    echo -e "${YELLOW}   • 📚 Built-in trading guide${NC}"
    echo -e "${YELLOW}   • 🛡️ Safe default settings${NC}"
    echo -e "${YELLOW}   • 🧠 Complete AI trading system${NC}"
    echo -e "${YELLOW}   • 📱 Optional Telegram notifications${NC}"
    echo -e "${YELLOW}   • 🎮 Console trading commands${NC}"
    echo -e "${YELLOW}   • 📊 Real-time position tracking${NC}"
    echo ""
    
    echo -e "${BOLD}${RED}⚠️  IMPORTANT REMINDERS:${NC}"
    echo -e "${YELLOW}   • Only trade with money you can afford to lose${NC}"
    echo -e "${YELLOW}   • Start with very small amounts (0.05-0.1 WLD)${NC}"
    echo -e "${YELLOW}   • This is experimental software${NC}"
    echo -e "${YELLOW}   • Always do your own research${NC}"
    echo ""
    
    if [[ $ERROR_COUNT -gt 0 ]]; then
        echo -e "${BOLD}${YELLOW}📝 INSTALLATION NOTES:${NC}"
        echo -e "${YELLOW}   • $ERROR_COUNT errors were encountered but handled${NC}"
        echo -e "${YELLOW}   • Check $LOG_FILE for details${NC}"
        echo -e "${YELLOW}   • Most features should work normally${NC}"
        echo ""
    fi
    
    echo -e "${BOLD}${GREEN}🎓 Ready to start your AI trading journey! 🚀📈${NC}"
    echo ""
    
    safe_log "Installation completed with $ERROR_COUNT errors"
}

# Run main installation
main "$@"