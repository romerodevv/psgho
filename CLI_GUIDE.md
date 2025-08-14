# 🤖 ALGORITMIT CLI - Console Commands Guide

**Manage ALGORITMIT trading operations directly from the command line without launching the full bot interface.**

---

## 🚀 **Quick Start**

### **Start the CLI:**
```bash
# Method 1: Using launcher script
./cli.sh

# Method 2: Direct Node.js
node algoritmit-cli.js
```

### **First Commands:**
```bash
algoritmit> help          # Show all available commands
algoritmit> status        # Check bot status
algoritmit> balance       # Show wallet balances
```

---

## 📋 **Available Commands**

### **📊 INFORMATION COMMANDS**

#### **`help` / `h`**
Show complete command reference
```bash
algoritmit> help
```

#### **`status`**
Display bot status and configuration
```bash
algoritmit> status
```
Shows: Wallets loaded, RPC URL, WLD address, slippage, gas price, strategy status

#### **`balance [wallet]`** / **`bal [wallet]`**
Show wallet balances (default: wallet 1)
```bash
algoritmit> balance        # Wallet 1 balances
algoritmit> balance 2      # Wallet 2 balances  
algoritmit> bal           # Short form
```
Shows: WLD balance, ETH balance, discovered tokens

#### **`positions`** / **`pos`**
Show open trading positions
```bash
algoritmit> positions
algoritmit> pos           # Short form
```
Shows: Position status, entry price, amount, P&L

#### **`strategies`** / **`strat`**
Show active strategies
```bash
algoritmit> strategies
algoritmit> strat         # Short form
```
Shows: Strategy status, trades, profit

#### **`stats`**
Show comprehensive trading statistics
```bash
algoritmit> stats
```
Shows: Strategy stats, custom strategy stats, total P&L

---

### **💹 TRADING COMMANDS**

#### **`buy <token> <amount>`**
Buy tokens with WLD
```bash
algoritmit> buy YIELD 0.10           # Buy 0.10 WLD worth of YIELD
algoritmit> buy ORO 0.05             # Buy 0.05 WLD worth of ORO
algoritmit> buy RAMEN all            # Buy with all available WLD
```

#### **`buy <token> <amount> d<dip> p<profit>`**
Buy with DIP/profit strategy
```bash
algoritmit> buy YIELD 0.10 d15 p10   # Buy YIELD with 15% DIP, 10% profit target
algoritmit> buy ORO 0.05 d20 p15     # Buy ORO with 20% DIP, 15% profit target
```
- `d15` = 15% DIP buy trigger
- `p10` = 10% profit sell trigger
- Automatically creates position monitoring

#### **`buy <token> <timeframe>`**
Buy at optimal time based on SMA analysis
```bash
algoritmit> buy YIELD 1h             # Buy YIELD at 1-hour optimal rate
algoritmit> buy ORO 6h               # Buy ORO at 6-hour optimal rate
algoritmit> buy RAMEN 24h            # Buy RAMEN at 24-hour optimal rate
```
Supported timeframes: `1h`, `6h`, `24h`, `1d`, `7d`

#### **`sell <token> <amount>`**
Sell tokens for WLD
```bash
algoritmit> sell YIELD 100           # Sell 100 YIELD tokens
algoritmit> sell ORO 50              # Sell 50 ORO tokens
algoritmit> sell RAMEN all           # Sell all RAMEN tokens
```

#### **`sell <token> <timeframe>`**
Sell at optimal time based on SMA analysis
```bash
algoritmit> sell YIELD 1h            # Sell YIELD at 1-hour optimal rate
algoritmit> sell ORO 6h              # Sell ORO at 6-hour optimal rate
```

#### **`quote <from> <to> <amount>`**
Get swap quote without executing
```bash
algoritmit> quote WLD YIELD 1.0      # Quote 1 WLD to YIELD
algoritmit> quote YIELD WLD 100      # Quote 100 YIELD to WLD
```
Shows: Output amount, price impact, gas estimate

---

### **🎯 STRATEGY COMMANDS**

#### **`create <name> <token> [config]`**
Create new trading strategy
```bash
algoritmit> create "YIELD Strategy" YIELD
algoritmit> create "ORO DIP Strategy" ORO
```
Creates strategy with default 15% DIP, 10% profit settings

#### **`start <strategy_id>`**
Start strategy monitoring
```bash
algoritmit> start 1                  # Start strategy ID 1
```

#### **`stop <strategy_id>`**
Stop strategy monitoring
```bash
algoritmit> stop 1                   # Stop strategy ID 1
```

