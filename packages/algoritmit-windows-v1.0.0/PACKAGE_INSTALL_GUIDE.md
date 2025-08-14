# 📦 ALGORITMIT - Package Installation Guide

**The easiest way to install ALGORITMIT! Just download, extract, and run.**

---

## 🎯 **Choose Your Package**

| Platform | Package | Size | Installation |
|----------|---------|------|-------------|
| **🪟 Windows** | `algoritmit-windows-v3.0.zip` | ~2MB | Double-click files |
| **🍎 macOS** | `algoritmit-macos-v3.0.zip` | ~2MB | Double-click files |
| **🐧 Linux** | `algoritmit-linux-v3.0.tar.gz` | ~2MB | Run shell scripts |
| **🌍 Universal** | `algoritmit-universal-v3.0.zip` | ~2MB | Works everywhere |

---

## 📥 **Download Links**

### **Direct Downloads:**
- **Windows**: [algoritmit-windows-v3.0.zip](https://github.com/romerodevv/psgho/releases/latest/download/algoritmit-windows-v3.0.zip)
- **macOS**: [algoritmit-macos-v3.0.zip](https://github.com/romerodevv/psgho/releases/latest/download/algoritmit-macos-v3.0.zip)
- **Linux**: [algoritmit-linux-v3.0.tar.gz](https://github.com/romerodevv/psgho/releases/latest/download/algoritmit-linux-v3.0.tar.gz)
- **Universal**: [algoritmit-universal-v3.0.zip](https://github.com/romerodevv/psgho/releases/latest/download/algoritmit-universal-v3.0.zip)

### **Alternative Download Methods:**
```bash
# Using wget (Linux/macOS)
wget https://github.com/romerodevv/psgho/releases/latest/download/algoritmit-linux-v3.0.tar.gz

# Using curl (Linux/macOS)
curl -L -O https://github.com/romerodevv/psgho/releases/latest/download/algoritmit-macos-v3.0.zip

# Using PowerShell (Windows)
Invoke-WebRequest -Uri "https://github.com/romerodevv/psgho/releases/latest/download/algoritmit-windows-v3.0.zip" -OutFile "algoritmit-windows-v3.0.zip"
```

---

## 🪟 **Windows Installation**

### **📋 Requirements:**
- Windows 10/11
- Python 3.7+ ([Download from python.org](https://python.org))

### **🚀 Installation Steps:**

1. **Download the package:**
   ```
   algoritmit-windows-v3.0.zip
   ```

2. **Extract the ZIP file:**
   - Right-click the ZIP file
   - Select "Extract All..."
   - Choose a location (e.g., Desktop)

3. **Install ALGORITMIT:**
   - Open the extracted folder
   - **Double-click `INSTALL.bat`**
   - Follow the prompts

4. **Configure your wallet:**
   - Edit the `.env` file with Notepad
   - Add your wallet private key

5. **Start ALGORITMIT:**
   - **Double-click `START.bat`**

### **📁 Windows Package Contents:**
```
algoritmit-windows-v3.0/
├── INSTALL.bat          ← Double-click to install
├── START.bat            ← Double-click to start
├── UPDATE.bat           ← Double-click to update
├── README-WINDOWS.txt   ← Read this first
├── install.py           ← Python installer
├── .env.example         ← Configuration template
└── *.js files           ← Bot source code
```

### **🔧 Windows Troubleshooting:**
- **Python not found?** Install from [python.org](https://python.org) and check "Add Python to PATH"
- **INSTALL.bat not working?** Open Command Prompt and run `python install.py`
- **Permission denied?** Right-click and "Run as Administrator"

---

## 🍎 **macOS Installation**

### **📋 Requirements:**
- macOS 10.14+
- Python 3.7+ (usually pre-installed)
- Xcode Command Line Tools: `xcode-select --install`

### **🚀 Installation Steps:**

1. **Download the package:**
   ```
   algoritmit-macos-v3.0.zip
   ```

2. **Extract the ZIP file:**
   - Double-click the ZIP file
   - It will extract automatically

3. **Install ALGORITMIT:**
   - Open the extracted folder
   - **Double-click `install.command`**
   - Enter your password if prompted

4. **Configure your wallet:**
   - Edit the `.env` file with TextEdit
   - Add your wallet private key

5. **Start ALGORITMIT:**
   - **Double-click `start.command`**

### **📁 macOS Package Contents:**
```
algoritmit-macos-v3.0/
├── install.command      ← Double-click to install
├── start.command        ← Double-click to start
├── README-MACOS.txt     ← Read this first
├── install.py           ← Python installer
├── .env.example         ← Configuration template
└── *.js files           ← Bot source code
```

### **🔧 macOS Troubleshooting:**
- **"Cannot be opened" error?** Right-click → Open → Open anyway
- **Python not found?** Install from [python.org](https://python.org) or use `brew install python`
- **Permission denied?** Run `chmod +x install.command` in Terminal

---

## 🐧 **Linux Installation**

### **📋 Requirements:**
- Ubuntu 18.04+ / Debian 10+ / CentOS 7+
- Python 3.7+
- Internet connection

### **🚀 Installation Steps:**

1. **Download the package:**
   ```bash
   wget https://github.com/romerodevv/psgho/releases/latest/download/algoritmit-linux-v3.0.tar.gz
   ```

2. **Extract the archive:**
   ```bash
   tar -xzf algoritmit-linux-v3.0.tar.gz
   cd algoritmit-linux-v3.0
   ```

3. **Install ALGORITMIT:**
   ```bash
   chmod +x install.sh
   ./install.sh
   ```

4. **Configure your wallet:**
   ```bash
   nano .env
   # Add your wallet private key
   ```

5. **Start ALGORITMIT:**
   ```bash
   ./start.sh
   ```

### **📁 Linux Package Contents:**
```
algoritmit-linux-v3.0/
├── install.sh           ← Run this to install
├── start.sh             ← Run this to start
├── README-LINUX.txt     ← Read this first
├── install.py           ← Python installer
├── .env.example         ← Configuration template
└── *.js files           ← Bot source code
```

### **🔧 Linux Troubleshooting:**
- **Permission denied?** Run `chmod +x *.sh` first
- **Python not found?** Run `sudo apt install python3 python3-pip`
- **Dependencies missing?** Run `sudo apt update && sudo apt install curl wget`

---

## 🌍 **Universal Package (All Platforms)**

### **🚀 One Package for Everything:**

The Universal package contains installation files for Windows, macOS, and Linux in one download.

1. **Download:**
   ```
   algoritmit-universal-v3.0.zip
   ```

2. **Extract and choose your platform:**

   **🪟 Windows Users:**
   - Double-click `INSTALL.bat`
   - Then double-click `START.bat`

   **🍎 macOS Users:**
   - Double-click `install.command`
   - Then double-click `start.command`

   **🐧 Linux Users:**
   - Run `chmod +x install.sh && ./install.sh`
   - Then run `./start.sh`

### **📁 Universal Package Contents:**
```
algoritmit-universal-v3.0/
├── INSTALL.bat          ← Windows installer
├── START.bat            ← Windows starter
├── UPDATE.bat           ← Windows updater
├── install.command      ← macOS installer
├── start.command        ← macOS starter
├── install.sh           ← Linux installer
├── start.sh             ← Linux starter
├── install.py           ← Universal Python installer
├── README.txt           ← Universal instructions
├── .env.example         ← Configuration template
└── *.js files           ← Bot source code
```

---

## ⚙️ **Configuration Setup**

### **🔐 Wallet Configuration:**

After installation, you **must** configure your wallet:

1. **Open the `.env` file** (created during installation)

2. **Add your wallet private key:**
   ```env
   PRIVATE_KEY_1=your_wallet_private_key_here
   WALLET_NAME_1=Main Trading Wallet
   ```

3. **Optional settings:**
   ```env
   # Trading Configuration
   DEFAULT_SLIPPAGE=1.0
   MAX_GAS_PRICE=50
   
   # ALGORITMIT ML Settings
   ML_CONFIDENCE_THRESHOLD=75
   ML_MAX_POSITION_SIZE=0.1
   ML_LEARNING_MODE=true
   ML_AUTO_TRADING=false
   ```

### **🛡️ Security Tips:**
- **Never share your private key**
- **Keep backups of your `.env` file**
- **Use a dedicated trading wallet**
- **Start with small amounts**

---

## 🚀 **Starting ALGORITMIT**

### **🎯 First Run - Critical Steps:**

1. **Start the bot** (using your platform's method above)

2. **Go to Menu Option 7** (🤖 ALGORITMIT)

3. **Enable ALGORITMIT Strategy**

4. **🚨 ENABLE LEARNING MODE FIRST** (24+ hours minimum)

5. **Let it collect data** - DO NOT skip this step!

6. **Check ML Statistics** - Wait for 60%+ accuracy

7. **Enable auto-trading** with 0.01 WLD maximum

8. **Monitor closely** and scale gradually

### **📊 Menu Navigation:**
```
🤖 ALGORITMIT Main Menu
1. 💰 Wallet Management
2. 🔍 Token Discovery  
3. 💹 Trading Operations
4. 📈 Trading Strategy
5. 🎯 Strategy Builder
6. 📊 Price Triggers
7. 🤖 ALGORITMIT (Machine Learning Trading) ← Start here!
8. 🚪 Exit
```

---

## 🔄 **Updates**

### **🔄 Updating Your Installation:**

**Windows:**
- Double-click `UPDATE.bat`

**macOS/Linux:**
- Download the latest package
- Extract over your existing installation
- Your `.env` file will be preserved

**Manual Update:**
```bash
# Download latest version
curl -L https://github.com/romerodevv/psgho/archive/main.zip -o update.zip

# Extract and update
unzip -o update.zip
cp -r psgho-main/* .
rm -rf psgho-main update.zip

# Update dependencies
npm install
```

---

## 🆘 **Troubleshooting**

### **Common Issues:**

#### **❌ "Python not found"**
- **Windows**: Install from [python.org](https://python.org), check "Add to PATH"
- **macOS**: Install from [python.org](https://python.org) or `brew install python`
- **Linux**: `sudo apt install python3 python3-pip`

#### **❌ "Node.js not found"**
- **Windows**: Download from [nodejs.org](https://nodejs.org)
- **macOS**: `brew install node` or download from [nodejs.org](https://nodejs.org)
- **Linux**: `sudo apt install nodejs npm`

#### **❌ "Permission denied"**
- **Windows**: Right-click → "Run as Administrator"
- **macOS**: Right-click → Open → Open anyway
- **Linux**: `chmod +x *.sh`

#### **❌ "Configuration not found"**
- Make sure you've edited the `.env` file
- Copy from `.env.example` if missing
- Add your wallet private key

#### **❌ "Dependencies failed"**
- Check internet connection
- Try running `npm install` manually
- Update Node.js to latest version

### **🔍 Getting Help:**
- **GitHub Issues**: [Report problems](https://github.com/romerodevv/psgho/issues)
- **Documentation**: [Full guide](https://github.com/romerodevv/psgho)
- **In-App Tutorial**: ALGORITMIT menu → option 8

---

## ⚠️ **Safety Reminders**

### **🚨 CRITICAL - Read Before Trading:**

- **🛡️ ALWAYS start with Learning Mode for 24+ hours**
- **💰 Use tiny amounts (0.01 WLD) for initial testing**
- **📊 Wait for 60%+ ML accuracy before auto-trading**
- **👀 Monitor all trades closely**
- **💸 Never risk more than you can afford to lose**
- **🔐 Keep your private keys secure**
- **📱 Use a dedicated trading wallet**

### **📈 Recommended Progression:**
1. **Day 1-2**: Learning Mode only, no trading
2. **Day 3-4**: Manual trades with 0.01 WLD
3. **Week 2**: Auto-trading with 0.05 WLD max
4. **Month 2**: Scale up gradually based on performance

---

## 🎉 **You're Ready!**

Download your platform's package, extract it, and start your AI-powered trading journey with ALGORITMIT!

**Remember: Learning Mode first, small amounts first, safety first!** 🛡️

---

## 📊 **Package Comparison**

| Feature | Package Install | Script Install | Docker Install |
|---------|----------------|----------------|----------------|
| **Ease of Use** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐ |
| **Download Size** | 2MB | Minimal | 100MB+ |
| **Setup Time** | 2 minutes | 5 minutes | 10 minutes |
| **Offline Install** | ✅ Yes | ❌ No | ❌ No |
| **Updates** | Manual | Automatic | Automatic |
| **Beginner Friendly** | ✅ Yes | ⚠️ Medium | ❌ Advanced |

**🏆 Winner for most users: Package Installation!**