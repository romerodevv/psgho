# 🌍 WorldChain Interactive Trading Bot

A fully interactive, high-speed trading bot for Worldcoin (WLD) with advanced wallet management, token discovery, and automated trading capabilities.

## ✨ Features

### 🚀 **High-Speed Trading**
- Optimized RPC endpoints for fastest execution
- Cached SDK components for improved performance
- Proven routing fixes from successful transactions
- Optimized gas settings for cost efficiency

### 💰 **Wallet Management**
- **Add Wallets**: Import wallets using private keys
- **Remove Wallets**: Securely remove wallets from the system
- **View Wallets**: Display all wallets with balances and token counts
- **Auto-Scan**: Automatically discover tokens in newly added wallets

### 🔄 **Trading Pairs**
- **Auto-Discovery**: Automatically add trading pairs when tokens are discovered
- **Manual Addition**: Add custom trading pairs by entering contract addresses
- **WLD-Centric**: All trading pairs use WLD as the base token (WLD-ORO, WLD-YIELD, etc.)
- **Status Management**: Enable/disable trading pairs as needed

### 📊 **Portfolio Management**
- **Real-time Updates**: Automatic portfolio updates every 5 minutes
- **Token Discovery**: Automatically scan and add discovered tokens
- **Balance Tracking**: Monitor ETH and token balances across all wallets
- **Portfolio Summary**: Comprehensive overview of all holdings

### 🎯 **Trading Features**
- **Bidirectional Swaps**: WLD ↔ Token and Token ↔ WLD
- **Quote System**: Get swap quotes before executing trades
- **Quick Swap**: Fast WLD to ORO swaps
- **Slippage Control**: Customizable slippage tolerance
- **Gas Optimization**: Automatic gas optimization for cost efficiency

### 🔍 **Token Discovery**
- **Automatic Scanning**: Scan all wallets for tokens
- **Contract Validation**: Validate token contracts before adding
- **Auto-Integration**: Automatically add discovered tokens to trading pairs
- **Token Information**: Display token names, symbols, and decimals

## 🛠️ Installation

### Prerequisites
- Node.js 16+ 
- npm or yarn
- Worldcoin wallet with private key

### Setup
1. **Clone/Download** the project files
2. **Install Dependencies**:
   ```bash
   npm install
   ```
3. **Start the Bot**:
   ```bash
   npm start
   ```

## 🚀 Usage

### Starting the Bot
```bash
npm start
```

The bot will display a beautiful interactive menu with all available options.

### Main Menu Options

#### 💰 **Wallet Management**
- **Add New Wallet**: Import a wallet using its private key
- **Remove Wallet**: Securely remove wallets from the system
- **View Wallets**: See all wallets with balances and token counts
- **Scan Wallet**: Manually scan a wallet for tokens

#### 🔄 **Trading Pairs**
- **Add Trading Pair**: Add new pairs by entering contract addresses
- **Remove Trading Pair**: Remove unwanted trading pairs
- **View Trading Pairs**: See all configured pairs with status
- **Toggle Status**: Enable/disable trading pairs

#### 📊 **Portfolio Overview**
- **View All Portfolios**: Detailed view of all wallet portfolios
- **Update All Portfolios**: Manually refresh all portfolio data
- **Portfolio Summary**: High-level overview of total holdings

#### 🚀 **Execute Trade**
- **Swap WLD → Token**: Trade WLD for other tokens
- **Swap Token → WLD**: Trade other tokens for WLD
- **Get Quote**: Get swap quotes without executing trades

#### ⚡ **Quick Swap (WLD)**
- Fast WLD to ORO swaps with minimal configuration
- Perfect for quick trades

#### 🔍 **Token Discovery**
- **Scan All Wallets**: Automatically scan all wallets for tokens
- **Scan Specific Wallet**: Scan a particular wallet
- **View Discovered Tokens**: See all discovered tokens

#### ⚙️ **Settings**
- **RPC Configuration**: View current RPC endpoints
- **Trading Settings**: View trading parameters
- **Auto-Update Settings**: View automatic update configurations

## 🔧 Configuration

### RPC Endpoints
- **Primary**: `https://worldchain-mainnet.g.alchemy.com/public`
- **Fallback**: `https://worldchain-mainnet.g.alchemy.com/v2/7MFAWnvGmZk3tDjmofyx6`
- **Chain ID**: 480 (WorldChain)

