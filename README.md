# 🤖 ALGORITMIT - Worldchain Machine Learning Trading Bot

**The most advanced AI-powered trading bot for Worldchain with machine learning capabilities.**

## 🚀 Quick Installation

### One-Line Install (Recommended)
```bash
curl -fsSL https://raw.githubusercontent.com/romerodevv/psgho/main/install-algoritmit.sh | bash
```

### Manual Installation
```bash
git clone https://github.com/romerodevv/psgho.git
cd psgho
npm install
./install-holdstation-sdk.sh
cp .env.example .env
# Edit .env with your settings
node worldchain-trading-bot.js
```

## ✨ New Features - ALGORITMIT v3.0

### 🤖 Machine Learning Trading Strategy
- **Linear Regression Models**: Predicts price movements based on historical trends
- **Pattern Recognition**: Identifies bullish, bearish, and neutral market patterns
- **Automated Learning**: Continuously improves from market data
- **Risk-Adjusted Trading**: Position sizing based on confidence and volatility
- **Real-time Adaptation**: Models retrain automatically every 24 hours

### 🧠 AI-Powered Decision Making
- **Multi-Signal Analysis**: Combines multiple ML algorithms for trading decisions
- **Confidence Scoring**: Only trades when AI is highly confident (configurable 50-95%)
- **Feature Engineering**: Extracts technical indicators automatically
- **Pattern Memory**: Learns from successful and failed trades

### 📊 Advanced Analytics
- **ML Accuracy Tracking**: Monitor prediction performance in real-time
- **Training Data Visualization**: See how much data the AI has learned from
- **Performance Metrics**: Win rate, profit/loss, and model effectiveness
- **Learning Progress**: Track AI improvement over time

## 🎯 Core Features

### 💹 Trading Capabilities
- **HoldStation SDK Integration**: Native Worldchain DEX support
- **Uniswap V3 Fallback**: Backup trading infrastructure
- **Multi-Wallet Support**: Manage multiple trading wallets
- **Token Discovery**: Automatic detection of wallet holdings
- **Slippage Protection**: Configurable slippage limits

### 🏗️ Strategy Builder
- **Custom DIP/Profit Strategies**: Create personalized trading rules
- **Price History Analysis**: Compare prices across different timeframes
- **SMA Integration**: Simple Moving Average-based trading signals
- **Profit Range Selling**: Sell portions at different profit levels
- **Console Commands**: Quick trade execution via command line

### 🎯 Price Triggers & Automation
- **Background Price Monitoring**: Continuous price tracking for all tokens
- **Trigger-Based Trading**: Execute trades based on price conditions
- **Historical Comparisons**: Trade based on 5min, 1hr, 6hr, 24hr, 7-day data
- **Smart Notifications**: Alerts for significant price movements

## 🛡️ Safety & Risk Management

### 🔒 Built-in Safety Features
- **Learning Mode**: AI learns without trading for 24+ hours first
- **Position Limits**: Configurable maximum position sizes
- **Confidence Thresholds**: Only trade with high-confidence predictions
- **Stop Loss Protection**: Automatic loss prevention
- **Manual Override**: Disable auto-trading anytime

### 📋 Recommended Safety Protocol
1. **Phase 1 (Days 1-2)**: Enable Learning Mode only
2. **Phase 2 (Days 3-7)**: Start auto-trading with 0.01 WLD positions  
3. **Phase 3 (Days 8+)**: Scale up gradually based on performance

## ⚙️ Configuration

### Environment Variables (.env)
```env
# Wallet Configuration
PRIVATE_KEY_1=your_private_key_here
WALLET_NAME_1=Main Trading Wallet

# RPC Configuration
WORLDCHAIN_RPC_URL=https://worldchain-mainnet.g.alchemy.com/public
ALCHEMY_API_KEY=your_alchemy_api_key

# ALGORITMIT ML Settings
ML_CONFIDENCE_THRESHOLD=75        # 50-95% (higher = fewer but better trades)
ML_MAX_POSITION_SIZE=0.1          # Maximum WLD per trade
ML_LEARNING_MODE=true             # Start with learning only
ML_AUTO_TRADING=false             # Enable after learning period
```

### ALGORITMIT Parameters
- **Confidence Threshold**: 70%+ for high confidence trades
- **Max Position Size**: Start with 0.01-0.1 WLD
- **Risk Tolerance**: 1-20% position adjustment
- **Learning Period**: 50-500 data points for training

## 📊 Usage Guide

### Getting Started with ALGORITMIT

1. **Launch the Bot**
   ```bash
   ./start-algoritmit.sh
   ```

2. **Access ALGORITMIT Menu**
   - Main Menu → Option 7 (🤖 ALGORITMIT)

3. **Enable Learning Mode**
   - Select "1. Enable/Disable ALGORITMIT" → Enable
   - Select "2. Configure Learning Mode" → Enable
   - Let it run for 24-48 hours

4. **Monitor ML Statistics**
   - Select "4. View ML Statistics"
   - Wait for 60%+ accuracy before auto-trading

5. **Enable Auto-Trading (Carefully!)**
   - Select "3. Configure Auto-Trading Mode"
   - Type "CONFIRM" to enable
   - Start with minimal position sizes

### Key Menu Options

#### Main Features
- **🏠 Wallet Management**: Create, import, and manage wallets
- **🔍 Token Discovery**: Find tokens in your wallets automatically
- **📈 Trading Operations**: Execute manual trades with enhanced routing
- **🎯 Strategy Management**: Traditional DIP/profit strategies
- **🏗️ Strategy Builder**: Custom trading strategies
- **🎯 Price Triggers**: Automated buy/sell based on price conditions
- **🤖 ALGORITMIT**: Machine learning trading system ⭐ NEW!

