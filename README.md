# 🌍 WorldChain Trading Bot

An advanced, fully interactive trading bot for Worldchain with ATM-style interface, featuring wallet management, automatic token discovery, and high-speed WLD pair trading.

## 🚀 Features

### 💼 Wallet Management
- **Create New Wallets**: Generate secure wallets with private keys
- **Import Existing Wallets**: Import wallets using private keys
- **Wallet Operations**: List, remove, and check balances of all wallets
- **Multi-Wallet Support**: Manage multiple wallets simultaneously
- **Balance Tracking**: Real-time ETH and WLD balance monitoring

### 🔍 Token Discovery & Portfolio
- **Automatic Token Discovery**: Scan wallets for existing tokens
- **Manual Token Addition**: Add tokens by contract address
- **Portfolio Tracking**: Real-time portfolio value calculation
- **Token Information**: Fetch name, symbol, decimals automatically
- **WLD Pair Creation**: Automatically create WLD trading pairs

### 📈 Trading Operations
- **Interactive Trading**: Select wallet, pair, and execute trades
- **WLD-Based Pairs**: All trading pairs are WLD-based (WLD-ORO, WLD-YIELD, etc.)
- **High-Speed Mode**: Automated high-frequency trading capabilities
- **Price Monitoring**: Real-time price tracking and alerts
- **Trade History**: Complete transaction history with details

### ⚙️ Configuration
- **Trading Settings**: Configurable slippage tolerance and trading parameters
- **Gas Configuration**: Customizable gas price and limits
- **Auto-Discovery**: Automated token discovery settings
- **Persistent Storage**: All settings saved locally

### 🎨 User Interface
- **ATM-Style Interface**: Intuitive menu-driven navigation
- **Colorful CLI**: Beautiful terminal interface with colors and emojis
- **Real-time Feedback**: Live updates and progress indicators
- **Error Handling**: Comprehensive error messages and recovery

## 📋 Requirements

- **Node.js**: Version 16.0.0 or higher
- **NPM**: Latest version
- **Internet Connection**: For blockchain interactions
- **Terminal**: Command line interface

## 🛠️ Installation

1. **Clone or Download** the project files
2. **Install Dependencies**:
   ```bash
   npm install
   ```
3. **Make Executable** (Optional):
   ```bash
   chmod +x worldchain-trading-bot.js
   ```

## 🚀 Usage

### Start the Bot
```bash
npm start
```

Or run directly:
```bash
node worldchain-trading-bot.js
```

### Main Menu Options

1. **💼 Wallet Management**
   - Create new wallets
   - Import existing wallets
   - View wallet list and balances
   - Remove wallets

2. **🔍 Token Discovery & Portfolio**
   - Discover tokens in all wallets
   - Add tokens by contract address
   - View discovered tokens
   - Portfolio summary

3. **📈 Trading Operations**
   - Execute trades
   - View trading pairs
   - High-speed trading mode
   - Price monitoring
   - Trade history

4. **⚙️ Configuration**
   - Trading settings
   - Gas configuration
   - Auto-discovery settings

5. **📊 Portfolio Overview**
   - Complete portfolio summary
   - Total value calculation
   - Token distribution

## 🔐 Security Features

- **Local Storage**: All data stored locally in JSON files
- **Private Key Protection**: Secure private key handling
- **Input Validation**: Comprehensive input validation
- **Error Recovery**: Graceful error handling and recovery

## 📁 File Structure

```
worldchain-trading-bot/
├── worldchain-trading-bot.js    # Main bot application
├── package.json                 # Dependencies and scripts
├── README.md                   # This file
├── config.json                 # Bot configuration (auto-created)
├── wallets.json               # Wallet storage (auto-created)
└── discovered_tokens.json     # Token storage (auto-created)
```

## 🌐 Worldchain Integration

### Network Configuration
- **RPC Endpoint**: Worldchain Mainnet
- **Chain ID**: Worldchain Layer 2
- **WLD Token**: Primary trading token
- **DEX Integration**: Uniswap V3 compatible

### Trading Pairs
All trading pairs are WLD-based:
- WLD-ORO
- WLD-YIELD
- WLD-[ANY_TOKEN]

## ⚡ High-Speed Trading

The bot includes high-frequency trading capabilities:
- **Rapid Execution**: Sub-second trade execution
- **Market Monitoring**: Real-time price movement analysis
- **Automated Strategies**: Configurable trading algorithms
- **Risk Management**: Built-in risk controls

## 🔧 Configuration Options

### Trading Settings
- **Slippage Tolerance**: Default 0.5%
- **Trading Enabled**: Enable/disable trading
- **Gas Price**: Configurable gas price in Gwei
- **Gas Limit**: Maximum gas limit per transaction

### Auto-Discovery
- **Enable/Disable**: Automatic token discovery
- **Refresh Interval**: Token discovery frequency
- **Portfolio Updates**: Automatic balance updates

## 📊 Token Discovery

The bot automatically discovers tokens by:
1. Scanning wallet transactions
2. Checking token balances
3. Fetching token metadata
4. Creating WLD trading pairs
5. Adding to portfolio tracking

## 🎯 Use Cases

- **DeFi Trading**: Automated DeFi token trading
- **Portfolio Management**: Multi-wallet portfolio tracking
- **Token Discovery**: Automatic new token detection
- **High-Frequency Trading**: Professional trading operations
- **Yield Farming**: Automated yield optimization

## ⚠️ Disclaimers

- **Educational Purpose**: This bot is for educational and research purposes
- **Risk Warning**: Trading cryptocurrencies involves risk
- **Private Keys**: Keep your private keys secure and never share them
- **Testing**: Test with small amounts before large trades
- **No Guarantees**: No guarantee of profits or performance

## 🐛 Troubleshooting

### Common Issues

1. **Network Connection**
   - Check internet connection
   - Verify RPC endpoint accessibility

2. **Gas Errors**
   - Increase gas price in configuration
   - Check wallet ETH balance for gas fees

3. **Token Not Found**
   - Verify contract address
   - Check if token exists on Worldchain

4. **Transaction Failed**
   - Check wallet balance
   - Verify trading pair liquidity

## 🔄 Updates and Maintenance

The bot automatically:
- Saves configuration changes
- Updates wallet balances
- Discovers new tokens
- Maintains transaction history

## 📞 Support

For issues or questions:
1. Check the troubleshooting section
2. Verify your configuration
3. Test with small amounts first
4. Review error messages carefully

## 🎉 Getting Started

1. **Install** the dependencies
2. **Run** the bot: `npm start`
3. **Create** your first wallet
4. **Add** some tokens or let auto-discovery find them
5. **Start** trading with WLD pairs!

---

**Happy Trading on Worldchain! 🌍💰**