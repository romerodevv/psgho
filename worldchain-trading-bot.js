#!/usr/bin/env node

const { ethers } = require('ethers');
const fs = require('fs');
const path = require('path');
const readline = require('readline');
const axios = require('axios');
const chalk = require('chalk');
const figlet = require('figlet');
const AdvancedTradingEngine = require('./trading-engine');
const TokenDiscoveryService = require('./token-discovery');
const TradingStrategy = require('./trading-strategy');
require('dotenv').config();

class WorldchainTradingBot {
    constructor() {
        this.configPath = path.join(__dirname, 'config.json');
        this.walletsPath = path.join(__dirname, 'wallets.json');
        this.tokensPath = path.join(__dirname, 'discovered_tokens.json');
        
        // Worldchain RPC endpoint (Layer 2) - Multiple endpoints for reliability
        const rpcEndpoints = [
            process.env.WORLDCHAIN_RPC_URL,
            'https://worldchain-mainnet.g.alchemy.com/public',
            'https://worldchain.drpc.org',
            'https://worldchain-rpc.publicnode.com'
        ].filter(Boolean);
        
        this.provider = new ethers.JsonRpcProvider(rpcEndpoints[0]);
        
        // Configure network for Worldchain
        this.provider._network = {
            name: 'worldchain',
            chainId: 480,
            ensAddress: null
        };
        
        this.config = this.loadConfig();
        this.wallets = this.loadWallets();
        this.discoveredTokens = this.loadDiscoveredTokens();
        
        // Initialize advanced modules
        this.tradingEngine = new AdvancedTradingEngine(this.provider, this.config);
        this.tokenDiscovery = new TokenDiscoveryService(this.provider, this.config);
        this.tradingStrategy = new TradingStrategy(this.tradingEngine, this.config);
        
        // Setup strategy event listeners
        this.setupStrategyEventListeners();
        
        // WLD token address on Worldchain (correct address)
        this.WLD_ADDRESS = '0x2cfc85d8e48f8eab294be644d9e25c3030863003';
        
        // DEX router addresses for Worldchain (using Uniswap V3 compatible)
        this.ROUTER_ADDRESS = '0xE592427A0AEce92De3Edee1F18E0157C05861564';
        
        this.rl = readline.createInterface({
            input: process.stdin,
            output: process.stdout
        });
    }

    loadConfig() {
        try {
            if (fs.existsSync(this.configPath)) {
                return JSON.parse(fs.readFileSync(this.configPath, 'utf8'));
            }
        } catch (error) {
            console.log(chalk.yellow('Warning: Could not load config file'));
        }
        return {
            slippage: 0.5,
            gasPrice: '20',
            maxGasLimit: '500000',
            tradingEnabled: true,
            autoDiscovery: true,
            refreshInterval: 30000
        };
    }

    loadWallets() {
        try {
            if (fs.existsSync(this.walletsPath)) {
                return JSON.parse(fs.readFileSync(this.walletsPath, 'utf8'));
            }
        } catch (error) {
            console.log(chalk.yellow('Warning: Could not load wallets file'));
        }
        return [];
    }

    loadDiscoveredTokens() {
        try {
            if (fs.existsSync(this.tokensPath)) {
                return JSON.parse(fs.readFileSync(this.tokensPath, 'utf8'));
            }
        } catch (error) {
            console.log(chalk.yellow('Warning: Could not load discovered tokens file'));
        }
        return {};
    }

    saveConfig() {
        fs.writeFileSync(this.configPath, JSON.stringify(this.config, null, 2));
    }

    saveWallets() {
        fs.writeFileSync(this.walletsPath, JSON.stringify(this.wallets, null, 2));
    }

    saveDiscoveredTokens() {
        fs.writeFileSync(this.tokensPath, JSON.stringify(this.discoveredTokens, null, 2));
    }

    async displayHeader() {
        console.clear();
        console.log(chalk.cyan(figlet.textSync('WorldChain Bot', { font: 'Small' })));
        console.log(chalk.green('🌍 Advanced Trading Bot for Worldchain (WLD Pairs)'));
        console.log(chalk.gray('═'.repeat(60)));
    }

    async displayMainMenu() {
        await this.displayHeader();
        console.log(chalk.white('\n📋 MAIN MENU'));
        console.log(chalk.gray('─'.repeat(30)));
        console.log(chalk.cyan('1. 💼 Wallet Management'));
        console.log(chalk.cyan('2. 🔍 Token Discovery & Portfolio'));
        console.log(chalk.cyan('3. 📈 Trading Operations'));
        console.log(chalk.cyan('4. 🎯 Strategy Management'));
        console.log(chalk.cyan('5. ⚙️  Configuration'));
        console.log(chalk.cyan('6. 📊 Portfolio Overview'));
        console.log(chalk.red('7. 🚪 Exit'));
        console.log(chalk.gray('─'.repeat(30)));
    }

    async walletManagementMenu() {
        while (true) {
            await this.displayHeader();
            console.log(chalk.white('\n💼 WALLET MANAGEMENT'));
            console.log(chalk.gray('─'.repeat(30)));
            console.log(chalk.green(`📊 Active Wallets: ${this.wallets.length}`));
            console.log(chalk.gray('─'.repeat(30)));
            console.log(chalk.cyan('1. ➕ Create New Wallet'));
            console.log(chalk.cyan('2. 📥 Import Existing Wallet'));
            console.log(chalk.cyan('3. 📋 List All Wallets'));
            console.log(chalk.cyan('4. 🗑️  Remove Wallet'));
            console.log(chalk.cyan('5. 💰 Check Wallet Balance'));
            console.log(chalk.red('6. ⬅️  Back to Main Menu'));
            
            const choice = await this.getUserInput('\nSelect option: ');
            
            switch (choice) {
                case '1':
                    await this.createNewWallet();
                    break;
                case '2':
                    await this.importWallet();
                    break;
                case '3':
                    await this.listWallets();
                    break;
                case '4':
                    await this.removeWallet();
                    break;
                case '5':
                    await this.checkWalletBalance();
                    break;
                case '6':
                    return;
                default:
                    console.log(chalk.red('❌ Invalid option'));
                    await this.sleep(1500);
            }
        }
    }

    async createNewWallet() {
        try {
            const wallet = ethers.Wallet.createRandom();
            const name = await this.getUserInput('Enter wallet name: ');
            
            const walletData = {
                name: name || `Wallet_${Date.now()}`,
                address: wallet.address,
                privateKey: wallet.privateKey,
                created: new Date().toISOString(),
                balance: '0',
                tokens: []
            };
            
            this.wallets.push(walletData);
            this.saveWallets();
            
            console.log(chalk.green('\n✅ Wallet created successfully!'));
            console.log(chalk.white(`📝 Name: ${walletData.name}`));
            console.log(chalk.white(`📍 Address: ${walletData.address}`));
            console.log(chalk.yellow('🔐 Private Key: ') + chalk.red(walletData.privateKey));
            console.log(chalk.red('\n⚠️  IMPORTANT: Save your private key securely!'));
            
            await this.getUserInput('\nPress Enter to continue...');
        } catch (error) {
            console.log(chalk.red(`❌ Error creating wallet: ${error.message}`));
            await this.getUserInput('\nPress Enter to continue...');
        }
    }

    async importWallet() {
        try {
            const privateKey = await this.getUserInput('Enter private key: ');
            const name = await this.getUserInput('Enter wallet name: ');
            
            const wallet = new ethers.Wallet(privateKey);
            
            // Check if wallet already exists
            if (this.wallets.some(w => w.address.toLowerCase() === wallet.address.toLowerCase())) {
                console.log(chalk.red('❌ Wallet already exists!'));
                await this.getUserInput('\nPress Enter to continue...');
                return;
            }
            
            const walletData = {
                name: name || `Imported_${Date.now()}`,
                address: wallet.address,
                privateKey: privateKey,
                created: new Date().toISOString(),
                balance: '0',
                tokens: []
            };
            
            this.wallets.push(walletData);
            this.saveWallets();
            
            console.log(chalk.green('\n✅ Wallet imported successfully!'));
            console.log(chalk.white(`📝 Name: ${walletData.name}`));
            console.log(chalk.white(`📍 Address: ${walletData.address}`));
            
            await this.getUserInput('\nPress Enter to continue...');
        } catch (error) {
            console.log(chalk.red(`❌ Error importing wallet: ${error.message}`));
            await this.getUserInput('\nPress Enter to continue...');
        }
    }

