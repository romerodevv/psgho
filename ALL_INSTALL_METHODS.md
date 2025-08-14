# 🚀 ALGORITMIT - All Installation Methods

Choose the installation method that best fits your needs and experience level.

---

## 🎯 **Quick Comparison**

| Method | Difficulty | Time | Best For |
|--------|------------|------|----------|
| **Ultra Quick** | ⭐ Easy | 2 min | Experienced users |
| **Simple** | ⭐⭐ Easy | 5 min | Most users |
| **Manual** | ⭐⭐⭐ Medium | 15 min | Control-focused users |
| **Docker** | ⭐⭐⭐⭐ Advanced | 10 min | Production/DevOps |
| **Full** | ⭐⭐ Easy | 8 min | First-time users |

---

## ⚡ **Method 1: Ultra Quick Install**

**Perfect for**: Experienced Linux users who want minimal output

### **One Command:**
```bash
curl -fsSL https://raw.githubusercontent.com/romerodevv/psgho/main/quick-install.sh | bash
```

### **What it does:**
- ✅ Installs Node.js if needed
- ✅ Downloads ALGORITMIT
- ✅ Installs all packages
- ✅ Creates `run.sh` script
- ⏱️ **~2 minutes**

### **After installation:**
```bash
cd ~/algoritmit-bot
nano .env          # Add your private key
./run.sh           # Start ALGORITMIT
```

---

## 🛠️ **Method 2: Simple Install**

**Perfect for**: Most users who want to see progress

### **Command:**
```bash
curl -fsSL https://raw.githubusercontent.com/romerodevv/psgho/main/simple-install.sh | bash
```

### **What it does:**
- ✅ Shows detailed progress for each step
- ✅ System requirements check
- ✅ Node.js installation with version check
- ✅ Complete dependency setup
- ✅ Configuration template creation
- ⏱️ **~5 minutes**

### **Features:**
- Progress indicators
- Detailed success/error messages
- System compatibility checks
- Helper script creation

---

## 🔧 **Method 3: Manual Step-by-Step**

**Perfect for**: Users who want complete control over each step

### **Command:**
```bash
curl -fsSL https://raw.githubusercontent.com/romerodevv/psgho/main/manual-install.sh | bash
```

### **What it does:**
- 🔍 **Step 1**: System information and requirements check
- 📁 **Step 2**: Choose custom installation directory
- ⚙️ **Step 3**: Node.js version selection (18 or 20)
- 📥 **Step 4**: Download method choice (Git/ZIP/Skip)
- 📦 **Step 5**: Dependency installation with confirmation
- 🔧 **Step 6**: Configuration setup with editor choice
- 🛠️ **Step 7**: Helper scripts creation
- ✅ **Step 8**: Installation verification and testing
- ⏱️ **~15 minutes**

### **Features:**
- Complete control over each step
- Custom installation paths
- Interactive configuration editing
- Comprehensive testing
- Detailed system information
- Multiple download options
- Helper script generation

---

## 🐳 **Method 4: Docker Installation**

**Perfect for**: Production deployments and containerized environments

### **Command:**
```bash
curl -fsSL https://raw.githubusercontent.com/romerodevv/psgho/main/docker-install.sh | bash
```

### **What it creates:**
```
~/algoritmit-docker/
├── Dockerfile              # Container definition
├── docker-compose.yml      # Service configuration
├── config/
│   └── .env                # Configuration file
├── data/                   # Persistent data
├── logs/                   # Log files
└── Management Scripts:
    ├── start.sh            # Start container
    ├── stop.sh             # Stop container
    ├── interactive.sh      # Interactive mode
    ├── logs.sh             # View logs
    └── update.sh           # Update container
```

### **Management Commands:**
```bash
cd ~/algoritmit-docker
./interactive.sh      # First-time setup
./start.sh            # Background mode
./stop.sh             # Stop container
./logs.sh             # View logs
./update.sh           # Update to latest
```

### **Features:**
- ✅ Isolated environment
- ✅ Easy updates and rollbacks
- ✅ Persistent data storage
- ✅ Production-ready
- ✅ Auto-restart capabilities
- ✅ Log management
- ⏱️ **~10 minutes**

---

## 📚 **Method 5: Full Featured Install**

**Perfect for**: First-time users who want comprehensive guidance

### **Command:**
```bash
curl -fsSL https://raw.githubusercontent.com/romerodevv/psgho/main/install-algoritmit.sh | bash
```

### **What it includes:**
- 🎨 Beautiful ASCII art banner
- 📊 Comprehensive progress indicators
- 🔧 Advanced system checks
- 📝 Detailed explanations
- 🛡️ Enhanced safety warnings
- 📚 Built-in tutorials
- ⏱️ **~8 minutes**

### **Features:**
- Complete beginner-friendly interface
- Detailed progress tracking
- System optimization checks
- Professional presentation
- Comprehensive error handling

---

## 🔄 **After Any Installation Method**

### **Essential Configuration:**
1. **Edit configuration file:**
   ```bash
   nano .env  # or config/.env for Docker
   ```

2. **Add your wallet private key:**
   ```env
   PRIVATE_KEY_1=your_wallet_private_key_here
   ```

### **Critical Safety Steps:**
1. **Start ALGORITMIT**
2. **Go to Menu Option 7** (🤖 ALGORITMIT)
3. **Enable ALGORITMIT Strategy**
4. **Enable Learning Mode FIRST**
5. **Wait 24+ hours** for data collection
6. **Check ML Statistics** (aim for 60%+ accuracy)
7. **Enable Auto-Trading** with 0.01 WLD maximum
8. **Monitor closely**

---

## 🎯 **Which Method Should You Choose?**

### **Choose Ultra Quick if:**
- ✅ You're experienced with Linux
- ✅ You want minimal output
- ✅ You prefer speed over guidance

### **Choose Simple if:**
- ✅ You want to see what's happening
- ✅ You're comfortable with command line
- ✅ You want good balance of speed and detail

### **Choose Manual if:**
- ✅ You want complete control
- ✅ You have specific requirements
- ✅ You want to understand each step
- ✅ You need custom installation paths

### **Choose Docker if:**
- ✅ You're running in production
- ✅ You want easy updates/rollbacks
- ✅ You need isolated environments
- ✅ You're familiar with containers

### **Choose Full if:**
- ✅ You're new to ALGORITMIT
- ✅ You want comprehensive guidance
- ✅ You prefer detailed explanations
- ✅ You want the complete experience

---

## 🆘 **Troubleshooting**

### **Common Issues:**

#### **"Command not found" errors:**
```bash
sudo apt update
sudo apt install curl git
```

#### **Permission denied:**
```bash
chmod +x *.sh
```

#### **Node.js issues:**
```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs
```

#### **Docker issues:**
```bash
sudo systemctl start docker
sudo usermod -aG docker $USER
# Then logout and login again
```

---

## 📞 **Support**

- **Repository**: https://github.com/romerodevv/psgho
- **Issues**: https://github.com/romerodevv/psgho/issues
- **In-App Tutorial**: ALGORITMIT menu → option 8

---

## ⚠️ **Critical Safety Reminder**

**For ALL installation methods:**

- 🚨 **ALWAYS start with Learning Mode for 24+ hours**
- 🚨 **Use tiny amounts (0.01 WLD) for initial testing**
- 🚨 **Never risk more than you can afford to lose**
- 🚨 **Monitor all trades closely**

---

## 🎉 **Ready to Choose?**

Pick your preferred method above and start your AI-powered trading journey with ALGORITMIT! 🤖💹

**Remember: Safety first, Learning Mode first, small amounts first!** 🛡️