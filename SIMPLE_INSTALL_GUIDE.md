# 🚀 ALGORITMIT - Simple Installation Guide

## ⚡ **Ultra Quick Install (Recommended)**

### **One Command Install:**
```bash
curl -fsSL https://raw.githubusercontent.com/romerodevv/psgho/main/quick-install.sh | bash
```

**That's it!** This will:
- Install Node.js if needed
- Download ALGORITMIT
- Install all packages
- Set up configuration

---

## 🛠️ **Simple Install (More Details)**

### **With Progress Display:**
```bash
curl -fsSL https://raw.githubusercontent.com/romerodevv/psgho/main/simple-install.sh | bash
```

This shows more detailed progress during installation.

---

## 🔧 **After Installation**

### **1. Configure Your Wallet**
```bash
cd ~/algoritmit-bot
nano .env
```

**Add your private key:**
```env
PRIVATE_KEY_1=your_wallet_private_key_here
```

### **2. Start ALGORITMIT**
```bash
./run.sh
```

### **3. Enable Learning Mode (CRITICAL!)**
1. Go to **Menu Option 7** (🤖 ALGORITMIT)
2. Select **"1. Enable/Disable ALGORITMIT"** → Choose "y"
3. Select **"2. Configure Learning Mode"** → Choose "y"
4. **Let it learn for 24+ hours** (do NOT skip this!)

### **4. After 24+ Hours - Enable Trading**
1. Check **"4. View ML Statistics"** → Wait for 60%+ accuracy
2. Enable **"3. Configure Auto-Trading Mode"** → Type "CONFIRM"
3. **Start with 0.01 WLD maximum** position size

---

## 📋 **System Requirements**

- **OS**: Ubuntu 20.04+, Debian 10+, or similar Linux
- **RAM**: 4GB+ (for machine learning)
- **Storage**: 2GB+ free space
- **Internet**: Stable connection

---

## ⚠️ **CRITICAL SAFETY STEPS**

### **Phase 1: Learning (24+ hours)**
- ✅ Enable ALGORITMIT
- ✅ Enable Learning Mode
- ❌ **DO NOT** enable auto-trading yet
- ❌ **DO NOT** skip the learning period

### **Phase 2: Testing (Days 3-7)**
- ✅ Check ML accuracy (60%+ recommended)
- ✅ Enable auto-trading with **0.01 WLD max**
- ✅ Monitor every trade closely

### **Phase 3: Scaling (Days 8+)**
- ✅ Gradually increase position sizes
- ✅ Only if consistently profitable
- ✅ Never risk more than you can afford to lose

---

## 🆘 **Troubleshooting**

### **"Command not found" errors:**
```bash
sudo apt update
sudo apt install curl git
```

### **Permission denied:**
```bash
chmod +x run.sh
```

### **Node.js issues:**
```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs
```

---

## 📞 **Support**

- **Repository**: https://github.com/romerodevv/psgho
- **Issues**: https://github.com/romerodevv/psgho/issues
- **In-App Tutorial**: ALGORITMIT menu → option 8

---

## 🎯 **Quick Summary**

1. **Install**: `curl -fsSL https://raw.githubusercontent.com/romerodevv/psgho/main/quick-install.sh | bash`
2. **Configure**: `cd ~/algoritmit-bot && nano .env`
3. **Start**: `./run.sh`
4. **Learn**: Enable Learning Mode for 24+ hours
5. **Trade**: Start with 0.01 WLD after 60%+ ML accuracy

**Remember: Safety first, Learning Mode first, small amounts first!** 🛡️