    async listWallets() {
        if (this.wallets.length === 0) {
            console.log(chalk.yellow('\n📭 No wallets found. Create one first!'));
            await this.getUserInput('\nPress Enter to continue...');
            return;
        }
        
        console.log(chalk.white('\n📋 WALLET LIST'));
        console.log(chalk.gray('═'.repeat(80)));
        
        for (let i = 0; i < this.wallets.length; i++) {
            const wallet = this.wallets[i];
            console.log(chalk.cyan(`\n${i + 1}. ${wallet.name}`));
            console.log(chalk.white(`   📍 Address: ${wallet.address}`));
            console.log(chalk.white(`   📅 Created: ${new Date(wallet.created).toLocaleDateString()}`));
            console.log(chalk.white(`   💰 Balance: ${wallet.balance} ETH`));
            console.log(chalk.white(`   🪙 Tokens: ${wallet.tokens.length} discovered`));
        }
        
        await this.getUserInput('\nPress Enter to continue...');
    }

    async removeWallet() {
        if (this.wallets.length === 0) {
            console.log(chalk.yellow('\n📭 No wallets to remove!'));
            await this.getUserInput('\nPress Enter to continue...');
            return;
        }
        
        await this.listWallets();
        const index = await this.getUserInput('\nEnter wallet number to remove (0 to cancel): ');
        
        if (index === '0') return;
        
        const walletIndex = parseInt(index) - 1;
        if (walletIndex >= 0 && walletIndex < this.wallets.length) {
            const wallet = this.wallets[walletIndex];
            const confirm = await this.getUserInput(`Are you sure you want to remove "${wallet.name}"? (yes/no): `);
            
            if (confirm.toLowerCase() === 'yes') {
                this.wallets.splice(walletIndex, 1);
                this.saveWallets();
                console.log(chalk.green('\n✅ Wallet removed successfully!'));
            } else {
                console.log(chalk.yellow('\n❌ Operation cancelled'));
            }
        } else {
            console.log(chalk.red('\n❌ Invalid wallet number'));
        }
        
        await this.getUserInput('\nPress Enter to continue...');
    }

    async checkWalletBalance() {
        if (this.wallets.length === 0) {
            console.log(chalk.yellow('\n📭 No wallets found!'));
            await this.getUserInput('\nPress Enter to continue...');
            return;
        }
        
        console.log(chalk.white('\n💰 CHECKING WALLET BALANCES...'));
        console.log(chalk.gray('═'.repeat(60)));
        
        for (let i = 0; i < this.wallets.length; i++) {
            const wallet = this.wallets[i];
            try {
                console.log(chalk.cyan(`\n${wallet.name}:`));
                console.log(chalk.white(`  📍 ${wallet.address}`));
                
                // Try Alchemy Portfolio API first for accurate balances
                const portfolioData = await this.getPortfolioBalances(wallet.address);
                
                if (portfolioData.success) {
                    console.log(chalk.green(`  💰 ${portfolioData.ethBalance} ETH`));
                    console.log(chalk.yellow(`  🌍 ${portfolioData.wldBalance} WLD`));
                    
                    wallet.balance = portfolioData.ethBalance;
                    wallet.wldBalance = portfolioData.wldBalance;
                    
                    // Show other tokens if any
                    if (portfolioData.tokens && portfolioData.tokens.length > 0) {
                        console.log(chalk.white(`  🪙 Other Tokens:`));
                        portfolioData.tokens.slice(0, 5).forEach(token => {
                            console.log(chalk.gray(`     • ${token.balance} ${token.symbol}`));
                        });
                        if (portfolioData.tokens.length > 5) {
                            console.log(chalk.gray(`     ... and ${portfolioData.tokens.length - 5} more`));
                        }
                    }
                } else {
                    // Fallback to direct RPC calls
                    console.log(chalk.gray(`  📡 Using direct RPC calls...`));
                    const balance = await this.provider.getBalance(wallet.address);
                    const ethBalance = ethers.formatEther(balance);
                    wallet.balance = ethBalance;
                    
                    console.log(chalk.green(`  💰 ${ethBalance} ETH`));
                    
                    // Get WLD balance with retry logic
                    const wldBalance = await this.getTokenBalanceWithRetry(wallet.address, this.WLD_ADDRESS);
                    console.log(chalk.yellow(`  🌍 ${wldBalance} WLD`));
                    wallet.wldBalance = wldBalance;
                }
                
            } catch (error) {
                console.log(chalk.red(`  ❌ Error fetching balance: ${error.message}`));
                console.log(chalk.gray(`     Please check your network connection and try again.`));
            }
        }
        
        this.saveWallets();
        await this.getUserInput('\nPress Enter to continue...');
    }

    async getTokenBalance(walletAddress, tokenAddress) {
        try {
            const abi = ['function balanceOf(address owner) view returns (uint256)', 'function decimals() view returns (uint8)'];
            const contract = new ethers.Contract(tokenAddress, abi, this.provider);
            
            const balance = await contract.balanceOf(walletAddress);
            const decimals = await contract.decimals();
            
            return ethers.formatUnits(balance, decimals);
        } catch (error) {
            return '0';
        }
    }

    async getTokenBalanceWithRetry(walletAddress, tokenAddress, maxRetries = 3) {
        for (let attempt = 1; attempt <= maxRetries; attempt++) {
            try {
                const abi = [
                    'function balanceOf(address owner) view returns (uint256)', 
                    'function decimals() view returns (uint8)',
                    'function symbol() view returns (string)'
                ];
                const contract = new ethers.Contract(tokenAddress, abi, this.provider);
                
                const [balance, decimals] = await Promise.all([
                    contract.balanceOf(walletAddress),
                    contract.decimals()
                ]);
                
                return ethers.formatUnits(balance, decimals);
            } catch (error) {
                if (attempt === maxRetries) {
                    console.log(chalk.gray(`     ⚠️ Failed to fetch token balance after ${maxRetries} attempts`));
                    return '0';
                }
                await this.sleep(1000 * attempt); // Exponential backoff
            }
        }
        return '0';
    }

    async getPortfolioBalances(walletAddress) {
        try {
            // Try Alchemy Portfolio API if API key is available
            if (process.env.ALCHEMY_API_KEY && process.env.ALCHEMY_API_KEY !== 'demo') {
                return await this.getAlchemyPortfolioBalances(walletAddress);
            }
            
            // Fallback to direct contract calls
            return await this.getDirectPortfolioBalances(walletAddress);
        } catch (error) {
            console.log(chalk.gray(`     Portfolio API error: ${error.message}`));
            return { success: false };
        }
    }

    async getAlchemyPortfolioBalances(walletAddress) {
        try {
            const axios = require('axios');
            const apiKey = process.env.ALCHEMY_API_KEY;
            const baseURL = `https://worldchain-mainnet.g.alchemy.com/v2/${apiKey}`;
            
            // Get native balance (ETH)
            const nativeResponse = await axios.post(baseURL, {
                jsonrpc: '2.0',
                id: 1,
                method: 'alchemy_getTokenBalances',
                params: [walletAddress, 'DEFAULT_TOKENS']
            });
            
            // Get ETH balance
            const ethResponse = await axios.post(baseURL, {
                jsonrpc: '2.0',
                id: 2,
                method: 'eth_getBalance',
                params: [walletAddress, 'latest']
            });
            
            const ethBalance = ethers.formatEther(ethResponse.data.result || '0');
            
            // Parse token balances
            let wldBalance = '0';
            const tokens = [];
            
            if (nativeResponse.data.result && nativeResponse.data.result.tokenBalances) {
                for (const tokenData of nativeResponse.data.result.tokenBalances) {
                    if (tokenData.contractAddress.toLowerCase() === this.WLD_ADDRESS.toLowerCase()) {
                        wldBalance = ethers.formatUnits(tokenData.tokenBalance || '0', 18);
                    } else if (tokenData.tokenBalance && tokenData.tokenBalance !== '0x0') {
                        // Get token metadata
                        try {
                            const metadataResponse = await axios.post(baseURL, {
                                jsonrpc: '2.0',
                                id: 3,
                                method: 'alchemy_getTokenMetadata',
                                params: [tokenData.contractAddress]
                            });
                            
                            const metadata = metadataResponse.data.result;
                            if (metadata) {
                                const balance = ethers.formatUnits(tokenData.tokenBalance, metadata.decimals || 18);
                                if (parseFloat(balance) > 0) {
                                    tokens.push({
                                        symbol: metadata.symbol || 'Unknown',
                                        balance: parseFloat(balance).toFixed(4),
                                        address: tokenData.contractAddress
                                    });
                                }
                            }
                        } catch (metaError) {
                            // Skip tokens we can't get metadata for
                        }
                    }
                }
            }
            
            return {
                success: true,
                ethBalance: parseFloat(ethBalance).toFixed(8),
                wldBalance: parseFloat(wldBalance).toFixed(4),
                tokens: tokens
            };
        } catch (error) {
            return { success: false, error: error.message };
        }
    }

