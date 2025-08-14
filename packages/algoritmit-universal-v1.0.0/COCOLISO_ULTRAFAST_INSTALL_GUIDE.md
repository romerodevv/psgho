# 🚀 Cocoliso Premium Ultra-Fast Edition v2.1 - Installation Guide

## 🎯 What's New in Ultra-Fast Edition

### ⚡ ULTRA-FAST EXECUTION (70%+ Speed Improvement)
- **Before**: 11+ seconds execution time
- **Now**: <3 seconds execution time
- **Improvement**: 70%+ faster trading

### 🎨 COLOR-CODED MONITORING
- **Green**: Profitable positions (P&L ≥ 0%)
- **Red**: Losing positions (P&L < 0%)
- **Easy visual tracking** of your trading performance

### ⚙️ FLEXIBLE CONFIGURATION
- **Stop Loss**: -99% to +99% (previously limited to -50% to 0%)
- **Profit Target**: 0.01% to 999% (previously limited to 1% to 100%)
- **DIP Threshold**: 0.1% to 99% (more flexible ranges)

### 🏗️ STRATEGY BUILDER
- Create custom DIP buying strategies
- Set individual profit targets per token
- Automated trading based on price drops

## 📋 System Requirements

- **Node.js**: Version 18 or higher
- **npm**: Latest version
- **git**: For easy installation
- **OS**: Linux, macOS, or Windows WSL
- **RAM**: Minimum 2GB available
- **Network**: Stable internet connection

## 🚀 Quick Installation (Recommended)

### Option 1: One-Command Install
```bash
curl -fsSL https://raw.githubusercontent.com/romerodevv/psgho/main/cocoliso-premium-install.sh | bash
```

### Option 2: Manual Download and Install
```bash
# Download the installer
wget https://raw.githubusercontent.com/romerodevv/psgho/main/cocoliso-premium-install.sh

# Make it executable
chmod +x cocoliso-premium-install.sh

# Run the installer
./cocoliso-premium-install.sh
```

## 📁 Manual Installation

If you prefer manual installation:

```bash
# 1. Create installation directory
mkdir -p ~/cocoliso-premium-ultrafast
cd ~/cocoliso-premium-ultrafast

# 2. Clone the repository
git clone https://github.com/romerodevv/psgho.git .

# 3. Install dependencies
npm install

# 4. Install HoldStation SDK
npm install @holdstation/worldchain-sdk@latest
npm install @holdstation/worldchain-ethers-v6@latest
npm install @worldcoin/minikit-js@latest

# 5. Setup configuration
cp .env.example .env
nano .env  # Edit with your settings
```

## ⚙️ Configuration Setup

### 1. Edit the `.env` file:
```bash
nano .env
```

### 2. Required Settings:
```env
# Your wallet private key (keep this secure!)
PRIVATE_KEY=your_private_key_here

# RPC endpoints for Worldchain
WORLDCHAIN_RPC_URL=https://worldchain-mainnet.g.alchemy.com/v2/YOUR_API_KEY
BACKUP_RPC_URL=https://worldchain-mainnet.g.alchemy.com/public

# Alchemy API key for portfolio tracking
ALCHEMY_API_KEY=your_alchemy_api_key

# Token addresses (pre-configured for Worldchain)
WLD_TOKEN_ADDRESS=0x2cfc85d8e48f8eab294be644d9e25c3030863003
```

### 3. Optional Advanced Settings:
```env
# Gas optimization (for ultra-fast execution)
DEFAULT_GAS_PRICE=0.002
PRIORITY_FEE=0.0005
SPEED_BOOST_PERCENTAGE=25

# Performance settings
MAX_SLIPPAGE=1
CONFIRMATION_BLOCKS=1
RETRY_DELAY_MS=500
```

## 🏃‍♂️ Running the Bot

### Start the Bot:
```bash
cd ~/cocoliso-premium-ultrafast
node worldchain-trading-bot.js
```

### Background Operation:
```bash
# Run in background with logging
nohup node worldchain-trading-bot.js > bot.log 2>&1 &

# Check if running
ps aux | grep worldchain-trading-bot

# View logs
tail -f bot.log
```

### Using Screen (Recommended for Servers):
```bash
# Start a screen session
screen -S cocoliso-bot

# Run the bot
node worldchain-trading-bot.js

# Detach: Ctrl+A, then D
# Reattach: screen -r cocoliso-bot
```

## 🎯 Ultra-Fast Features Guide

### 1. **Enhanced Trading (Option 1)**
- Uses HoldStation SDK for optimal routing
- Single confirmation waits
- 25% gas price boost for priority
- Target: <3 seconds execution

### 2. **Color-Coded Monitoring**
```
📊 Position status:
   💰 Entry: 0.1 WLD → 38.036 tokens
   📈 Current: 38.036 tokens → 0.102 WLD
   🟢📊 P&L: +0.002 WLD (+2.1%)     ← GREEN = Profit
   🔴📊 P&L: -0.000804 WLD (-0.80%) ← RED = Loss
```

