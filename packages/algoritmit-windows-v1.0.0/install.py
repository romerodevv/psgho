#!/usr/bin/env python3
"""
ALGORITMIT - Universal Python Installer
Works on Windows, macOS, and Linux without bash
"""

import os
import sys
import subprocess
import platform
import urllib.request
import zipfile
import shutil
import json
from pathlib import Path

# Colors for cross-platform terminal output
class Colors:
    if platform.system() == "Windows":
        # Windows doesn't support ANSI colors by default
        RED = GREEN = YELLOW = BLUE = CYAN = PURPLE = WHITE = NC = ""
    else:
        RED = '\033[0;31m'
        GREEN = '\033[0;32m'
        YELLOW = '\033[1;33m'
        BLUE = '\033[0;34m'
        CYAN = '\033[0;36m'
        PURPLE = '\033[0;35m'
        WHITE = '\033[1;37m'
        NC = '\033[0m'

def print_banner():
    """Display the ALGORITMIT banner"""
    print(f"{Colors.CYAN}")
    print("╔══════════════════════════════════════════════════════════════════════════════════════╗")
    print("║                                                                                      ║")
    print("║     █████╗ ██╗      ██████╗  ██████╗ ██████╗ ██╗████████╗███╗   ███╗██╗████████╗   ║")
    print("║    ██╔══██╗██║     ██╔════╝ ██╔═══██╗██╔══██╗██║╚══██╔══╝████╗ ████║██║╚══██╔══╝   ║")
    print("║    ███████║██║     ██║  ███╗██║   ██║██████╔╝██║   ██║   ██╔████╔██║██║   ██║      ║")
    print("║    ██╔══██║██║     ██║   ██║██║   ██║██╔══██╗██║   ██║   ██║╚██╔╝██║██║   ██║      ║")
    print("║    ██║  ██║███████╗╚██████╔╝╚██████╔╝██║  ██║██║   ██║   ██║ ╚═╝ ██║██║   ██║      ║")
    print("║    ╚═╝  ╚═╝╚══════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝   ╚═╝   ╚═╝     ╚═╝╚═╝   ╚═╝      ║")
    print("║                                                                                      ║")
    print("║                    🐍 Universal Python Installer (No Bash!)                        ║")
    print("║                        Works on Windows, macOS, and Linux                          ║")
    print("╚══════════════════════════════════════════════════════════════════════════════════════╝")
    print(f"{Colors.NC}")

def print_step(step_num, title):
    """Print a step header"""
    print(f"\n{Colors.PURPLE}{'='*80}{Colors.NC}")
    print(f"{Colors.WHITE}STEP {step_num}: {title}{Colors.NC}")
    print(f"{Colors.PURPLE}{'='*80}{Colors.NC}")

def print_success(message):
    """Print success message"""
    print(f"{Colors.GREEN}✅ {message}{Colors.NC}")

def print_warning(message):
    """Print warning message"""
    print(f"{Colors.YELLOW}⚠️  {message}{Colors.NC}")

def print_error(message):
    """Print error message"""
    print(f"{Colors.RED}❌ {message}{Colors.NC}")

def print_info(message):
    """Print info message"""
    print(f"{Colors.BLUE}ℹ️  {message}{Colors.NC}")

def ask_yes_no(question, default=True):
    """Ask a yes/no question"""
    suffix = "(Y/n)" if default else "(y/N)"
    while True:
        answer = input(f"{Colors.CYAN}{question} {suffix}: {Colors.NC}").strip().lower()
        if answer == "":
            return default
        elif answer in ["y", "yes"]:
            return True
        elif answer in ["n", "no"]:
            return False
        else:
            print_error("Please answer yes or no.")

def run_command(command, shell=True, capture_output=True):
    """Run a system command safely"""
    try:
        if isinstance(command, str) and not shell:
            command = command.split()
        
        result = subprocess.run(
            command, 
            shell=shell, 
            capture_output=capture_output, 
            text=True,
            timeout=300  # 5 minute timeout
        )
        return result.returncode == 0, result.stdout, result.stderr
    except subprocess.TimeoutExpired:
        return False, "", "Command timed out"
    except Exception as e:
        return False, "", str(e)