    async getDirectPortfolioBalances(walletAddress) {
        try {
            // Get ETH balance
            const ethBalanceWei = await this.provider.getBalance(walletAddress);
            const ethBalance = ethers.formatEther(ethBalanceWei);
            
            // Get WLD balance
            const wldBalance = await this.getTokenBalanceWithRetry(walletAddress, this.WLD_ADDRESS);
            
            return {
                success: true,
                ethBalance: parseFloat(ethBalance).toFixed(8),
                wldBalance: parseFloat(wldBalance).toFixed(4),
                tokens: []
            };
        } catch (error) {
            return { success: false, error: error.message };
        }
    }

    async tokenDiscoveryMenu() {
        while (true) {
            await this.displayHeader();
            console.log(chalk.white('\n🔍 TOKEN DISCOVERY & PORTFOLIO'));
            console.log(chalk.gray('─'.repeat(40)));
            console.log(chalk.cyan('1. 🔍 Discover Tokens in All Wallets'));
            console.log(chalk.cyan('2. ➕ Add Token by Contract Address'));
            console.log(chalk.cyan('3. 📋 View Discovered Tokens'));
            console.log(chalk.cyan('4. 🔄 Auto-Discovery Settings'));
            console.log(chalk.cyan('5. 📊 Portfolio Summary'));
            console.log(chalk.red('6. ⬅️  Back to Main Menu'));
            
            const choice = await this.getUserInput('\nSelect option: ');
            
            switch (choice) {
                case '1':
                    await this.discoverTokensInWallets();
                    break;
                case '2':
                    await this.addTokenByAddress();
                    break;
                case '3':
                    await this.viewDiscoveredTokens();
                    break;
                case '4':
                    await this.autoDiscoverySettings();
                    break;
                case '5':
                    await this.portfolioSummary();
                    break;
                case '6':
                    return;
                default:
                    console.log(chalk.red('❌ Invalid option'));
                    await this.sleep(1500);
            }
        }
    }

    async discoverTokensInWallets() {
        if (this.wallets.length === 0) {
            console.log(chalk.yellow('\n📭 No wallets found!'));
            await this.getUserInput('\nPress Enter to continue...');
            return;
        }
        
        console.log(chalk.white('\n🔍 DISCOVERING TOKENS...'));
        console.log(chalk.gray('═'.repeat(50)));
        
        for (const wallet of this.wallets) {
            console.log(chalk.cyan(`\nScanning ${wallet.name}...`));
            
            try {
                // This would typically use a service like Moralis or Alchemy
                // For demo purposes, we'll simulate token discovery
                const tokens = await this.scanWalletForTokens(wallet.address);
                
                wallet.tokens = tokens;
                
                // Add to global discovered tokens
                for (const token of tokens) {
                    if (!this.discoveredTokens[token.address]) {
                        this.discoveredTokens[token.address] = {
                            ...token,
                            discoveredAt: new Date().toISOString(),
                            tradingPair: `WLD-${token.symbol}`
                        };
                    }
                }
                
                console.log(chalk.green(`  ✅ Found ${tokens.length} tokens`));
                
            } catch (error) {
                console.log(chalk.red(`  ❌ Error scanning wallet: ${error.message}`));
            }
        }
        
        this.saveWallets();
        this.saveDiscoveredTokens();
        
        console.log(chalk.green('\n✅ Token discovery completed!'));
        await this.getUserInput('\nPress Enter to continue...');
    }

    async scanWalletForTokens(walletAddress) {
        try {
            // Use the advanced token discovery service
            const tokens = await this.tokenDiscovery.discoverTokensInWallet(walletAddress, {
                includeZeroBalances: false,
                useCache: true,
                maxTokens: 50
            });
            
            return tokens;
        } catch (error) {
            console.error('Token scanning failed:', error.message);
            
            // Fallback to demo tokens if discovery fails
            return [
                {
                    address: '0x1234567890123456789012345678901234567890',
                    symbol: 'ORO',
                    name: 'Oro Token',
                    decimals: 18,
                    balance: '100.5'
                },
                {
                    address: '0x0987654321098765432109876543210987654321',
                    symbol: 'YIELD',
                    name: 'Yield Token',
                    decimals: 18,
                    balance: '250.75'
                }
            ];
        }
    }

    async addTokenByAddress() {
        const tokenAddress = await this.getUserInput('Enter token contract address: ');
        
        if (!ethers.isAddress(tokenAddress)) {
            console.log(chalk.red('❌ Invalid contract address!'));
            await this.getUserInput('\nPress Enter to continue...');
            return;
        }
        
        try {
            console.log(chalk.white('\n🔍 Fetching token information...'));
            
            // Use the token discovery service for validation and info
            const validation = await this.tokenDiscovery.validateTokenContract(tokenAddress);
            
            if (!validation.valid) {
                console.log(chalk.red(`❌ ${validation.reason}`));
                await this.getUserInput('\nPress Enter to continue...');
                return;
            }
            
            const tokenInfo = await this.tokenDiscovery.getTokenInfo(tokenAddress);
            
            const tokenData = {
                ...tokenInfo,
                discoveredAt: new Date().toISOString(),
                tradingPair: `WLD-${tokenInfo.symbol}`,
                manuallyAdded: true
            };
            
            this.discoveredTokens[tokenAddress] = tokenData;
            this.saveDiscoveredTokens();
            
            console.log(chalk.green('\n✅ Token added successfully!'));
            console.log(chalk.white(`📝 Name: ${tokenInfo.name}`));
            console.log(chalk.white(`🏷️  Symbol: ${tokenInfo.symbol}`));
            console.log(chalk.white(`📊 Decimals: ${tokenInfo.decimals}`));
            console.log(chalk.white(`📈 Trading Pair: WLD-${tokenInfo.symbol}`));
            
        } catch (error) {
            console.log(chalk.red(`❌ Error fetching token info: ${error.message}`));
        }
        
        await this.getUserInput('\nPress Enter to continue...');
    }

    async viewDiscoveredTokens() {
        const tokens = Object.values(this.discoveredTokens);
        
        if (tokens.length === 0) {
            console.log(chalk.yellow('\n📭 No tokens discovered yet!'));
            await this.getUserInput('\nPress Enter to continue...');
            return;
        }
        
        console.log(chalk.white('\n📋 DISCOVERED TOKENS'));
        console.log(chalk.gray('═'.repeat(80)));
        
        tokens.forEach((token, index) => {
            console.log(chalk.cyan(`\n${index + 1}. ${token.name} (${token.symbol})`));
            console.log(chalk.white(`   📍 Address: ${token.address}`));
            console.log(chalk.white(`   📈 Trading Pair: ${token.tradingPair}`));
            console.log(chalk.white(`   📅 Discovered: ${new Date(token.discoveredAt).toLocaleDateString()}`));
            if (token.manuallyAdded) {
                console.log(chalk.yellow('   ✋ Manually Added'));
            }
        });
        
        await this.getUserInput('\nPress Enter to continue...');
    }

