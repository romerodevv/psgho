#!/bin/bash

# ALGORITMIT - Docker Installation Method
# Containerized deployment for easy management

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}"
echo "🐳 ALGORITMIT Docker Installation"
echo "================================="
echo -e "${NC}"

# Check if Docker is installed
if ! command -v docker >/dev/null 2>&1; then
    echo -e "${YELLOW}📦 Installing Docker...${NC}"
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    echo -e "${GREEN}✅ Docker installed. Please logout and login again.${NC}"
    exit 0
fi

# Create project directory
INSTALL_DIR="$HOME/algoritmit-docker"
echo -e "${BLUE}📁 Creating project directory: $INSTALL_DIR${NC}"
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

# Create Dockerfile
echo -e "${BLUE}🐳 Creating Dockerfile...${NC}"
cat > Dockerfile << 'EOF'
FROM node:20-alpine

# Set working directory
WORKDIR /app

# Install git and other dependencies
RUN apk add --no-cache git

# Clone ALGORITMIT repository
RUN git clone https://github.com/romerodevv/psgho.git .

# Install dependencies
RUN npm install
RUN npm install @holdstation/worldchain-sdk@latest
RUN npm install @holdstation/worldchain-ethers-v6@latest
RUN npm install @worldcoin/minikit-js@latest

# Create data directory for persistence
RUN mkdir -p /app/data

# Expose port (if needed for web interface in future)
EXPOSE 3000

# Start command
CMD ["node", "worldchain-trading-bot.js"]
EOF

# Create docker-compose.yml
echo -e "${BLUE}📝 Creating docker-compose.yml...${NC}"
cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  algoritmit:
    build: .
    container_name: algoritmit-bot
    restart: unless-stopped
    volumes:
      - ./config:/app/config
      - ./data:/app/data
      - ./logs:/app/logs
    environment:
      - NODE_ENV=production
    # Uncomment to run in interactive mode
    # stdin_open: true
    # tty: true
EOF

# Create configuration directory
echo -e "${BLUE}📂 Setting up configuration...${NC}"
mkdir -p config data logs

# Create .env template
cat > config/.env << 'EOF'
# ALGORITMIT Docker Configuration
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
EOF

# Create management scripts
echo -e "${BLUE}🛠️  Creating management scripts...${NC}"

# Start script
cat > start.sh << 'EOF'
#!/bin/bash
echo "🐳 Starting ALGORITMIT Docker Container..."
docker-compose up -d
echo "✅ Container started!"
echo "📋 Use 'docker-compose logs -f' to view logs"
EOF
chmod +x start.sh

# Stop script
cat > stop.sh << 'EOF'
#!/bin/bash
echo "🛑 Stopping ALGORITMIT Docker Container..."
docker-compose down
echo "✅ Container stopped!"
EOF
chmod +x stop.sh

# Interactive mode script
cat > interactive.sh << 'EOF'
#!/bin/bash
echo "🔄 Starting ALGORITMIT in interactive mode..."
docker-compose run --rm algoritmit
EOF
chmod +x interactive.sh

# Update script
cat > update.sh << 'EOF'
#!/bin/bash
echo "🔄 Updating ALGORITMIT..."
docker-compose down
docker-compose build --no-cache
docker-compose up -d
echo "✅ Update complete!"
EOF
chmod +x update.sh

# Logs script
cat > logs.sh << 'EOF'
#!/bin/bash
echo "📋 Showing ALGORITMIT logs..."
docker-compose logs -f
EOF
chmod +x logs.sh

# Build the Docker image
echo -e "${BLUE}🔨 Building Docker image...${NC}"
echo -e "${YELLOW}This may take 5-10 minutes...${NC}"
docker-compose build

echo ""
echo -e "${GREEN}🎉 ALGORITMIT Docker Installation Complete!${NC}"
echo ""
echo -e "${CYAN}📍 Installation Location:${NC} $INSTALL_DIR"
echo ""
echo -e "${YELLOW}🔧 NEXT STEPS:${NC}"
echo ""
echo -e "${WHITE}1. Configure your wallet:${NC}"
echo -e "   nano config/.env"
echo -e "   (Add your wallet private key)"
echo ""
echo -e "${WHITE}2. Start ALGORITMIT:${NC}"
echo -e "   ./interactive.sh    (for first-time setup)"
echo -e "   ./start.sh          (for background mode)"
echo ""
echo -e "${WHITE}3. Management commands:${NC}"
echo -e "   ./start.sh          - Start container"
echo -e "   ./stop.sh           - Stop container"
echo -e "   ./interactive.sh    - Interactive mode"
echo -e "   ./logs.sh           - View logs"
echo -e "   ./update.sh         - Update to latest version"
echo ""
echo -e "${RED}⚠️  SAFETY REMINDER:${NC}"
echo -e "${RED}   • Start with Learning Mode for 24+ hours${NC}"
echo -e "${RED}   • Use tiny amounts (0.01 WLD) for testing${NC}"
echo -e "${RED}   • Never risk more than you can afford to lose${NC}"
echo ""
echo -e "${GREEN}🐳 Docker deployment ready!${NC}"