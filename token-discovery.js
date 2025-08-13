const { ethers } = require('ethers');
const axios = require('axios');

class TokenDiscoveryService {
    constructor(provider, config) {
        this.provider = provider;
        this.config = config;
        
        // API endpoints for token discovery
        this.ALCHEMY_API_KEY = process.env.ALCHEMY_API_KEY || 'demo';
        this.MORALIS_API_KEY = process.env.MORALIS_API_KEY || '';
        
        // Worldchain specific endpoints
        this.WORLDCHAIN_EXPLORER_API = 'https://worldchain-mainnet.explorer.alchemy.com/api';
        
        // ERC20 ABI for token interactions
        this.ERC20_ABI = [
            'function name() view returns (string)',
            'function symbol() view returns (string)',
            'function decimals() view returns (uint8)',
            'function totalSupply() view returns (uint256)',
            'function balanceOf(address owner) view returns (uint256)',
            'event Transfer(address indexed from, address indexed to, uint256 value)'
        ];
        
        // Common token addresses on Worldchain
        this.KNOWN_TOKENS = {
            'WLD': '0x2cfc85d8e48f8eab294be644d9e25c3030863003',
            'WETH': '0x4200000000000000000000000000000000000006',
            'USDC': '0x79A02482A880bCE3F13e09Da970dC34db4CD24d1'
        };
        
        // Cache for discovered tokens
        this.tokenCache = new Map();
        this.discoveryCache = new Map();
    }

    // Main token discovery function
    async discoverTokensInWallet(walletAddress, options = {}) {
        const {
            includeZeroBalances = false,
            useCache = true,
            maxTokens = 100,
            includeNFTs = false
        } = options;

        try {
            console.log(`🔍 Discovering tokens for wallet: ${walletAddress}`);
            
            // Check cache first
            const cacheKey = `${walletAddress}_${includeZeroBalances}_${includeNFTs}`;
            if (useCache && this.discoveryCache.has(cacheKey)) {
                const cached = this.discoveryCache.get(cacheKey);
                if (Date.now() - cached.timestamp < 300000) { // 5 minutes cache
                    console.log('📋 Using cached token discovery results');
                    return cached.tokens;
                }
            }

            // Multiple discovery methods
            const discoveryMethods = [
                () => this.discoverViaTransactionHistory(walletAddress, maxTokens),
                () => this.discoverViaAlchemy(walletAddress, includeNFTs),
                () => this.discoverViaDirectScanning(walletAddress),
                () => this.discoverViaKnownTokens(walletAddress)
            ];

            // Run discovery methods in parallel
            const results = await Promise.allSettled(discoveryMethods.map(method => method()));
            
            // Combine results from all methods
            const allTokens = new Map();
            
            results.forEach((result, index) => {
                if (result.status === 'fulfilled' && result.value) {
                    result.value.forEach(token => {
                        const key = token.address.toLowerCase();
                        if (!allTokens.has(key) || parseFloat(token.balance) > 0) {
                            allTokens.set(key, token);
                        }
                    });
                } else if (result.status === 'rejected') {
                    console.warn(`Discovery method ${index} failed:`, result.reason.message);
                }
            });

            // Convert to array and filter
            let discoveredTokens = Array.from(allTokens.values());
            
            // Filter out zero balances if requested
            if (!includeZeroBalances) {
                discoveredTokens = discoveredTokens.filter(token => 
                    parseFloat(token.balance) > 0
                );
            }

            // Sort by balance value
            discoveredTokens.sort((a, b) => parseFloat(b.balance) - parseFloat(a.balance));

            // Limit results
            if (discoveredTokens.length > maxTokens) {
                discoveredTokens = discoveredTokens.slice(0, maxTokens);
            }

            // Cache results
            this.discoveryCache.set(cacheKey, {
                tokens: discoveredTokens,
                timestamp: Date.now()
            });

            console.log(`✅ Discovered ${discoveredTokens.length} tokens`);
            return discoveredTokens;

        } catch (error) {
            console.error('❌ Token discovery failed:', error.message);
            return [];
        }
    }

