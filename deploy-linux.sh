#!/bin/bash

# WorldChain Trading Bot - Automated Linux Deployment Script
# This script automates the deployment process on Linux servers

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
BOT_DIR="/opt/worldchain-bot"
GITHUB_REPO="YOUR_USERNAME/worldchain-trading-bot"  # Replace with actual repo
SERVICE_NAME="worldchain-bot"

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════════════════════════╗"
    echo "║                    🌍 WorldChain Trading Bot Deployment 🚀                  ║"
    echo "║                         Automated Linux Installation                        ║"
    echo "╚══════════════════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Detect Linux distribution
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$ID
        VERSION=$VERSION_ID
    else
        print_error "Cannot detect Linux distribution"
        exit 1
    fi
    
    print_status "Detected: $PRETTY_NAME"
}

# Check if running as root
check_root() {
    if [ "$EUID" -eq 0 ]; then
        print_warning "Running as root. It's recommended to run as a regular user with sudo privileges."
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
}

# Check system requirements
check_requirements() {
    print_status "Checking system requirements..."
    
    # Check RAM
    TOTAL_RAM=$(free -m | awk 'NR==2{printf "%.0f", $2}')
    if [ "$TOTAL_RAM" -lt 1000 ]; then
        print_warning "Low RAM detected: ${TOTAL_RAM}MB. Recommended: 1GB+"
    fi
    
    # Check disk space
    AVAILABLE_SPACE=$(df / | awk 'NR==2{print $4}')
    if [ "$AVAILABLE_SPACE" -lt 2000000 ]; then
        print_warning "Low disk space. Recommended: 2GB+ free space"
    fi
    
    print_success "System requirements check completed"
}

# Update system packages
update_system() {
    print_status "Updating system packages..."
    
    case $DISTRO in
        ubuntu|debian)
            sudo apt update && sudo apt upgrade -y
            ;;
        centos|rhel|rocky|almalinux)
            if command -v dnf &> /dev/null; then
                sudo dnf update -y
            else
                sudo yum update -y
            fi
            ;;
        *)
            print_warning "Unknown distribution. Please update manually."
            ;;
    esac
    
    print_success "System packages updated"
}

# Install Node.js and npm
install_nodejs() {
    print_status "Installing Node.js and npm..."
    
    if command -v node &> /dev/null; then
        NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
        if [ "$NODE_VERSION" -ge 16 ]; then
            print_success "Node.js $(node -v) is already installed"
            return
        fi
    fi
    
    case $DISTRO in
        ubuntu|debian)
            curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
            sudo apt-get install -y nodejs
            ;;
        centos|rhel|rocky|almalinux)
            curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo bash -
            if command -v dnf &> /dev/null; then
                sudo dnf install -y nodejs
            else
                sudo yum install -y nodejs
            fi
            ;;
        *)
            print_error "Unsupported distribution for automatic Node.js installation"
            print_status "Please install Node.js 16+ manually from https://nodejs.org/"
            exit 1
            ;;
    esac
    
    # Verify installation
    if command -v node &> /dev/null && command -v npm &> /dev/null; then
        print_success "Node.js $(node -v) and npm $(npm -v) installed successfully"
    else
        print_error "Node.js installation failed"
        exit 1
    fi
}

# Install Git
install_git() {
    print_status "Installing Git..."
    
    if command -v git &> /dev/null; then
        print_success "Git is already installed"
        return
    fi
    
    case $DISTRO in
        ubuntu|debian)
            sudo apt install -y git
            ;;
        centos|rhel|rocky|almalinux)
            if command -v dnf &> /dev/null; then
                sudo dnf install -y git
            else
                sudo yum install -y git
            fi
            ;;
        *)
            print_error "Unsupported distribution for automatic Git installation"
            exit 1
            ;;
    esac
    
    print_success "Git installed successfully"
}

# Create application directory
create_app_directory() {
    print_status "Creating application directory..."
    
    if [ -d "$BOT_DIR" ]; then
        print_warning "Directory $BOT_DIR already exists"
        read -p "Remove existing directory? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            sudo rm -rf "$BOT_DIR"
        else
            print_error "Installation cancelled"
            exit 1
        fi
    fi
    
    sudo mkdir -p "$BOT_DIR"
    sudo chown $USER:$USER "$BOT_DIR"
    
    print_success "Application directory created: $BOT_DIR"
}