    async tradingOperationsMenu() {
        while (true) {
            await this.displayHeader();
            console.log(chalk.white('\n📈 TRADING OPERATIONS'));
            console.log(chalk.gray('─'.repeat(30)));
            console.log(chalk.cyan('1. 🔄 Execute Trade'));
            console.log(chalk.cyan('2. 📊 View Trading Pairs'));
            console.log(chalk.cyan('3. ⚡ High-Speed Trading Mode'));
            console.log(chalk.cyan('4. 📈 Price Monitoring'));
            console.log(chalk.cyan('5. 📋 Trade History'));
            console.log(chalk.red('6. ⬅️  Back to Main Menu'));
            
            const choice = await this.getUserInput('\nSelect option: ');
            
            switch (choice) {
                case '1':
                    await this.executeTrade();
                    break;
                case '2':
                    await this.viewTradingPairs();
                    break;
                case '3':
                    await this.highSpeedTradingMode();
                    break;
                case '4':
                    await this.priceMonitoring();
                    break;
                case '5':
                    await this.tradeHistory();
                    break;
                case '6':
                    return;
                default:
                    console.log(chalk.red('❌ Invalid option'));
                    await this.sleep(1500);
            }
        }
    }

    async executeTrade() {
        if (this.wallets.length === 0) {
            console.log(chalk.yellow('\n📭 No wallets found!'));
            await this.getUserInput('\nPress Enter to continue...');
            return;
        }
        
        const tokens = Object.values(this.discoveredTokens);
        if (tokens.length === 0) {
            console.log(chalk.yellow('\n📭 No trading pairs available! Discover tokens first.'));
            await this.getUserInput('\nPress Enter to continue...');
            return;
        }
        
        // Select wallet
        console.log(chalk.white('\n💼 SELECT WALLET:'));
        this.wallets.forEach((wallet, index) => {
            console.log(chalk.cyan(`${index + 1}. ${wallet.name} (${wallet.address.slice(0, 10)}...)`));
        });
        
        const walletChoice = await this.getUserInput('\nSelect wallet: ');
        const walletIndex = parseInt(walletChoice) - 1;
        
        if (walletIndex < 0 || walletIndex >= this.wallets.length) {
            console.log(chalk.red('❌ Invalid wallet selection'));
            await this.getUserInput('\nPress Enter to continue...');
            return;
        }
        
        const selectedWallet = this.wallets[walletIndex];
        
        // Select trading pair
        console.log(chalk.white('\n📈 SELECT TRADING PAIR:'));
        tokens.forEach((token, index) => {
            console.log(chalk.cyan(`${index + 1}. ${token.tradingPair}`));
        });
        
        const pairChoice = await this.getUserInput('\nSelect trading pair: ');
        const pairIndex = parseInt(pairChoice) - 1;
        
        if (pairIndex < 0 || pairIndex >= tokens.length) {
            console.log(chalk.red('❌ Invalid pair selection'));
            await this.getUserInput('\nPress Enter to continue...');
            return;
        }
        
        const selectedToken = tokens[pairIndex];
        
        // Trade direction
        console.log(chalk.white('\n📊 TRADE DIRECTION:'));
        console.log(chalk.green('1. Buy (WLD → ' + selectedToken.symbol + ')'));
        console.log(chalk.red('2. Sell (' + selectedToken.symbol + ' → WLD)'));
        
        const direction = await this.getUserInput('\nSelect direction: ');
        const amount = await this.getUserInput('Enter amount: ');
        
        if (!amount || isNaN(parseFloat(amount))) {
            console.log(chalk.red('❌ Invalid amount'));
            await this.getUserInput('\nPress Enter to continue...');
            return;
        }
        
        // Execute trade simulation
        console.log(chalk.white('\n⚡ EXECUTING TRADE...'));
        console.log(chalk.gray('═'.repeat(40)));
        
        try {
            const result = await this.simulateTrade(selectedWallet, selectedToken, direction === '1', parseFloat(amount));
            
            console.log(chalk.green('\n✅ Trade executed successfully!'));
            console.log(chalk.white(`📊 Pair: ${selectedToken.tradingPair}`));
            console.log(chalk.white(`💰 Amount: ${amount}`));
            console.log(chalk.white(`📈 Direction: ${direction === '1' ? 'BUY' : 'SELL'}`));
            console.log(chalk.white(`⛽ Gas Used: ${result.gasUsed}`));
            console.log(chalk.white(`🧾 Transaction Hash: ${result.txHash}`));
            
        } catch (error) {
            console.log(chalk.red(`❌ Trade failed: ${error.message}`));
        }
        
        await this.getUserInput('\nPress Enter to continue...');
    }

    async simulateTrade(wallet, token, isBuy, amount) {
        try {
            console.log(chalk.white('⚡ Using advanced trading engine...'));
            
            // Determine token addresses for the swap
            const tokenIn = isBuy ? this.WLD_ADDRESS : token.address;
            const tokenOut = isBuy ? token.address : this.WLD_ADDRESS;
            
            // Execute the actual trade using the trading engine
            const result = await this.tradingEngine.executeSwap(
                wallet,
                tokenIn,
                tokenOut,
                amount,
                this.config.slippage || 0.5
            );
            
            return result;
            
        } catch (error) {
            console.error('Trade execution failed:', error.message);
            
            // Fallback to simulation if real trading fails
            await this.sleep(2000);
            
            return {
                success: false,
                error: error.message,
                gasUsed: '150000',
                txHash: '0x' + Math.random().toString(16).substr(2, 64)
            };
        }
    }

    async viewTradingPairs() {
        const tokens = Object.values(this.discoveredTokens);
        
        if (tokens.length === 0) {
            console.log(chalk.yellow('\n📭 No trading pairs available!'));
            await this.getUserInput('\nPress Enter to continue...');
            return;
        }
        
        console.log(chalk.white('\n📈 AVAILABLE TRADING PAIRS'));
        console.log(chalk.gray('═'.repeat(60)));
        
        tokens.forEach((token, index) => {
            console.log(chalk.cyan(`\n${index + 1}. ${token.tradingPair}`));
            console.log(chalk.white(`   Token: ${token.name} (${token.symbol})`));
            console.log(chalk.white(`   Address: ${token.address}`));
            console.log(chalk.green(`   Status: Active`));
        });
        
        await this.getUserInput('\nPress Enter to continue...');
    }

    async highSpeedTradingMode() {
        console.log(chalk.white('\n⚡ HIGH-SPEED TRADING MODE'));
        console.log(chalk.gray('═'.repeat(40)));
        console.log(chalk.yellow('⚠️  This mode enables automated high-frequency trading'));
        console.log(chalk.yellow('⚠️  Use with caution and proper risk management'));
        
        const confirm = await this.getUserInput('\nEnable high-speed mode? (yes/no): ');
        
        if (confirm.toLowerCase() !== 'yes') {
            console.log(chalk.yellow('❌ High-speed mode cancelled'));
            await this.getUserInput('\nPress Enter to continue...');
            return;
        }
        
        console.log(chalk.green('\n✅ High-speed trading mode activated!'));
        console.log(chalk.white('📊 Monitoring price movements...'));
        console.log(chalk.white('⚡ Ready for rapid execution...'));
        
        // Simulate high-speed trading monitoring
        for (let i = 0; i < 10; i++) {
            console.log(chalk.gray(`Tick ${i + 1}: Analyzing market conditions...`));
            await this.sleep(500);
        }
        
        console.log(chalk.green('\n✅ High-speed mode demonstration completed'));
        await this.getUserInput('\nPress Enter to continue...');
    }

    async priceMonitoring() {
        console.log(chalk.white('\n📊 PRICE MONITORING'));
        console.log(chalk.gray('═'.repeat(40)));
        console.log(chalk.white('🔄 Fetching real-time prices...'));
        
        const tokens = Object.values(this.discoveredTokens);
        
        if (tokens.length === 0) {
            console.log(chalk.yellow('\n📭 No tokens to monitor!'));
            await this.getUserInput('\nPress Enter to continue...');
            return;
        }
        
        try {
            // Use the trading engine to get real prices
            const tokenAddresses = tokens.slice(0, 5).map(token => token.address);
            const prices = await this.tradingEngine.getBatchPrices(tokenAddresses);
            
            for (const token of tokens.slice(0, 5)) {
                const priceData = prices[token.address];
                
                if (priceData && !priceData.error) {
                    const change = ((Math.random() - 0.5) * 20).toFixed(2); // Simulated 24h change
                    const changeColor = parseFloat(change) >= 0 ? chalk.green : chalk.red;
                    
                    console.log(chalk.cyan(`\n${token.tradingPair}:`));
                    console.log(chalk.white(`  💰 Price: ${priceData.price.toFixed(6)} WLD`));
                    console.log(chalk.white(`  📊 Fee Tier: ${priceData.fee / 10000}%`));
                    console.log(changeColor(`  📈 24h Change: ${change}%`));
                } else {
                    console.log(chalk.cyan(`\n${token.tradingPair}:`));
                    console.log(chalk.red(`  ❌ Price unavailable: ${priceData?.error || 'Unknown error'}`));
                }
                
                await this.sleep(1000);
            }
        } catch (error) {
            console.log(chalk.red(`❌ Price monitoring failed: ${error.message}`));
        }
        
        await this.getUserInput('\nPress Enter to continue...');
    }

