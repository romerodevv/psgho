# 📱 ALGORITMIT Telegram Notifications Guide

## 🎯 Overview

ALGORITMIT now includes **comprehensive Telegram notifications** to keep you updated on your trading positions in real-time, even when you're away from your computer!

## 🚀 Features

### 📊 **Real-time Position Updates**
- Position profit/loss changes
- Entry and current prices
- Unrealized P&L tracking
- Strategy performance

### 💹 **Trade Execution Alerts**
- Buy trade confirmations
- Sell trade confirmations
- Gas usage and execution time
- Profit/loss on completed trades

### 🎯 **Smart Profit & Loss Alerts**
- **Profit Alerts**: Notifications when positions reach 10%+ profit
- **Loss Alerts**: Warnings when positions drop 5%+ in value
- **Position Updates**: Regular updates for significant price movements

### 📈 **Strategy Notifications**
- Strategy start/stop notifications
- Custom strategy execution alerts
- ALGORITMIT ML trading updates
- Daily performance reports

### 🔔 **Price Alerts**
- Custom price target notifications
- DIP opportunity alerts
- Market movement warnings

---

## 🛠️ Setup Instructions

### 📱 **Step 1: Create a Telegram Bot**

1. **Open Telegram** and search for `@BotFather`
2. **Send `/newbot`** command
3. **Choose a name** for your bot (e.g., "My ALGORITMIT Bot")
4. **Choose a username** (must end with "bot", e.g., "myalgoritmit_bot")
5. **Copy the bot token** (looks like: `123456789:ABCdefGHIjklMNOpqrsTUVwxyz`)

### 💬 **Step 2: Get Your Chat ID**

1. **Start a chat** with your new bot
2. **Send any message** to the bot
3. **Visit**: `https://api.telegram.org/bot<YOUR_BOT_TOKEN>/getUpdates`
4. **Look for** `"chat":{"id": YOUR_CHAT_ID`
5. **Copy the chat ID** (a number like: `123456789`)

### ⚙️ **Step 3: Configure ALGORITMIT**

Add these lines to your `.env` file:

```bash
# Telegram Notifications
TELEGRAM_BOT_TOKEN=123456789:ABCdefGHIjklMNOpqrsTUVwxyz
TELEGRAM_CHAT_ID=123456789
```

### 🔄 **Step 4: Restart ALGORITMIT**

```bash
# Stop current instance
Ctrl+C

# Restart
node worldchain-trading-bot.js
```

---

## 🎮 Using Telegram Notifications

### 📋 **Main Menu Access**

1. Launch ALGORITMIT
2. Select **"8. 📱 Telegram Notifications"**
3. Configure your preferences

### 🔧 **Available Options**

#### **1. 🔧 Setup Telegram Bot**
- Step-by-step setup guide
- Troubleshooting help
- Configuration verification

#### **2. 📊 Test Notifications**
- Send test message to verify connection
- Check bot token and chat ID
- Confirm notifications are working

#### **3. ⚙️ Notification Settings**
- **Position Updates**: Enable/disable position tracking
- **Trade Executions**: Enable/disable trade alerts
- **Profit Alerts**: Configure profit notification threshold
- **Loss Alerts**: Configure loss warning threshold
- **Strategy Updates**: Enable/disable strategy notifications
- **Price Alerts**: Enable/disable price movement alerts
- **Minimum Interval**: Set notification frequency (default: 5 minutes)

#### **4. 🟢 Enable Notifications**
- Activate Telegram notifications
- Test connection automatically
- Start receiving alerts

#### **5. 🔴 Disable Notifications**
- Temporarily disable all notifications
- Keep configuration for later use

#### **6. 📈 Send Position Status**
- Manual position status update
- Current P&L for all positions
- Real-time portfolio snapshot

#### **7. 📊 Send Daily Report**
- Comprehensive trading summary
- Success rate and total P&L
- Active strategies overview

#### **8. 💬 Send Custom Message**
- Send custom messages to test
- Verify bot is responding
- Manual communication

---

## 📨 Notification Types

### 🟢 **Buy Trade Executed**
```
🟢 TRADE EXECUTED

💹 BOUGHT 0x1234...
💰 Amount: 0.100000 WLD
💱 Received: 37.234567 tokens
💸 Price: 0.00268432 WLD per token
⛽ Gas Used: 234567
⏱️ Execution Time: 2340ms

🕐 2024-01-15 14:30:25
```

### 🔴 **Sell Trade Executed**
```
🔴 TRADE EXECUTED

💹 SOLD 0x1234...
💰 Amount: 37.234567 tokens
💱 Received: 0.105432 WLD
💸 Price: 0.00283156 WLD per token
⛽ Gas Used: 198765
⏱️ Execution Time: 1890ms

🕐 2024-01-15 16:45:12
```

### 📈 **Position Update**
```
📈 POSITION UPDATE

🪙 0x1234...
📊 Entry Price: 0.00268432 WLD
📊 Current Price: 0.00295678 WLD
💰 Amount: 37.234567 tokens
🟢 P&L: +10.15%
💹 Unrealized: +0.010143 WLD

🕐 2024-01-15 17:20:08
```

### 🚀 **Profit Alert**
```
🚀 PROFIT ALERT!

🪙 0x1234...
🎉 Profit: +15.25%
📊 Entry: 0.00268432 WLD
📊 Current: 0.00309234 WLD
💰 Value: 0.115234 WLD
💹 Gain: +0.015234 WLD

🎯 Consider taking profits!
🕐 2024-01-15 18:10:33
```

