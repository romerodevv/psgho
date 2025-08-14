# 🚀 ALGORITMIT v3.1 - Telegram Edition Installation Guide

## 📱 **Complete Package with All Fixes & Telegram Notifications**

### 🎯 **What's New in v3.1 - Telegram Edition**

✅ **Complete Telegram notifications system** - Real-time trading alerts on your phone  
✅ **Fixed Price Triggers menu** - All "TypeError" issues resolved, fully functional  
✅ **Robust error handling** - HoldStation SDK 404/400 errors handled with fallbacks  
✅ **Multiple price sources** - Automatic fallback to alternative APIs when needed  
✅ **Health monitoring** - System health tracking and automatic cleanup  
✅ **CLI interface** - Command-line interface for headless server operation  
✅ **Enhanced documentation** - Complete guides for all features  

---

## ⚡ **Quick Installation Methods**

### 🚀 **Method 1: One-Line Install (Recommended)**

```bash
# Download and auto-install (Linux/macOS)
curl -fsSL https://raw.githubusercontent.com/romerodevv/psgho/main/packages/algoritmit-telegram-v3.1-complete/install-telegram-edition.sh | bash
```

### 📦 **Method 2: Download Package**

#### **Option A: Direct Download**
```bash
# Download the complete package
wget https://github.com/romerodevv/psgho/archive/main.zip
unzip main.zip
cd psgho-main/packages/algoritmit-telegram-v3.1-complete/

# Run installer
chmod +x install-telegram-edition.sh
./install-telegram-edition.sh
```

#### **Option B: Git Clone**
```bash
# Clone repository
git clone https://github.com/romerodevv/psgho.git
cd psgho/packages/algoritmit-telegram-v3.1-complete/

# Run installer
chmod +x install-telegram-edition.sh
./install-telegram-edition.sh
```

#### **Option C: Compressed Package**
```bash
# Download compressed package
wget https://github.com/romerodevv/psgho/raw/main/packages/algoritmit-telegram-v3.1-complete.tar.gz

# Extract and install
tar -xzf algoritmit-telegram-v3.1-complete.tar.gz
cd algoritmit-telegram-v3.1-complete/
chmod +x install-telegram-edition.sh
./install-telegram-edition.sh
```

---

## 🔧 **Installation Process**

The installer will automatically:

1. **✅ Check system requirements** (Node.js 18+, Git, curl, wget)
2. **📦 Install Node.js** (if not present) - via apt/yum/brew
3. **📦 Install Git** (if not present) - via package manager
4. **🔗 Install dependencies** - npm packages and HoldStation SDK
5. **⚙️ Setup configuration** - Create .env file from template
6. **📝 Create helper scripts** - Start, CLI, and update scripts
7. **🎉 Finalize setup** - Create logs directory and final instructions

### **Installation Output Example:**
```
🚀 ALGORITMIT v3.1 - Telegram Edition Installer
═══════════════════════════════════════════════════

✨ NEW IN v3.1:
📱 Complete Telegram notifications system
🔧 Robust price monitoring with fallbacks
🎯 Fixed Price Triggers menu (fully functional)
🛡️ Enhanced error handling for HoldStation SDK
📊 Health monitoring and automatic cleanup
⚡ CLI interface for headless operation

[STEP 1/8] Checking system requirements...
✅ Operating System: linux
✅ System requirements check passed

[STEP 2/8] Checking Node.js installation...
✅ Node.js found: v20.10.0

[STEP 3/8] Checking Git installation...
✅ Git found: git version 2.34.1

[STEP 4/8] Installing Node.js dependencies...
✅ Core dependencies installed

[STEP 5/8] Installing HoldStation SDK...
✅ HoldStation SDK installed

[STEP 6/8] Setting up configuration...
✅ Created .env file from template

[STEP 7/8] Creating helper scripts...
✅ Helper scripts created

[STEP 8/8] Finalizing installation...
✅ Logs directory created

🎉 ALGORITMIT v3.1 - Telegram Edition Installation Complete!
```

