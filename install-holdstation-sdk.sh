#!/bin/bash

echo "🚀 Installing HoldStation SDK for Worldchain Trading Bot..."
echo "═════════════════════════════════════════════════════════"

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js first."
    exit 1
fi

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo "❌ npm is not installed. Please install npm first."
    exit 1
fi

echo "📦 Installing HoldStation SDK dependencies..."

# Install HoldStation SDK packages
npm install @holdstation/worldchain-sdk@latest
npm install @holdstation/worldchain-ethers-v6@latest
npm install @worldcoin/minikit-js@latest

# Verify installation
echo ""
echo "🔍 Verifying HoldStation SDK installation..."

if npm list @holdstation/worldchain-sdk > /dev/null 2>&1; then
    echo "✅ @holdstation/worldchain-sdk installed successfully"
else
    echo "❌ Failed to install @holdstation/worldchain-sdk"
    exit 1
fi

if npm list @holdstation/worldchain-ethers-v6 > /dev/null 2>&1; then
    echo "✅ @holdstation/worldchain-ethers-v6 installed successfully"
else
    echo "❌ Failed to install @holdstation/worldchain-ethers-v6"
    exit 1
fi

echo ""
echo "🎉 HoldStation SDK installation completed successfully!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Your bot can now use HoldStation's DEX for trading"
echo "✅ WLD/ORO pairs should now work properly"
echo "✅ Enhanced trading with better liquidity routing"
echo ""
echo "💡 Next steps:"
echo "   1. Run: ./start-corit.sh (or your preferred start script)"
echo "   2. Go to Trading Operations"
echo "   3. Try 'Sinclave Enhanced Trade' option"
echo "   4. The bot will now use HoldStation SDK instead of Uniswap V3"
echo ""
echo "🔗 For more info: https://docs.holdstation.com/"