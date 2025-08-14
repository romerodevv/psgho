#!/bin/bash

# ALGORITMIT Trading Bot - Automated Installer
# Machine Learning Powered Trading for Worldchain

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
GRAY='\033[0;37m'
NC='\033[0m' # No Color

# ASCII Art Banner
print_banner() {
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════════════════════════════════╗"
    echo "║                                                                                      ║"
    echo "║     █████╗ ██╗      ██████╗  ██████╗ ██████╗ ██╗████████╗███╗   ███╗██╗████████╗   ║"
    echo "║    ██╔══██╗██║     ██╔════╝ ██╔═══██╗██╔══██╗██║╚══██╔══╝████╗ ████║██║╚══██╔══╝   ║"
    echo "║    ███████║██║     ██║  ███╗██║   ██║██████╔╝██║   ██║   ██╔████╔██║██║   ██║      ║"
    echo "║    ██╔══██║██║     ██║   ██║██║   ██║██╔══██╗██║   ██║   ██║╚██╔╝██║██║   ██║      ║"
    echo "║    ██║  ██║███████╗╚██████╔╝╚██████╔╝██║  ██║██║   ██║   ██║ ╚═╝ ██║██║   ██║      ║"
    echo "║    ╚═╝  ╚═╝╚══════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝   ╚═╝   ╚═╝     ╚═╝╚═╝   ╚═╝      ║"
    echo "║                                                                                      ║"
    echo "║                    🤖 Machine Learning Trading Bot for Worldchain                   ║"
    echo "║                              Version 3.0 - ALGORITMIT Edition                       ║"
    echo "╚══════════════════════════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Progress indicator
show_progress() {
    local current=$1
    local total=$2
    local message=$3
    local percent=$((current * 100 / total))
    local bar_length=50
    local filled_length=$((percent * bar_length / 100))
    
    printf "\r${CYAN}["
    printf "%*s" $filled_length | tr ' ' '█'
    printf "%*s" $((bar_length - filled_length)) | tr ' ' '░'
    printf "] %d%% - %s${NC}" $percent "$message"
    
    if [ $current -eq $total ]; then
        echo ""
    fi
}

# Logging function
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING: $1${NC}"
}

log_error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $1${NC}"
}

# Check if running as root
check_root() {
    if [[ $EUID -eq 0 ]]; then
        log_warning "Running as root detected"
        echo -e "${YELLOW}It's recommended to run this as a regular user for security.${NC}"
        echo -e "${YELLOW}Continue anyway? (y/N)${NC}"
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            echo -e "${RED}Installation cancelled.${NC}"
            exit 1
        fi
    fi
}

# System requirements check
check_requirements() {
    log "Checking system requirements..."
    
    # Check OS
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
        DISTRO=$(lsb_release -si 2>/dev/null || echo "Unknown")
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        DISTRO="macOS"
    else
        log_error "Unsupported operating system: $OSTYPE"
        exit 1
    fi
    
    log "Operating System: $DISTRO"
    
    # Check RAM (minimum 4GB recommended)
    if command -v free >/dev/null 2>&1; then
        RAM_GB=$(free -g | awk '/^Mem:/{print $2}')
        if [ "$RAM_GB" -lt 4 ]; then
            log_warning "Low RAM detected: ${RAM_GB}GB. 4GB+ recommended for ML processing."
        else
            log "RAM: ${RAM_GB}GB ✓"
        fi
    fi
    
    # Check disk space (minimum 2GB)
    DISK_SPACE=$(df . | tail -1 | awk '{print $4}')
    DISK_GB=$((DISK_SPACE / 1024 / 1024))
    if [ "$DISK_GB" -lt 2 ]; then
        log_error "Insufficient disk space: ${DISK_GB}GB. 2GB+ required."
        exit 1
    else
        log "Disk Space: ${DISK_GB}GB ✓"
    fi
}