#### **`monitor`**
Toggle position monitoring on/off
```bash
algoritmit> monitor                  # Toggle monitoring
```

---

### **🔍 UTILITY COMMANDS**

#### **`discover [wallet]`**
Discover tokens in wallet
```bash
algoritmit> discover                 # Discover tokens in wallet 1
algoritmit> discover 2               # Discover tokens in wallet 2
```
Shows: Token symbol, balance, contract address

#### **`clear`** / **`cls`**
Clear screen
```bash
algoritmit> clear
algoritmit> cls                      # Short form
```

#### **`exit`** / **`quit`** / **`q`**
Exit CLI
```bash
algoritmit> exit
algoritmit> quit
algoritmit> q                        # Short form
```

---

## 🎯 **Real-World Examples**

### **Quick Trading Session:**
```bash
algoritmit> balance                  # Check WLD balance
algoritmit> buy YIELD 0.10           # Buy YIELD
algoritmit> positions                # Check position
algoritmit> sell YIELD all           # Sell all YIELD
```

### **DIP Strategy Setup:**
```bash
algoritmit> buy ORO 0.05 d20 p15     # Buy ORO with 20% DIP, 15% profit
algoritmit> strategies               # Check strategy status
algoritmit> positions                # Monitor position
```

### **Time-Based Trading:**
```bash
algoritmit> buy RAMEN 1h             # Buy at 1-hour optimal
algoritmit> sell RAMEN 6h            # Sell at 6-hour optimal
```

### **Strategy Management:**
```bash
algoritmit> create "My Strategy" YIELD
algoritmit> start 1                  # Start the strategy
algoritmit> stats                    # Check performance
algoritmit> stop 1                   # Stop when satisfied
```

---

## ⚡ **Advantages Over Full Bot**

### **🚀 Speed:**
- **Instant startup** (no menu navigation)
- **Direct commands** (no waiting for prompts)
- **Batch operations** (script multiple commands)

### **🔧 Automation:**
- **Scriptable** (create bash scripts)
- **Background friendly** (run in screen/tmux)
- **API-like interface** (integrate with other tools)

### **💻 Efficiency:**
- **Minimal resource usage**
- **No UI overhead**
- **Perfect for servers**

---

## 📝 **Scripting Examples**

### **Auto-Buy Script:**
```bash
#!/bin/bash
# auto-buy.sh
echo "buy YIELD 0.10 d15 p10" | node algoritmit-cli.js
echo "buy ORO 0.05 d20 p15" | node algoritmit-cli.js
```

### **Balance Check Script:**
```bash
#!/bin/bash
# check-balances.sh
echo "balance" | node algoritmit-cli.js
echo "positions" | node algoritmit-cli.js
echo "stats" | node algoritmit-cli.js
```

### **Emergency Sell Script:**
```bash
#!/bin/bash
# emergency-sell.sh
echo "sell YIELD all" | node algoritmit-cli.js
echo "sell ORO all" | node algoritmit-cli.js
echo "sell RAMEN all" | node algoritmit-cli.js
```

---

## 🔒 **Security Features**

- **Same wallet security** as full bot
- **Same .env configuration**
- **No additional permissions needed**
- **Graceful shutdown** on Ctrl+C

---

## 🚨 **Safety Reminders**

- **Always check balances** before large trades
- **Start with small amounts** for testing
- **Monitor positions regularly**
- **Use DIP strategies** for risk management
- **Test commands** with small amounts first

---

## 🆘 **Troubleshooting**

### **CLI won't start:**
```bash
# Check Node.js
node --version

# Check .env file
ls -la .env

# Check permissions
chmod +x cli.sh algoritmit-cli.js
```

### **Commands not working:**
```bash
# Check wallet configuration
algoritmit> status

# Check token discovery
algoritmit> discover

# Check balances
algoritmit> balance
```

### **Trading errors:**
```bash
# Get quote first
algoritmit> quote WLD YIELD 0.10

# Check slippage settings
algoritmit> status

# Try smaller amounts
algoritmit> buy YIELD 0.01
```

---

## 🎉 **You're Ready!**

The ALGORITMIT CLI gives you **direct access** to all trading operations without the overhead of the full bot interface. Perfect for:

- **Quick trades**
- **Server deployments** 
- **Automated scripts**
- **Advanced users**
- **High-frequency operations**

**Start trading with just one command!** 🚀

```bash
./cli.sh
algoritmit> help
```

**Happy trading!** 🤖💹