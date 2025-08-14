# 🌍 WorldChain Trading Bot - Novice Installation Guide

## 📖 What is this?

This is an **automated trading bot** for WorldChain that:
- ✅ Tracks your trades automatically
- ✅ Sells when you reach profit targets (like 1% gain)
- ✅ Protects you with stop losses
- ✅ Finds good buying opportunities
- ✅ Works 24/7 in the background

## 🎯 Super Simple Installation (3 Steps!)

### Step 1: Download and Extract

1. **Download** the `worldchain-bot-novice.tar.gz` file
2. **Extract** it on your Linux server:
   ```bash
   tar -xzf worldchain-bot-novice.tar.gz
   cd worldchain-bot-novice
   ```

### Step 2: Run the Auto-Installer

```bash
# Just run this one command - it does everything!
./auto-install.sh
```

**That's it!** The installer will:
- ✅ Install Node.js automatically
- ✅ Install all dependencies
- ✅ Set up the bot
- ✅ Create a desktop-like menu
- ✅ Configure everything for you

### Step 3: Start Trading

```bash
# Start the bot
./start-bot.sh
```

## 🎮 How to Use (Beginner Friendly)

### First Time Setup (5 minutes)

1. **Start the bot**: `./start-bot.sh`
2. **Create a wallet**: 
   - Choose "1. Wallet Management"
   - Choose "1. Create New Wallet"
   - Give it a name like "My Trading Wallet"
   - **IMPORTANT**: Save the private key somewhere safe!

3. **Add some tokens**:
   - Choose "2. Token Discovery"
   - Choose "2. Add Token by Contract Address"
   - Enter a token address (like ORO or YIELD token)

4. **Configure strategy**:
   - Choose "4. Strategy Management" 
   - Choose "5. Strategy Configuration"
   - Set profit target (recommend: 1% for beginners)
   - Set stop loss (recommend: -3% for safety)

### Start Automated Trading

1. **Start the strategy**: 
   - Choose "4. Strategy Management"
   - Choose "1. Start Strategy"

2. **Make your first trade**:
   - Choose "4. Execute Strategic Trade"
   - Select your wallet
   - Select a token
   - Enter amount (start small, like 1-5 WLD)

3. **Watch it work**:
   - The bot will monitor prices every 5 seconds
   - When profit target is hit, it sells automatically
   - You'll see real-time updates

## 💡 Beginner Tips

### Safe Settings for New Users
```
Profit Target: 1% (sell when you make 1% profit)
Stop Loss: -3% (sell if you lose 3% to protect you)
Max Position: 10 WLD (don't risk too much)
Price Check: 5 seconds (check prices often)
```

### What Each Menu Does

**1. Wallet Management** 📱
- Like your crypto wallet app
- Create wallets, check balances
- Import existing wallets

**2. Token Discovery** 🔍
- Finds tokens in your wallet automatically
- Add new tokens to trade
- See your portfolio

**3. Trading Operations** 📈
- Manual trading (like normal exchanges)
- View prices and trading pairs
- Check trade history

**4. Strategy Management** 🎯 ⭐ **MOST IMPORTANT**
- This is the "auto-pilot" mode
- Set profit targets and stop losses
- Monitor automatic trades
- Configure how aggressive the bot is

**5. Configuration** ⚙️
- Advanced settings (usually don't need to change)
- Gas fees and slippage settings

**6. Portfolio Overview** 📊
- See all your money and tokens
- Total value and performance

## 🔐 Security for Beginners

### Keep These Safe
- ✅ Your wallet private keys (write them down!)
- ✅ Your `.env` file (has your settings)
- ✅ Never share private keys with anyone

### Start Safe
- ✅ Begin with `ENABLE_REAL_TRADING=false` (practice mode)
- ✅ Use small amounts (1-10 WLD) when starting
- ✅ Set conservative profit targets (1-2%)
- ✅ Always use stop losses (-3% to -5%)

## 📱 Daily Usage

### Morning Routine (2 minutes)
```bash
# Check if bot is running
./check-status.sh

# View today's performance
./view-profits.sh
```

### Evening Routine (2 minutes)
```bash
# Check positions
./start-bot.sh
# Choose "4. Strategy Management" → "3. View Positions"

# Create backup
./backup.sh
```

## 🆘 Help! Something's Wrong

### Bot Won't Start
```bash
# Try this fix
./fix-permissions.sh
./start-bot.sh
```

### Can't See My Tokens
```bash
# Refresh token discovery
./start-bot.sh
# Choose "2. Token Discovery" → "1. Discover Tokens"
```

### Lost Money on a Trade
- This is normal in trading! 
- Check your stop loss settings
- Consider using smaller amounts
- The bot learns from your settings

### Bot Stopped Working
```bash
# Restart everything
./restart-bot.sh

# Check what happened
./view-logs.sh
```

## 📞 Quick Commands Reference

```bash
./start-bot.sh          # Start the main bot
./check-status.sh       # See if bot is running
./view-profits.sh       # See how much you've made
./backup.sh            # Save your data
./restart-bot.sh       # Fix most problems
./view-logs.sh         # See what the bot is doing
./fix-permissions.sh   # Fix file permission errors
```

## 🎯 Example: Your First Trade

Let's say you want to trade WLD for ORO token:

1. **Start bot**: `./start-bot.sh`
2. **Start strategy**: Menu 4 → Option 1
3. **Make trade**: Menu 4 → Option 4
   - Select wallet: "My Trading Wallet"
   - Select token: "ORO" 
   - Amount: "2" (2 WLD)
4. **Wait and watch**: Bot monitors every 5 seconds
5. **Automatic profit**: When ORO goes up 1%, bot sells automatically
6. **Result**: You get back ~2.02 WLD (0.02 WLD profit!)

## 🎉 Success! You're Now a Crypto Trader

Your bot will:
- ✅ Monitor prices 24/7
- ✅ Buy low, sell high automatically  
- ✅ Protect you from big losses
- ✅ Make money while you sleep
- ✅ Send you notifications about trades

## 📚 Want to Learn More?

- Read `README.md` for advanced features
- Check `DEPLOYMENT.md` for technical details
- Join crypto trading communities
- Start with small amounts and learn!

---

**Remember**: 
- 💡 Start small and learn
- 🔒 Keep private keys safe
- 📊 Monitor your bot regularly
- 🎯 Set realistic profit targets

**Happy Trading! 🌍💰🎯**