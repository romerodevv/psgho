# 🚀 ALGORITMIT v3.1 - Telegram Edition Quick Start

## ⚡ Ultra-Fast Installation

### 1️⃣ **One-Line Install (Linux/macOS)**
```bash
curl -fsSL https://raw.githubusercontent.com/romerodevv/psgho/main/packages/algoritmit-telegram-v3.1-complete/install-telegram-edition.sh | bash
```

### 2️⃣ **Manual Installation**
```bash
# Download and extract
wget https://github.com/romerodevv/psgho/archive/main.zip
unzip main.zip
cd psgho-main/packages/algoritmit-telegram-v3.1-complete/

# Run installer
chmod +x install-telegram-edition.sh
./install-telegram-edition.sh
```

### 3️⃣ **Configure & Start**
```bash
# 1. Edit configuration
nano .env

# 2. Start ALGORITMIT
./start-algoritmit.sh

# OR start CLI version
./start-cli.sh
```

---

## 🆕 **What's New in v3.1**

### 📱 **Telegram Notifications**
- Real-time position updates
- Trade execution alerts
- Profit/loss notifications
- Daily performance reports
- Custom message support

### 🛡️ **Enhanced Reliability**
- Fixed HoldStation SDK errors (404/400)
- Multiple price source fallbacks
- Automatic error recovery
- Health monitoring system
- Self-healing token cleanup

### 🎯 **Fixed Price Triggers**
- Complete Price Triggers menu implementation
- Buy/sell automation triggers
- Price-based and percentage-based triggers
- Quick command interface
- Telegram integration

### ⚡ **CLI Interface**
- Standalone command-line interface
- Headless server operation
- Scriptable trading commands
- Real-time position tracking

---

## ⚙️ **Essential Configuration**

### **Required (.env file)**
```bash
# Wallet Configuration
PRIVATE_KEY=your_private_key_here
RPC_URL=https://worldchain-mainnet.g.alchemy.com/v2/your-api-key

# Trading Settings
PROFIT_TARGET=1.0
DIP_BUY_THRESHOLD=1.0
MAX_SLIPPAGE=1.0
```

### **Optional - Telegram Notifications**
```bash
# Get these from @BotFather on Telegram
TELEGRAM_BOT_TOKEN=123456789:ABCdefGHIjklMNOpqrsTUVwxyz
TELEGRAM_CHAT_ID=123456789
```

---

## 🎮 **Usage Examples**

### **Full Bot Interface**
```bash
./start-algoritmit.sh
# Navigate to: 8. 📱 Telegram Notifications
# Set up your bot and start receiving alerts!
```

### **CLI Commands**
```bash
./start-cli.sh

# In CLI:
algoritmit> buy ORO 0.1 below 0.005
algoritmit> sell YIELD 100 profit 15
algoritmit> positions
algoritmit> stats
```

### **Price Triggers**
```bash
# In main menu: 6. 🎯 Price Triggers
# Create buy trigger: Buy ORO when price drops 10%
# Create sell trigger: Sell at 15% profit
```

---

## 📊 **Key Features**

| Feature | Description | Status |
|---------|-------------|---------|
| 📱 Telegram Notifications | Real-time trading alerts | ✅ NEW |
| 🎯 Price Triggers | Automated buy/sell orders | ✅ FIXED |
| 🤖 ALGORITMIT ML | Machine learning trading | ✅ Enhanced |
| ⚡ CLI Interface | Command-line trading | ✅ NEW |
| 🛡️ Error Handling | Robust fallback systems | ✅ Improved |
| 📊 Health Monitoring | System status tracking | ✅ NEW |

---

## 🆘 **Troubleshooting**

### **Common Issues**

**❌ "HoldStation SDK errors"**
- ✅ **FIXED in v3.1** - Now uses fallback price sources

**❌ "Price Triggers not working"**  
- ✅ **FIXED in v3.1** - Complete implementation added

**❌ "Telegram not working"**
- Check bot token and chat ID in .env
- Follow TELEGRAM_NOTIFICATIONS_GUIDE.md

**❌ "Node.js errors"**
- Ensure Node.js 18+ is installed
- Run: `./update-algoritmit.sh`

---

## 📚 **Documentation**

- **README.md** - Complete feature overview
- **TELEGRAM_NOTIFICATIONS_GUIDE.md** - Telegram setup guide
- **ALGORITMIT_GUIDE.md** - Machine learning trading
- **CLI_GUIDE.md** - Command-line interface guide

---

## 🔒 **Security First**

- ✅ Never share your private key
- ✅ Start with small test amounts
- ✅ Keep .env file secure
- ✅ Trading involves risk - use responsibly

---

## 🎯 **Perfect For**

- **Active Traders** - Real-time notifications while away
- **DeFi Enthusiasts** - Advanced automation features  
- **Server Operators** - CLI interface for headless operation
- **Risk Managers** - Automated stop losses and profit taking

---

**Start trading smarter with ALGORITMIT v3.1! 🤖📱💹**
