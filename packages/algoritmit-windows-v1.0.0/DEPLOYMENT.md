# 🌍 WorldChain Trading Bot - Linux Server Deployment Guide

This guide will walk you through deploying the WorldChain Trading Bot on a Linux server from GitHub.

## 📋 Prerequisites

### System Requirements
- **Linux Server** (Ubuntu 20.04+ / CentOS 8+ / Debian 11+)
- **RAM**: Minimum 1GB, Recommended 2GB+
- **Storage**: Minimum 2GB free space
- **Network**: Stable internet connection
- **User**: Root access or sudo privileges

### Required Software
- **Node.js**: Version 16.0.0 or higher
- **npm**: Latest version (comes with Node.js)
- **Git**: For cloning the repository
- **curl/wget**: For downloading files

## 🚀 Step-by-Step Installation

### Step 1: Connect to Your Linux Server

```bash
# SSH into your server
ssh username@your-server-ip

# Or if using a key file
ssh -i /path/to/your-key.pem username@your-server-ip
```

### Step 2: Update System Packages

```bash
# Ubuntu/Debian
sudo apt update && sudo apt upgrade -y

# CentOS/RHEL/Rocky Linux
sudo yum update -y
# OR for newer versions
sudo dnf update -y
```

### Step 3: Install Node.js and npm

#### Option A: Using NodeSource Repository (Recommended)

```bash
# Ubuntu/Debian
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# CentOS/RHEL/Rocky Linux
curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo bash -
sudo yum install -y nodejs
```

#### Option B: Using Package Manager

```bash
# Ubuntu/Debian
sudo apt install -y nodejs npm

# CentOS/RHEL/Rocky Linux
sudo yum install -y nodejs npm
```

#### Verify Installation

```bash
node --version  # Should show v16.0.0 or higher
npm --version   # Should show latest version
```

### Step 4: Install Git

```bash
# Ubuntu/Debian
sudo apt install -y git

# CentOS/RHEL/Rocky Linux
sudo yum install -y git
```

### Step 5: Create Application Directory

```bash
# Create directory for the bot
sudo mkdir -p /opt/worldchain-bot
sudo chown $USER:$USER /opt/worldchain-bot
cd /opt/worldchain-bot
```

### Step 6: Clone the Repository from GitHub

```bash
# Clone the repository (replace with actual GitHub URL)
git clone https://github.com/YOUR_USERNAME/worldchain-trading-bot.git .

# Or if you have the files in a different repository
git clone https://github.com/YOUR_GITHUB_USERNAME/YOUR_REPOSITORY_NAME.git .

# If you need to download specific files without full git history
git clone --depth 1 https://github.com/YOUR_USERNAME/worldchain-trading-bot.git .
```

### Step 7: Install Dependencies and Setup

```bash
# Make the startup script executable
chmod +x start.sh

# Run the installation
./start.sh install
```

### Step 8: Configure Environment Variables

```bash
# Copy the example environment file
cp .env.example .env

# Edit the configuration file
nano .env
# OR use vim if you prefer
vim .env
```

#### Essential Configuration Settings:

```bash
# Blockchain RPC Configuration
WORLDCHAIN_RPC_URL=https://worldchain-mainnet.g.alchemy.com/public

# API Keys (Optional but recommended)
ALCHEMY_API_KEY=your_alchemy_api_key_here
MORALIS_API_KEY=your_moralis_api_key_here

# Trading Configuration
DEFAULT_SLIPPAGE=0.5
DEFAULT_GAS_PRICE=20
ENABLE_REAL_TRADING=false  # Set to true when ready for real trading

# Strategy Configuration
PROFIT_TARGET=1.0
DIP_BUY_THRESHOLD=1.0
MAX_SLIPPAGE=1.0
STOP_LOSS_THRESHOLD=-5.0
PRICE_CHECK_INTERVAL=5000
ENABLE_AUTO_SELL=true
ENABLE_DIP_BUYING=false

# Security Settings
MAX_TRADE_AMOUNT=1000
MAX_POSITION_SIZE=100
MAX_OPEN_POSITIONS=5
```

### Step 9: Test Installation

```bash
# Check if everything is working
./start.sh check

# Test run the bot
./start.sh start
```

## 🛠️ Advanced Setup Options

### Option 1: Running as a System Service

Create a systemd service to run the bot automatically:

```bash
# Create service file
sudo nano /etc/systemd/system/worldchain-bot.service
```

Add the following content:

```ini
[Unit]
Description=WorldChain Trading Bot
After=network.target

[Service]
Type=simple
User=your-username
WorkingDirectory=/opt/worldchain-bot
Environment=NODE_ENV=production
ExecStart=/usr/bin/node worldchain-trading-bot.js
Restart=always
RestartSec=10
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=worldchain-bot

[Install]
WantedBy=multi-user.target
```

Enable and start the service:

```bash
# Reload systemd
sudo systemctl daemon-reload

# Enable the service
sudo systemctl enable worldchain-bot

# Start the service
sudo systemctl start worldchain-bot

# Check status
sudo systemctl status worldchain-bot

# View logs
sudo journalctl -u worldchain-bot -f
```

### Option 2: Using Screen/Tmux for Background Running

#### Using Screen:

```bash
# Install screen
sudo apt install screen  # Ubuntu/Debian
sudo yum install screen  # CentOS/RHEL

# Start a new screen session
screen -S worldchain-bot

# Run the bot
./start.sh start

# Detach from screen (Ctrl+A, then D)
# Reattach to screen
screen -r worldchain-bot
```

#### Using Tmux:

```bash
# Install tmux
sudo apt install tmux  # Ubuntu/Debian
sudo yum install tmux  # CentOS/RHEL

# Start a new tmux session
tmux new-session -d -s worldchain-bot

# Run the bot in the session
tmux send-keys -t worldchain-bot './start.sh start' Enter

# Attach to the session
tmux attach-session -t worldchain-bot
```

### Option 3: Using PM2 (Process Manager)

```bash
# Install PM2 globally
sudo npm install -g pm2

# Start the bot with PM2
pm2 start worldchain-trading-bot.js --name "worldchain-bot"

# Save PM2 configuration
pm2 save

# Setup PM2 to start on boot
pm2 startup

# Monitor the bot
pm2 monit

# View logs
pm2 logs worldchain-bot

# Restart the bot
pm2 restart worldchain-bot
```

## 🔒 Security Considerations

### 1. Firewall Configuration

```bash
# Ubuntu/Debian (using ufw)
sudo ufw allow ssh
sudo ufw allow 22/tcp
sudo ufw enable

# CentOS/RHEL (using firewalld)
sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --reload
```

### 2. Secure File Permissions

```bash
# Set proper permissions
chmod 600 .env
chmod 600 wallets.json
chmod 700 /opt/worldchain-bot
```

### 3. User Security

```bash
# Create a dedicated user for the bot (recommended)
sudo useradd -r -s /bin/false worldchain-bot
sudo chown -R worldchain-bot:worldchain-bot /opt/worldchain-bot
```

### 4. SSL/TLS for API Connections

Ensure your server has updated certificates:

```bash
# Ubuntu/Debian
sudo apt install ca-certificates

# CentOS/RHEL
sudo yum install ca-certificates
```

## 📊 Monitoring and Maintenance

### Log Management

```bash
# Create log directory
mkdir -p /opt/worldchain-bot/logs

# View real-time logs
tail -f /opt/worldchain-bot/logs/bot.log

# Rotate logs (add to crontab)
0 0 * * * /usr/sbin/logrotate /opt/worldchain-bot/logrotate.conf
```

### Backup Strategy

```bash
# Create backup script
#!/bin/bash
BACKUP_DIR="/backup/worldchain-bot"
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p $BACKUP_DIR
tar -czf $BACKUP_DIR/worldchain-bot-backup-$DATE.tar.gz \
    /opt/worldchain-bot/.env \
    /opt/worldchain-bot/config.json \
    /opt/worldchain-bot/wallets.json \
    /opt/worldchain-bot/discovered_tokens.json \
    /opt/worldchain-bot/strategy_positions.json

# Keep only last 7 backups
find $BACKUP_DIR -name "worldchain-bot-backup-*.tar.gz" -mtime +7 -delete
```

### System Monitoring

```bash
# Check system resources
htop
# OR
top

# Check disk usage
df -h

# Check memory usage
free -h

# Monitor network connections
netstat -tlnp
```

## 🚨 Troubleshooting

### Common Issues and Solutions

#### 1. Node.js Version Issues

```bash
# Check current version
node --version

# Update Node.js using n (node version manager)
sudo npm install -g n
sudo n latest
```

#### 2. Permission Denied Errors

```bash
# Fix ownership
sudo chown -R $USER:$USER /opt/worldchain-bot

# Fix permissions
chmod +x start.sh
chmod +x worldchain-trading-bot.js
```

#### 3. Port Already in Use

```bash
# Find process using port
sudo netstat -tlnp | grep :PORT_NUMBER

# Kill process
sudo kill -9 PID_NUMBER
```

#### 4. Memory Issues

```bash
# Increase Node.js memory limit
export NODE_OPTIONS="--max-old-space-size=2048"

# Or modify the start script
node --max-old-space-size=2048 worldchain-trading-bot.js
```

#### 5. Network Connectivity Issues

```bash
# Test internet connection
ping -c 4 google.com

# Test specific endpoints
curl -I https://worldchain-mainnet.g.alchemy.com/public

# Check DNS resolution
nslookup worldchain-mainnet.g.alchemy.com
```

## 🔄 Updates and Maintenance

### Updating the Bot

```bash
# Navigate to bot directory
cd /opt/worldchain-bot

# Stop the bot (if running as service)
sudo systemctl stop worldchain-bot

# Pull latest changes
git pull origin main

# Update dependencies
npm update

# Restart the bot
sudo systemctl start worldchain-bot
```

### Regular Maintenance Tasks

```bash
# Weekly maintenance script
#!/bin/bash

# Update system packages
sudo apt update && sudo apt upgrade -y

# Clean npm cache
npm cache clean --force

# Clean old log files
find /opt/worldchain-bot/logs -name "*.log" -mtime +30 -delete

# Restart the bot service
sudo systemctl restart worldchain-bot
```

## 📞 Support and Logs

### Viewing Logs

```bash
# System service logs
sudo journalctl -u worldchain-bot -f

# PM2 logs
pm2 logs worldchain-bot

# Direct file logs
tail -f /opt/worldchain-bot/logs/bot.log
```

### Getting Help

If you encounter issues:

1. Check the logs first
2. Verify your configuration in `.env`
3. Ensure all dependencies are installed
4. Check system resources (RAM, disk space)
5. Verify network connectivity

## 🎉 Final Steps

1. **Verify Installation**: Run `./start.sh check`
2. **Test with Small Amounts**: Start with minimal trading amounts
3. **Monitor Performance**: Watch logs and system resources
4. **Setup Backups**: Implement regular backup strategy
5. **Security Review**: Ensure proper permissions and firewall rules

---

**Your WorldChain Trading Bot is now ready to run on your Linux server! 🌍💰🎯**

For additional support or questions, refer to the main README.md file or check the troubleshooting section above.