def check_python_version():
    """Check if Python version is adequate"""
    version = sys.version_info
    if version.major < 3 or (version.major == 3 and version.minor < 7):
        print_error(f"Python 3.7+ required. You have Python {version.major}.{version.minor}")
        return False
    print_success(f"Python {version.major}.{version.minor}.{version.micro} detected")
    return True

def check_internet_connection():
    """Check if internet connection is available"""
    try:
        urllib.request.urlopen('https://www.google.com', timeout=5)
        print_success("Internet connection verified")
        return True
    except:
        print_error("No internet connection detected")
        return False

def detect_system():
    """Detect the operating system"""
    system = platform.system()
    print_info(f"Operating System: {system} {platform.release()}")
    print_info(f"Architecture: {platform.machine()}")
    return system

def check_node_js():
    """Check if Node.js is installed and get version"""
    success, stdout, stderr = run_command("node --version")
    if success:
        version = stdout.strip()
        major_version = int(version.replace('v', '').split('.')[0])
        print_success(f"Node.js {version} detected")
        return major_version >= 18
    else:
        print_warning("Node.js not found")
        return False

def install_node_js():
    """Install Node.js based on the operating system"""
    system = platform.system()
    
    print_info("Installing Node.js...")
    
    if system == "Windows":
        print_info("Please install Node.js manually from https://nodejs.org/")
        print_info("Download the Windows Installer (.msi) and run it")
        if ask_yes_no("Have you installed Node.js?", False):
            return check_node_js()
        return False
        
    elif system == "Darwin":  # macOS
        # Try to install via Homebrew
        success, _, _ = run_command("brew --version")
        if success:
            print_info("Installing Node.js via Homebrew...")
            success, _, _ = run_command("brew install node")
            return success
        else:
            print_info("Please install Node.js manually from https://nodejs.org/")
            if ask_yes_no("Have you installed Node.js?", False):
                return check_node_js()
            return False
            
    else:  # Linux
        print_info("Installing Node.js via NodeSource repository...")
        # Install Node.js 20 on Linux
        commands = [
            "curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -",
            "sudo apt-get install -y nodejs"
        ]
        
        for cmd in commands:
            success, stdout, stderr = run_command(cmd)
            if not success:
                print_error(f"Failed to install Node.js: {stderr}")
                return False
        
        return check_node_js()

def create_install_directory():
    """Create and return the installation directory"""
    home = Path.home()
    install_dir = home / "algoritmit-bot"
    
    print_info(f"Installation directory: {install_dir}")
    
    if install_dir.exists():
        print_warning("Directory already exists")
        if ask_yes_no("Remove existing directory?", False):
            shutil.rmtree(install_dir)
            print_success("Old directory removed")
        else:
            print_error("Installation cancelled")
            return None
    
    install_dir.mkdir(parents=True, exist_ok=True)
    print_success(f"Created directory: {install_dir}")
    return install_dir

def download_algoritmit(install_dir):
    """Download ALGORITMIT source code"""
    print_info("Downloading ALGORITMIT from GitHub...")
    
    zip_url = "https://github.com/romerodevv/psgho/archive/main.zip"
    zip_path = install_dir / "algoritmit.zip"
    
    try:
        # Download the ZIP file
        print_info("Downloading source code...")
        urllib.request.urlretrieve(zip_url, zip_path)
        print_success("Download completed")
        
        # Extract the ZIP file
        print_info("Extracting files...")
        with zipfile.ZipFile(zip_path, 'r') as zip_ref:
            zip_ref.extractall(install_dir)
        
        # Move files from extracted folder to install_dir
        extracted_dir = install_dir / "psgho-main"
        if extracted_dir.exists():
            for item in extracted_dir.iterdir():
                shutil.move(str(item), str(install_dir))
            extracted_dir.rmdir()
        
        # Clean up
        zip_path.unlink()
        print_success("Files extracted successfully")
        return True
        
    except Exception as e:
        print_error(f"Failed to download ALGORITMIT: {str(e)}")
        return False