# Clone repository
clone_repository() {
    print_status "Cloning repository from GitHub..."
    
    cd "$BOT_DIR"
    
    # Try different methods to get the code
    if [ -n "$GITHUB_REPO" ] && [ "$GITHUB_REPO" != "YOUR_USERNAME/worldchain-trading-bot" ]; then
        git clone "https://github.com/$GITHUB_REPO.git" .
    else
        print_warning "GitHub repository not specified or using placeholder"
        print_status "You'll need to manually copy the bot files to $BOT_DIR"
        print_status "Or update the GITHUB_REPO variable in this script"
        
        # Create basic structure
        mkdir -p logs backups data
        
        # Create a placeholder message
        cat > README_DEPLOYMENT.txt << EOF
WorldChain Trading Bot Deployment

The automated deployment script has prepared the directory structure.
You need to copy the following files to this directory:

Required files:
- worldchain-trading-bot.js
- trading-engine.js  
- token-discovery.js
- trading-strategy.js
- package.json
- .env.example
- start.sh

After copying the files, run:
1. chmod +x start.sh
2. ./start.sh install
3. cp .env.example .env
4. Edit .env with your configuration
5. ./start.sh start

EOF
        print_warning "Please copy the bot files manually and follow the instructions in README_DEPLOYMENT.txt"
        return
    fi
    
    print_success "Repository cloned successfully"
}

# Install dependencies
install_dependencies() {
    print_status "Installing dependencies..."
    
    cd "$BOT_DIR"
    
    if [ ! -f "package.json" ]; then
        print_warning "package.json not found. Skipping dependency installation."
        return
    fi
    
    # Make scripts executable
    if [ -f "start.sh" ]; then
        chmod +x start.sh
    fi
    
    if [ -f "worldchain-trading-bot.js" ]; then
        chmod +x worldchain-trading-bot.js
    fi
    
    # Install dependencies
    npm install
    
    print_success "Dependencies installed successfully"
}

# Setup environment configuration
setup_environment() {
    print_status "Setting up environment configuration..."
    
    cd "$BOT_DIR"
    
    if [ -f ".env.example" ] && [ ! -f ".env" ]; then
        cp .env.example .env
        print_success "Created .env file from template"
        print_warning "Please edit .env file to configure your settings"
    elif [ ! -f ".env" ]; then
        print_status "Creating basic .env file..."
        cat > .env << EOF
# WorldChain Trading Bot Configuration
WORLDCHAIN_RPC_URL=https://worldchain-mainnet.g.alchemy.com/public
ALCHEMY_API_KEY=demo
DEFAULT_SLIPPAGE=0.5
DEFAULT_GAS_PRICE=20
ENABLE_REAL_TRADING=false
SIMULATION_MODE=true

# Strategy Configuration
PROFIT_TARGET=1.0
DIP_BUY_THRESHOLD=1.0
MAX_SLIPPAGE=1.0
STOP_LOSS_THRESHOLD=-5.0
PRICE_CHECK_INTERVAL=5000
ENABLE_AUTO_SELL=true
ENABLE_DIP_BUYING=false
MAX_POSITION_SIZE=100
MAX_OPEN_POSITIONS=5
EOF
        print_success "Created basic .env file"
    fi
    
    # Set secure permissions
    chmod 600 .env
    
    print_success "Environment configuration completed"
}

# Create systemd service
create_service() {
    print_status "Creating systemd service..."
    
    if [ ! -f "$BOT_DIR/worldchain-trading-bot.js" ]; then
        print_warning "Main bot file not found. Skipping service creation."
        return
    fi
    
    sudo tee /etc/systemd/system/$SERVICE_NAME.service > /dev/null << EOF
[Unit]
Description=WorldChain Trading Bot
After=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$BOT_DIR
Environment=NODE_ENV=production
ExecStart=/usr/bin/node worldchain-trading-bot.js
Restart=always
RestartSec=10
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=$SERVICE_NAME

[Install]
WantedBy=multi-user.target
EOF
    
    # Reload systemd
    sudo systemctl daemon-reload
    
    print_success "Systemd service created: $SERVICE_NAME"
    print_status "To enable auto-start: sudo systemctl enable $SERVICE_NAME"
    print_status "To start the service: sudo systemctl start $SERVICE_NAME"
}

# Install additional tools
install_tools() {
    print_status "Installing additional monitoring tools..."
    
    case $DISTRO in
        ubuntu|debian)
            sudo apt install -y htop curl wget screen tmux
            ;;
        centos|rhel|rocky|almalinux)
            if command -v dnf &> /dev/null; then
                sudo dnf install -y htop curl wget screen tmux
            else
                sudo yum install -y htop curl wget screen tmux
            fi
            ;;
    esac
    
    print_success "Additional tools installed"
}

# Setup firewall
setup_firewall() {
    print_status "Configuring firewall..."
    
    case $DISTRO in
        ubuntu|debian)
            if command -v ufw &> /dev/null; then
                sudo ufw --force enable
                sudo ufw allow ssh
                print_success "UFW firewall configured"
            fi
            ;;
        centos|rhel|rocky|almalinux)
            if command -v firewall-cmd &> /dev/null; then
                sudo systemctl enable firewalld
                sudo systemctl start firewalld
                sudo firewall-cmd --permanent --add-service=ssh
                sudo firewall-cmd --reload
                print_success "Firewalld configured"
            fi
            ;;
    esac
}

