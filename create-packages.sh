#!/bin/bash

# ALGORITMIT Package Creator
# Creates downloadable packages for easy installation

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}🎁 ALGORITMIT Package Creator${NC}"
echo -e "${BLUE}Creating downloadable packages for all platforms...${NC}"
echo ""

# Create packages directory
PACKAGES_DIR="packages"
mkdir -p "$PACKAGES_DIR"

# Get current version from package.json
VERSION=$(node -p "require('./package.json').version" 2>/dev/null || echo "3.0.0")
echo -e "${BLUE}📦 Creating packages for version: $VERSION${NC}"

# Function to create package structure
create_package() {
    local platform=$1
    local package_name="algoritmit-${platform}-v${VERSION}"
    local package_dir="${PACKAGES_DIR}/${package_name}"
    
    echo -e "${YELLOW}📁 Creating ${platform} package...${NC}"
    
    # Create package directory
    rm -rf "$package_dir"
    mkdir -p "$package_dir"
    
    # Copy core files
    cp -r *.js "$package_dir/" 2>/dev/null || true
    cp -r *.json "$package_dir/" 2>/dev/null || true
    cp -r *.md "$package_dir/" 2>/dev/null || true
    cp .env.example "$package_dir/" 2>/dev/null || true
    cp .gitignore "$package_dir/" 2>/dev/null || true
    
    # Copy installation scripts
    cp install.py "$package_dir/" 2>/dev/null || true
    cp *-install.sh "$package_dir/" 2>/dev/null || true
    
    return 0
}

# Create Windows package
create_package "windows"
WINDOWS_DIR="${PACKAGES_DIR}/algoritmit-windows-v${VERSION}"

# Create Windows-specific files
cat > "${WINDOWS_DIR}/INSTALL.bat" << 'EOF'
@echo off
echo 🤖 ALGORITMIT Windows Installer
echo ===============================
echo.
echo This will install ALGORITMIT Machine Learning Trading Bot
echo.
pause

echo 📋 Checking Python...
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Python not found. Please install Python 3.7+ from https://python.org
    echo    Make sure to check "Add Python to PATH" during installation
    pause
    exit /b 1
)

echo ✅ Python found
echo.

echo 🔧 Running Python installer...
python install.py

echo.
echo 🎉 Installation complete!
echo.
echo 📝 Next steps:
echo 1. Edit .env file with your wallet private key
echo 2. Double-click START.bat to run ALGORITMIT
echo.
pause
EOF

cat > "${WINDOWS_DIR}/START.bat" << 'EOF'
@echo off
title ALGORITMIT - Machine Learning Trading Bot
echo 🤖 Starting ALGORITMIT Machine Learning Trading Bot...
echo 📊 Version 3.0 - AI-Powered Trading for Worldchain
echo.
echo ⚠️  SAFETY REMINDER:
echo    • Start with Learning Mode for 24+ hours
echo    • Use tiny amounts (0.01 WLD) for testing
echo    • Never risk more than you can afford to lose
echo.

if not exist ".env" (
    echo ❌ Configuration file (.env) not found!
    echo    Please run INSTALL.bat first and configure your wallet
    echo.
    pause
    exit /b 1
)

if not exist "node_modules" (
    echo 📦 Installing dependencies...
    npm install
    npm install @holdstation/worldchain-sdk@latest
    npm install @holdstation/worldchain-ethers-v6@latest
    npm install @worldcoin/minikit-js@latest
)

node worldchain-trading-bot.js
pause
EOF

cat > "${WINDOWS_DIR}/UPDATE.bat" << 'EOF'
@echo off
echo 🔄 Updating ALGORITMIT...
echo.

echo 📥 Downloading latest version...
curl -L https://github.com/romerodevv/psgho/archive/main.zip -o update.zip

echo 📂 Extracting files...
powershell -command "Expand-Archive -Force update.zip ."
xcopy /E /Y psgho-main\* .
rmdir /S /Q psgho-main
del update.zip

echo 📦 Updating dependencies...
npm install

echo ✅ Update complete!
pause
EOF

cat > "${WINDOWS_DIR}/README-WINDOWS.txt" << EOF
🤖 ALGORITMIT - Machine Learning Trading Bot for Windows
========================================================

