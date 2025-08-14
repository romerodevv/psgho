# 🌍 WorldChain Trading Bot - Cocoliso Premium Edition

## 💎 Installation Guide

Welcome to **Cocoliso Premium** - the most advanced WorldChain trading bot with HoldStation SDK integration, professional-grade features, and enterprise-level tools.

---

## 🚀 Quick Installation

### Option 1: One-Command Installation (Recommended)

```bash
# Download and extract Cocoliso Premium
wget https://github.com/romerodevv/psgho/raw/main/worldchain-bot-cocoliso.tar.gz
tar -xzf worldchain-bot-cocoliso.tar.gz
cd worldchain-bot-cocoliso

# Run the premium installer
./cocoliso-install.sh
```

### Option 2: Manual Installation

```bash
# Clone from repository
git clone https://github.com/romerodevv/psgho.git
cd psgho

# Run Cocoliso installer
chmod +x cocoliso-install.sh
./cocoliso-install.sh
```

---

## 📋 System Requirements

- **Node.js**: v18.0+ (automatically installed if missing)
- **npm**: v8.0+ (comes with Node.js)
- **Operating System**: Linux, macOS, Windows (WSL)
- **Memory**: 2GB+ RAM recommended
- **Storage**: 1GB+ free space
- **Network**: Stable internet connection

---

## 🎯 Installation Process

The installer performs these steps automatically:

### Step 1: System Check ✅
- Verifies Node.js and npm installation
- Installs missing dependencies
- Checks Git availability

### Step 2: Premium Components 💎
- Installs all Node.js dependencies
- Integrates HoldStation SDK
- Configures WorldCoin MiniKit
- Sets up premium trading libraries

### Step 3: Helper Scripts 🛠️
Creates 10 professional helper scripts:
- `start-cocoliso.sh` - Launch the bot
- `test-cocoliso.sh` - Run test suite
- `wallet-manager.sh` - Wallet management
- `trading-analyzer.sh` - Trading analysis
- `portfolio-tracker.sh` - Portfolio monitoring
- `strategy-optimizer.sh` - Strategy optimization
- `market-scanner.sh` - Market scanning
- `backup-manager.sh` - Backup management
- `update-cocoliso.sh` - Auto updates
- `uninstall-cocoliso.sh` - Clean removal

### Step 4: Configuration 🔧
- Creates premium `.env` configuration
- Sets up optimized RPC endpoints
- Configures HoldStation SDK settings
- Enables security features

### Step 5: Verification ✅
- Tests HoldStation SDK integration
- Verifies all components
- Creates documentation
- Confirms installation success

---

## 🌟 What's Included

### 💎 Premium Features
- ✅ **HoldStation SDK Integration** - Native Worldchain DEX
- ✅ **Sinclave Enhanced Trading** - Proven patterns from sinclave.js
- ✅ **Advanced Portfolio Management** - Multi-wallet support
- ✅ **Professional Analytics** - Performance metrics
- ✅ **MEV Protection** - Sandwich attack prevention
- ✅ **Gas Optimization** - Cost-effective transactions
- ✅ **Automatic Backup System** - Data protection
- ✅ **Real-time Market Scanner** - Opportunity detection
- ✅ **Strategy Optimization** - AI-powered trading
- ✅ **Multi-DEX Support** - HoldStation, ZeroX, HoldSo

### 🛠️ Professional Tools
- **10 Helper Scripts** - Complete toolkit
- **Automatic Updates** - Latest features delivered
- **Backup Management** - Secure data protection
- **Configuration Manager** - Easy setup
- **Test Suite** - Verify functionality
- **Documentation** - Complete guides

### 📊 Trading Capabilities
- **WLD/ORO Pairs** - Primary trading focus
- **Custom Token Support** - Any token with liquidity
- **Multi-Wallet Trading** - Portfolio diversification
- **Strategy Automation** - Hands-off trading
- **Risk Management** - Advanced protection

---

## ⚡ Quick Start

After installation:

### 1. Configure Settings
```bash
nano .env
# Add your API keys and preferences
```

### 2. Start Cocoliso Premium
```bash
./start-cocoliso.sh
```

### 3. Run Tests (Optional)
```bash
./test-cocoliso.sh
```

### 4. Explore Features
```bash
ls -la *.sh  # See all available tools
```

---

## 🔧 Configuration

### Essential Settings (.env file)

