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