    // Discover tokens via transaction history analysis
    async discoverViaTransactionHistory(walletAddress, maxTokens = 50) {
        try {
            console.log('🔍 Scanning transaction history...');
            
            // Get transaction history from explorer API
            const response = await axios.get(`${this.WORLDCHAIN_EXPLORER_API}`, {
                params: {
                    module: 'account',
                    action: 'tokentx',
                    address: walletAddress,
                    startblock: 0,
                    endblock: 'latest',
                    sort: 'desc',
                    apikey: this.ALCHEMY_API_KEY
                },
                timeout: 10000
            });

            if (response.data.status !== '1' || !response.data.result) {
                console.log('⚠️ No transaction history found');
                return [];
            }

            // Extract unique token addresses from transactions
            const tokenAddresses = new Set();
            const transactions = response.data.result.slice(0, 1000); // Limit to recent 1000 transactions

            transactions.forEach(tx => {
                if (tx.contractAddress && ethers.isAddress(tx.contractAddress)) {
                    tokenAddresses.add(tx.contractAddress.toLowerCase());
                }
            });

            // Get token information and balances
            const tokens = [];
            const addressArray = Array.from(tokenAddresses).slice(0, maxTokens);

            for (const tokenAddress of addressArray) {
                try {
                    const tokenInfo = await this.getTokenInfo(tokenAddress);
                    const balance = await this.getTokenBalance(walletAddress, tokenAddress);
                    
                    tokens.push({
                        ...tokenInfo,
                        balance,
                        discoveryMethod: 'transaction_history'
                    });
                } catch (error) {
                    console.warn(`Failed to get info for token ${tokenAddress}:`, error.message);
                }
            }

            console.log(`📈 Found ${tokens.length} tokens via transaction history`);
            return tokens;

        } catch (error) {
            console.warn('Transaction history discovery failed:', error.message);
            return [];
        }
    }

    // Discover tokens via Alchemy API
    async discoverViaAlchemy(walletAddress, includeNFTs = false) {
        try {
            console.log('🔍 Using Alchemy API for token discovery...');
            
            if (!this.ALCHEMY_API_KEY || this.ALCHEMY_API_KEY === 'demo') {
                console.log('⚠️ Alchemy API key not configured, skipping');
                return [];
            }

            const alchemyUrl = `https://eth-mainnet.g.alchemy.com/v2/${this.ALCHEMY_API_KEY}`;
            
            // Get token balances
            const response = await axios.post(alchemyUrl, {
                id: 1,
                jsonrpc: '2.0',
                method: 'alchemy_getTokenBalances',
                params: [walletAddress]
            }, {
                timeout: 15000
            });

            if (!response.data.result || !response.data.result.tokenBalances) {
                console.log('⚠️ No token balances found via Alchemy');
                return [];
            }

            const tokens = [];
            const tokenBalances = response.data.result.tokenBalances;

            for (const tokenBalance of tokenBalances) {
                try {
                    if (!tokenBalance.contractAddress || tokenBalance.tokenBalance === '0x0') {
                        continue;
                    }

                    const tokenInfo = await this.getTokenInfo(tokenBalance.contractAddress);
                    const balance = ethers.formatUnits(
                        tokenBalance.tokenBalance,
                        tokenInfo.decimals
                    );

                    tokens.push({
                        ...tokenInfo,
                        balance,
                        discoveryMethod: 'alchemy_api'
                    });
                } catch (error) {
                    console.warn(`Failed to process token ${tokenBalance.contractAddress}:`, error.message);
                }
            }

            console.log(`🔗 Found ${tokens.length} tokens via Alchemy`);
            return tokens;

        } catch (error) {
            console.warn('Alchemy discovery failed:', error.message);
            return [];
        }
    }

    // Discover tokens via direct blockchain scanning
    async discoverViaDirectScanning(walletAddress) {
        try {
            console.log('🔍 Direct blockchain scanning...');
            
            // Get recent blocks and scan for token transfers
            const currentBlock = await this.provider.getBlockNumber();
            const fromBlock = Math.max(0, currentBlock - 10000); // Last ~10k blocks
            
            // Create filter for Transfer events involving the wallet
            const transferEventSignature = ethers.id('Transfer(address,address,uint256)');
            
            const logs = await this.provider.getLogs({
                fromBlock: fromBlock,
                toBlock: 'latest',
                topics: [
                    transferEventSignature,
                    [
                        ethers.zeroPadValue(walletAddress, 32), // from
                        null,
                        ethers.zeroPadValue(walletAddress, 32)  // to
                    ]
                ]
            });

            // Extract unique contract addresses
            const tokenAddresses = new Set();
            logs.forEach(log => {
                if (log.address && ethers.isAddress(log.address)) {
                    tokenAddresses.add(log.address.toLowerCase());
                }
            });

            // Get token information and current balances
            const tokens = [];
            for (const tokenAddress of Array.from(tokenAddresses).slice(0, 20)) {
                try {
                    const tokenInfo = await this.getTokenInfo(tokenAddress);
                    const balance = await this.getTokenBalance(walletAddress, tokenAddress);
                    
                    tokens.push({
                        ...tokenInfo,
                        balance,
                        discoveryMethod: 'blockchain_scanning'
                    });
                } catch (error) {
                    console.warn(`Failed to get info for token ${tokenAddress}:`, error.message);
                }
            }

            console.log(`⛓️ Found ${tokens.length} tokens via blockchain scanning`);
            return tokens;

        } catch (error) {
            console.warn('Direct scanning failed:', error.message);
            return [];
        }
    }