📋 QUICK START:
1. Double-click INSTALL.bat
2. Edit .env file with your wallet private key
3. Double-click START.bat

📁 PACKAGE CONTENTS:
- INSTALL.bat     -> Run this first to install
- START.bat       -> Run this to start ALGORITMIT
- UPDATE.bat      -> Run this to update to latest version
- install.py      -> Python installer script
- .env.example    -> Configuration template
- *.js files      -> ALGORITMIT bot source code
- *.md files      -> Documentation

💻 SYSTEM REQUIREMENTS:
- Windows 10/11
- Python 3.7+ (download from python.org)
- Internet connection

🔧 MANUAL INSTALLATION (if INSTALL.bat fails):
1. Install Node.js from nodejs.org
2. Open Command Prompt in this folder
3. Run: python install.py
4. Edit .env file with your wallet details
5. Run: node worldchain-trading-bot.js

⚠️  SAFETY FIRST:
- Always start with Learning Mode for 24+ hours
- Use tiny amounts (0.01 WLD) for testing
- Never risk more than you can afford to lose

🆘 SUPPORT:
- GitHub: https://github.com/romerodevv/psgho
- Issues: https://github.com/romerodevv/psgho/issues

Version: ${VERSION}
EOF

# Create macOS package
create_package "macos"
MACOS_DIR="${PACKAGES_DIR}/algoritmit-macos-v${VERSION}"

cat > "${MACOS_DIR}/install.command" << 'EOF'
#!/bin/bash
cd "$(dirname "$0")"

echo "🤖 ALGORITMIT macOS Installer"
echo "============================="
echo ""

# Check if Python is available
if ! command -v python3 >/dev/null 2>&1; then
    echo "❌ Python 3 not found. Please install from https://python.org"
    echo "   Or install via Homebrew: brew install python"
    read -p "Press Enter to exit..."
    exit 1
fi

echo "✅ Python 3 found"
echo ""

echo "🔧 Running installer..."
python3 install.py

echo ""
echo "🎉 Installation complete!"
echo ""
echo "📝 Next steps:"
echo "1. Edit .env file with your wallet private key"
echo "2. Double-click start.command to run ALGORITMIT"
echo ""
read -p "Press Enter to exit..."
EOF
chmod +x "${MACOS_DIR}/install.command"

cat > "${MACOS_DIR}/start.command" << 'EOF'
#!/bin/bash
cd "$(dirname "$0")"

echo "🤖 Starting ALGORITMIT Machine Learning Trading Bot..."
echo "📊 Version 3.0 - AI-Powered Trading for Worldchain"
echo ""
echo "⚠️  SAFETY REMINDER:"
echo "   • Start with Learning Mode for 24+ hours"
echo "   • Use tiny amounts (0.01 WLD) for testing"
echo "   • Never risk more than you can afford to lose"
echo ""

if [ ! -f ".env" ]; then
    echo "❌ Configuration file (.env) not found!"
    echo "   Please run install.command first and configure your wallet"
    echo ""
    read -p "Press Enter to exit..."
    exit 1
fi

if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    npm install
    npm install @holdstation/worldchain-sdk@latest
    npm install @holdstation/worldchain-ethers-v6@latest
    npm install @worldcoin/minikit-js@latest
fi

node worldchain-trading-bot.js
EOF
chmod +x "${MACOS_DIR}/start.command"

cat > "${MACOS_DIR}/README-MACOS.txt" << EOF
🤖 ALGORITMIT - Machine Learning Trading Bot for macOS
======================================================

📋 QUICK START:
1. Double-click install.command
2. Edit .env file with your wallet private key
3. Double-click start.command

📁 PACKAGE CONTENTS:
- install.command -> Run this first to install
- start.command   -> Run this to start ALGORITMIT
- install.py      -> Python installer script
- .env.example    -> Configuration template
- *.js files      -> ALGORITMIT bot source code
- *.md files      -> Documentation

💻 SYSTEM REQUIREMENTS:
- macOS 10.14+
- Python 3.7+ (usually pre-installed)
- Xcode Command Line Tools: xcode-select --install
- Internet connection

🔧 MANUAL INSTALLATION (if install.command fails):
1. Install Homebrew: /bin/bash -c "\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
2. Install Node.js: brew install node
3. Open Terminal in this folder
4. Run: python3 install.py
5. Edit .env file with your wallet details
6. Run: node worldchain-trading-bot.js

