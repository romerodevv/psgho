@echo off
echo 🤖 ALGORITMIT Windows Installer
echo ===============================
echo.
echo This will install ALGORITMIT Machine Learning Trading Bot
echo.
pause

echo 📋 Checking Python...
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Python not found. Please install Python 3.7+ from https://python.org
    echo    Make sure to check "Add Python to PATH" during installation
    pause
    exit /b 1
)

echo ✅ Python found
echo.

echo 🔧 Running Python installer...
python install.py

echo.
echo 🎉 Installation complete!
echo.
echo 📝 Next steps:
echo 1. Edit .env file with your wallet private key
echo 2. Double-click START.bat to run ALGORITMIT
echo.
pause
