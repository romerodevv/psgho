# 🎓 ALGORITMIT Smart Volatility - Novice Trader Package v1.0
## 📦 Installation Instructions

---

## 🚀 **Quick Start (Recommended for Beginners)**

### **Method 1: Automated Installer (Easiest)**

If you downloaded this package, simply run:

```bash
# Make the installer executable
chmod +x novice-trader-installer.sh

# Run the installer
./novice-trader-installer.sh
```

The installer will:
- ✅ Check your system and install dependencies
- ✅ Set up the trading environment
- ✅ Create educational materials
- ✅ Configure safe default settings
- ✅ Guide you through the setup process

---

## 📋 **Method 2: Manual Installation**

### **Step 1: System Requirements Check**

**Minimum Requirements:**
- Linux (Ubuntu/Debian), macOS, or Windows WSL
- 1GB RAM available
- 500MB free disk space
- Internet connection

### **Step 2: Install Node.js (if not installed)**

**For Linux (Ubuntu/Debian):**
```bash
# Install Node.js v20
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

# Verify installation
node --version  # Should show v20.x.x
npm --version   # Should show 10.x.x
```

**For macOS:**
```bash
# Install using Homebrew
brew install node

# Verify installation
node --version
npm --version
```

### **Step 3: Extract and Setup**

```bash
# Navigate to the package directory
cd algoritmit-novice-package-v1.0

# Install dependencies
npm install --no-optional --legacy-peer-deps

# Copy configuration template
cp .env.example .env
```

### **Step 4: Configure Your Settings**

Edit the `.env` file:
```bash
nano .env
```

**Required Settings:**
```env
# Your wallet's private key (KEEP SECRET!)
PRIVATE_KEY=your_private_key_here

# Worldchain RPC connection
WORLDCHAIN_RPC_URL=https://worldchain-mainnet.g.alchemy.com/public
```

**Optional but Recommended:**
```env
# Telegram notifications (see setup guide below)
TELEGRAM_BOT_TOKEN=your_bot_token
TELEGRAM_CHAT_ID=your_chat_id

# Safe defaults for beginners
DEFAULT_SLIPPAGE=0.5
MAX_TRADE_AMOUNT=0.1
STOP_LOSS_PERCENTAGE=15
```

### **Step 5: Create Startup Scripts**

**Create start script:**
```bash
cat > start-bot.sh << 'EOF'
#!/bin/bash
echo "🎓 Starting ALGORITMIT Smart Volatility - Novice Edition"
echo "🛡️ Safe settings enabled for learning"
echo ""
node worldchain-trading-bot.js
EOF

chmod +x start-bot.sh
```

### **Step 6: Start Trading**

```bash
./start-bot.sh
```

---

## 📱 **Telegram Notifications Setup (Optional)**

