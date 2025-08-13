# 🚀 WorldChain Trading Bot - Quick Start Guide

Get your WorldChain trading bot running on a Linux server in minutes!

## 📋 Prerequisites

- Linux server (Ubuntu/Debian/CentOS/RHEL)
- SSH access to the server
- Internet connection

## 🌐 Method 1: From GitHub Repository (Recommended)

### Step 1: Upload to GitHub

1. **Create a new repository** on GitHub:
   - Go to https://github.com/new
   - Name: `worldchain-trading-bot`
   - Set to Public or Private
   - Click "Create repository"

2. **Upload the bot files** to your repository:
   - `worldchain-trading-bot.js`
   - `trading-engine.js`
   - `token-discovery.js`
   - `trading-strategy.js`
   - `package.json`
   - `.env.example`
   - `start.sh`
   - `deploy-linux.sh`
   - `README.md`

### Step 2: Deploy on Linux Server

```bash
# SSH into your server
ssh your-username@your-server-ip

# Download the deployment script
wget https://raw.githubusercontent.com/YOUR_USERNAME/worldchain-trading-bot/main/deploy-linux.sh

# Make it executable
chmod +x deploy-linux.sh

# Edit the script to set your GitHub repository
nano deploy-linux.sh
# Change: GITHUB_REPO="YOUR_USERNAME/worldchain-trading-bot"
# To: GITHUB_REPO="yourusername/worldchain-trading-bot"

# Run the automated deployment
./deploy-linux.sh install
```

### Step 3: Configure and Start

```bash
# Navigate to the bot directory
cd /opt/worldchain-bot

# Edit configuration
nano .env

# Start the bot
./start.sh start
```

## 🔧 Method 2: Manual File Transfer

### Step 1: Prepare Your Server

```bash
# SSH into your server
ssh your-username@your-server-ip

# Download and run the deployment script
wget https://raw.githubusercontent.com/YOUR_USERNAME/worldchain-trading-bot/main/deploy-linux.sh
chmod +x deploy-linux.sh
./deploy-linux.sh install
```

### Step 2: Transfer Files

Use one of these methods to transfer your bot files:

#### Option A: SCP (Secure Copy)
```bash
# From your local machine, copy all files
scp -r ./worldchain-bot/* your-username@your-server-ip:/opt/worldchain-bot/
```

#### Option B: SFTP
```bash
# Connect via SFTP
sftp your-username@your-server-ip

# Upload files
put worldchain-trading-bot.js /opt/worldchain-bot/
put trading-engine.js /opt/worldchain-bot/
put token-discovery.js /opt/worldchain-bot/
put trading-strategy.js /opt/worldchain-bot/
put package.json /opt/worldchain-bot/
put .env.example /opt/worldchain-bot/
put start.sh /opt/worldchain-bot/
```

#### Option C: Git Clone (if you have a repository)
```bash
# On the server
cd /opt/worldchain-bot
git clone https://github.com/YOUR_USERNAME/worldchain-trading-bot.git .
```

### Step 3: Setup and Start

```bash
# On the server
cd /opt/worldchain-bot

# Make scripts executable
chmod +x start.sh
chmod +x worldchain-trading-bot.js

# Install dependencies
./start.sh install

# Configure environment
cp .env.example .env
nano .env

# Start the bot
./start.sh start
```

## ⚙️ Essential Configuration

Edit `/opt/worldchain-bot/.env`:

```bash
# Blockchain Configuration
WORLDCHAIN_RPC_URL=https://worldchain-mainnet.g.alchemy.com/public
ALCHEMY_API_KEY=your_alchemy_api_key_here

# Trading Settings
ENABLE_REAL_TRADING=false  # Set to true when ready
DEFAULT_SLIPPAGE=0.5
PROFIT_TARGET=1.0
STOP_LOSS_THRESHOLD=-5.0

# Security
MAX_POSITION_SIZE=100
MAX_OPEN_POSITIONS=5
```

## 🎯 Quick Commands

### Start/Stop Bot
```bash
# Start the bot
cd /opt/worldchain-bot && ./start.sh start

# Start as background service
sudo systemctl start worldchain-bot
sudo systemctl enable worldchain-bot  # Auto-start on boot
```

### Monitor Bot
```bash
# View logs
sudo journalctl -u worldchain-bot -f

# Check status
sudo systemctl status worldchain-bot

# View bot files
ls -la /opt/worldchain-bot/
```

### Backup Data
```bash
# Create backup
sudo /usr/local/bin/backup-worldchain-bot.sh

# View backups
ls -la /backup/worldchain-bot/
```

## 🔒 Security Checklist

- [ ] Set secure file permissions: `chmod 600 /opt/worldchain-bot/.env`
- [ ] Enable firewall: `sudo ufw enable`
- [ ] Use strong passwords for wallets
- [ ] Start with `ENABLE_REAL_TRADING=false` for testing
- [ ] Monitor logs regularly
- [ ] Create regular backups

## 🐛 Troubleshooting

### Common Issues

**1. Permission Denied**
```bash
sudo chown -R $USER:$USER /opt/worldchain-bot
chmod +x /opt/worldchain-bot/start.sh
```

**2. Node.js Not Found**
```bash
# Install Node.js 18
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs
```

**3. Dependencies Failed**
```bash
cd /opt/worldchain-bot
npm cache clean --force
npm install
```

**4. Service Won't Start**
```bash
# Check logs
sudo journalctl -u worldchain-bot -n 50

# Restart service
sudo systemctl restart worldchain-bot
```

### Check Installation
```bash
# Verify everything is working
cd /opt/worldchain-bot
./start.sh check
```

## 📊 Usage Flow

1. **Start Bot**: `./start.sh start`
2. **Create Wallet**: Menu → Wallet Management → Create New Wallet
3. **Add Tokens**: Menu → Token Discovery → Add Token by Address
4. **Configure Strategy**: Menu → Strategy Management → Strategy Configuration
5. **Start Strategy**: Menu → Strategy Management → Start Strategy
6. **Execute Trade**: Menu → Strategy Management → Execute Strategic Trade
7. **Monitor**: Watch real-time P&L and automatic trades!

## 🎉 You're Ready!

Your WorldChain trading bot is now running on your Linux server with:

- ✅ **Automated position tracking**
- ✅ **Real-time price monitoring**
- ✅ **Profit target automation**
- ✅ **DIP buying detection**
- ✅ **Risk management**
- ✅ **Background service operation**

## 📞 Need Help?

1. Check the logs: `sudo journalctl -u worldchain-bot -f`
2. Review configuration: `cat /opt/worldchain-bot/.env`
3. Verify files: `ls -la /opt/worldchain-bot/`
4. Test manually: `cd /opt/worldchain-bot && node worldchain-trading-bot.js`

---

**Happy Trading on WorldChain! 🌍💰🎯**

*Remember: Start with small amounts and monitor your bot carefully!*