⚠️  SAFETY FIRST:
- Always start with Learning Mode for 24+ hours
- Use tiny amounts (0.01 WLD) for testing
- Never risk more than you can afford to lose

🆘 SUPPORT:
- GitHub: https://github.com/romerodevv/psgho
- Issues: https://github.com/romerodevv/psgho/issues

Version: ${VERSION}
EOF

# Create Linux package
create_package "linux"
LINUX_DIR="${PACKAGES_DIR}/algoritmit-linux-v${VERSION}"

cat > "${LINUX_DIR}/install.sh" << 'EOF'
#!/bin/bash

echo "🤖 ALGORITMIT Linux Installer"
echo "============================="
echo ""

# Check if Python is available
if ! command -v python3 >/dev/null 2>&1; then
    echo "❌ Python 3 not found. Installing..."
    sudo apt update
    sudo apt install -y python3 python3-pip curl wget
fi

echo "✅ Python 3 found"
echo ""

echo "🔧 Running installer..."
python3 install.py

echo ""
echo "🎉 Installation complete!"
echo ""
echo "📝 Next steps:"
echo "1. Edit .env file with your wallet private key"
echo "2. Run: ./start.sh"
echo ""
EOF
chmod +x "${LINUX_DIR}/install.sh"

cat > "${LINUX_DIR}/start.sh" << 'EOF'
#!/bin/bash

echo "🤖 Starting ALGORITMIT Machine Learning Trading Bot..."
echo "📊 Version 3.0 - AI-Powered Trading for Worldchain"
echo ""
echo "⚠️  SAFETY REMINDER:"
echo "   • Start with Learning Mode for 24+ hours"
echo "   • Use tiny amounts (0.01 WLD) for testing"
echo "   • Never risk more than you can afford to lose"
echo ""

if [ ! -f ".env" ]; then
    echo "❌ Configuration file (.env) not found!"
    echo "   Please run ./install.sh first and configure your wallet"
    echo ""
    exit 1
fi

if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    npm install
    npm install @holdstation/worldchain-sdk@latest
    npm install @holdstation/worldchain-ethers-v6@latest
    npm install @worldcoin/minikit-js@latest
fi

node worldchain-trading-bot.js
EOF
chmod +x "${LINUX_DIR}/start.sh"

cat > "${LINUX_DIR}/README-LINUX.txt" << EOF
🤖 ALGORITMIT - Machine Learning Trading Bot for Linux
======================================================

📋 QUICK START:
1. Run: chmod +x install.sh && ./install.sh
2. Edit .env file with your wallet private key
3. Run: ./start.sh

📁 PACKAGE CONTENTS:
- install.sh      -> Run this first to install
- start.sh        -> Run this to start ALGORITMIT
- install.py      -> Python installer script
- .env.example    -> Configuration template
- *.js files      -> ALGORITMIT bot source code
- *.md files      -> Documentation

💻 SYSTEM REQUIREMENTS:
- Ubuntu 18.04+ / Debian 10+ / CentOS 7+
- Python 3.7+
- Internet connection

🔧 MANUAL INSTALLATION (if install.sh fails):
1. Update system: sudo apt update && sudo apt upgrade -y
2. Install dependencies: sudo apt install -y curl wget python3 nodejs npm
3. Run: python3 install.py
4. Edit .env file with your wallet details
5. Run: node worldchain-trading-bot.js

⚠️  SAFETY FIRST:
- Always start with Learning Mode for 24+ hours
- Use tiny amounts (0.01 WLD) for testing
- Never risk more than you can afford to lose

🆘 SUPPORT:
- GitHub: https://github.com/romerodevv/psgho
- Issues: https://github.com/romerodevv/psgho/issues

Version: ${VERSION}
EOF

# Create Universal package (all platforms)
create_package "universal"
UNIVERSAL_DIR="${PACKAGES_DIR}/algoritmit-universal-v${VERSION}"

