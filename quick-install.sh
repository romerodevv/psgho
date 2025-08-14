#!/bin/bash

# ALGORITMIT - Ultra Simple Installer
set -e

echo "🤖 ALGORITMIT Quick Install"
echo "=========================="

# Install Node.js if needed
if ! command -v node >/dev/null 2>&1; then
    echo "📦 Installing Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - >/dev/null 2>&1
    sudo apt-get install -y nodejs >/dev/null 2>&1
fi

# Download and setup
echo "📥 Downloading ALGORITMIT..."
cd $HOME
rm -rf algoritmit-bot
git clone https://github.com/romerodevv/psgho.git algoritmit-bot >/dev/null 2>&1
cd algoritmit-bot

echo "📦 Installing packages..."
npm install >/dev/null 2>&1
npm install @holdstation/worldchain-sdk@latest @holdstation/worldchain-ethers-v6@latest @worldcoin/minikit-js@latest >/dev/null 2>&1

# Setup
cp .env.example .env
echo '#!/bin/bash' > run.sh
echo 'node worldchain-trading-bot.js' >> run.sh
chmod +x run.sh

echo ""
echo "✅ ALGORITMIT Installed!"
echo ""
echo "Next steps:"
echo "1. cd ~/algoritmit-bot"
echo "2. nano .env (add your private key)"
echo "3. ./run.sh"
echo ""
echo "⚠️  IMPORTANT: Enable Learning Mode first (24+ hours)!"
echo "   Then use tiny amounts (0.01 WLD) for testing."