### 3. **Flexible Configuration**
- **Stop Loss**: Set any value from -99% to +99%
- **Profit Target**: Set from 0.01% to 999%
- **DIP Threshold**: Set from 0.1% to 99%

### 4. **Performance Feedback**
```
🚀 ULTRA-FAST EXECUTION: 2847ms - EXCELLENT!  (< 3 seconds)
⚡ FAST EXECUTION: 4523ms - GOOD              (3-6 seconds)
⏳ STANDARD EXECUTION: 8234ms                 (> 6 seconds)
```

## 📊 Performance Optimization Tips

### 1. **For Maximum Speed**:
- Always use "Enhanced Trade" (option 1)
- Pre-approve tokens to skip approval transactions
- Keep gas settings optimized (default settings are optimized)
- Use stable RPC endpoints

### 2. **Network Optimization**:
- Use primary RPC: `https://worldchain-mainnet.g.alchemy.com/public`
- Backup RPC: Your authenticated Alchemy endpoint
- Monitor network congestion

### 3. **Gas Optimization**:
- Default settings are optimized for speed
- 25% gas boost for priority mining
- Single confirmation waits
- Automatic retry with higher gas

## 🛠️ Troubleshooting

### Common Issues:

#### 1. **"Cannot find module" errors**
```bash
# Reinstall dependencies
rm -rf node_modules package-lock.json
npm install
```

#### 2. **HoldStation SDK errors**
```bash
# Install HoldStation components
npm install @holdstation/worldchain-sdk@latest
npm install @holdstation/worldchain-ethers-v6@latest
npm install @worldcoin/minikit-js@latest
```

#### 3. **Slow execution times**
- Check your RPC endpoint speed
- Verify gas settings in .env
- Ensure you're using "Enhanced Trade"
- Check network congestion

#### 4. **Configuration errors**
```bash
# Reset configuration
cp .env.example .env
nano .env  # Reconfigure
```

### Performance Diagnostics:
```bash
# Check Node.js version
node --version  # Should be 18+

# Check dependencies
npm list

# Test RPC connection
curl -X POST -H "Content-Type: application/json" \
  --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' \
  https://worldchain-mainnet.g.alchemy.com/public
```

## 📈 Monitoring and Logs

### View Real-time Performance:
- The bot shows execution times for each trade
- Color-coded P&L monitoring
- Performance feedback (ULTRA-FAST/FAST/STANDARD)

### Log Files:
```bash
# View current session logs
tail -f bot.log

# Search for specific events
grep "ULTRA-FAST" bot.log
grep "P&L:" bot.log
grep "ERROR" bot.log
```

## 🔄 Updating to Latest Version

### Automatic Update:
```bash
cd ~/cocoliso-premium-ultrafast
git pull origin main
npm install  # Install any new dependencies
```

### Clean Reinstall:
```bash
# Backup your .env file
cp .env ~/.env.backup

# Remove old installation
rm -rf ~/cocoliso-premium-ultrafast

# Run installer again
curl -fsSL https://raw.githubusercontent.com/romerodevv/psgho/main/cocoliso-premium-install.sh | bash

# Restore configuration
cp ~/.env.backup ~/cocoliso-premium-ultrafast/.env
```

## 🔐 Security Best Practices

### 1. **Private Key Security**:
- Never share your private keys
- Keep .env file secure (chmod 600 .env)
- Never commit .env to git
- Use separate wallets for trading

### 2. **System Security**:
```bash
# Set proper file permissions
chmod 600 .env
chmod 755 *.js
chmod +x *.sh
```

### 3. **Network Security**:
- Use VPN if on public networks
- Monitor for unusual activity
- Keep system updated

## 📞 Support

### Documentation:
- **Performance Guide**: `PERFORMANCE_OPTIMIZATIONS.md`
- **Strategy Guide**: `STRATEGY_GUIDE.md`
- **API Reference**: `API_DOCUMENTATION.md`

### GitHub Repository:
- **Main**: https://github.com/romerodevv/psgho
- **Issues**: Report bugs and request features
- **Releases**: Download specific versions

### Quick Help:
```bash
# Check bot status
ps aux | grep worldchain

# View recent logs
tail -20 bot.log

# Test configuration
node -e "require('dotenv').config(); console.log('Config loaded successfully');"
```

---

## 🎉 Ready to Trade!

Your Cocoliso Premium Ultra-Fast Edition is now ready to deliver:
- **⚡ <3 second execution times**
- **🎨 Color-coded profit/loss tracking**  
- **⚙️ Flexible configuration options**
- **🏗️ Custom strategy building**

**Happy Ultra-Fast Trading!** 🚀

---

*Last updated: Version 2.1 - Ultra-Fast Edition*