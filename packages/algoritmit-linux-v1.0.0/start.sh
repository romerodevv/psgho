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
