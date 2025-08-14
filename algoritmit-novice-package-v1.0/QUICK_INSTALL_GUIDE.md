# 🚀 Quick Install Guide - ALGORITMIT Smart Volatility v4.0

## 📥 One-Line Installation (Recommended)

### For Linux/macOS:
```bash
curl -fsSL https://raw.githubusercontent.com/your-repo/algoritmit-smart-volatility-v4.0/main/install-smart-volatility.sh | bash
```

### For Manual Installation:

1. **Download the package:**
   ```bash
   wget https://github.com/your-repo/algoritmit-smart-volatility-v4.0.tar.gz
   tar -xzf algoritmit-smart-volatility-v4.0.tar.gz
   cd algoritmit-smart-volatility-v4.0
   ```

2. **Run installer:**
   ```bash
   ./install-smart-volatility.sh
   ```

3. **Configure:**
   ```bash
   cd ~/algoritmit-smart-volatility
   nano .env
   ```

4. **Start trading:**
   ```bash
   ./start-bot.sh
   ```

## ⚙️ Essential Configuration

Edit your `.env` file with these required settings:

```env
# Your wallet private key (KEEP SECRET!)
PRIVATE_KEY=your_private_key_here

# Worldchain RPC (use default or your own)
WORLDCHAIN_RPC_URL=https://worldchain-mainnet.g.alchemy.com/public

# Telegram notifications (optional)
TELEGRAM_BOT_TOKEN=your_bot_token
TELEGRAM_CHAT_ID=your_chat_id

# Trading settings
DEFAULT_SLIPPAGE=1.0
GAS_PRICE_MULTIPLIER=1.2
```

## 🎯 Quick Start Strategy

1. **Create your first strategy:**
   - Choose "Strategy Builder" from main menu
   - Set 5% profit target for conservative trading
   - Set 15% DIP threshold
   - Use 0.1 WLD trade amount for testing

2. **Let the smart system work:**
   - Bot analyzes market volatility automatically
   - Adapts buying/selling thresholds in real-time
   - Executes trades when opportunities arise

## 🚨 Important Notes

- **Start with small amounts** (0.05-0.1 WLD) for testing
- **Never share your private key**
- **Monitor your first few trades** to understand behavior
- **The bot auto-sells when profit targets are reached**

## 🆘 Need Help?

- Check `README_SMART_VOLATILITY_v4.0.md` for full documentation
- Common issues are covered in the troubleshooting section
- Test with small amounts first!

**Ready to seize big opportunities in volatile markets!** 🎯