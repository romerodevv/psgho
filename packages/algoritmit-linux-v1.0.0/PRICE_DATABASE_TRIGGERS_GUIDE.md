# 📊 PRICE DATABASE & TRIGGERS SYSTEM GUIDE

## 🚀 Overview

Version 2.5 introduces a revolutionary **Background Price Database** and **Automated Triggers System** that transforms your trading bot into a fully automated trading assistant.

## 📊 Background Price Database

### What It Does
- **Automatically tracks prices** for ALL tokens discovered in your wallets
- **Runs 24/7** in the background with 30-second updates
- **Stores 7 days** of price history for each token
- **Calculates SMAs** for 5min, 1h, 6h, 24h, 7day periods
- **Persists data** to disk for recovery after restarts

### How It Works
1. **Auto-Discovery**: When you run token discovery, tokens are automatically added to price tracking
2. **Background Monitoring**: Price database starts automatically when the bot launches
3. **Data Collection**: Every 30 seconds, fetches current prices using HoldStation SDK
4. **SMA Calculations**: Updates moving averages for technical analysis
5. **Storage**: Saves all data to `price-database.json` for persistence

### Accessing Price Data
```
Main Menu → Price Triggers → Price Database Status
```

## 🎯 Price Triggers System

### Trigger Types

#### 1. Buy Triggers
- **Price Drop**: Buy when token drops X% in timeframe
- **Below SMA**: Buy when price is X% below SMA

#### 2. Sell Triggers  
- **Price Rise**: Sell when token rises X% in timeframe
- **Above SMA**: Sell when price is X% above SMA

### Creating Triggers

#### Via Menu Interface
```
Main Menu → Price Triggers → Create Buy/Sell Trigger
```

1. Select wallet
2. Choose token from discovered tokens
3. Pick condition type (price drop/rise, SMA-based)
4. Set threshold percentage
5. Choose timeframe
6. Set trade amount
7. Configure slippage and max executions

#### Via Console Commands
```
Main Menu → Price Triggers → Quick Trigger Commands
```

**Command Format:**
```bash
trigger <action> <token> <condition> <timeframe> <amount>
```

**Examples:**
```bash
# Buy 0.1 WLD worth of YIELD when it drops 30% in 5 minutes
trigger buy YIELD -30% 5min 0.1

# Sell 1000 YIELD when it rises 15% in 1 hour
trigger sell YIELD +15% 1h 1000

# Buy 0.05 WLD worth of YIELD when it's 5% below 1-hour SMA
trigger buy YIELD below_sma 5% 1h 0.05
```

### Trigger Management
```
Main Menu → Price Triggers → Manage Triggers
```

- **View Active Triggers**: See all running triggers
- **Toggle On/Off**: Enable/disable triggers
- **Delete Triggers**: Remove unwanted triggers
- **View Details**: Inspect trigger configuration

## 🛑 Stop Loss System (FIXED!)

### The Problem (Fixed in V2.5)
Previous versions had a floating-point precision bug that prevented exact stop loss triggers.

### The Solution
- Added **0.01% tolerance** to stop loss comparisons
- Now triggers reliably at exact percentages
- **90% stop loss** works perfectly!

### Testing Stop Loss
1. **Configure**: `Main Menu → Strategy Management → Configure Strategy → Stop Loss`
2. **Set Value**: Enter `-90` for 90% stop loss protection
3. **Create Trade**: Use strategic trading to open a position
4. **Monitor**: Watch for `🛑 STOP LOSS TRIGGERED!` message
5. **Verify**: Position closes automatically when loss reaches 90%

## 💡 Usage Scenarios

### 1. Automated DIP Buying
```bash
trigger buy YIELD -25% 5min 0.5
```
**What it does**: Automatically buys 0.5 WLD worth of YIELD when the price drops 25% within any 5-minute period.

**Use case**: Catch sudden price dips for potential quick profits.

### 2. Profit Taking
```bash
trigger sell YIELD +20% 1h 1000
```
**What it does**: Sells 1000 YIELD tokens when the price rises 20% within any 1-hour period.

**Use case**: Lock in profits during price pumps.

### 3. SMA-Based Entry
```bash
trigger buy YIELD below_sma 10% 1h 0.2
```
**What it does**: Buys 0.2 WLD worth of YIELD when the current price is 10% below the 1-hour Simple Moving Average.

**Use case**: Technical analysis-based entries at oversold levels.

### 4. SMA-Based Exit
```bash
trigger sell YIELD above_sma 15% 6h 500
```
**What it does**: Sells 500 YIELD tokens when the price is 15% above the 6-hour SMA.

**Use case**: Exit positions when technically overbought.

## 📈 Advanced Strategies