### ⚠️ **Loss Alert**
```
⚠️ LOSS ALERT!

🪙 0x1234...
📉 Loss: -8.45%
📊 Entry: 0.00268432 WLD
📊 Current: 0.00245678 WLD
💰 Value: 0.091456 WLD
💸 Loss: -0.008544 WLD

🛡️ Consider stop loss!
🕐 2024-01-15 19:25:17
```

### 📊 **Daily Report**
```
📊 DAILY TRADING REPORT

📈 Total Trades: 12
✅ Successful: 9
❌ Failed: 3
📊 Success Rate: 75.0%
💰 Total P&L: +0.045678 WLD
📊 Open Positions: 3
🎯 Active Strategies: 2

📅 Mon Jan 15 2024
```

---

## ⚙️ Configuration Options

### 🔧 **Notification Settings**

| Setting | Default | Description |
|---------|---------|-------------|
| Position Updates | ✅ Enabled | Real-time position tracking |
| Trade Executions | ✅ Enabled | Buy/sell trade confirmations |
| Profit Alerts | ✅ Enabled | Notifications at 10%+ profit |
| Loss Alerts | ✅ Enabled | Warnings at 5%+ loss |
| Strategy Updates | ✅ Enabled | Strategy start/stop/execution |
| Price Alerts | ✅ Enabled | Custom price target alerts |
| Minimum Interval | 5 minutes | Rate limiting between similar notifications |
| Profit Threshold | 5% | Minimum profit change for notifications |
| Loss Threshold | -10% | Maximum loss before alert |

### 🎛️ **Customization**

You can customize notification thresholds in the menu:

1. Go to **"3. ⚙️ Notification Settings"**
2. Adjust thresholds:
   - **Profit Threshold**: 1% - 50% (when to send profit alerts)
   - **Loss Threshold**: -1% to -50% (when to send loss warnings)
   - **Notification Interval**: 1-60 minutes (rate limiting)

---

## 🛡️ Security & Privacy

### 🔒 **Bot Security**
- Your bot token is private - never share it
- Only you can send commands to your bot
- Messages are encrypted by Telegram

### 📱 **Chat Privacy**
- Only your chat ID receives notifications
- Bot cannot read your other Telegram messages
- No personal data is stored by the bot

### ⚙️ **Configuration Security**
- Bot token stored in `.env` file (not committed to git)
- Local configuration only
- No data sent to external servers

---

## 🔧 Troubleshooting

### ❌ **"Telegram not configured"**
- Check `.env` file has `TELEGRAM_BOT_TOKEN` and `TELEGRAM_CHAT_ID`
- Restart ALGORITMIT after adding credentials
- Use **"Setup Telegram Bot"** menu for help

### ❌ **"Failed to send test message"**
- Verify bot token is correct (no extra spaces)
- Ensure you sent at least one message to the bot first
- Check chat ID is a number (not username)

### ❌ **"Bot token is incorrect"**
- Copy token exactly from @BotFather
- Include the full token including the colon
- Remove any quotes around the token in `.env`

### ❌ **"Chat not found"**
- Send `/start` command to your bot first
- Get chat ID from the correct API endpoint
- Use numeric chat ID, not username

### 🔄 **Not receiving notifications**
- Check notification settings are enabled
- Verify minimum interval hasn't blocked notifications
- Test with **"Send Custom Message"** option

---

## 🎯 Best Practices

### 📊 **Notification Management**
- Start with default settings and adjust as needed
- Use higher thresholds for less frequent notifications
- Enable daily reports for comprehensive overviews

### 🔔 **Alert Optimization**
- Set profit alerts at meaningful levels (5-10%+)
- Configure loss alerts for risk management (-5% to -10%)
- Use position updates for active monitoring

### 📱 **Mobile Trading**
- Pin your ALGORITMIT bot chat for quick access
- Enable Telegram notifications on your phone
- Use custom messages to communicate with your bot

### 🛡️ **Risk Management**
- Pay attention to loss alerts immediately
- Use profit alerts to consider taking profits
- Monitor daily reports for strategy performance

---

## 🆕 Advanced Features

### 🤖 **ALGORITMIT Integration**
- ML trading notifications
- Model retraining alerts
- Confidence level updates
- Auto-trading confirmations

### 🎯 **Strategy Notifications**
- Custom strategy execution alerts
- DIP buying opportunity notifications
- Profit range selling confirmations
- Price trigger activations

### 📈 **Performance Tracking**
- Real-time P&L updates
- Success rate notifications
- Best performing strategy alerts
- Portfolio value changes

---

## 🎉 Getting Started Checklist

- [ ] Create Telegram bot with @BotFather
- [ ] Get bot token and chat ID
- [ ] Add credentials to `.env` file
- [ ] Restart ALGORITMIT
- [ ] Test notifications in menu
- [ ] Configure notification preferences
- [ ] Enable notifications
- [ ] Start trading with real-time updates!

---

## 🆘 Support

If you need help with Telegram notifications:

1. **Use the built-in setup guide** in the menu
2. **Test notifications** to verify configuration
3. **Check troubleshooting section** above
4. **Review your `.env` file** for correct formatting

**Happy Trading with Real-time Updates!** 📱💹🚀