---

## ⚙️ **Configuration**

### **1. Edit .env File (Required)**

After installation, configure your credentials:

```bash
# Edit configuration file
nano .env
```

**Required Settings:**
```bash
# Wallet Configuration
PRIVATE_KEY=your_private_key_here_without_0x
RPC_URL=https://worldchain-mainnet.g.alchemy.com/v2/your-api-key

# Trading Settings
PROFIT_TARGET=1.0
DIP_BUY_THRESHOLD=1.0
MAX_SLIPPAGE=1.0
STOP_LOSS_THRESHOLD=-10.0
```

### **2. Telegram Notifications (Optional)**

For real-time trading alerts on your phone:

```bash
# Add to .env file
TELEGRAM_BOT_TOKEN=123456789:ABCdefGHIjklMNOpqrsTUVwxyz
TELEGRAM_CHAT_ID=123456789
```

**Get Telegram Credentials:**
1. Open Telegram, search for `@BotFather`
2. Send `/newbot` and follow instructions
3. Copy bot token
4. Send message to your bot, then visit: `https://api.telegram.org/bot<TOKEN>/getUpdates`
5. Copy your chat ID from the response

---

## 🚀 **Starting ALGORITMIT**

### **Full Bot Interface**
```bash
./start-algoritmit.sh
```

### **CLI Interface (Headless)**
```bash
./start-cli.sh
```

### **Update Dependencies**
```bash
./update-algoritmit.sh
```

---

## 🎮 **Usage Examples**

### **📱 Setting Up Telegram Notifications**

1. Start ALGORITMIT: `./start-algoritmit.sh`
2. Select: **"8. 📱 Telegram Notifications"**
3. Choose: **"1. 🔧 Setup Telegram Bot"** (follow guide)
4. Choose: **"2. 📊 Test Notifications"** (verify working)
5. Choose: **"4. 🟢 Enable Notifications"**

You'll now receive real-time alerts like:
```
🟢 TRADE EXECUTED

💹 BOUGHT lolo
💰 Amount: 0.100000 WLD
💱 Received: 37.234567 tokens
💸 Price: 0.00268432 WLD per token

🕐 2024-01-15 14:30:25
```

### **🎯 Creating Price Triggers**

1. Select: **"6. 🎯 Price Triggers"**
2. Choose: **"1. Create Buy Trigger"**
3. Set: Buy ORO when price drops 10%
4. Choose: **"2. Create Sell Trigger"**  
5. Set: Sell at 15% profit

### **⚡ Using CLI Commands**

```bash
./start-cli.sh

# In CLI:
algoritmit> buy ORO 0.1 below 0.005     # Buy when price drops
algoritmit> sell YIELD 100 profit 15    # Sell at 15% profit
algoritmit> positions                    # View open positions
algoritmit> stats                        # View statistics
algoritmit> help                         # Show all commands
```

---

## 📊 **Key Features Overview**

| Feature | Description | Status |
|---------|-------------|---------|
| 📱 **Telegram Notifications** | Real-time trading alerts | ✅ **NEW** |
| 🎯 **Price Triggers** | Automated buy/sell orders | ✅ **FIXED** |
| 🤖 **ALGORITMIT ML** | Machine learning trading | ✅ Enhanced |
| ⚡ **CLI Interface** | Command-line trading | ✅ **NEW** |
| 🛡️ **Error Handling** | Robust fallback systems | ✅ **Improved** |
| 📊 **Health Monitoring** | System status tracking | ✅ **NEW** |
| 🔄 **Price Fallbacks** | Multiple price sources | ✅ **NEW** |
| 🧹 **Auto Cleanup** | Self-healing system | ✅ **NEW** |

---

## 🛡️ **Fixed Issues in v3.1**