### **Step 1: Create Telegram Bot**
1. Open Telegram and message [@BotFather](https://t.me/BotFather)
2. Send `/newbot` and follow instructions
3. Choose a name and username for your bot
4. Copy the bot token (format: `123456789:ABC-DEF1234ghIkl-zyx57W2v1u123ew11`)

### **Step 2: Get Your Chat ID**
1. Message your new bot first (send any message)
2. Visit: `https://api.telegram.org/bot<YOUR_BOT_TOKEN>/getUpdates`
3. Find your chat ID in the response (it's a number like `123456789`)

### **Step 3: Add to Configuration**
Edit your `.env` file:
```env
TELEGRAM_BOT_TOKEN=123456789:ABC-DEF1234ghIkl-zyx57W2v1u123ew11
TELEGRAM_CHAT_ID=123456789
```

### **Step 4: Test Notifications**
```bash
# Test your setup
curl -X POST "https://api.telegram.org/bot<YOUR_BOT_TOKEN>/sendMessage" \
     -d "chat_id=<YOUR_CHAT_ID>&text=🎓 ALGORITMIT Test Message"
```

---

## 🎯 **Beginner's First Strategy**

### **Recommended Settings for Learning:**

```env
# Conservative settings for beginners
DEFAULT_SLIPPAGE=0.5          # Tight slippage (0.5%)
MAX_TRADE_AMOUNT=0.05         # Start with 0.05 WLD (~$1)
STOP_LOSS_PERCENTAGE=15       # Stop loss at 15%
GAS_PRICE_MULTIPLIER=1.1      # Economical gas settings
```

### **Your First Trade Setup:**
1. **Token**: Start with YIELD or ORO (established tokens)
2. **Amount**: 0.05 WLD (about $1-2)
3. **Profit Target**: 5% (conservative)
4. **DIP Threshold**: 15% (standard)

### **What to Expect:**
- Bot monitors price every 30 seconds
- Buys when price drops 15% from recent high
- Auto-sells when 5% profit is reached
- In volatile markets, adapts targets automatically

---

## 🧠 **Understanding Smart Volatility**

### **How the AI Adapts:**

**Normal Market Conditions:**
- 15% price drop → Small buy (0.5x your set amount)
- 5% profit target → Sells at exactly 5%

**Volatile Market Conditions:**
- 30% price drop → Medium buy (1x your set amount)
- 60% price drop → Large buy (1.5x your set amount)
- 5% profit target → Sells at 7.5% (adapts higher)

**Extreme Market Conditions:**
- 90% price drop → Extreme buy (2x your set amount)
- 5% profit target → Sells at 12.5% (much higher)

### **Beginner Protection Features:**
- ✅ Never buys above your average entry price
- ✅ Automatic stop-loss protection
- ✅ Conservative gas settings
- ✅ Maximum trade size limits

---

## 📚 **Educational Materials**

The package includes comprehensive learning materials:

### **Created During Installation:**
- `NOVICE_TRADING_GUIDE.md` - Complete beginner's guide
- `TROUBLESHOOTING.md` - Common issues and solutions
- `setup-help.sh` - Step-by-step configuration help

### **Key Learning Topics:**
1. **Understanding Volatility** - How markets move
2. **Risk Management** - Protecting your capital
3. **Position Sizing** - How much to trade
4. **Market Psychology** - Understanding fear and greed
5. **Scaling Strategies** - Growing as a trader

---

## 🆘 **Troubleshooting Common Issues**

### **❌ "Node.js not found"**
```bash
# Install Node.js
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs
```

### **❌ "npm install fails"**
```bash
# Try with legacy peer deps
npm install --no-optional --legacy-peer-deps
```

### **❌ "Private key invalid"**
- Check format: `PRIVATE_KEY=0x1234567890abcdef...`
- No spaces around the `=` sign
- Private key must start with `0x`

### **❌ "No liquidity available"**
- Try a different token with more volume
- Reduce trade amount: `MAX_TRADE_AMOUNT=0.02`
- Increase slippage: `DEFAULT_SLIPPAGE=1.0`

### **❌ "Bot not trading"**
- Check token has enough liquidity
- Verify DIP threshold isn't too high
- Ensure price movement is sufficient

---

## 🎓 **Learning Path for Beginners**

### **Week 1: Foundation**
- [ ] Complete installation and setup
- [ ] Read `NOVICE_TRADING_GUIDE.md`
- [ ] Make your first 0.05 WLD trade
- [ ] Understand how volatility detection works
- [ ] Set up Telegram notifications

### **Week 2-4: Building Confidence**
- [ ] Increase to 0.1 WLD trades
- [ ] Try different tokens (YIELD, ORO)
- [ ] Experiment with profit targets (5-10%)
- [ ] Learn to read market patterns
- [ ] Track your performance

### **Month 2+: Advanced Features**
- [ ] Create multiple strategies
- [ ] Customize DIP thresholds
- [ ] Use historical price analysis
- [ ] Set up price triggers
- [ ] Scale up position sizes gradually

---

## 🛡️ **Safety Checklist**

Before you start trading:

- [ ] ✅ Using a dedicated wallet with limited funds
- [ ] ✅ Started with small amounts (0.05-0.1 WLD)
- [ ] ✅ Read all educational materials
- [ ] ✅ Configured Telegram notifications
- [ ] ✅ Understand the risk of trading
- [ ] ✅ Set appropriate stop-loss levels
- [ ] ✅ Have a plan for scaling up gradually

---

## 📞 **Getting Help**

### **Built-in Support:**
- Run `./setup-help.sh` for configuration help
- Check `TROUBLESHOOTING.md` for common issues
- Review `NOVICE_TRADING_GUIDE.md` for trading guidance

### **Community Support:**
- **Repository**: https://github.com/romerodevv/psgho
- **Issues**: https://github.com/romerodevv/psgho/issues
- **Discussions**: https://github.com/romerodevv/psgho/discussions

---

## 🎯 **Success Tips**

1. **Start Small**: Begin with 0.05 WLD trades
2. **Learn First**: Understand before scaling up
3. **Monitor Closely**: Watch your first trades
4. **Stay Informed**: Read about the tokens you trade
5. **Be Patient**: Good opportunities take time
6. **Keep Learning**: Each trade teaches something
7. **Stay Safe**: Never risk more than you can afford
8. **Have Fun**: Trading should be exciting, not stressful!

---

## 🎉 **Ready to Start Your AI Trading Journey!**

This package contains everything you need to learn AI-powered trading safely. The smart volatility system will help you understand market dynamics while protecting your capital.

**Remember**: The goal is to LEARN and grow as a trader while the AI handles complex analysis for you!

🎓 **Your AI Trading Education Starts Now!** 🚀📈

---

**Package Version**: ALGORITMIT Smart Volatility v4.0 - Novice Trader Edition v1.0  
**License**: MIT Open Source  
**Support**: https://github.com/romerodevv/psgho