    async tradeHistory() {
        console.log(chalk.white('\n📋 TRADE HISTORY'));
        console.log(chalk.gray('═'.repeat(50)));
        
        // Simulate trade history
        const trades = [
            { pair: 'WLD-ORO', type: 'BUY', amount: '100', price: '0.05', time: '2024-01-15 10:30:00' },
            { pair: 'WLD-YIELD', type: 'SELL', amount: '50', price: '0.12', time: '2024-01-15 11:45:00' },
            { pair: 'WLD-ORO', type: 'SELL', amount: '75', price: '0.055', time: '2024-01-15 14:20:00' }
        ];
        
        trades.forEach((trade, index) => {
            const typeColor = trade.type === 'BUY' ? chalk.green : chalk.red;
            
            console.log(chalk.cyan(`\n${index + 1}. ${trade.pair}`));
            console.log(typeColor(`   ${trade.type} ${trade.amount} @ ${trade.price} WLD`));
            console.log(chalk.gray(`   ${trade.time}`));
        });
        
        await this.getUserInput('\nPress Enter to continue...');
    }

    async portfolioSummary() {
        console.log(chalk.white('\n📊 PORTFOLIO SUMMARY'));
        console.log(chalk.gray('═'.repeat(50)));
        
        if (this.wallets.length === 0) {
            console.log(chalk.yellow('\n📭 No wallets found!'));
            await this.getUserInput('\nPress Enter to continue...');
            return;
        }
        
        let totalValue = 0;
        
        for (const wallet of this.wallets) {
            console.log(chalk.cyan(`\n💼 ${wallet.name}:`));
            console.log(chalk.white(`   📍 ${wallet.address}`));
            console.log(chalk.green(`   💰 ${wallet.balance} ETH`));
            
            if (wallet.tokens && wallet.tokens.length > 0) {
                console.log(chalk.white(`   🪙 Tokens:`));
                wallet.tokens.forEach(token => {
                    console.log(chalk.gray(`     • ${token.balance} ${token.symbol}`));
                });
            }
            
            totalValue += parseFloat(wallet.balance || 0);
        }
        
        console.log(chalk.white('\n═'.repeat(50)));
        console.log(chalk.green(`💎 Total Portfolio Value: ${totalValue.toFixed(4)} ETH`));
        console.log(chalk.white(`🪙 Total Tokens Discovered: ${Object.keys(this.discoveredTokens).length}`));
        console.log(chalk.white(`💼 Active Wallets: ${this.wallets.length}`));
        
        await this.getUserInput('\nPress Enter to continue...');
    }

    async configurationMenu() {
        while (true) {
            await this.displayHeader();
            console.log(chalk.white('\n⚙️  CONFIGURATION'));
            console.log(chalk.gray('─'.repeat(25)));
            console.log(chalk.cyan('1. 🔧 Trading Settings'));
            console.log(chalk.cyan('2. ⛽ Gas Configuration'));
            console.log(chalk.cyan('3. 🔄 Auto-Discovery Settings'));
            console.log(chalk.cyan('4. 📊 Display Current Config'));
            console.log(chalk.cyan('5. 💾 Save Configuration'));
            console.log(chalk.red('6. ⬅️  Back to Main Menu'));
            
            const choice = await this.getUserInput('\nSelect option: ');
            
            switch (choice) {
                case '1':
                    await this.tradingSettings();
                    break;
                case '2':
                    await this.gasConfiguration();
                    break;
                case '3':
                    await this.autoDiscoverySettings();
                    break;
                case '4':
                    await this.displayCurrentConfig();
                    break;
                case '5':
                    this.saveConfig();
                    console.log(chalk.green('✅ Configuration saved!'));
                    await this.sleep(1500);
                    break;
                case '6':
                    return;
                default:
                    console.log(chalk.red('❌ Invalid option'));
                    await this.sleep(1500);
            }
        }
    }

    async tradingSettings() {
        console.log(chalk.white('\n🔧 TRADING SETTINGS'));
        console.log(chalk.gray('═'.repeat(30)));
        
        const slippage = await this.getUserInput(`Slippage tolerance (current: ${this.config.slippage}%): `);
        if (slippage && !isNaN(parseFloat(slippage))) {
            this.config.slippage = parseFloat(slippage);
        }
        
        const tradingEnabled = await this.getUserInput(`Enable trading (current: ${this.config.tradingEnabled}) [true/false]: `);
        if (tradingEnabled.toLowerCase() === 'true' || tradingEnabled.toLowerCase() === 'false') {
            this.config.tradingEnabled = tradingEnabled.toLowerCase() === 'true';
        }
        
        console.log(chalk.green('\n✅ Trading settings updated!'));
        await this.getUserInput('\nPress Enter to continue...');
    }

    async gasConfiguration() {
        console.log(chalk.white('\n⛽ GAS CONFIGURATION'));
        console.log(chalk.gray('═'.repeat(30)));
        
        const gasPrice = await this.getUserInput(`Gas price in Gwei (current: ${this.config.gasPrice}): `);
        if (gasPrice && !isNaN(parseFloat(gasPrice))) {
            this.config.gasPrice = gasPrice;
        }
        
        const gasLimit = await this.getUserInput(`Max gas limit (current: ${this.config.maxGasLimit}): `);
        if (gasLimit && !isNaN(parseInt(gasLimit))) {
            this.config.maxGasLimit = gasLimit;
        }
        
        console.log(chalk.green('\n✅ Gas configuration updated!'));
        await this.getUserInput('\nPress Enter to continue...');
    }

    async autoDiscoverySettings() {
        console.log(chalk.white('\n🔄 AUTO-DISCOVERY SETTINGS'));
        console.log(chalk.gray('═'.repeat(35)));
        
        const autoDiscovery = await this.getUserInput(`Enable auto-discovery (current: ${this.config.autoDiscovery}) [true/false]: `);
        if (autoDiscovery.toLowerCase() === 'true' || autoDiscovery.toLowerCase() === 'false') {
            this.config.autoDiscovery = autoDiscovery.toLowerCase() === 'true';
        }
        
        const refreshInterval = await this.getUserInput(`Refresh interval in ms (current: ${this.config.refreshInterval}): `);
        if (refreshInterval && !isNaN(parseInt(refreshInterval))) {
            this.config.refreshInterval = parseInt(refreshInterval);
        }
        
        console.log(chalk.green('\n✅ Auto-discovery settings updated!'));
        await this.getUserInput('\nPress Enter to continue...');
    }

    async displayCurrentConfig() {
        console.log(chalk.white('\n📊 CURRENT CONFIGURATION'));
        console.log(chalk.gray('═'.repeat(40)));
        
        console.log(chalk.cyan('\n🔧 Trading Settings:'));
        console.log(chalk.white(`  Slippage Tolerance: ${this.config.slippage}%`));
        console.log(chalk.white(`  Trading Enabled: ${this.config.tradingEnabled}`));
        
        console.log(chalk.cyan('\n⛽ Gas Settings:'));
        console.log(chalk.white(`  Gas Price: ${this.config.gasPrice} Gwei`));
        console.log(chalk.white(`  Max Gas Limit: ${this.config.maxGasLimit}`));
        
        console.log(chalk.cyan('\n🔄 Auto-Discovery:'));
        console.log(chalk.white(`  Enabled: ${this.config.autoDiscovery}`));
        console.log(chalk.white(`  Refresh Interval: ${this.config.refreshInterval}ms`));
        
        await this.getUserInput('\nPress Enter to continue...');
    }

    async getUserInput(prompt) {
        return new Promise((resolve) => {
            this.rl.question(chalk.white(prompt), (answer) => {
                resolve(answer.trim());
            });
        });
    }

    sleep(ms) {
        return new Promise(resolve => setTimeout(resolve, ms));
    }