### **✅ Price Triggers Menu Fixed**
- **Before:** `TypeError: this.createBuyTrigger is not a function`
- **After:** Complete implementation with all trigger types

### **✅ HoldStation SDK Errors Fixed**
- **Before:** 404/400 errors causing price monitoring failures
- **After:** Automatic fallback to alternative price sources

### **✅ Enhanced Error Handling**
- **Before:** System crashes on API errors
- **After:** Graceful fallback and continued operation

### **✅ Telegram Integration**
- **Before:** No mobile notifications
- **After:** Complete real-time alert system

---

## 🆘 **Troubleshooting**

### **Common Issues & Solutions**

#### **❌ "Node.js not found"**
```bash
# Manual Node.js installation
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs
```

#### **❌ "Permission denied"**
```bash
# Fix permissions
chmod +x install-telegram-edition.sh
chmod +x start-algoritmit.sh
chmod +x start-cli.sh
```

#### **❌ ".env file not found"**
```bash
# Copy template
cp .env.example .env
nano .env  # Edit with your credentials
```

#### **❌ "HoldStation SDK errors"**
- ✅ **FIXED in v3.1** - Now automatically uses fallback price sources

#### **❌ "Price Triggers not working"**
- ✅ **FIXED in v3.1** - Complete implementation added

#### **❌ "Telegram not working"**
```bash
# Check configuration
grep TELEGRAM .env
# Should show your bot token and chat ID
```

---

## 📚 **Documentation**

### **Complete Guides Included:**
- **README.md** - Main documentation and features
- **TELEGRAM_NOTIFICATIONS_GUIDE.md** - Complete Telegram setup
- **ALGORITMIT_GUIDE.md** - Machine learning trading guide
- **CLI_GUIDE.md** - Command-line interface documentation
- **QUICK_START_v3.1.md** - Quick start guide for v3.1

### **Helper Scripts:**
- **start-algoritmit.sh** - Start full bot interface
- **start-cli.sh** - Start CLI interface
- **update-algoritmit.sh** - Update all dependencies
- **cli.sh** - Alternative CLI launcher

---

## 🎯 **Perfect For Your Use Case**

Given your **lolo position at +22.14% profit**, v3.1 is perfect because:

✅ **Telegram alerts** - Get notified when lolo hits profit targets  
✅ **Price triggers** - Set automatic sell orders at 25% profit  
✅ **Reliable monitoring** - No more HoldStation errors interrupting tracking  
✅ **Health status** - See system health and token monitoring status  
✅ **CLI access** - Monitor positions from command line  

---

## 🔒 **Security Reminders**

- ✅ **Never share your private key** - Keep .env file secure
- ✅ **Start with small amounts** - Test with minimal funds first
- ✅ **Use strong passwords** - For server access and Telegram
- ✅ **Regular backups** - Backup your configuration
- ✅ **Monitor actively** - Check positions regularly

---

## 📞 **Support & Updates**

### **Getting Help:**
- **Documentation** - Check included guides first
- **GitHub Issues** - Report bugs or request features
- **Telegram Guide** - Follow TELEGRAM_NOTIFICATIONS_GUIDE.md

### **Staying Updated:**
```bash
# Update to latest version
./update-algoritmit.sh

# Check for new releases
git pull origin main
```

---

## 🎉 **Installation Summary**

**ALGORITMIT v3.1 - Telegram Edition** includes:

🚀 **One-command installation** - `curl -fsSL ... | bash`  
📱 **Complete Telegram system** - Real-time mobile alerts  
🎯 **Fixed Price Triggers** - All TypeError issues resolved  
🛡️ **Robust error handling** - Automatic fallbacks and recovery  
⚡ **CLI interface** - Perfect for servers and automation  
📊 **Health monitoring** - System status and auto-cleanup  
📚 **Complete documentation** - Guides for every feature  

**Ready to trade smarter with mobile notifications! 🤖📱💹**

---

*Installation takes 2-5 minutes depending on your system and internet connection.*