# Install Node.js
install_nodejs() {
    log "Installing Node.js..."
    show_progress 1 8 "Checking Node.js installation"
    
    if command -v node >/dev/null 2>&1; then
        NODE_VERSION=$(node --version | cut -d'v' -f2 | cut -d'.' -f1)
        if [ "$NODE_VERSION" -ge 18 ]; then
            log "Node.js $(node --version) already installed ✓"
            return
        else
            log_warning "Node.js version $NODE_VERSION is too old. Installing Node.js 20..."
        fi
    fi
    
    show_progress 2 8 "Installing Node.js 20"
    
    if [[ "$OS" == "linux" ]]; then
        # Install Node.js 20 on Linux
        curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - >/dev/null 2>&1
        sudo apt-get install -y nodejs >/dev/null 2>&1
    elif [[ "$OS" == "macos" ]]; then
        # Install Node.js 20 on macOS
        if command -v brew >/dev/null 2>&1; then
            brew install node >/dev/null 2>&1
        else
            log_error "Homebrew not found. Please install Node.js 20+ manually."
            exit 1
        fi
    fi
    
    # Verify installation
    if command -v node >/dev/null 2>&1; then
        log "Node.js $(node --version) installed successfully ✓"
    else
        log_error "Node.js installation failed"
        exit 1
    fi
}

# Install Git if needed
install_git() {
    show_progress 3 8 "Checking Git installation"
    
    if ! command -v git >/dev/null 2>&1; then
        log "Installing Git..."
        if [[ "$OS" == "linux" ]]; then
            sudo apt-get update >/dev/null 2>&1
            sudo apt-get install -y git >/dev/null 2>&1
        elif [[ "$OS" == "macos" ]]; then
            if command -v brew >/dev/null 2>&1; then
                brew install git >/dev/null 2>&1
            else
                log_error "Please install Git manually"
                exit 1
            fi
        fi
    fi
    
    log "Git $(git --version | cut -d' ' -f3) ✓"
}

# Clone repository
clone_repository() {
    show_progress 4 8 "Cloning ALGORITMIT repository"
    
    INSTALL_DIR="$HOME/worldchain-algoritmit-bot"
    
    if [ -d "$INSTALL_DIR" ]; then
        log_warning "Directory $INSTALL_DIR already exists"
        echo -e "${YELLOW}Remove existing directory and reinstall? (y/N)${NC}"
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            rm -rf "$INSTALL_DIR"
        else
            log "Using existing directory"
            cd "$INSTALL_DIR"
            git pull >/dev/null 2>&1 || log_warning "Failed to update repository"
            return
        fi
    fi
    
    # Clone the repository (replace with actual GitHub URL)
    git clone https://github.com/your-username/worldchain-algoritmit-bot.git "$INSTALL_DIR" >/dev/null 2>&1
    
    if [ ! -d "$INSTALL_DIR" ]; then
        log_error "Failed to clone repository"
        exit 1
    fi
    
    cd "$INSTALL_DIR"
    log "Repository cloned to $INSTALL_DIR ✓"
}

# Install Node.js dependencies
install_dependencies() {
    show_progress 5 8 "Installing Node.js dependencies"
    
    log "Installing npm packages..."
    npm install >/dev/null 2>&1
    
    if [ $? -ne 0 ]; then
        log_error "Failed to install npm dependencies"
        exit 1
    fi
    
    log "Node.js dependencies installed ✓"
}

# Install HoldStation SDK
install_holdstation_sdk() {
    show_progress 6 8 "Installing HoldStation SDK for Worldchain"
    
    log "Installing HoldStation SDK components..."
    
    # Make install script executable
    chmod +x install-holdstation-sdk.sh
    
    # Run HoldStation SDK installer
    ./install-holdstation-sdk.sh >/dev/null 2>&1
    
    if [ $? -ne 0 ]; then
        log_warning "HoldStation SDK installation had issues, but continuing..."
        # Try manual installation
        npm install @holdstation/worldchain-sdk@latest >/dev/null 2>&1
        npm install @holdstation/worldchain-ethers-v6@latest >/dev/null 2>&1
        npm install @worldcoin/minikit-js@latest >/dev/null 2>&1
    fi
    
    log "HoldStation SDK components installed ✓"
}

# Setup configuration
setup_configuration() {
    show_progress 7 8 "Setting up configuration"
    
    if [ ! -f ".env" ]; then
        cp .env.example .env
        log "Configuration template created: .env"
    else
        log "Configuration file already exists: .env"
    fi
    
    # Create data directories
    mkdir -p logs data backups
    
    log "Configuration setup completed ✓"
}

