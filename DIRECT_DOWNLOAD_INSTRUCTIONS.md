# 📦 ALGORITMIT - Direct Package Downloads

**Since GitHub releases aren't set up yet, here are direct download methods that work right now:**

---

## 🚀 **Working Download Methods**

### **Method 1: Direct Repository Download**

```bash
# Download the entire repository and extract packages
curl -L https://github.com/romerodevv/psgho/archive/main.zip -o algoritmit-source.zip
unzip algoritmit-source.zip
cd psgho-main/packages/

# Your packages are here:
ls -la *.zip *.tar.gz
```

### **Method 2: Clone and Extract**

```bash
# Clone the repository
git clone https://github.com/romerodevv/psgho.git
cd psgho/packages/

# Extract your platform's package
# Linux:
tar -xzf algoritmit-linux-v1.0.0.tar.gz
cd algoritmit-linux-v1.0.0/

# macOS:
unzip algoritmit-macos-v1.0.0.zip
cd algoritmit-macos-v1.0.0/

# Windows:
unzip algoritmit-windows-v1.0.0.zip
cd algoritmit-windows-v1.0.0/
```

### **Method 3: One-Line Install (Linux)**

```bash
# Download, extract, and install in one command
curl -L https://github.com/romerodevv/psgho/archive/main.zip -o temp.zip && \
unzip temp.zip && \
cd psgho-main/packages/ && \
tar -xzf algoritmit-linux-v1.0.0.tar.gz && \
cd algoritmit-linux-v1.0.0/ && \
chmod +x install.sh && \
./install.sh
```

---

## 🐧 **Linux Quick Start (What You Need Right Now)**

Since you're on Linux, here's the fastest way to get ALGORITMIT running:

### **Option A: Package Installation**
```bash
# Download the source
curl -L https://github.com/romerodevv/psgho/archive/main.zip -o algoritmit.zip

# Extract everything
unzip algoritmit.zip
cd psgho-main/packages/

# Extract the Linux package
tar -xzf algoritmit-linux-v1.0.0.tar.gz
cd algoritmit-linux-v1.0.0/

# Install
chmod +x install.sh
./install.sh

# Configure (edit with your wallet private key)
nano .env

# Start ALGORITMIT
./start.sh
```

### **Option B: Direct Installation (Even Faster)**
```bash
# Download and install directly from main source
curl -L https://github.com/romerodevv/psgho/archive/main.zip -o algoritmit.zip
unzip algoritmit.zip
cd psgho-main/

# Install dependencies
python3 install.py

# Configure
nano .env

# Start
node worldchain-trading-bot.js
```

### **Option C: Use Existing Installation Scripts**
```bash
# Ultra-fast one-liner (works right now)
curl -fsSL https://raw.githubusercontent.com/romerodevv/psgho/main/quick-install.sh | bash
```

---

## 🔧 **After Installation**

**Critical Steps:**

1. **Edit the `.env` file:**
   ```bash
   nano .env
   ```

2. **Add your wallet private key:**
   ```env
   PRIVATE_KEY_1=your_wallet_private_key_here
   ```

3. **Start ALGORITMIT:**
   ```bash
   node worldchain-trading-bot.js
   ```

4. **Go to Menu Option 7** (🤖 ALGORITMIT)

5. **Enable Learning Mode FIRST** (24+ hours minimum)

6. **Wait for 60%+ ML accuracy before auto-trading**

7. **Start with 0.01 WLD maximum**

---

## 📦 **Package Sizes Available**

```
algoritmit-linux-v1.0.0.tar.gz:    267KB
algoritmit-macos-v1.0.0.zip:       298KB
algoritmit-windows-v1.0.0.zip:     299KB
algoritmit-universal-v1.0.0.zip:   302KB
```

---

## 🚨 **Why the 404 Error Occurred**

The download link you tried:
```
https://github.com/romerodevv/psgho/releases/latest/download/algoritmit-linux-v1.0.0.tar.gz
```

This requires a **GitHub Release** to be created first. The packages exist in the repository but haven't been uploaded as release assets yet.

---

## ✅ **Working Alternative Downloads**

**Instead, use these working URLs:**

### **Linux Package:**
```bash
# Download the repository and extract Linux package
curl -L https://github.com/romerodevv/psgho/archive/main.zip -o temp.zip
unzip temp.zip
cp psgho-main/packages/algoritmit-linux-v1.0.0.tar.gz .
tar -xzf algoritmit-linux-v1.0.0.tar.gz
cd algoritmit-linux-v1.0.0/
```

### **Or Use the Fastest Method:**
```bash
# This works right now - no packages needed
curl -fsSL https://raw.githubusercontent.com/romerodevv/psgho/main/simple-install.sh | bash
```

---

## 🎯 **Recommendation for You**

Since you're already comfortable with the command line, I recommend using the **simple installer** that works right now:

```bash
curl -fsSL https://raw.githubusercontent.com/romerodevv/psgho/main/simple-install.sh | bash
```

This will:
- ✅ Install Node.js if needed
- ✅ Download ALGORITMIT
- ✅ Install all dependencies
- ✅ Set up configuration
- ✅ Create helper scripts
- ✅ Work immediately (no releases needed)

**Then just:**
1. Edit `.env` with your wallet private key
2. Run `cd ~/algoritmit-bot && ./start.sh`
3. Enable Learning Mode first!

---

## 📧 **GitHub Releases Coming Soon**

I'll set up proper GitHub releases so the direct download links work. But for now, the methods above will get you up and running immediately!

**The ALGORITMIT Machine Learning Trading Bot is ready to use right now!** 🤖💹