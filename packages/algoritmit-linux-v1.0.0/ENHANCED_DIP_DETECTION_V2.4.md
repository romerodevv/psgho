# 🎯 Enhanced DIP Detection System V2.4

## 📊 Overview

The Enhanced DIP Detection System transforms how the trading bot identifies buying opportunities by introducing sophisticated timeframe-based analysis and historical price comparisons.

## 🚀 Key Features

### ⏱️ Configurable DIP Timeframes

Instead of simple "1% drop from current price", the system now analyzes price drops over configurable periods:

- **1 minute**: Fast detection for volatile tokens
- **5 minutes**: Balanced approach (recommended)
- **15 minutes**: Slower detection for stable tokens  
- **1 hour**: Long-term DIP detection
- **Custom**: Specify any timeframe from 1 minute to 24 hours

### 📈 How It Works

1. **Price History Tracking**: The bot continuously stores price data with timestamps
2. **Timeframe Analysis**: For DIP detection, it only looks at prices within your selected timeframe
3. **Highest Price Detection**: Finds the highest price within the timeframe
4. **DIP Calculation**: Calculates percentage drop from that highest price
5. **Smart Triggering**: Only executes buy when drop exceeds your threshold

### 🎯 Example Scenarios

#### Scenario 1: 5-Minute DIP Detection
```
Strategy: Buy YIELD with 10% DIP threshold, 5-minute timeframe

Price History:
10:00 - 0.00320 WLD (highest in 5min window)
10:01 - 0.00315 WLD  
10:02 - 0.00310 WLD
10:03 - 0.00305 WLD
10:04 - 0.00280 WLD ← Current price

Drop: (0.00320 - 0.00280) / 0.00320 = 12.5%
Result: ✅ DIP DETECTED (12.5% > 10% threshold)
```

#### Scenario 2: 1-Hour DIP Detection  
```
Strategy: Buy ORO with 15% DIP threshold, 1-hour timeframe

Price over last hour:
09:00-09:30 - Peak at 0.00350 WLD
09:30-10:00 - Gradual decline to 0.00320 WLD
Current: 0.00300 WLD

Drop: (0.00350 - 0.00300) / 0.00350 = 14.3%
Result: ❌ NO DIP (14.3% < 15% threshold, need more drop)
```

## 📊 Historical Price Analysis (Advanced)

When enabled, the system provides additional context by comparing current price to multiple timeframes:

### Tracked Periods
- **5 minutes**: Recent volatility
- **1 hour**: Short-term trends  
- **6 hours**: Medium-term movements
- **24 hours**: Daily patterns
- **7 days**: Weekly trends

### Analysis Output
```
⏳ Strategy: Waiting for DIP | Current: 0.00316426 | 
Need: ≤0.00285000 | Drop: 8.2%/10% (5min) | 
5min:-2.1% 1hour:+5.3% 6hour:-8.7% | Runtime: 180s
```

This shows:
- **5min:-2.1%**: Price is 2.1% below 5-minute average
- **1hour:+5.3%**: Price is 5.3% above 1-hour average  
- **6hour:-8.7%**: Price is 8.7% below 6-hour average

## 🎯 Smart Average Price Strategy

The enhanced system maintains the proven Average Price Protection:

1. **First Buy**: Execute when DIP threshold is met
2. **Subsequent Buys**: Only if current price ≤ your average entry price
3. **Profit Target**: Sell ALL positions when price reaches target above average

### Enhanced Monitoring Output

#### Brief Updates (Every ~30 seconds)
```
⏳ StrategyName: Waiting for DIP | Current: 0.00307523 | 
Need: ≤0.00261294 | Drop: 5.2%/15% (5min) | Runtime: 120s
```

#### Detailed Analysis (Every ~2.5 minutes)
```
🚨 DIP DETECTED for Strategy!
════════════════════════════════════════════════════════════
📊 DIP Analysis (5min timeframe):
   📈 Highest Price: 0.00350000 WLD (2m ago)
   📉 Current Price: 0.00280000 WLD
   📊 Price Drop: 20.0% (Target: 15%)
   🎯 DIP Trigger: 0.00297500 WLD
   📋 Data Points: 12 prices in 5min

📊 Average Price Protection:
   📊 Current Average: 0.00310000 WLD
   📈 Price vs Average: -9.7%
   ✅ APPROVED: Price below average - will improve average

💰 Trade Details:
   💵 Amount: 0.1 WLD → YIELD
   📊 Max Slippage: 1%
════════════════════════════════════════════════════════════
🚀 Executing DIP buy...
```

## ⚙️ Configuration Options

### During Strategy Creation

1. **DIP Timeframe Selection**:
   ```
   ⏱️ DIP Detection Timeframe:
   1. 1 minute (fast, good for volatile tokens)
   2. 5 minutes (balanced, recommended)  
   3. 15 minutes (slower, good for stable tokens)
   4. 1 hour (long-term DIP detection)
   5. Custom (specify your own)
   ```

2. **Historical Analysis**:
   ```
   📊 Historical Price Comparison (Advanced):
   Enable historical price analysis? (y/N):
   ```

### Recommended Settings

| Token Type | DIP Timeframe | DIP Threshold | Reasoning |
|------------|---------------|---------------|-----------|
| High Volatility | 1-5 minutes | 5-15% | Quick reaction to rapid price movements |
| Medium Volatility | 5-15 minutes | 10-20% | Balanced approach, avoid noise |
| Low Volatility | 15-60 minutes | 15-30% | Wait for meaningful drops |
| Long-term Hold | 1-6 hours | 20-40% | Major dip opportunities only |

## 🔧 Technical Implementation

### Price History Storage
```javascript
priceHistory: {
  prices: [
    { timestamp: 1735123456789, price: 0.00320 },
    { timestamp: 1735123486789, price: 0.00315 },
    // ...
  ],
  maxHistoryAge: 604800000 // 7 days
}
```

### DIP Detection Logic
```javascript
// Get prices within timeframe
const dipTimeframePrices = getPricesInTimeframe(priceHistory, strategy.dipTimeframe);
const highestPrice = Math.max(...dipTimeframePrices.map(p => p.price));
const priceDrop = ((highestPrice - currentPrice) / highestPrice) * 100;

if (priceDrop >= strategy.dipThreshold) {
  // Execute DIP buy with average price protection
}
```

## 📈 Benefits

1. **Precision**: Target specific price movements within defined periods
2. **Flexibility**: Adapt to different token volatilities and market conditions  
3. **Context**: Historical analysis provides broader market perspective
4. **Discipline**: Average price protection prevents emotional buying
5. **Transparency**: Detailed logging shows exact decision logic

## 🚨 Important Notes

- **Data Requirements**: System needs time to build price history
- **Timeframe Selection**: Choose based on token volatility and trading style
- **Average Price**: Only buys when price improves or maintains average
- **Historical Analysis**: Optional but provides valuable market context

## 🎯 Migration from V2.3

Existing strategies will continue to work with default 5-minute timeframes. To use new features:

1. Create new strategies with timeframe selection
2. Enable historical analysis for advanced insights
3. Monitor enhanced status outputs for better decision making

---

**🚀 Ready to use the Enhanced DIP Detection System? Create a new strategy and experience precision DIP trading!**