def install_dependencies(install_dir):
    """Install Node.js dependencies"""
    print_info("Installing Node.js dependencies...")
    
    # Change to install directory
    original_dir = os.getcwd()
    os.chdir(install_dir)
    
    try:
        # Install main dependencies
        print_info("Installing core packages...")
        success, stdout, stderr = run_command("npm install", capture_output=False)
        if not success:
            print_error(f"Failed to install core packages: {stderr}")
            return False
        print_success("Core packages installed")
        
        # Install HoldStation SDK
        print_info("Installing HoldStation SDK...")
        sdk_packages = [
            "@holdstation/worldchain-sdk@latest",
            "@holdstation/worldchain-ethers-v6@latest", 
            "@worldcoin/minikit-js@latest"
        ]
        
        for package in sdk_packages:
            success, stdout, stderr = run_command(f"npm install {package}", capture_output=False)
            if not success:
                print_warning(f"Failed to install {package}: {stderr}")
            else:
                print_success(f"Installed {package}")
        
        return True
        
    except Exception as e:
        print_error(f"Error installing dependencies: {str(e)}")
        return False
    finally:
        os.chdir(original_dir)

def create_configuration(install_dir):
    """Create configuration file"""
    print_info("Setting up configuration...")
    
    env_content = """# ALGORITMIT Configuration
PRIVATE_KEY_1=your_private_key_here
WALLET_NAME_1=Main Trading Wallet

# RPC Configuration
WORLDCHAIN_RPC_URL=https://worldchain-mainnet.g.alchemy.com/public
ALCHEMY_API_KEY=your_alchemy_api_key_here

# Trading Configuration
WLD_TOKEN_ADDRESS=0x2cfc85d8e48f8eab294be644d9e25C3030863003
DEFAULT_SLIPPAGE=1.0
MAX_GAS_PRICE=50

# ALGORITMIT ML Settings
ML_CONFIDENCE_THRESHOLD=75
ML_MAX_POSITION_SIZE=0.1
ML_LEARNING_MODE=true
ML_AUTO_TRADING=false
"""
    
    env_path = install_dir / ".env"
    try:
        with open(env_path, 'w') as f:
            f.write(env_content)
        print_success("Configuration file created (.env)")
        return True
    except Exception as e:
        print_error(f"Failed to create configuration: {str(e)}")
        return False

def create_helper_scripts(install_dir):
    """Create helper scripts for different platforms"""
    system = platform.system()
    
    if system == "Windows":
        # Create Windows batch files
        start_script = install_dir / "start.bat"
        with open(start_script, 'w') as f:
            f.write("""@echo off
echo 🤖 Starting ALGORITMIT Machine Learning Trading Bot...
echo 📊 Version 3.0 - AI-Powered Trading for Worldchain
echo.
echo ⚠️  SAFETY REMINDER:
echo    • Start with Learning Mode for 24+ hours
echo    • Use tiny amounts (0.01 WLD) for testing
echo    • Never risk more than you can afford to lose
echo.
node worldchain-trading-bot.js
pause
""")
        
        update_script = install_dir / "update.bat"
        with open(update_script, 'w') as f:
            f.write("""@echo off
echo 🔄 Updating ALGORITMIT...
python install.py
echo ✅ Update complete!
pause
""")
        
        print_success("Created Windows batch files (start.bat, update.bat)")
        
    else:
        # Create shell scripts for macOS/Linux
        start_script = install_dir / "start.sh"
        with open(start_script, 'w') as f:
            f.write("""#!/bin/bash
echo "🤖 Starting ALGORITMIT Machine Learning Trading Bot..."
echo "📊 Version 3.0 - AI-Powered Trading for Worldchain"
echo ""
echo "⚠️  SAFETY REMINDER:"
echo "   • Start with Learning Mode for 24+ hours"
echo "   • Use tiny amounts (0.01 WLD) for testing"
echo "   • Never risk more than you can afford to lose"
echo ""
node worldchain-trading-bot.js
""")
        start_script.chmod(0o755)
        
        update_script = install_dir / "update.sh"
        with open(update_script, 'w') as f:
            f.write("""#!/bin/bash
echo "🔄 Updating ALGORITMIT..."
python3 install.py
echo "✅ Update complete!"
""")
        update_script.chmod(0o755)
        
        print_success("Created shell scripts (start.sh, update.sh)")