# Copy all platform-specific files to universal package
cp "${WINDOWS_DIR}/INSTALL.bat" "${UNIVERSAL_DIR}/"
cp "${WINDOWS_DIR}/START.bat" "${UNIVERSAL_DIR}/"
cp "${WINDOWS_DIR}/UPDATE.bat" "${UNIVERSAL_DIR}/"
cp "${MACOS_DIR}/install.command" "${UNIVERSAL_DIR}/"
cp "${MACOS_DIR}/start.command" "${UNIVERSAL_DIR}/"
cp "${LINUX_DIR}/install.sh" "${UNIVERSAL_DIR}/"
cp "${LINUX_DIR}/start.sh" "${UNIVERSAL_DIR}/"

cat > "${UNIVERSAL_DIR}/README.txt" << EOF
🤖 ALGORITMIT - Universal Machine Learning Trading Bot Package
==============================================================

This package works on Windows, macOS, and Linux!

📋 INSTALLATION BY PLATFORM:

🪟 WINDOWS:
1. Double-click INSTALL.bat
2. Edit .env file with your wallet private key
3. Double-click START.bat

🍎 MACOS:
1. Double-click install.command
2. Edit .env file with your wallet private key  
3. Double-click start.command

🐧 LINUX:
1. Run: chmod +x install.sh && ./install.sh
2. Edit .env file with your wallet private key
3. Run: ./start.sh

⚡ ALTERNATIVE (All Platforms):
1. Run: python3 install.py (or python install.py on Windows)
2. Edit .env file with your wallet private key
3. Run: node worldchain-trading-bot.js

💻 SYSTEM REQUIREMENTS:
- Python 3.7+ (required for all platforms)
- Internet connection
- 2GB+ free disk space
- 4GB+ RAM (recommended for ML processing)

⚠️  SAFETY FIRST:
- Always start with Learning Mode for 24+ hours
- Use tiny amounts (0.01 WLD) for testing  
- Never risk more than you can afford to lose

🆘 SUPPORT:
- GitHub: https://github.com/romerodevv/psgho
- Issues: https://github.com/romerodevv/psgho/issues

Version: ${VERSION}
Built: $(date)
EOF

echo ""
echo -e "${YELLOW}📦 Creating compressed archives...${NC}"

# Create ZIP files for each package
cd "$PACKAGES_DIR"

# Windows ZIP
echo -e "${BLUE}Creating Windows package...${NC}"
zip -r "algoritmit-windows-v${VERSION}.zip" "algoritmit-windows-v${VERSION}/" >/dev/null
echo -e "${GREEN}✅ algoritmit-windows-v${VERSION}.zip${NC}"

# macOS ZIP  
echo -e "${BLUE}Creating macOS package...${NC}"
zip -r "algoritmit-macos-v${VERSION}.zip" "algoritmit-macos-v${VERSION}/" >/dev/null
echo -e "${GREEN}✅ algoritmit-macos-v${VERSION}.zip${NC}"

# Linux TAR.GZ
echo -e "${BLUE}Creating Linux package...${NC}"
tar -czf "algoritmit-linux-v${VERSION}.tar.gz" "algoritmit-linux-v${VERSION}/"
echo -e "${GREEN}✅ algoritmit-linux-v${VERSION}.tar.gz${NC}"

# Universal ZIP
echo -e "${BLUE}Creating Universal package...${NC}"
zip -r "algoritmit-universal-v${VERSION}.zip" "algoritmit-universal-v${VERSION}/" >/dev/null
echo -e "${GREEN}✅ algoritmit-universal-v${VERSION}.zip${NC}"

cd ..

echo ""
echo -e "${GREEN}🎉 All packages created successfully!${NC}"
echo ""
echo -e "${CYAN}📦 Package Summary:${NC}"
echo -e "${YELLOW}Windows:${NC}   packages/algoritmit-windows-v${VERSION}.zip"
echo -e "${YELLOW}macOS:${NC}     packages/algoritmit-macos-v${VERSION}.zip"  
echo -e "${YELLOW}Linux:${NC}     packages/algoritmit-linux-v${VERSION}.tar.gz"
echo -e "${YELLOW}Universal:${NC} packages/algoritmit-universal-v${VERSION}.zip"
echo ""
echo -e "${BLUE}📊 Package sizes:${NC}"
ls -lh packages/*.zip packages/*.tar.gz 2>/dev/null | awk '{print "  " $9 ": " $5}'
echo ""
echo -e "${GREEN}Ready for distribution! 🚀${NC}"