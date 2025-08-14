#!/bin/bash

# ALGORITMIT CLI Launcher
# Quick access to console commands without full bot interface

echo "🚀 Starting ALGORITMIT CLI..."
echo "📝 Console commands ready - no full bot interface needed"
echo ""

# Make sure we're in the right directory
cd "$(dirname "$0")"

# Check if Node.js is available
if ! command -v node >/dev/null 2>&1; then
    echo "❌ Node.js not found. Please install Node.js 18+ first."
    exit 1
fi

# Check if .env exists
if [ ! -f ".env" ]; then
    echo "❌ Configuration file (.env) not found."
    echo "   Please run the full bot first to set up your wallet configuration."
    exit 1
fi

# Start the CLI
node algoritmit-cli.js