    // Discover balances for known tokens
    async discoverViaKnownTokens(walletAddress) {
        try {
            console.log('🔍 Checking known token balances...');
            
            const tokens = [];
            for (const [symbol, address] of Object.entries(this.KNOWN_TOKENS)) {
                try {
                    const tokenInfo = await this.getTokenInfo(address);
                    const balance = await this.getTokenBalance(walletAddress, address);
                    
                    tokens.push({
                        ...tokenInfo,
                        balance,
                        discoveryMethod: 'known_tokens'
                    });
                } catch (error) {
                    console.warn(`Failed to get balance for ${symbol}:`, error.message);
                }
            }

            console.log(`📋 Checked ${tokens.length} known tokens`);
            return tokens;

        } catch (error) {
            console.warn('Known tokens discovery failed:', error.message);
            return [];
        }
    }

    // Get comprehensive token information
    async getTokenInfo(tokenAddress) {
        // Check cache first
        const cacheKey = tokenAddress.toLowerCase();
        if (this.tokenCache.has(cacheKey)) {
            return this.tokenCache.get(cacheKey);
        }

        try {
            const tokenContract = new ethers.Contract(tokenAddress, this.ERC20_ABI, this.provider);
            
            const [name, symbol, decimals, totalSupply] = await Promise.all([
                tokenContract.name().catch(() => 'Unknown Token'),
                tokenContract.symbol().catch(() => 'UNKNOWN'),
                tokenContract.decimals().catch(() => 18),
                tokenContract.totalSupply().catch(() => '0')
            ]);

            const tokenInfo = {
                address: tokenAddress,
                name,
                symbol,
                decimals: Number(decimals),
                totalSupply: ethers.formatUnits(totalSupply, decimals)
            };

            // Cache the result
            this.tokenCache.set(cacheKey, tokenInfo);
            
            return tokenInfo;

        } catch (error) {
            console.warn(`Failed to get token info for ${tokenAddress}:`, error.message);
            
            // Return minimal info for failed tokens
            return {
                address: tokenAddress,
                name: 'Unknown Token',
                symbol: 'UNKNOWN',
                decimals: 18,
                totalSupply: '0'
            };
        }
    }

    // Get token balance for a specific wallet
    async getTokenBalance(walletAddress, tokenAddress) {
        try {
            const tokenContract = new ethers.Contract(tokenAddress, this.ERC20_ABI, this.provider);
            const balance = await tokenContract.balanceOf(walletAddress);
            const decimals = await tokenContract.decimals();
            
            return ethers.formatUnits(balance, decimals);
        } catch (error) {
            console.warn(`Failed to get balance for ${tokenAddress}:`, error.message);
            return '0';
        }
    }

    // Validate token contract
    async validateTokenContract(tokenAddress) {
        try {
            if (!ethers.isAddress(tokenAddress)) {
                return { valid: false, reason: 'Invalid address format' };
            }

            const code = await this.provider.getCode(tokenAddress);
            if (code === '0x') {
                return { valid: false, reason: 'Address is not a contract' };
            }

            // Try to call basic ERC20 functions
            const tokenContract = new ethers.Contract(tokenAddress, this.ERC20_ABI, this.provider);
            
            try {
                await Promise.all([
                    tokenContract.name(),
                    tokenContract.symbol(),
                    tokenContract.decimals()
                ]);
                
                return { valid: true, reason: 'Valid ERC20 token' };
            } catch (error) {
                return { valid: false, reason: 'Not a valid ERC20 token' };
            }

        } catch (error) {
            return { valid: false, reason: error.message };
        }
    }