# Final setup and instructions
final_setup() {
    show_progress 8 8 "Completing installation"
    
    # Create startup script
    cat > start-algoritmit.sh << 'EOF'
#!/bin/bash
cd "$(dirname "$0")"
echo "🤖 Starting ALGORITMIT Trading Bot..."
echo "📊 Machine Learning Trading for Worldchain"
echo ""
node worldchain-trading-bot.js
EOF
    
    chmod +x start-algoritmit.sh
    
    # Create service script for advanced users
    cat > create-service.sh << 'EOF'
#!/bin/bash
# Create systemd service for ALGORITMIT bot
INSTALL_DIR=$(pwd)
USER=$(whoami)

sudo tee /etc/systemd/system/algoritmit-bot.service > /dev/null << EOL
[Unit]
Description=ALGORITMIT Machine Learning Trading Bot
After=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$INSTALL_DIR
ExecStart=/usr/bin/node worldchain-trading-bot.js
Restart=always
RestartSec=10
Environment=NODE_ENV=production

[Install]
WantedBy=multi-user.target
EOL

sudo systemctl daemon-reload
echo "✅ Service created. Enable with: sudo systemctl enable algoritmit-bot"
echo "▶️  Start with: sudo systemctl start algoritmit-bot"
EOF
    
    chmod +x create-service.sh
    
    log "Installation completed successfully! ✓"
}

# Display post-installation instructions
show_instructions() {
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                         🎉 INSTALLATION SUCCESSFUL! 🎉                            ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${CYAN}📍 Installation Location:${NC} $HOME/worldchain-algoritmit-bot"
    echo ""
    echo -e "${YELLOW}🔧 NEXT STEPS:${NC}"
    echo ""
    echo -e "${WHITE}1. Configure your settings:${NC}"
    echo -e "   ${GRAY}cd $HOME/worldchain-algoritmit-bot${NC}"
    echo -e "   ${GRAY}nano .env${NC}"
    echo ""
    echo -e "${WHITE}2. Add your wallet private key and RPC settings to .env file${NC}"
    echo ""
    echo -e "${WHITE}3. Start the bot:${NC}"
    echo -e "   ${CYAN}./start-algoritmit.sh${NC}"
    echo ""
    echo -e "${WHITE}4. Follow the ALGORITMIT Quick Start Guide:${NC}"
    echo -e "   ${GRAY}• Go to Menu Option 7 (🤖 ALGORITMIT)${NC}"
    echo -e "   ${GRAY}• Enable ALGORITMIT Strategy${NC}"
    echo -e "   ${GRAY}• Turn on Learning Mode${NC}"
    echo -e "   ${GRAY}• Let it learn for 24-48 hours${NC}"
    echo -e "   ${GRAY}• Enable auto-trading with small amounts${NC}"
    echo ""
    echo -e "${PURPLE}🤖 ALGORITMIT FEATURES:${NC}"
    echo -e "   ${GRAY}• Machine Learning price predictions${NC}"
    echo -e "   ${GRAY}• Pattern recognition trading${NC}"
    echo -e "   ${GRAY}• Automated risk management${NC}"
    echo -e "   ${GRAY}• Continuous model improvement${NC}"
    echo ""
    echo -e "${RED}⚠️  IMPORTANT SAFETY REMINDERS:${NC}"
    echo -e "   ${GRAY}• Start with Learning Mode ONLY for 24+ hours${NC}"
    echo -e "   ${GRAY}• Use tiny amounts (0.01 WLD) when first auto-trading${NC}"
    echo -e "   ${GRAY}• Monitor performance closely${NC}"
    echo -e "   ${GRAY}• Never risk more than you can afford to lose${NC}"
    echo ""
    echo -e "${BLUE}📚 Documentation:${NC}"
    echo -e "   ${GRAY}• ALGORITMIT_GUIDE.md - Comprehensive ML trading guide${NC}"
    echo -e "   ${GRAY}• INSTALL_ALGORITMIT.md - Detailed installation guide${NC}"
    echo -e "   ${GRAY}• In-app tutorial (ALGORITMIT menu → option 8)${NC}"
    echo ""
    echo -e "${GREEN}🚀 Ready to start your machine learning trading journey!${NC}"
    echo ""
    echo -e "${CYAN}Support: Check documentation or GitHub issues for help${NC}"
    echo ""
}

# Main installation process
main() {
    print_banner
    
    echo -e "${WHITE}🤖 Welcome to ALGORITMIT - Machine Learning Trading Bot${NC}"
    echo -e "${GRAY}This installer will set up everything you need to start AI-powered trading on Worldchain${NC}"
    echo ""
    echo -e "${YELLOW}Press Enter to continue or Ctrl+C to cancel...${NC}"
    read -r
    
    echo ""
    log "Starting ALGORITMIT installation..."
    
    check_root
    check_requirements
    install_nodejs
    install_git
    clone_repository
    install_dependencies
    install_holdstation_sdk
    setup_configuration
    final_setup
    
    show_instructions
}

# Run main installation
main "$@"