def run_installation():
    """Main installation function"""
    print_banner()
    
    print(f"{Colors.WHITE}🐍 Welcome to ALGORITMIT Universal Python Installer{Colors.NC}")
    print(f"{Colors.BLUE}This installer works on Windows, macOS, and Linux - No bash required!{Colors.NC}")
    print(f"{Colors.BLUE}Perfect for users who want a simple, cross-platform installation.{Colors.NC}")
    print()
    print_warning("Important: This is a machine learning trading bot that handles real money.")
    print_warning("Please read each step carefully and understand what you're installing.")
    print()
    
    if not ask_yes_no("Continue with installation?", True):
        print_info("Installation cancelled by user.")
        return False
    
    # Step 1: System Check
    print_step(1, "System Requirements Check")
    
    if not check_python_version():
        return False
    
    if not check_internet_connection():
        return False
    
    system = detect_system()
    
    # Step 2: Node.js Check/Install
    print_step(2, "Node.js Installation")
    
    if not check_node_js():
        if ask_yes_no("Install Node.js automatically?", True):
            if not install_node_js():
                print_error("Node.js installation failed. Please install manually.")
                return False
        else:
            print_info("Please install Node.js 18+ manually from https://nodejs.org/")
            return False
    
    # Step 3: Create Installation Directory
    print_step(3, "Setup Installation Directory")
    
    install_dir = create_install_directory()
    if not install_dir:
        return False
    
    # Step 4: Download ALGORITMIT
    print_step(4, "Download ALGORITMIT Source Code")
    
    if not download_algoritmit(install_dir):
        return False
    
    # Step 5: Install Dependencies
    print_step(5, "Install Dependencies")
    
    if not install_dependencies(install_dir):
        print_warning("Some dependencies may have failed to install.")
        if not ask_yes_no("Continue anyway?", True):
            return False
    
    # Step 6: Create Configuration
    print_step(6, "Setup Configuration")
    
    if not create_configuration(install_dir):
        return False
    
    # Step 7: Create Helper Scripts
    print_step(7, "Create Helper Scripts")
    
    create_helper_scripts(install_dir)
    
    # Step 8: Final Instructions
    print_step(8, "🎉 Installation Complete!")
    
    print_success("ALGORITMIT Machine Learning Trading Bot has been successfully installed!")
    print()
    print(f"{Colors.CYAN}📍 Installation Location:{Colors.NC} {install_dir}")
    print()
    print(f"{Colors.WHITE}🚀 NEXT STEPS:{Colors.NC}")
    print()
    print(f"{Colors.YELLOW}1. Configure your wallet:{Colors.NC}")
    print(f"   Edit the file: {install_dir}/.env")
    print(f"   Add your wallet private key to PRIVATE_KEY_1")
    print()
    print(f"{Colors.YELLOW}2. Start ALGORITMIT:{Colors.NC}")
    if system == "Windows":
        print(f"   Double-click: {install_dir}/start.bat")
        print(f"   Or run: cd {install_dir} && node worldchain-trading-bot.js")
    else:
        print(f"   Run: cd {install_dir} && ./start.sh")
        print(f"   Or: cd {install_dir} && node worldchain-trading-bot.js")
    print()
    print(f"{Colors.YELLOW}3. CRITICAL - Enable Learning Mode FIRST:{Colors.NC}")
    print(f"   • Go to Menu Option 7 (🤖 ALGORITMIT)")
    print(f"   • Enable ALGORITMIT Strategy")
    print(f"   • Turn on Learning Mode")
    print(f"   • Let it learn for 24+ hours (DO NOT SKIP!)")
    print()
    print(f"{Colors.RED}⚠️  CRITICAL SAFETY REMINDERS:{Colors.NC}")
    print(f"{Colors.RED}   • ALWAYS start with Learning Mode for 24+ hours{Colors.NC}")
    print(f"{Colors.RED}   • Use tiny amounts (0.01 WLD) for initial testing{Colors.NC}")
    print(f"{Colors.RED}   • Never risk more than you can afford to lose{Colors.NC}")
    print(f"{Colors.RED}   • Monitor all trades closely{Colors.NC}")
    print()
    print(f"{Colors.GREEN}🎯 Ready to revolutionize your trading with AI! Good luck!{Colors.NC}")
    
    return True

if __name__ == "__main__":
    try:
        success = run_installation()
        sys.exit(0 if success else 1)
    except KeyboardInterrupt:
        print(f"\n{Colors.YELLOW}Installation cancelled by user.{Colors.NC}")
        sys.exit(1)
    except Exception as e:
        print_error(f"Unexpected error: {str(e)}")
        sys.exit(1)