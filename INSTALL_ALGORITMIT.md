# 🤖 ALGORITMIT Trading Bot - Installation Guide

## Quick Installation (Recommended)

### One-Line Install Command
```bash
curl -fsSL https://raw.githubusercontent.com/your-username/worldchain-algoritmit-bot/main/install-algoritmit.sh | bash
```

## Manual Installation

### Prerequisites
- **Linux/macOS** (Ubuntu 20.04+ recommended)
- **Node.js 18+** (Node.js 20+ preferred)
- **Git** installed
- **Minimum 4GB RAM** for ML processing
- **Stable internet connection**

### Step 1: Install Node.js (if not installed)
```bash
# Ubuntu/Debian
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

# macOS with Homebrew
brew install node

# Verify installation
node --version  # Should be 18.0.0 or higher
npm --version
```

### Step 2: Clone the Repository
```bash
git clone https://github.com/your-username/worldchain-algoritmit-bot.git
cd worldchain-algoritmit-bot
```

### Step 3: Install Dependencies
```bash
# Install Node.js dependencies
npm install

# Install HoldStation SDK (for Worldchain trading)
chmod +x install-holdstation-sdk.sh
./install-holdstation-sdk.sh
```

### Step 4: Configure Environment
```bash
# Copy environment template
cp .env.example .env

# Edit configuration (use nano, vim, or any text editor)
nano .env
```

### Step 5: Configure Your Settings
Edit the `.env` file with your details:

```env
# Wallet Configuration
PRIVATE_KEY_1=your_private_key_here
WALLET_NAME_1=Main Trading Wallet

# RPC Configuration  
WORLDCHAIN_RPC_URL=https://worldchain-mainnet.g.alchemy.com/public
ALCHEMY_API_KEY=your_alchemy_api_key_here

# Trading Configuration
WLD_TOKEN_ADDRESS=0x2cfc85d8e48f8eab294be644d9e25C3030863003
DEFAULT_SLIPPAGE=1.0
MAX_GAS_PRICE=50

# ALGORITMIT ML Settings
ML_CONFIDENCE_THRESHOLD=75
ML_MAX_POSITION_SIZE=0.1
ML_LEARNING_MODE=true
ML_AUTO_TRADING=false
```

### Step 6: Start the Bot
```bash
node worldchain-trading-bot.js
```

## 🚀 Quick Start with ALGORITMIT

### Phase 1: Learning Mode (Days 1-2)
1. **Launch the bot**: `node worldchain-trading-bot.js`
2. **Go to ALGORITMIT menu**: Select option 7
3. **Enable ALGORITMIT**: Select option 1, choose 'y'
4. **Enable Learning Mode**: Select option 2, choose 'y'
5. **Let it learn**: Keep running for 24-48 hours

### Phase 2: Testing (Days 3-7)
1. **Check ML accuracy**: Select option 4 (aim for 60%+)
2. **Enable auto-trading**: Select option 3, type "CONFIRM"
3. **Start small**: Set max position to 0.01 WLD
4. **Monitor closely**: Check statistics daily

### Phase 3: Scaling (Days 8+)
1. **Review performance**: Check win rate and profits
2. **Gradually increase**: Raise position sizes if profitable
3. **Optimize settings**: Adjust confidence threshold
4. **Run autonomously**: Let ALGORITMIT trade automatically

## 🔧 Configuration Options

### ALGORITMIT Parameters
- **Confidence Threshold**: 50-95% (recommended: 75%)
- **Max Position Size**: 0.01-10 WLD (start with 0.01)
- **Risk Tolerance**: 1-20% (recommended: 5%)
- **Learning Period**: 50-500 data points (recommended: 100)

### Safety Settings
- **Always start with Learning Mode only**
- **Use minimal position sizes initially**
- **Monitor performance for first week**
- **Disable auto-trading if losses occur**

## 📊 Monitoring Your Bot

### Key Statistics to Watch
- **ML Accuracy**: Should be 60%+ before auto-trading
- **Win Rate**: Target 55%+ for profitable trading
- **Total Profit/Loss**: Track cumulative performance
- **Active Positions**: Monitor open trades