    // Batch validate multiple token addresses
    async batchValidateTokens(tokenAddresses) {
        const validationPromises = tokenAddresses.map(address => 
            this.validateTokenContract(address).then(result => ({
                address,
                ...result
            }))
        );

        return await Promise.all(validationPromises);
    }

    // Get token price from DEX (if available)
    async getTokenPrice(tokenAddress, baseCurrency = 'WLD') {
        try {
            // This would integrate with DEX price feeds
            // For now, return a simulated price
            const randomPrice = (Math.random() * 10).toFixed(6);
            return {
                price: parseFloat(randomPrice),
                baseCurrency,
                timestamp: Date.now(),
                source: 'dex_simulation'
            };
        } catch (error) {
            return {
                price: 0,
                baseCurrency,
                timestamp: Date.now(),
                error: error.message
            };
        }
    }

    // Discover new tokens by monitoring recent transactions
    async monitorNewTokens(callback, interval = 30000) {
        console.log('🔄 Starting new token monitoring...');
        
        let lastBlock = await this.provider.getBlockNumber();
        
        const monitor = async () => {
            try {
                const currentBlock = await this.provider.getBlockNumber();
                
                if (currentBlock > lastBlock) {
                    // Get logs for new blocks
                    const transferEventSignature = ethers.id('Transfer(address,address,uint256)');
                    
                    const logs = await this.provider.getLogs({
                        fromBlock: lastBlock + 1,
                        toBlock: currentBlock,
                        topics: [transferEventSignature]
                    });

                    // Find new token contracts
                    const newTokens = new Set();
                    logs.forEach(log => {
                        if (log.address && !this.tokenCache.has(log.address.toLowerCase())) {
                            newTokens.add(log.address);
                        }
                    });

                    // Process new tokens
                    for (const tokenAddress of newTokens) {
                        try {
                            const validation = await this.validateTokenContract(tokenAddress);
                            if (validation.valid) {
                                const tokenInfo = await this.getTokenInfo(tokenAddress);
                                callback({
                                    type: 'new_token_discovered',
                                    token: tokenInfo,
                                    block: currentBlock,
                                    timestamp: Date.now()
                                });
                            }
                        } catch (error) {
                            console.warn(`Failed to process new token ${tokenAddress}:`, error.message);
                        }
                    }

                    lastBlock = currentBlock;
                }

            } catch (error) {
                console.error('New token monitoring error:', error.message);
            }
        };

        // Initial run
        await monitor();

        // Set up interval
        const intervalId = setInterval(monitor, interval);
        
        return () => clearInterval(intervalId);
    }

    // Get portfolio analytics for discovered tokens
    async getPortfolioAnalytics(walletAddress, tokenList) {
        try {
            const analytics = {
                totalTokens: tokenList.length,
                totalValue: 0,
                tokensByValue: [],
                diversification: {},
                lastUpdated: Date.now()
            };

            // Calculate values and analytics
            for (const token of tokenList) {
                const balance = parseFloat(token.balance);
                if (balance > 0) {
                    const priceInfo = await this.getTokenPrice(token.address);
                    const value = balance * priceInfo.price;
                    
                    analytics.totalValue += value;
                    analytics.tokensByValue.push({
                        ...token,
                        value,
                        price: priceInfo.price
                    });
                }
            }

            // Sort by value
            analytics.tokensByValue.sort((a, b) => b.value - a.value);

            // Calculate percentages
            analytics.tokensByValue.forEach(token => {
                token.percentage = (token.value / analytics.totalValue) * 100;
            });

            return analytics;

        } catch (error) {
            console.error('Portfolio analytics failed:', error.message);
            return {
                totalTokens: 0,
                totalValue: 0,
                tokensByValue: [],
                error: error.message
            };
        }
    }

    // Clear all caches
    clearCache() {
        this.tokenCache.clear();
        this.discoveryCache.clear();
        console.log('🗑️ Token discovery cache cleared');
    }

    // Get cache statistics
    getCacheStats() {
        return {
            tokenCacheSize: this.tokenCache.size,
            discoveryCacheSize: this.discoveryCache.size,
            knownTokensCount: Object.keys(this.KNOWN_TOKENS).length
        };
    }
}

module.exports = TokenDiscoveryService;