# Create backup script
create_backup_script() {
    print_status "Creating backup script..."
    
    sudo tee /usr/local/bin/backup-worldchain-bot.sh > /dev/null << 'EOF'
#!/bin/bash
BACKUP_DIR="/backup/worldchain-bot"
DATE=$(date +%Y%m%d_%H%M%S)
BOT_DIR="/opt/worldchain-bot"

mkdir -p $BACKUP_DIR

tar -czf $BACKUP_DIR/worldchain-bot-backup-$DATE.tar.gz \
    -C $BOT_DIR \
    .env \
    config.json \
    wallets.json \
    discovered_tokens.json \
    strategy_positions.json \
    2>/dev/null || echo "Some files may not exist yet"

# Keep only last 7 backups
find $BACKUP_DIR -name "worldchain-bot-backup-*.tar.gz" -mtime +7 -delete 2>/dev/null

echo "Backup completed: worldchain-bot-backup-$DATE.tar.gz"
EOF
    
    sudo chmod +x /usr/local/bin/backup-worldchain-bot.sh
    
    print_success "Backup script created: /usr/local/bin/backup-worldchain-bot.sh"
    print_status "To create a backup: sudo /usr/local/bin/backup-worldchain-bot.sh"
}

# Final verification
verify_installation() {
    print_status "Verifying installation..."
    
    cd "$BOT_DIR"
    
    # Check if main files exist
    MISSING_FILES=()
    
    [ ! -f "package.json" ] && MISSING_FILES+=("package.json")
    [ ! -f ".env" ] && MISSING_FILES+=(".env")
    
    if [ ${#MISSING_FILES[@]} -gt 0 ]; then
        print_warning "Missing files: ${MISSING_FILES[*]}"
        print_status "You may need to copy additional files manually"
    fi
    
    # Check Node.js
    if command -v node &> /dev/null; then
        print_success "Node.js: $(node -v)"
    else
        print_error "Node.js not found"
    fi
    
    # Check npm
    if command -v npm &> /dev/null; then
        print_success "npm: $(npm -v)"
    else
        print_error "npm not found"
    fi
    
    # Check Git
    if command -v git &> /dev/null; then
        print_success "Git: $(git --version)"
    else
        print_error "Git not found"
    fi
    
    print_success "Installation verification completed"
}

# Display final instructions
show_final_instructions() {
    print_header
    echo -e "${GREEN}🎉 WorldChain Trading Bot Deployment Completed! 🎉${NC}"
    echo
    echo -e "${CYAN}📁 Installation Directory:${NC} $BOT_DIR"
    echo -e "${CYAN}🔧 Configuration File:${NC} $BOT_DIR/.env"
    echo -e "${CYAN}📊 Service Name:${NC} $SERVICE_NAME"
    echo
    echo -e "${YELLOW}📋 Next Steps:${NC}"
    echo "1. Edit configuration: nano $BOT_DIR/.env"
    echo "2. Test the bot: cd $BOT_DIR && ./start.sh start"
    echo "3. Enable auto-start: sudo systemctl enable $SERVICE_NAME"
    echo "4. Start service: sudo systemctl start $SERVICE_NAME"
    echo "5. Check status: sudo systemctl status $SERVICE_NAME"
    echo "6. View logs: sudo journalctl -u $SERVICE_NAME -f"
    echo
    echo -e "${YELLOW}🔒 Security Reminders:${NC}"
    echo "• Keep your private keys secure"
    echo "• Start with small trading amounts"
    echo "• Monitor the bot regularly"
    echo "• Create regular backups: /usr/local/bin/backup-worldchain-bot.sh"
    echo
    echo -e "${GREEN}Happy Trading on WorldChain! 🌍💰🎯${NC}"
}

# Main installation function
main() {
    print_header
    
    print_status "Starting WorldChain Trading Bot deployment..."
    echo
    
    # Check if GitHub repo is configured
    if [ "$GITHUB_REPO" = "YOUR_USERNAME/worldchain-trading-bot" ]; then
        print_warning "Please update the GITHUB_REPO variable in this script with your actual repository"
        read -p "Continue with manual file copying? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
    
    # Run installation steps
    detect_distro
    check_root
    check_requirements
    update_system
    install_nodejs
    install_git
    install_tools
    create_app_directory
    clone_repository
    install_dependencies
    setup_environment
    create_service
    setup_firewall
    create_backup_script
    verify_installation
    
    echo
    show_final_instructions
}

# Handle script arguments
case "${1:-install}" in
    "install")
        main
        ;;
    "verify")
        verify_installation
        ;;
    "service")
        create_service
        ;;
    "backup")
        create_backup_script
        ;;
    "help"|"-h"|"--help")
        echo "WorldChain Trading Bot - Linux Deployment Script"
        echo
        echo "Usage: $0 [OPTION]"
        echo
        echo "Options:"
        echo "  install    Full installation (default)"
        echo "  verify     Verify existing installation"
        echo "  service    Create systemd service only"
        echo "  backup     Create backup script only"
        echo "  help       Show this help message"
        ;;
    *)
        print_error "Unknown option: $1"
        echo "Use '$0 help' for usage information"
        exit 1
        ;;
esac