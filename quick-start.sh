#!/bin/bash

# WorldChain Interactive Trading Bot - Quick Start Script
# This script will help you get the trading bot running quickly

echo "🌍 WorldChain Interactive Trading Bot - Quick Start"
echo "=================================================="
echo ""

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js 16+ first."
    echo "   Visit: https://nodejs.org/"
    exit 1
fi

# Check Node.js version
NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 16 ]; then
    echo "❌ Node.js version 16+ is required. Current version: $(node -v)"
    echo "   Please upgrade Node.js first."
    exit 1
fi

echo "✅ Node.js $(node -v) detected"

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo "❌ npm is not installed. Please install npm first."
    exit 1
fi

echo "✅ npm $(npm -v) detected"

# Install dependencies
echo ""
echo "📦 Installing dependencies..."
npm install

if [ $? -ne 0 ]; then
    echo "❌ Failed to install dependencies. Please check the error above."
    exit 1
fi

echo "✅ Dependencies installed successfully"

# Create data directory if it doesn't exist
if [ ! -f "trading-data.json" ]; then
    echo ""
    echo "📁 Creating initial data file..."
    echo '{"wallets":[],"tradingPairs":[],"portfolio":{}}' > trading-data.json
    echo "✅ Initial data file created"
fi

# Check if config file exists
if [ ! -f "config.js" ]; then
    echo "❌ Configuration file not found. Please ensure config.js exists."
    exit 1
fi

echo ""
echo "🚀 Bot is ready to start!"
echo ""
echo "To start the trading bot, run:"
echo "   npm start"
echo ""
echo "Or for development mode with auto-restart:"
echo "   npm run dev"
echo ""
echo "📖 For detailed instructions, see README.md"
echo "⚙️  Customize settings in config.js"
echo ""
echo "⚠️  IMPORTANT: Make sure you have:"
echo "   - A Worldcoin wallet with private key"
echo "   - Some ETH for gas fees"
echo "   - Some WLD tokens for trading"
echo ""
echo "🌍 Happy Trading on WorldChain!"