### Trading Parameters
- **Default Slippage**: 0.5%
- **Default Fee**: 0.2%
- **Gas Limit**: 280,000 (optimized)
- **WLD Address**: `0x2cFc85d8E48F8EAB294be644d9E25C3030863003`

### Auto-Updates
- **Portfolio Updates**: Every 5 minutes
- **Token Discovery**: Automatic on wallet operations
- **Trading Pair Updates**: Automatic on token discovery

## 📁 Data Storage

The bot automatically saves all data to `trading-data.json`:
- Wallet information (encrypted private keys)
- Trading pairs configuration
- Portfolio data and token balances
- Last update timestamps

## 🚨 Security Features

- **Private Key Encryption**: Secure storage of wallet credentials
- **Input Validation**: Comprehensive validation of all inputs
- **Error Handling**: Graceful error handling and recovery
- **Transaction Verification**: Verify all transactions before execution

## ⚡ Performance Optimizations

### Speed Improvements
- **Cached SDK**: Pre-loaded and cached SDK components
- **Optimized RPC**: Fastest available RPC endpoints
- **Efficient Scanning**: Batch operations for multiple wallets
- **Smart Caching**: Intelligent caching of frequently accessed data

### Gas Optimization
- **Proven Gas Settings**: Gas parameters from successful transactions
- **Dynamic Adjustment**: Automatic gas adjustment based on network conditions
- **Priority Fee Optimization**: Minimal priority fees for cost efficiency

## 🔄 Trading Workflow

1. **Add Wallet**: Import your Worldcoin wallet
2. **Auto-Discovery**: Bot automatically discovers tokens
3. **Trading Pairs**: Auto-created for discovered tokens
4. **Execute Trades**: Swap WLD ↔ Tokens with optimized routing
5. **Portfolio Updates**: Automatic balance and token updates

## 📊 Example Trading Pairs

- **WLD-ORO**: Worldcoin to ORO token
- **WLD-YIELD**: Worldcoin to YIELD token
- **WLD-[TOKEN]**: Automatically created for discovered tokens

## 🛡️ Error Handling

The bot includes comprehensive error handling:
- **Network Issues**: Automatic fallback to backup RPC
- **Transaction Failures**: Detailed error reporting and recovery
- **Invalid Inputs**: Input validation with helpful error messages
- **SDK Errors**: Graceful degradation and retry mechanisms

## 🔧 Troubleshooting

### Common Issues
1. **RPC Connection Failed**: Bot automatically uses fallback endpoint
2. **SDK Initialization Error**: Check network connectivity and retry
3. **Transaction Failed**: Verify wallet balance and gas settings
4. **Token Not Found**: Ensure contract address is valid and on WorldChain

### Support
- Check console output for detailed error messages
- Verify wallet has sufficient ETH for gas fees
- Ensure trading pairs are active before executing trades

## 📈 Monitoring

### Real-time Updates
- Portfolio balances update every 5 minutes
- Transaction status monitoring
- Gas price tracking
- Network health monitoring

### Logging
- Comprehensive transaction logging
- Error tracking and reporting
- Performance metrics
- User action logging

## 🎯 Best Practices

1. **Start Small**: Begin with small trade amounts to test
2. **Monitor Gas**: Keep an eye on gas prices for optimal timing
3. **Regular Updates**: Let the bot auto-update portfolios
4. **Secure Storage**: Keep your trading data file secure
5. **Backup Wallets**: Always have backup wallet access

## 🔮 Future Enhancements

- **Price Charts**: Real-time price visualization
- **Trading Strategies**: Automated trading strategies
- **Mobile Interface**: Mobile app for remote monitoring
- **API Integration**: External API for portfolio tracking
- **Advanced Analytics**: Detailed trading performance metrics

## 📄 License

MIT License - Feel free to modify and distribute

## ⚠️ Disclaimer

This trading bot is for educational and personal use. Trading cryptocurrencies involves risk. Always:
- Test with small amounts first
- Understand the risks involved
- Never invest more than you can afford to lose
- Keep your private keys secure

---

**🌍 Happy Trading on WorldChain! 🚀**