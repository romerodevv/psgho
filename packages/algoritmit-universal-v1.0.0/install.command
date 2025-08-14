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