```bash
# RPC Endpoints
PRIMARY_RPC_URL=https://worldchain-mainnet.g.alchemy.com/public
ALCHEMY_API_KEY=your_alchemy_key_here

# Trading Settings
DEFAULT_SLIPPAGE=0.5
DEFAULT_GAS_LIMIT=280000

# Security Features
ENABLE_MEV_PROTECTION=true
ENABLE_SLIPPAGE_PROTECTION=true
```

### Token Addresses (Pre-configured)
- **WLD**: `0x2cfc85d8e48f8eab294be644d9e25c3030863003`
- **ORO**: `0xcd1E32B86953D79a6AC58e813D2EA7a1790cAb63`
- **Custom**: `0x1a16f733b813a59815a76293dac835ad1c7fedff`

---

## 📱 Usage Examples

### Basic Trading
```bash
# Start the bot
./start-cocoliso.sh

# Navigate to: Trading Operations > Sinclave Enhanced Trade
# Select wallet, token pair, and amount
# Execute trade with HoldStation SDK
```

### Portfolio Management
```bash
# Check portfolio
./portfolio-tracker.sh

# Manage wallets
./wallet-manager.sh

# Analyze trades
./trading-analyzer.sh
```

### Advanced Features
```bash
# Scan markets
./market-scanner.sh

# Optimize strategies
./strategy-optimizer.sh

# Create backups
./backup-manager.sh
```

---

## 🛡️ Security Features

### MEV Protection
- Sandwich attack prevention
- Front-running protection
- Slippage monitoring

### Data Security
- Automatic backups
- Encrypted wallet storage
- Secure API handling

### Transaction Safety
- Pre-flight validation
- Liquidity checks
- Gas optimization

---

## 🔄 Updates & Maintenance

### Automatic Updates
```bash
./update-cocoliso.sh
```

### Manual Backup
```bash
./backup-manager.sh
```

### Clean Uninstall
```bash
./uninstall-cocoliso.sh
```

---

## 🆘 Troubleshooting

### Installation Issues

**Problem**: Node.js not found
```bash
# Solution: Install Node.js manually
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs
```

**Problem**: Permission denied
```bash
# Solution: Make script executable
chmod +x cocoliso-install.sh
```

**Problem**: Dependencies fail
```bash
# Solution: Clear npm cache
npm cache clean --force
rm -rf node_modules
npm install
```

### Runtime Issues

**Problem**: HoldStation SDK error
```bash
# Solution: Reinstall SDK
npm install @holdstation/worldchain-sdk@latest
npm install @holdstation/worldchain-ethers-v6@latest
```

**Problem**: No liquidity found
```bash
# Solution: Use liquidity checker
# Go to Trading Operations > Check Pair Liquidity
# Or run: ./test-cocoliso.sh
```

---

## 📞 Support

### Documentation
- `COCOLISO_README.md` - Complete feature guide
- `HOLDSTATION_SDK_GUIDE.md` - SDK integration details
- Helper script documentation in each `.sh` file

### Community
- GitHub Issues: Report bugs and request features
- Telegram: Join WorldChain trading community
- Discord: Get real-time help

### Professional Support
- Priority troubleshooting
- Custom configuration
- Advanced strategy development

---

## 🏆 Why Choose Cocoliso Premium?

### 1. **Battle-Tested** 🛡️
- Based on successful sinclave.js patterns
- Proven HoldStation SDK integration
- Real-world trading validation

### 2. **Professional Grade** 💼
- Enterprise-level features
- Advanced security measures
- Performance optimization

### 3. **User-Friendly** 👥
- Intuitive interface
- Comprehensive helpers
- Detailed documentation

### 4. **Profitable** 💰
- Optimized trading algorithms
- MEV protection
- Gas cost minimization

### 5. **Future-Proof** 🚀
- Automatic updates
- Expandable architecture
- Community-driven development

---

## 📈 Success Metrics

After successful installation, you should see:

✅ **HoldStation SDK**: Fully integrated and functional  
✅ **Trading Pairs**: WLD/ORO and custom tokens working  
✅ **Helper Scripts**: 10 professional tools available  
✅ **Test Results**: All tests passing  
✅ **Documentation**: Complete guides accessible  

---

## 🎉 Welcome to Cocoliso Premium!

**You're now ready to experience the future of Worldchain trading.**

🌍 **Professional Trading Made Simple**  
💎 **Enterprise Features for Everyone**  
🚀 **Your Gateway to Profitable DeFi Trading**

---

*Cocoliso Premium - Where Innovation Meets Profitability* 🌟