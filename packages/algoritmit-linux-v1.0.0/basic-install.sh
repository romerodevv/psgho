#!/bin/bash

# Basic Ultra-Fast Trading Bot Installer
# Simple installation like previous versions

echo "🚀 Installing Ultra-Fast Trading Bot..."
echo "======================================"

# Install Node.js if needed
if ! command -v node &> /dev/null; then
    echo "📦 Installing Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - >/dev/null 2>&1
    sudo apt-get install -y nodejs >/dev/null 2>&1
fi

# Create directory
cd ~
rm -rf trading-bot
mkdir trading-bot
cd trading-bot

# Download bot
echo "📥 Downloading bot..."
git clone https://github.com/romerodevv/psgho.git . >/dev/null 2>&1

# Install packages
echo "📦 Installing packages..."
npm install >/dev/null 2>&1
npm install @holdstation/worldchain-sdk@latest >/dev/null 2>&1
npm install @holdstation/worldchain-ethers-v6@latest >/dev/null 2>&1
npm install @worldcoin/minikit-js@latest >/dev/null 2>&1

# Create config
echo "⚙️  Creating config..."
cat > .env << 'EOF'
PRIVATE_KEY=your_private_key_here
WORLDCHAIN_RPC_URL=https://worldchain-mainnet.g.alchemy.com/public
WLD_TOKEN_ADDRESS=0x2cfc85d8e48f8eab294be644d9e25c3030863003
EOF

echo ""
echo "✅ Installation complete!"
echo ""
echo "Next steps:"
echo "1. Edit your private key: nano .env"
echo "2. Start the bot: node worldchain-trading-bot.js"
echo ""
echo "Bot location: ~/trading-bot"
echo "Features: <3 second trades, color profits/losses"