### 1. Multi-Timeframe Analysis
Create multiple triggers for the same token with different timeframes:
```bash
trigger buy YIELD -15% 5min 0.1    # Quick dip buying
trigger buy YIELD -30% 1h 0.2      # Larger dip buying
trigger sell YIELD +25% 1h 200     # Profit taking
```

### 2. SMA Ladder Strategy
```bash
trigger buy YIELD below_sma 5% 1h 0.1   # Light buying below 1h SMA
trigger buy YIELD below_sma 10% 6h 0.2  # More buying below 6h SMA
trigger sell YIELD above_sma 15% 1h 300 # Sell above 1h SMA
```

### 3. Risk Management
```bash
# Entry triggers
trigger buy YIELD -20% 15min 0.3

# Exit triggers (multiple safety nets)
trigger sell YIELD +30% 1h 1000     # Profit target
trigger sell YIELD -50% 1h 1000     # Emergency stop loss
```

## 🔧 Configuration Options

### Price Database Settings
- **Update Interval**: 30 seconds (configurable in code)
- **History Retention**: 7 days (configurable in code)
- **SMA Periods**: 5min, 1h, 6h, 24h, 7day
- **Storage Location**: `price-database.json`

### Trigger Settings
- **Max Slippage**: Default 2% (configurable per trigger)
- **Max Executions**: Default 1 (configurable per trigger)
- **Timeframes**: 1min, 5min, 15min, 1h, 6h
- **SMA Periods**: 5min, 1h, 6h, 24h, 7day

## 📊 Monitoring & Analytics

### Price Statistics
```
Main Menu → Price Triggers → Price Statistics
```
View comprehensive price data for all tracked tokens:
- Current price
- 24h, 5min, 1h, 6h changes
- SMA values
- Data points collected
- Last update time

### Trigger Status
```
Main Menu → Price Triggers → View Active Triggers
```
Monitor all active triggers:
- Trigger name and conditions
- Execution count
- Creation date
- Last check time

### Database Status
```
Main Menu → Price Triggers → View Price Database Status
```
Check system health:
- Monitoring status (active/stopped)
- Number of tracked tokens
- Active/total triggers
- Total price points
- Last update time

## 🚨 Troubleshooting

### Price Database Not Starting
**Symptoms**: No price updates, triggers not working
**Solutions**:
1. Run token discovery first to populate tokens
2. Check RPC connection in `.env` file
3. Verify HoldStation SDK is installed
4. Check console for error messages

### Triggers Not Executing
**Symptoms**: Conditions met but no trades executed
**Solutions**:
1. Check wallet balance (insufficient funds)
2. Verify token has liquidity on HoldStation
3. Check trigger conditions are realistic
4. Ensure `canExecuteReverseSwap` is true
5. Review slippage settings

### Stop Loss Not Triggering
**Symptoms**: Position continues losing beyond stop loss
**Solutions**:
1. Verify stop loss is negative (e.g., -90%)
2. Check position monitoring is active
3. Ensure token has liquidity for reverse swap
4. Look for position locking conflicts

### Floating-Point Issues
**Symptoms**: Triggers not firing at exact percentages
**Solutions**:
- ✅ **Already Fixed in V2.5!**
- 0.01% tolerance automatically handles precision issues
- No user action required

## 🎯 Best Practices

### 1. Start Simple
- Begin with basic price drop/rise triggers
- Use small amounts initially
- Test with one token before scaling

### 2. Diversify Conditions
- Don't rely on single trigger type
- Combine percentage and SMA-based triggers
- Use multiple timeframes

### 3. Risk Management
- Always set realistic slippage limits
- Use stop loss triggers as safety nets
- Don't over-leverage positions

### 4. Monitor Performance
- Regularly check trigger execution logs
- Analyze price database statistics
- Adjust strategies based on results

### 5. Maintain Liquidity
- Ensure tokens have sufficient DEX liquidity
- Test triggers with small amounts first
- Monitor for low-liquidity warnings

## 🔮 Future Enhancements

Planned features for future versions:
- **Custom Indicators**: RSI, MACD, Bollinger Bands
- **Multi-Exchange Support**: Aggregate liquidity
- **Advanced Conditions**: Complex trigger combinations
- **Backtesting**: Test strategies on historical data
- **Portfolio Rebalancing**: Automated allocation management

## 📞 Support

Need help with the new features?

1. **Check Logs**: Console output shows detailed trigger activity
2. **Review Settings**: Verify configuration in menus
3. **Test Small**: Start with small amounts to validate setup
4. **Documentation**: Read README.md for additional details
5. **Community**: Share experiences with other traders

---

**🎉 Enjoy fully automated trading with WorldChain Bot V2.5!**

The combination of background price tracking and automated triggers gives you professional-grade trading capabilities that work 24/7, even when you're away from your computer.