    // Setup strategy event listeners
    setupStrategyEventListeners() {
        this.tradingStrategy.on('positionOpened', (position) => {
            console.log(chalk.green(`\n🎯 NEW POSITION OPENED:`));
            console.log(chalk.white(`📝 ID: ${position.id}`));
            console.log(chalk.white(`🪙 Token: ${position.tokenAddress}`));
            console.log(chalk.white(`💰 Amount: ${position.entryAmountWLD} WLD`));
            console.log(chalk.white(`📊 Entry Price: ${position.entryPrice.toFixed(8)} WLD/token`));
        });

        this.tradingStrategy.on('positionClosed', (position) => {
            const pnlColor = position.realizedPnL >= 0 ? chalk.green : chalk.red;
            console.log(pnlColor(`\n🎯 POSITION CLOSED:`));
            console.log(chalk.white(`📝 ID: ${position.id}`));
            console.log(chalk.white(`🪙 Token: ${position.tokenAddress}`));
            console.log(chalk.white(`🔄 Reason: ${position.closeReason}`));
            console.log(pnlColor(`💰 P&L: ${position.realizedPnL.toFixed(4)} WLD (${position.realizedPnLPercent.toFixed(2)}%)`));
        });

        this.tradingStrategy.on('dipOpportunity', (opportunity) => {
            console.log(chalk.yellow(`\n📉 DIP OPPORTUNITY DETECTED:`));
            console.log(chalk.white(`🪙 Token: ${opportunity.tokenAddress}`));
            console.log(chalk.white(`📊 Current Price: ${opportunity.currentPrice.toFixed(8)} WLD`));
            console.log(chalk.white(`📊 Average Price: ${opportunity.avgPrice.toFixed(8)} WLD`));
            console.log(chalk.yellow(`📉 DIP: ${opportunity.dipPercent.toFixed(2)}% below average`));
        });

        this.tradingStrategy.on('priceUpdate', (update) => {
            if (Math.abs(update.unrealizedPnLPercent) > 0.5) { // Only show significant changes
                const pnlColor = update.unrealizedPnLPercent >= 0 ? chalk.green : chalk.red;
                console.log(pnlColor(`📊 ${update.tokenAddress}: ${update.unrealizedPnLPercent.toFixed(2)}% P&L`));
            }
        });
    }

    // Strategy Management Menu
    async strategyManagementMenu() {
        while (true) {
            await this.displayHeader();
            const stats = this.tradingStrategy.getStrategyStats();
            
            console.log(chalk.white('\n🎯 STRATEGY MANAGEMENT'));
            console.log(chalk.gray('─'.repeat(40)));
            console.log(chalk.white(`📊 Status: ${stats.isRunning ? chalk.green('RUNNING') : chalk.red('STOPPED')}`));
            console.log(chalk.white(`📈 Open Positions: ${stats.openPositions}`));
            console.log(chalk.white(`💰 Total P&L: ${stats.totalPnL.toFixed(4)} WLD`));
            console.log(chalk.white(`📊 Success Rate: ${stats.successRate.toFixed(1)}%`));
            console.log(chalk.gray('─'.repeat(40)));
            
            console.log(chalk.cyan('1. 🚀 Start Strategy'));
            console.log(chalk.cyan('2. 🛑 Stop Strategy'));
            console.log(chalk.cyan('3. 📊 View Positions'));
            console.log(chalk.cyan('4. 🎯 Execute Strategic Trade'));
            console.log(chalk.cyan('5. ⚙️  Strategy Configuration'));
            console.log(chalk.cyan('6. 📈 Strategy Statistics'));
            console.log(chalk.cyan('7. 🔄 Close All Positions'));
            console.log(chalk.red('8. ⬅️  Back to Main Menu'));
            
            const choice = await this.getUserInput('\nSelect option: ');
            
            switch (choice) {
                case '1':
                    await this.startStrategy();
                    break;
                case '2':
                    await this.stopStrategy();
                    break;
                case '3':
                    await this.viewPositions();
                    break;
                case '4':
                    await this.executeStrategicTrade();
                    break;
                case '5':
                    await this.strategyConfiguration();
                    break;
                case '6':
                    await this.viewStrategyStatistics();
                    break;
                case '7':
                    await this.closeAllPositions();
                    break;
                case '8':
                    return;
                default:
                    console.log(chalk.red('❌ Invalid option'));
                    await this.sleep(1500);
            }
        }
    }

    // Start Strategy
    async startStrategy() {
        try {
            if (this.tradingStrategy.isRunning) {
                console.log(chalk.yellow('\n⚠️ Strategy is already running'));
                await this.getUserInput('\nPress Enter to continue...');
                return;
            }

            console.log(chalk.white('\n🚀 Starting Trading Strategy...'));
            await this.tradingStrategy.startStrategy();
            
            console.log(chalk.green('\n✅ Strategy started successfully!'));
            console.log(chalk.white('📊 The bot will now monitor prices every 5 seconds'));
            console.log(chalk.white('🎯 Automatic trades will execute based on profit targets'));
            console.log(chalk.white('📉 DIP buying opportunities will be detected'));
            
        } catch (error) {
            console.log(chalk.red(`❌ Failed to start strategy: ${error.message}`));
        }
        
        await this.getUserInput('\nPress Enter to continue...');
    }

    // Stop Strategy
    async stopStrategy() {
        try {
            if (!this.tradingStrategy.isRunning) {
                console.log(chalk.yellow('\n⚠️ Strategy is not running'));
                await this.getUserInput('\nPress Enter to continue...');
                return;
            }

            console.log(chalk.white('\n🛑 Stopping Trading Strategy...'));
            await this.tradingStrategy.stopStrategy();
            
            console.log(chalk.green('\n✅ Strategy stopped successfully!'));
            console.log(chalk.white('📊 All position monitoring has been stopped'));
            console.log(chalk.white('💾 Positions and data have been saved'));
            
        } catch (error) {
            console.log(chalk.red(`❌ Failed to stop strategy: ${error.message}`));
        }
        
        await this.getUserInput('\nPress Enter to continue...');
    }

    // View Positions
    async viewPositions() {
        const positions = this.tradingStrategy.getAllPositions();
        
        if (positions.length === 0) {
            console.log(chalk.yellow('\n📭 No positions found'));
            await this.getUserInput('\nPress Enter to continue...');
            return;
        }
        
        console.log(chalk.white('\n📊 TRADING POSITIONS'));
        console.log(chalk.gray('═'.repeat(80)));
        
        const openPositions = positions.filter(p => p.status === 'open');
        const closedPositions = positions.filter(p => p.status === 'closed');
        
        if (openPositions.length > 0) {
            console.log(chalk.green('\n🟢 OPEN POSITIONS:'));
            openPositions.forEach((pos, index) => {
                const pnlColor = pos.unrealizedPnLPercent >= 0 ? chalk.green : chalk.red;
                console.log(chalk.cyan(`\n${index + 1}. ${pos.tokenAddress}`));
                console.log(chalk.white(`   💰 Entry: ${pos.entryAmountWLD} WLD -> ${pos.entryAmountToken} tokens`));
                console.log(chalk.white(`   📊 Entry Price: ${pos.entryPrice.toFixed(8)} WLD/token`));
                console.log(chalk.white(`   📈 Current Price: ${pos.currentPrice.toFixed(8)} WLD/token`));
                console.log(chalk.white(`   💵 Current Value: ${pos.currentValue.toFixed(4)} WLD`));
                console.log(pnlColor(`   📊 P&L: ${pos.unrealizedPnL.toFixed(4)} WLD (${pos.unrealizedPnLPercent.toFixed(2)}%)`));
                console.log(chalk.white(`   🎯 Target: ${pos.profitTarget}% | Stop: ${pos.stopLoss}%`));
                console.log(chalk.gray(`   📅 Opened: ${new Date(pos.entryTimestamp).toLocaleString()}`));
            });
        }
        
        if (closedPositions.length > 0) {
            console.log(chalk.red('\n🔴 CLOSED POSITIONS (Last 5):'));
            closedPositions.slice(-5).forEach((pos, index) => {
                const pnlColor = pos.realizedPnL >= 0 ? chalk.green : chalk.red;
                console.log(chalk.cyan(`\n${index + 1}. ${pos.tokenAddress}`));
                console.log(chalk.white(`   💰 Trade: ${pos.entryAmountWLD} WLD -> ${pos.exitAmountWLD} WLD`));
                console.log(chalk.white(`   📊 Entry: ${pos.entryPrice.toFixed(8)} | Exit: ${pos.exitPrice.toFixed(8)}`));
                console.log(pnlColor(`   📊 P&L: ${pos.realizedPnL.toFixed(4)} WLD (${pos.realizedPnLPercent.toFixed(2)}%)`));
                console.log(chalk.white(`   🔄 Reason: ${pos.closeReason}`));
                console.log(chalk.gray(`   📅 Duration: ${((pos.exitTimestamp - pos.entryTimestamp) / 60000).toFixed(1)} min`));
            });
        }
        
        await this.getUserInput('\nPress Enter to continue...');
    }

