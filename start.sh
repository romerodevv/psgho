#!/bin/bash

# WorldChain Trading Bot Startup Script
# This script handles installation and startup of the trading bot

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

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
    echo "║                        🌍 WorldChain Trading Bot 🤖                         ║"
    echo "║                      Advanced WLD Pair Trading System                       ║"
    echo "╚══════════════════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Check if Node.js is installed
check_nodejs() {
    print_status "Checking Node.js installation..."
    
    if ! command -v node &> /dev/null; then
        print_error "Node.js is not installed!"
        print_status "Please install Node.js version 16 or higher from https://nodejs.org/"
        exit 1
    fi
    
    NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
    if [ "$NODE_VERSION" -lt 16 ]; then
        print_error "Node.js version 16 or higher is required. Current version: $(node -v)"
        exit 1
    fi
    
    print_success "Node.js $(node -v) is installed"
}

# Check if npm is installed
check_npm() {
    print_status "Checking npm installation..."
    
    if ! command -v npm &> /dev/null; then
        print_error "npm is not installed!"
        exit 1
    fi
    
    print_success "npm $(npm -v) is installed"
}

# Install dependencies
install_dependencies() {
    print_status "Installing dependencies..."
    
    if [ ! -f "package.json" ]; then
        print_error "package.json not found!"
        exit 1
    fi
    
    # Install dependencies
    npm install
    
    if [ $? -eq 0 ]; then
        print_success "Dependencies installed successfully"
    else
        print_error "Failed to install dependencies"
        exit 1
    fi
}

# Setup environment file
setup_environment() {
    print_status "Setting up environment configuration..."
    
    if [ ! -f ".env" ]; then
        if [ -f ".env.example" ]; then
            cp .env.example .env
            print_success "Created .env file from template"
            print_warning "Please edit .env file to configure your API keys and settings"
        else
            print_warning "No .env.example file found, creating basic .env file"
            cat > .env << EOF
# Basic configuration
WORLDCHAIN_RPC_URL=https://worldchain-mainnet.g.alchemy.com/public
ALCHEMY_API_KEY=demo
DEFAULT_SLIPPAGE=0.5
SIMULATION_MODE=true
EOF
            print_success "Created basic .env file"
        fi
    else
        print_success ".env file already exists"
    fi
}

# Create data directories
create_directories() {
    print_status "Creating data directories..."
    
    mkdir -p data
    mkdir -p logs
    mkdir -p backups
    
    print_success "Data directories created"
}

# Set permissions
set_permissions() {
    print_status "Setting file permissions..."
    
    # Make the main script executable
    chmod +x worldchain-trading-bot.js
    
    # Make this script executable
    chmod +x start.sh
    
    print_success "File permissions set"
}

# Check system requirements
check_system_requirements() {
    print_status "Checking system requirements..."
    
    # Check available memory
    if command -v free &> /dev/null; then
        AVAILABLE_RAM=$(free -m | awk 'NR==2{printf "%.0f", $7}')
        if [ "$AVAILABLE_RAM" -lt 512 ]; then
            print_warning "Low available RAM: ${AVAILABLE_RAM}MB. Recommended: 512MB+"
        fi
    fi
    
    # Check disk space
    if command -v df &> /dev/null; then
        AVAILABLE_DISK=$(df -h . | awk 'NR==2{print $4}' | sed 's/[^0-9]*//g')
        if [ "$AVAILABLE_DISK" -lt 1000 ]; then
            print_warning "Low available disk space. Recommended: 1GB+"
        fi
    fi
    
    print_success "System requirements check completed"
}

# Function to start the bot
start_bot() {
    print_status "Starting WorldChain Trading Bot..."
    
    # Check if all required files exist
    if [ ! -f "worldchain-trading-bot.js" ]; then
        print_error "Main bot file not found!"
        exit 1
    fi
    
    if [ ! -f "trading-engine.js" ]; then
        print_error "Trading engine module not found!"
        exit 1
    fi
    
    if [ ! -f "token-discovery.js" ]; then
        print_error "Token discovery module not found!"
        exit 1
    fi
    
    # Start the bot
    print_success "🚀 Launching WorldChain Trading Bot..."
    echo ""
    node worldchain-trading-bot.js
}

# Function to show help
show_help() {
    echo "WorldChain Trading Bot - Startup Script"
    echo ""
    echo "Usage: $0 [OPTION]"
    echo ""
    echo "Options:"
    echo "  install     Install dependencies and setup environment"
    echo "  start       Start the trading bot"
    echo "  dev         Start in development mode with auto-restart"
    echo "  check       Check system requirements and dependencies"
    echo "  clean       Clean cache and temporary files"
    echo "  backup      Create backup of configuration and data"
    echo "  help        Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 install  # First time setup"
    echo "  $0 start    # Start the bot"
    echo "  $0 check    # Check system"
    echo ""
}

# Function to run in development mode
dev_mode() {
    print_status "Starting in development mode..."
    
    if ! command -v nodemon &> /dev/null; then
        print_status "Installing nodemon for development..."
        npm install -g nodemon
    fi
    
    nodemon worldchain-trading-bot.js
}

# Function to clean cache and temporary files
clean_cache() {
    print_status "Cleaning cache and temporary files..."
    
    # Remove node_modules if exists
    if [ -d "node_modules" ]; then
        rm -rf node_modules
        print_success "Removed node_modules"
    fi
    
    # Remove package-lock.json if exists
    if [ -f "package-lock.json" ]; then
        rm -f package-lock.json
        print_success "Removed package-lock.json"
    fi
    
    # Clean npm cache
    npm cache clean --force
    
    print_success "Cache cleaned successfully"
}

# Function to create backup
create_backup() {
    print_status "Creating backup..."
    
    BACKUP_DIR="backups/backup_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    
    # Backup configuration files
    [ -f ".env" ] && cp .env "$BACKUP_DIR/"
    [ -f "config.json" ] && cp config.json "$BACKUP_DIR/"
    [ -f "wallets.json" ] && cp wallets.json "$BACKUP_DIR/"
    [ -f "discovered_tokens.json" ] && cp discovered_tokens.json "$BACKUP_DIR/"
    
    print_success "Backup created in $BACKUP_DIR"
}

# Function to check everything
check_all() {
    print_header
    check_system_requirements
    check_nodejs
    check_npm
    print_success "All checks completed successfully!"
}

# Main script logic
main() {
    case "${1:-start}" in
        "install")
            print_header
            check_nodejs
            check_npm
            install_dependencies
            setup_environment
            create_directories
            set_permissions
            print_success "🎉 Installation completed successfully!"
            print_status "Run './start.sh start' to launch the bot"
            ;;
        "start")
            print_header
            check_nodejs
            check_npm
            start_bot
            ;;
        "dev")
            print_header
            check_nodejs
            check_npm
            dev_mode
            ;;
        "check")
            check_all
            ;;
        "clean")
            clean_cache
            ;;
        "backup")
            create_backup
            ;;
        "help"|"-h"|"--help")
            show_help
            ;;
        *)
            print_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"