### Daily Checks
1. **View ML Statistics** (ALGORITMIT menu → option 4)
2. **Check Active Positions** (ALGORITMIT menu → option 6)
3. **Review Portfolio** (Main menu → option 9)

## 🛠️ Troubleshooting

### Common Issues

#### "Cannot find module 'ethers'"
```bash
npm install ethers@^6.0.0
```

#### "HoldStation SDK unavailable"
```bash
./install-holdstation-sdk.sh
npm install @holdstation/worldchain-sdk@latest
```

#### Low ML Accuracy
- Let the bot learn longer (48+ hours)
- Ensure price database is running
- Check that tokens are being discovered

#### No Auto-Trades Executing
- Verify confidence threshold isn't too high
- Confirm auto-trading mode is enabled
- Check WLD balance in wallet

### Performance Optimization
```bash
# For better performance, consider:
# 1. Running on a VPS with good connectivity
# 2. Using PM2 for process management
npm install -g pm2
pm2 start worldchain-trading-bot.js --name "algoritmit-bot"
pm2 save
pm2 startup
```

## 🔒 Security Best Practices

### Wallet Security
- **Never share private keys**
- **Use dedicated trading wallets**
- **Start with small amounts**
- **Regular security audits**

### System Security
```bash
# Update system regularly
sudo apt update && sudo apt upgrade

# Use firewall
sudo ufw enable
sudo ufw allow 22  # SSH only if needed

# Run as non-root user
sudo useradd -m algoritmit
sudo su algoritmit
```

## 📈 Advanced Features

### Running as a Service
```bash
# Create systemd service
sudo nano /etc/systemd/system/algoritmit-bot.service

[Unit]
Description=ALGORITMIT Trading Bot
After=network.target

[Service]
Type=simple
User=algoritmit
WorkingDirectory=/home/algoritmit/worldchain-algoritmit-bot
ExecStart=/usr/bin/node worldchain-trading-bot.js
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target

# Enable and start service
sudo systemctl daemon-reload
sudo systemctl enable algoritmit-bot
sudo systemctl start algoritmit-bot

# Check status
sudo systemctl status algoritmit-bot
```

### Log Monitoring
```bash
# View real-time logs
sudo journalctl -u algoritmit-bot -f

# View recent logs
sudo journalctl -u algoritmit-bot -n 50
```

## 🆘 Support & Resources

### Documentation
- **ALGORITMIT Guide**: `ALGORITMIT_GUIDE.md`
- **README**: `README.md`
- **In-App Tutorial**: ALGORITMIT menu → option 8

### Getting Help
1. **Check logs** for error messages
2. **Review documentation** for configuration
3. **Start with Learning Mode** to understand the system
4. **Use minimal amounts** when testing

### Community
- **GitHub Issues**: Report bugs and request features
- **Discussions**: Share strategies and tips
- **Wiki**: Community-maintained guides

## ⚠️ Important Disclaimers

### Financial Risk
- **Trading involves risk** of financial loss
- **Start with small amounts** you can afford to lose
- **No guarantees** of profit
- **Past performance** doesn't predict future results

### Technical Risk
- **Beta software** - may contain bugs
- **Machine learning** predictions can be wrong
- **Market volatility** can cause unexpected losses
- **Always monitor** your positions

---

## 🚀 Quick Commands Reference

```bash
# Installation
git clone https://github.com/your-username/worldchain-algoritmit-bot.git
cd worldchain-algoritmit-bot
npm install
./install-holdstation-sdk.sh

# Configuration
cp .env.example .env
nano .env

# Run
node worldchain-trading-bot.js

# Service Management (Advanced)
pm2 start worldchain-trading-bot.js --name "algoritmit-bot"
pm2 logs algoritmit-bot
pm2 restart algoritmit-bot
```

**Ready to start? Run the one-line installer and begin your machine learning trading journey!**

---

*Remember: ALGORITMIT is a powerful AI trading system, but it requires patience, monitoring, and responsible risk management. Always start small and scale gradually.*