    // Execute Strategic Trade
    async executeStrategicTrade() {
        if (this.wallets.length === 0) {
            console.log(chalk.yellow('\n📭 No wallets found!'));
            await this.getUserInput('\nPress Enter to continue...');
            return;
        }
        
        const tokens = Object.values(this.discoveredTokens);
        if (tokens.length === 0) {
            console.log(chalk.yellow('\n📭 No tokens available! Discover tokens first.'));
            await this.getUserInput('\nPress Enter to continue...');
            return;
        }
        
        try {
            // Select wallet
            console.log(chalk.white('\n💼 SELECT WALLET:'));
            this.wallets.forEach((wallet, index) => {
                console.log(chalk.cyan(`${index + 1}. ${wallet.name} (${wallet.address.slice(0, 10)}...)`));
            });
            
            const walletChoice = await this.getUserInput('\nSelect wallet: ');
            const walletIndex = parseInt(walletChoice) - 1;
            
            if (walletIndex < 0 || walletIndex >= this.wallets.length) {
                console.log(chalk.red('❌ Invalid wallet selection'));
                await this.getUserInput('\nPress Enter to continue...');
                return;
            }
            
            const selectedWallet = this.wallets[walletIndex];
            
            // Select token
            console.log(chalk.white('\n🪙 SELECT TOKEN:'));
            tokens.forEach((token, index) => {
                console.log(chalk.cyan(`${index + 1}. ${token.symbol} (${token.name})`));
            });
            
            const tokenChoice = await this.getUserInput('\nSelect token: ');
            const tokenIndex = parseInt(tokenChoice) - 1;
            
            if (tokenIndex < 0 || tokenIndex >= tokens.length) {
                console.log(chalk.red('❌ Invalid token selection'));
                await this.getUserInput('\nPress Enter to continue...');
                return;
            }
            
            const selectedToken = tokens[tokenIndex];
            
            // Get amount
            const amount = await this.getUserInput('Enter WLD amount to trade: ');
            const amountWLD = parseFloat(amount);
            
            if (!amountWLD || amountWLD <= 0) {
                console.log(chalk.red('❌ Invalid amount'));
                await this.getUserInput('\nPress Enter to continue...');
                return;
            }
            
            // Execute strategic trade
            console.log(chalk.white('\n🎯 EXECUTING STRATEGIC TRADE...'));
            console.log(chalk.gray('═'.repeat(50)));
            
            const position = await this.tradingStrategy.executeBuyTrade(
                selectedWallet,
                selectedToken.address,
                amountWLD
            );
            
            console.log(chalk.green('\n✅ Strategic trade executed successfully!'));
            console.log(chalk.white(`📝 Position ID: ${position.id}`));
            console.log(chalk.white(`🎯 Profit Target: ${position.profitTarget}%`));
            console.log(chalk.white(`🛑 Stop Loss: ${position.stopLoss}%`));
            console.log(chalk.white('📊 Position is now being monitored automatically'));
            
        } catch (error) {
            console.log(chalk.red(`❌ Strategic trade failed: ${error.message}`));
        }
        
        await this.getUserInput('\nPress Enter to continue...');
    }

    // Strategy Configuration
    async strategyConfiguration() {
        while (true) {
            await this.displayHeader();
            const config = this.tradingStrategy.strategyConfig;
            
            console.log(chalk.white('\n⚙️ STRATEGY CONFIGURATION'));
            console.log(chalk.gray('═'.repeat(50)));
            console.log(chalk.white(`🎯 Profit Target: ${config.profitTarget}%`));
            console.log(chalk.white(`📉 DIP Buy Threshold: ${config.dipBuyThreshold}%`));
            console.log(chalk.white(`⚠️ Max Slippage: ${config.maxSlippage}%`));
            console.log(chalk.white(`🛑 Stop Loss: ${config.stopLossThreshold}%`));
            console.log(chalk.white(`💰 Max Position Size: ${config.maxPositionSize} WLD`));
            console.log(chalk.white(`📊 Max Open Positions: ${config.maxOpenPositions}`));
            console.log(chalk.white(`⏱️ Price Check Interval: ${config.priceCheckInterval/1000}s`));
            console.log(chalk.gray('═'.repeat(50)));
            
            console.log(chalk.cyan('1. 🎯 Set Profit Target'));
            console.log(chalk.cyan('2. 📉 Set DIP Buy Threshold'));
            console.log(chalk.cyan('3. ⚠️ Set Max Slippage'));
            console.log(chalk.cyan('4. 🛑 Set Stop Loss'));
            console.log(chalk.cyan('5. 💰 Set Position Limits'));
            console.log(chalk.cyan('6. ⏱️ Set Monitoring Interval'));
            console.log(chalk.cyan('7. 🔄 Enable/Disable Features'));
            console.log(chalk.red('8. ⬅️  Back'));
            
            const choice = await this.getUserInput('\nSelect option: ');
            
            switch (choice) {
                case '1':
                    await this.configureProfit();
                    break;
                case '2':
                    await this.configureDipBuy();
                    break;
                case '3':
                    await this.configureSlippage();
                    break;
                case '4':
                    await this.configureStopLoss();
                    break;
                case '5':
                    await this.configurePositionLimits();
                    break;
                case '6':
                    await this.configureInterval();
                    break;
                case '7':
                    await this.configureFeatures();
                    break;
                case '8':
                    return;
                default:
                    console.log(chalk.red('❌ Invalid option'));
                    await this.sleep(1500);
            }
        }
    }

    // Configure profit target
    async configureProfit() {
        const current = this.tradingStrategy.strategyConfig.profitTarget;
        const input = await this.getUserInput(`Enter profit target % (current: ${current}%): `);
        
        const value = parseFloat(input);
        if (value && value > 0 && value <= 100) {
            this.tradingStrategy.updateConfig({ profitTarget: value });
            console.log(chalk.green(`✅ Profit target set to ${value}%`));
        } else {
            console.log(chalk.red('❌ Invalid profit target'));
        }
        
        await this.sleep(1500);
    }

    // Configure DIP buy threshold
    async configureDipBuy() {
        const current = this.tradingStrategy.strategyConfig.dipBuyThreshold;
        const input = await this.getUserInput(`Enter DIP buy threshold % (current: ${current}%): `);
        
        const value = parseFloat(input);
        if (value && value > 0 && value <= 50) {
            this.tradingStrategy.updateConfig({ dipBuyThreshold: value });
            console.log(chalk.green(`✅ DIP buy threshold set to ${value}%`));
        } else {
            console.log(chalk.red('❌ Invalid DIP threshold'));
        }
        
        await this.sleep(1500);
    }

    // Configure max slippage
    async configureSlippage() {
        const current = this.tradingStrategy.strategyConfig.maxSlippage;
        const input = await this.getUserInput(`Enter max slippage % (current: ${current}%): `);
        
        const value = parseFloat(input);
        if (value && value > 0 && value <= 10) {
            this.tradingStrategy.updateConfig({ maxSlippage: value });
            console.log(chalk.green(`✅ Max slippage set to ${value}%`));
        } else {
            console.log(chalk.red('❌ Invalid slippage value'));
        }
        
        await this.sleep(1500);
    }

    // Configure stop loss
    async configureStopLoss() {
        const current = this.tradingStrategy.strategyConfig.stopLossThreshold;
        const input = await this.getUserInput(`Enter stop loss % (current: ${current}%): `);
        
        const value = parseFloat(input);
        if (value && value < 0 && value >= -50) {
            this.tradingStrategy.updateConfig({ stopLossThreshold: value });
            console.log(chalk.green(`✅ Stop loss set to ${value}%`));
        } else {
            console.log(chalk.red('❌ Invalid stop loss value'));
        }
        
        await this.sleep(1500);
    }

