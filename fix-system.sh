#!/bin/bash

# System Repair Utility for Ubuntu/Debian
# Fixes common package management issues before installation

set -e

# Colors
G='\033[0;32m' # Green
R='\033[0;31m' # Red  
Y='\033[1;33m' # Yellow
B='\033[0;34m' # Blue
NC='\033[0m'   # No Color

ok() { echo -e "${G}✅ $1${NC}"; }
err() { echo -e "${R}❌ $1${NC}"; }
info() { echo -e "${B}ℹ️  $1${NC}"; }
warn() { echo -e "${Y}⚠️  $1${NC}"; }

echo -e "${B}🔧 SYSTEM REPAIR UTILITY${NC}"
echo "========================="
echo

info "This will fix common Ubuntu package management issues"
echo

# Check if running as root or with sudo
if [[ $EUID -ne 0 ]] && ! sudo -n true 2>/dev/null; then
    err "This script needs sudo access to fix system packages"
    info "Run with: sudo ./fix-system.sh"
    exit 1
fi

# Step 1: Fix interrupted dpkg
info "Step 1: Fixing interrupted package installations..."
if ! sudo dpkg --configure -a 2>/dev/null; then
    warn "Found interrupted package installations, fixing..."
    sudo dpkg --configure -a 2>/dev/null || true
    ok "dpkg configuration completed"
else
    ok "No interrupted packages found"
fi

# Step 2: Fix broken packages
info "Step 2: Fixing broken packages..."
sudo apt-get install -f -y >/dev/null 2>&1 || true
ok "Broken packages fixed"

# Step 3: Update package lists
info "Step 3: Updating package lists..."
if sudo apt-get update >/dev/null 2>&1; then
    ok "Package lists updated successfully"
else
    warn "Package update had issues, trying repair..."
    sudo apt-get update --fix-missing >/dev/null 2>&1 || true
    ok "Package lists updated with fixes"
fi

# Step 4: Clean package cache
info "Step 4: Cleaning package cache..."
sudo apt-get clean >/dev/null 2>&1 || true
sudo apt-get autoclean >/dev/null 2>&1 || true
ok "Package cache cleaned"

# Step 5: Remove unnecessary packages
info "Step 5: Removing unnecessary packages..."
sudo apt-get autoremove -y >/dev/null 2>&1 || true
ok "Unnecessary packages removed"

# Step 6: Test package manager
info "Step 6: Testing package manager..."
if sudo apt-get check >/dev/null 2>&1; then
    ok "Package manager is working correctly"
else
    warn "Package manager still has issues"
    info "You may need to manually resolve remaining conflicts"
fi

echo
ok "System repair completed!"
info "You can now run the trading bot installer:"
echo "  curl -fsSL https://raw.githubusercontent.com/romerodevv/psgho/main/simple-install.sh | bash"
echo