#### ALGORITMIT Submenu
- **Enable/Disable**: Turn the AI trading system on/off
- **Learning Mode**: Configure data collection and training
- **Auto-Trading**: Enable/disable automated trade execution
- **ML Statistics**: View AI performance and accuracy
- **Parameters**: Configure confidence, position sizes, risk tolerance
- **Active Positions**: Monitor AI-managed trades
- **Model Retraining**: Force model updates with new data
- **Tutorial**: Complete guide to ML trading

## 🔧 Advanced Features

### Console Commands
Quick trade execution via command line interface:
```bash
buy YIELD 0.10 d15 p15    # Buy YIELD with 0.10 WLD, 15% DIP, 15% profit
buy YIELD 0.10            # Immediate buy with 0.10 WLD
sell YIELD all            # Sell all YIELD tokens
buy YIELD 1h              # Buy at best rate from last hour
```

### Service Management
Run as a background service:
```bash
# Using PM2
npm install -g pm2
pm2 start worldchain-trading-bot.js --name "algoritmit-bot"

# Using systemd (advanced)
./create-service.sh
sudo systemctl enable algoritmit-bot
sudo systemctl start algoritmit-bot
```

## 📚 Documentation

### Complete Guides
- **[ALGORITMIT_GUIDE.md](ALGORITMIT_GUIDE.md)**: Comprehensive ML trading guide
- **[INSTALL_ALGORITMIT.md](INSTALL_ALGORITMIT.md)**: Detailed installation instructions
- **In-App Tutorial**: ALGORITMIT menu → option 8

### API References
- **HoldStation SDK**: Primary DEX integration for Worldchain
- **Ethers.js v6**: Blockchain interaction library
- **Alchemy API**: Portfolio and balance management

## ⚠️ Important Disclaimers

### Financial Risks
- **Real Money Trading**: This bot uses real cryptocurrency
- **No Profit Guarantees**: Past performance doesn't predict future results
- **Market Volatility**: Crypto markets are highly volatile
- **Start Small**: Always begin with amounts you can afford to lose

### Technical Considerations
- **Beta Software**: May contain bugs or unexpected behavior
- **Machine Learning Limitations**: AI predictions can be wrong
- **Internet Dependency**: Requires stable internet connection
- **Continuous Monitoring**: Regular supervision recommended

## 🆘 Troubleshooting

### Common Issues

**Low ML Accuracy**
- Solution: Let it learn longer (48+ hours)
- Check: Price database is running and collecting data

**No Auto-Trades Executing**
- Check: Confidence threshold not too high (try 70%)
- Verify: Auto-trading mode is enabled
- Confirm: Sufficient WLD balance in wallet

**"Cannot find module" Errors**
```bash
npm install
./install-holdstation-sdk.sh
```

**HoldStation SDK Issues**
```bash
npm install @holdstation/worldchain-sdk@latest
npm install @holdstation/worldchain-ethers-v6@latest
```

### Performance Optimization
- **VPS Hosting**: Better connectivity and uptime
- **4GB+ RAM**: Recommended for ML processing
- **SSD Storage**: Faster data access for AI models

## 🤝 Contributing

### Development Setup
```bash
git clone https://github.com/romerodevv/psgho.git
cd psgho
npm install
npm run dev
```

### Areas for Contribution
- **ML Model Improvements**: Better prediction algorithms
- **UI/UX Enhancements**: Improved user interface
- **Strategy Templates**: Pre-built trading strategies
- **Documentation**: Guides and tutorials
- **Testing**: Bug reports and fixes

## 📈 Roadmap

### Planned Features
- **Deep Learning Models**: Neural networks for complex patterns
- **Sentiment Analysis**: Social media and news integration
- **Multi-Timeframe Analysis**: Different prediction horizons
- **Portfolio Optimization**: Advanced risk management
- **Strategy Sharing**: Community strategy marketplace

### Community Features
- **Performance Leaderboards**: Compare AI performance
- **Strategy Templates**: Share successful configurations
- **Collaborative Learning**: Crowd-sourced pattern recognition

## 📞 Support

### Getting Help
1. **Documentation**: Check guides and tutorials first
2. **GitHub Issues**: Report bugs or request features
3. **Discussions**: Community support and tips
4. **In-App Help**: Built-in tutorials and guides

### Safety Reminders
- **Start with Learning Mode** for 24+ hours minimum
- **Use tiny amounts** (0.01 WLD) when first testing auto-trading
- **Monitor closely** during the first week of operation
- **Never invest** more than you can afford to lose completely

---

## 🚀 Quick Start Checklist

- [ ] Install ALGORITMIT bot using one-line installer
- [ ] Configure `.env` file with your wallet and RPC settings
- [ ] Launch bot and go to ALGORITMIT menu (option 7)
- [ ] Enable ALGORITMIT strategy
- [ ] Turn on Learning Mode and let it run 24+ hours
- [ ] Monitor ML accuracy until it reaches 60%+
- [ ] Enable auto-trading with 0.01 WLD max position
- [ ] Set confidence threshold to 75%
- [ ] Monitor performance daily for first week
- [ ] Scale up gradually based on results

**Ready to start your AI trading journey? Install now and let machine learning optimize your Worldchain trading!**

---

*⚠️ Trading cryptocurrency involves substantial risk of loss. This software is provided "as is" without warranties. Always trade responsibly and never risk more than you can afford to lose.*