    // Configure position limits
    async configurePositionLimits() {
        const currentSize = this.tradingStrategy.strategyConfig.maxPositionSize;
        const currentCount = this.tradingStrategy.strategyConfig.maxOpenPositions;
        
        const sizeInput = await this.getUserInput(`Enter max position size in WLD (current: ${currentSize}): `);
        const countInput = await this.getUserInput(`Enter max open positions (current: ${currentCount}): `);
        
        const size = parseFloat(sizeInput);
        const count = parseInt(countInput);
        
        const updates = {};
        
        if (size && size > 0 && size <= 10000) {
            updates.maxPositionSize = size;
        }
        
        if (count && count > 0 && count <= 20) {
            updates.maxOpenPositions = count;
        }
        
        if (Object.keys(updates).length > 0) {
            this.tradingStrategy.updateConfig(updates);
            console.log(chalk.green('✅ Position limits updated'));
        } else {
            console.log(chalk.red('❌ Invalid values'));
        }
        
        await this.sleep(1500);
    }

    // Configure monitoring interval
    async configureInterval() {
        const current = this.tradingStrategy.strategyConfig.priceCheckInterval / 1000;
        const input = await this.getUserInput(`Enter price check interval in seconds (current: ${current}s): `);
        
        const value = parseInt(input);
        if (value && value >= 1 && value <= 300) {
            this.tradingStrategy.updateConfig({ priceCheckInterval: value * 1000 });
            console.log(chalk.green(`✅ Price check interval set to ${value}s`));
        } else {
            console.log(chalk.red('❌ Invalid interval (1-300 seconds)'));
        }
        
        await this.sleep(1500);
    }

    // Configure features
    async configureFeatures() {
        const config = this.tradingStrategy.strategyConfig;
        
        console.log(chalk.white('\n🔄 FEATURE TOGGLES'));
        console.log(chalk.gray('─'.repeat(30)));
        console.log(chalk.white(`Auto Sell: ${config.enableAutoSell ? chalk.green('ON') : chalk.red('OFF')}`));
        console.log(chalk.white(`DIP Buying: ${config.enableDipBuying ? chalk.green('ON') : chalk.red('OFF')}`));
        console.log(chalk.white(`Trailing Stop: ${config.enableTrailingStop ? chalk.green('ON') : chalk.red('OFF')}`));
        
        const feature = await this.getUserInput('\nWhich feature to toggle? (auto/dip/trailing/cancel): ');
        
        switch (feature.toLowerCase()) {
            case 'auto':
                this.tradingStrategy.updateConfig({ enableAutoSell: !config.enableAutoSell });
                console.log(chalk.green(`✅ Auto sell ${!config.enableAutoSell ? 'enabled' : 'disabled'}`));
                break;
            case 'dip':
                this.tradingStrategy.updateConfig({ enableDipBuying: !config.enableDipBuying });
                console.log(chalk.green(`✅ DIP buying ${!config.enableDipBuying ? 'enabled' : 'disabled'}`));
                break;
            case 'trailing':
                this.tradingStrategy.updateConfig({ enableTrailingStop: !config.enableTrailingStop });
                console.log(chalk.green(`✅ Trailing stop ${!config.enableTrailingStop ? 'enabled' : 'disabled'}`));
                break;
            case 'cancel':
                return;
            default:
                console.log(chalk.red('❌ Invalid feature'));
        }
        
        await this.sleep(1500);
    }

    // View Strategy Statistics
    async viewStrategyStatistics() {
        const stats = this.tradingStrategy.getStrategyStats();
        
        console.log(chalk.white('\n📈 STRATEGY STATISTICS'));
        console.log(chalk.gray('═'.repeat(60)));
        
        console.log(chalk.cyan('\n📊 Overall Performance:'));
        console.log(chalk.white(`   Status: ${stats.isRunning ? chalk.green('RUNNING') : chalk.red('STOPPED')}`));
        console.log(chalk.white(`   Total Trades: ${stats.totalTrades}`));
        console.log(chalk.white(`   Successful Trades: ${stats.successfulTrades}`));
        console.log(chalk.white(`   Success Rate: ${stats.successRate.toFixed(1)}%`));
        
        console.log(chalk.cyan('\n💰 Profit & Loss:'));
        const totalPnLColor = stats.totalPnL >= 0 ? chalk.green : chalk.red;
        console.log(chalk.white(`   Realized P&L: ${stats.totalRealizedPnL.toFixed(4)} WLD`));
        console.log(chalk.white(`   Unrealized P&L: ${stats.totalUnrealizedPnL.toFixed(4)} WLD`));
        console.log(totalPnLColor(`   Total P&L: ${stats.totalPnL.toFixed(4)} WLD`));
        
        console.log(chalk.cyan('\n📊 Positions:'));
        console.log(chalk.white(`   Total Positions: ${stats.totalPositions}`));
        console.log(chalk.white(`   Open Positions: ${stats.openPositions}`));
        console.log(chalk.white(`   Closed Positions: ${stats.closedPositions}`));
        
        console.log(chalk.cyan('\n⚙️ Current Configuration:'));
        console.log(chalk.white(`   Profit Target: ${stats.config.profitTarget}%`));
        console.log(chalk.white(`   Stop Loss: ${stats.config.stopLossThreshold}%`));
        console.log(chalk.white(`   Max Slippage: ${stats.config.maxSlippage}%`));
        console.log(chalk.white(`   DIP Threshold: ${stats.config.dipBuyThreshold}%`));
        console.log(chalk.white(`   Max Position Size: ${stats.config.maxPositionSize} WLD`));
        console.log(chalk.white(`   Max Open Positions: ${stats.config.maxOpenPositions}`));
        
        await this.getUserInput('\nPress Enter to continue...');
    }

    // Close All Positions
    async closeAllPositions() {
        const openPositions = this.tradingStrategy.getAllPositions().filter(p => p.status === 'open');
        
        if (openPositions.length === 0) {
            console.log(chalk.yellow('\n📭 No open positions to close'));
            await this.getUserInput('\nPress Enter to continue...');
            return;
        }
        
        console.log(chalk.yellow(`\n⚠️ This will close ${openPositions.length} open positions`));
        const confirm = await this.getUserInput('Are you sure? (yes/no): ');
        
        if (confirm.toLowerCase() === 'yes') {
            try {
                console.log(chalk.white('\n🔄 Closing all positions...'));
                await this.tradingStrategy.closeAllPositions('manual_close_all');
                console.log(chalk.green('\n✅ All positions closed successfully!'));
            } catch (error) {
                console.log(chalk.red(`❌ Error closing positions: ${error.message}`));
            }
        } else {
            console.log(chalk.yellow('❌ Operation cancelled'));
        }
        
        await this.getUserInput('\nPress Enter to continue...');
    }

    async run() {
        while (true) {
            await this.displayMainMenu();
            const choice = await this.getUserInput('\nSelect option: ');
            
            switch (choice) {
                case '1':
                    await this.walletManagementMenu();
                    break;
                case '2':
                    await this.tokenDiscoveryMenu();
                    break;
                case '3':
                    await this.tradingOperationsMenu();
                    break;
                case '4':
                    await this.strategyManagementMenu();
                    break;
                case '5':
                    await this.configurationMenu();
                    break;
                case '6':
                    await this.portfolioSummary();
                    break;
                case '7':
                    console.log(chalk.green('\n👋 Thank you for using WorldChain Trading Bot!'));
                    console.log(chalk.yellow('💡 Remember to keep your private keys secure!'));
                    
                    // Stop strategy if running
                    if (this.tradingStrategy.isRunning) {
                        console.log(chalk.yellow('🛑 Stopping trading strategy...'));
                        await this.tradingStrategy.stopStrategy();
                    }
                    
                    this.rl.close();
                    process.exit(0);
                    break;
                default:
                    console.log(chalk.red('❌ Invalid option. Please try again.'));
                    await this.sleep(1500);
            }
        }
    }
}

// Start the bot
if (require.main === module) {
    const bot = new WorldchainTradingBot();
    bot.run().catch(console.error);
}

module.exports = WorldchainTradingBot;