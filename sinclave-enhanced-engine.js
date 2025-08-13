const { ethers } = require('ethers');
const axios = require('axios');

class SinclaveEnhancedTradingEngine {
    constructor(provider, config) {
        this.provider = provider;
        this.config = config;
        
        // Proven working contracts from sinclave.js analysis
        this.HOLDSTATION_CONTRACT = '0x0281c83C8F53314DFF3ebE24A90ee2412A2aA970';
        this.UNISWAP_V3_ROUTER = '0xE592427A0AEce92De3Edee1F18E0157C05861564';
        this.QUOTER_V2 = '0x61fFE014bA17989E743c5F6cB21bF9697530B21e';
        
        // WLD token on Worldchain
        this.WLD_ADDRESS = '0x2cfc85d8e48f8eab294be644d9e25c3030863003';
        
        // Optimized RPC endpoints (from sinclave.js)
        this.PRIMARY_RPC = 'https://worldchain-mainnet.g.alchemy.com/public';
        this.FALLBACK_RPC = process.env.ALCHEMY_API_KEY ? 
            `https://worldchain-mainnet.g.alchemy.com/v2/${process.env.ALCHEMY_API_KEY}` : 
            'https://worldchain-mainnet.drpc.org/public';
        
        // SDK component caching for speed
        this.cachedSDK = null;
        this.cachedProvider = null;
        
        // ABI definitions
        this.ERC20_ABI = [
            'function balanceOf(address owner) view returns (uint256)',
            'function decimals() view returns (uint8)',
            'function symbol() view returns (string)',
            'function name() view returns (string)',
            'function approve(address spender, uint256 amount) returns (bool)',
            'function allowance(address owner, address spender) view returns (uint256)',
            'function transfer(address to, uint256 amount) returns (bool)'
        ];
        
        this.ROUTER_ABI = [
            'function exactInputSingle((address tokenIn, address tokenOut, uint24 fee, address recipient, uint256 deadline, uint256 amountIn, uint256 amountOutMinimum, uint160 sqrtPriceLimitX96)) external returns (uint256 amountOut)'
        ];
        
        this.QUOTER_ABI = [
            'function quoteExactInputSingle(address tokenIn, address tokenOut, uint24 fee, uint256 amountIn, uint160 sqrtPriceLimitX96) external returns (uint256 amountOut)'
        ];
        
        // Proven gas settings from sinclave.js
        this.OPTIMAL_GAS_SETTINGS = {
            baseGasPrice: ethers.parseUnits('0.001', 'gwei'), // Proven working rate
            priorityFee: ethers.parseUnits('0.0001', 'gwei'), // Minimal priority
            gasLimit: 280000 // Proven optimal gas limit
        };
        
        // Fee tiers
        this.FEE_TIERS = [500, 3000, 10000];
        
        // Bad receiver addresses to fix (from sinclave.js analysis)
        this.BAD_RECEIVERS = [
            "43222f934ea5c593a060a6d46772fdbdc2e2cff0",
            "0x43222f934ea5c593a060a6d46772fdbdc2e2cff0"
        ];
        
        // Performance metrics
        this.metrics = {
            totalTrades: 0,
            successfulTrades: 0,
            averageExecutionTime: 0,
            gasOptimizationSavings: 0
        };
        
        console.log('🚀 Sinclave Enhanced Trading Engine initialized with proven patterns');
    }
    
    // Initialize optimized provider with caching (from sinclave.js)
    async initializeOptimizedProvider() {
        if (this.cachedProvider) {
            return this.cachedProvider;
        }
        
        try {
            // Primary: Use fast public endpoint
            const provider = new ethers.JsonRpcProvider(this.PRIMARY_RPC, {
                chainId: 480,
                name: "worldchain"
            });
            
            // Test connection
            await provider.getBlockNumber();
            this.cachedProvider = provider;
            console.log('✅ Connected to optimized public RPC endpoint');
            return provider;
            
        } catch (error) {
            console.log('⚠️ Public endpoint failed, using authenticated fallback');
            
            // Fallback: Use authenticated endpoint
            const fallbackProvider = new ethers.JsonRpcProvider(this.FALLBACK_RPC, {
                chainId: 480,
                name: "worldchain"
            });
            
            this.cachedProvider = fallbackProvider;
            return fallbackProvider;
        }
    }
    
    // Apply proven routing fix (from sinclave.js)
    applyProvenRoutingFix(quote, userWallet) {
        console.log('🔧 Applying proven WorldChain routing fix...');
        
        // Force use of proven working contract
        const originalContract = quote.to;
        quote.to = this.HOLDSTATION_CONTRACT;
        
        if (originalContract !== this.HOLDSTATION_CONTRACT) {
            console.log(`📋 Contract override: ${originalContract} → ${this.HOLDSTATION_CONTRACT}`);
        }
        
        // Apply transaction data fix for bad receivers
        if (quote.data && typeof quote.data === 'string') {
            const correctReceiver = userWallet.toLowerCase().replace("0x", "");
            let routingFixApplied = false;
            
            for (const badReceiver of this.BAD_RECEIVERS) {
                const cleanBadReceiver = badReceiver.replace("0x", "").toLowerCase();
                if (quote.data.toLowerCase().includes(cleanBadReceiver)) {
                    console.log(`🚨 Detected bad receiver: ${badReceiver}`);
                    
                    const originalData = quote.data;
                    quote.data = quote.data.replace(
                        new RegExp(cleanBadReceiver, 'gi'),
                        correctReceiver
                    );
                    
                    routingFixApplied = true;
                    console.log(`✅ Routing fixed: ${badReceiver} → ${userWallet}`);
                    console.log(`📊 Data integrity: ${originalData.length} → ${quote.data.length} bytes`);
                    break;
                }
            }
            
            if (!routingFixApplied) {
                console.log('✅ Transaction data verified - no bad receivers found');
            }
        }
        
        return quote;
    }
    
    // Calculate optimized gas settings (from sinclave.js)
    calculateOptimizedGasSettings(networkGasPrice) {
        const baseGasPrice = this.OPTIMAL_GAS_SETTINGS.baseGasPrice;
        const priorityFee = this.OPTIMAL_GAS_SETTINGS.priorityFee;
        
        // Only increase if network demands it
        const networkGas = networkGasPrice || baseGasPrice;
        const finalGasPrice = networkGas > baseGasPrice ? networkGas : baseGasPrice;
        
        return {
            maxFeePerGas: finalGasPrice + priorityFee,
            maxPriorityFeePerGas: priorityFee,
            gasLimit: this.OPTIMAL_GAS_SETTINGS.gasLimit
        };
    }
    
    // Enhanced swap execution with sinclave.js patterns
    async executeOptimizedSwap(wallet, tokenIn, tokenOut, amountIn, slippageTolerance = 0.5) {
        const startTime = Date.now();
        
        try {
            console.log(`🚀 Executing optimized swap: ${amountIn} tokens`);
            this.metrics.totalTrades++;
            
            // Step 1: Initialize optimized provider
            const provider = await this.initializeOptimizedProvider();
            const signer = new ethers.Wallet(wallet.privateKey, provider);
            
            // Step 2: Check network conditions
            const [ethBalance, gasPrice, currentBlock] = await Promise.all([
                provider.getBalance(signer.address),
                provider.getFeeData(),
                provider.getBlockNumber()
            ]);
            
            console.log(`💰 ETH Balance: ${ethers.formatEther(ethBalance)} ETH`);
            console.log(`⛽ Network Gas: ${ethers.formatUnits(gasPrice.gasPrice, 'gwei')} gwei`);
            console.log(`📦 Block: ${currentBlock}`);
            
            // Step 3: Get token contracts and check balances
            const tokenInContract = new ethers.Contract(tokenIn, this.ERC20_ABI, signer);
            const tokenOutContract = new ethers.Contract(tokenOut, this.ERC20_ABI, provider);
            
            const [tokenInDecimals, tokenOutDecimals] = await Promise.all([
                tokenInContract.decimals(),
                tokenOutContract.decimals()
            ]);
            
            const amountInWei = ethers.parseUnits(amountIn.toString(), tokenInDecimals);
            
            const [tokenInBalance, tokenOutBalanceBefore] = await Promise.all([
                tokenInContract.balanceOf(signer.address),
                tokenOutContract.balanceOf(signer.address)
            ]);
            
            console.log(`📊 Token In Balance: ${ethers.formatUnits(tokenInBalance, tokenInDecimals)}`);
            console.log(`📊 Token Out Balance (Before): ${ethers.formatUnits(tokenOutBalanceBefore, tokenOutDecimals)}`);
            
            if (tokenInBalance < amountInWei) {
                throw new Error(`Insufficient balance. Have: ${ethers.formatUnits(tokenInBalance, tokenInDecimals)}, Need: ${amountIn}`);
            }
            
                         // Step 4: Get optimized quote using multiple sources
             console.log('📈 Getting optimized swap quote...');
             
             // Try HoldStation SDK first (if available), then fallback to Uniswap
             let quote;
             let useHoldStationSDK = false;
             
             try {
                 // Attempt to use HoldStation SDK (like sinclave.js)
                 quote = await this.getHoldStationQuote(tokenIn, tokenOut, amountIn, signer.address);
                 useHoldStationSDK = true;
                 console.log('✅ Using HoldStation SDK for optimal routing');
             } catch (error) {
                 console.log(`⚠️ HoldStation SDK failed: ${error.message}`);
                 console.log('🔄 Fallback: Using Uniswap V3');
                 quote = await this.getUniswapQuote(tokenIn, tokenOut, amountInWei);
                 useHoldStationSDK = false;
             }
            
            if (!quote || !quote.to) {
                throw new Error('No swap quote available for this trading pair');
            }
            
            console.log(`💱 Quote received: ${quote.expectedOutput || 'Unknown'} tokens expected`);
            
            // Step 5: Apply proven routing fix
            const fixedQuote = this.applyProvenRoutingFix(quote, signer.address);
            
            // Step 6: Optimize gas settings
            const gasSettings = this.calculateOptimizedGasSettings(gasPrice.gasPrice);
            console.log(`⛽ Optimized Gas: ${ethers.formatUnits(gasSettings.maxFeePerGas, 'gwei')} gwei`);
            
            // Step 7: Handle approval if needed
            const currentAllowance = await tokenInContract.allowance(signer.address, fixedQuote.to);
            const needsApproval = currentAllowance < amountInWei;
            
            if (needsApproval) {
                console.log('🔓 Approving token spending with optimized gas...');
                
                const approveTx = await tokenInContract.approve(fixedQuote.to, amountInWei, {
                    gasLimit: 60000,
                    maxFeePerGas: gasSettings.maxFeePerGas,
                    maxPriorityFeePerGas: gasSettings.maxPriorityFeePerGas
                });
                
                console.log(`📝 Approval TX: ${approveTx.hash}`);
                console.log(`🔗 WorldScan: https://worldscan.org/tx/${approveTx.hash}`);
                
                const approvalReceipt = await approveTx.wait();
                console.log(`✅ Approval confirmed in block ${approvalReceipt.blockNumber}`);
            } else {
                console.log('✅ Already approved - proceeding to swap');
            }
            
            // Step 8: Execute optimized swap
            console.log('🔄 Executing optimized swap with proven patterns...');
            
            const swapTx = await signer.sendTransaction({
                to: fixedQuote.to,
                data: fixedQuote.data,
                value: fixedQuote.value || '0',
                gasLimit: gasSettings.gasLimit,
                maxFeePerGas: gasSettings.maxFeePerGas,
                maxPriorityFeePerGas: gasSettings.maxPriorityFeePerGas
            });
            
            console.log(`🚀 Swap TX sent: ${swapTx.hash}`);
            console.log(`🔗 WorldScan: https://worldscan.org/tx/${swapTx.hash}`);
            
            console.log('⏳ Waiting for confirmation...');
            const receipt = await swapTx.wait();
            
            const executionTime = Date.now() - startTime;
            
            if (receipt.status === 1) {
                console.log(`✅ Swap confirmed in block ${receipt.blockNumber}`);
                console.log(`⛽ Gas used: ${receipt.gasUsed.toString()}`);
                console.log(`⚡ Total execution time: ${executionTime}ms`);
                
                // Wait for balance updates
                await new Promise(resolve => setTimeout(resolve, 3000));
                
                // Check final balances
                const [tokenInBalanceAfter, tokenOutBalanceAfter] = await Promise.all([
                    tokenInContract.balanceOf(signer.address),
                    tokenOutContract.balanceOf(signer.address)
                ]);
                
                const tokensSpent = tokenInBalance - tokenInBalanceAfter;
                const tokensReceived = tokenOutBalanceAfter - tokenOutBalanceBefore;
                
                // Update metrics
                this.metrics.successfulTrades++;
                this.metrics.averageExecutionTime = 
                    (this.metrics.averageExecutionTime * (this.metrics.totalTrades - 1) + executionTime) / this.metrics.totalTrades;
                
                const result = {
                    success: true,
                    txHash: swapTx.hash,
                    blockNumber: receipt.blockNumber,
                    gasUsed: receipt.gasUsed.toString(),
                    executionTime: executionTime,
                    tokensSpent: ethers.formatUnits(tokensSpent, tokenInDecimals),
                    tokensReceived: ethers.formatUnits(tokensReceived, tokenOutDecimals),
                    exchangeRate: tokensSpent > 0 ? (Number(ethers.formatUnits(tokensReceived, tokenOutDecimals)) / Number(ethers.formatUnits(tokensSpent, tokenInDecimals))) : 0,
                    optimizations: {
                        publicRPCUsed: this.cachedProvider === this.PRIMARY_RPC,
                        routingFixApplied: true,
                        gasOptimized: true,
                        sdkUsed: useHoldStationSDK ? 'HoldStation' : 'Uniswap'
                    }
                };
                
                console.log('🎉 OPTIMIZED SWAP SUCCESS!');
                console.log(`📊 Exchange Rate: 1 token = ${result.exchangeRate.toFixed(6)} tokens`);
                console.log(`⚡ Execution Time: ${executionTime}ms`);
                
                return result;
                
            } else {
                throw new Error('Swap transaction failed');
            }
            
        } catch (error) {
            const executionTime = Date.now() - startTime;
            console.log(`❌ OPTIMIZED SWAP FAILED after ${executionTime}ms: ${error.message}`);
            
            return {
                success: false,
                error: error.message,
                executionTime: executionTime
            };
        }
    }
    
    // Get HoldStation SDK quote (like sinclave.js)
    async getHoldStationQuote(tokenIn, tokenOut, amountIn, receiver) {
        try {
            console.log('🚀 Attempting to initialize HoldStation SDK...');
            
            // Try to dynamically import HoldStation SDK
            // Note: These packages need to be installed manually as they may not be in public npm registry
            const { Client, Multicall3 } = await import("@holdstation/worldchain-ethers-v6");
            const { 
                config, 
                HoldSo, 
                inmemoryTokenStorage, 
                SwapHelper, 
                TokenProvider, 
                ZeroX,
                setPartnerCode 
            } = await import("@holdstation/worldchain-sdk");

            // Set partner code (like sinclave.js)
            try {
                setPartnerCode("WORLDCHAIN_TRADING_BOT_2025");
                console.log('✅ Partner code set for HoldStation SDK');
            } catch (error) {
                console.log('⚠️ Partner code already set');
            }

            // Initialize client and components
            const provider = await this.initializeOptimizedProvider();
            const client = new Client(provider);
            config.client = client;
            config.multicall3 = new Multicall3(provider);

            // Initialize swap helper with providers
            const swapHelper = new SwapHelper(client, {
                tokenStorage: inmemoryTokenStorage,
            });

            const tokenProvider = new TokenProvider({ client, multicall3: config.multicall3 });
            const zeroX = new ZeroX(tokenProvider, inmemoryTokenStorage);
            const worldswap = new HoldSo(tokenProvider, inmemoryTokenStorage);
            
            // Load swap providers
            swapHelper.load(zeroX);
            swapHelper.load(worldswap);

            console.log('✅ HoldStation SDK initialized successfully');

            // Get swap quote using HoldStation
            const params = {
                tokenIn: tokenIn,
                tokenOut: tokenOut,
                amountIn: amountIn.toString(),
                slippage: "0.5",
                fee: "0.2",
                receiver: receiver
            };
            
            console.log(`📊 Getting HoldStation quote for ${params.amountIn} tokens...`);
            const quote = await swapHelper.estimate.quote(params);

            if (!quote || !quote.to) {
                throw new Error('HoldStation SDK returned no quote for this pair');
            }

            console.log('✅ HoldStation quote received successfully');
            
            return {
                to: quote.to,
                data: quote.data,
                value: quote.value || '0',
                expectedOutput: quote.addons?.outAmount || 'Unknown',
                gasEstimate: quote.gasEstimate,
                provider: 'HoldStation'
            };

        } catch (error) {
            // More specific error handling
            if (error.code === 'MODULE_NOT_FOUND' || error.message.includes('Cannot resolve module')) {
                console.log('⚠️ HoldStation SDK packages not installed');
                console.log('💡 To use HoldStation SDK, you need to install the packages manually:');
                console.log('   npm install @holdstation/worldchain-sdk');
                console.log('   npm install @holdstation/worldchain-ethers-v6');
                throw new Error('HoldStation SDK packages not found - install manually or use fallback');
            } else {
                console.log(`❌ HoldStation SDK error: ${error.message}`);
                throw new Error(`HoldStation SDK failed: ${error.message}`);
            }
        }
    }
    
    // Fallback to Uniswap V3 quote
    async getUniswapQuote(tokenIn, tokenOut, amountInWei) {
        const quoterContract = new ethers.Contract(this.QUOTER_V2, this.QUOTER_ABI, this.provider);
        
        let bestQuote = null;
        let bestFee = 3000;
        
        for (const fee of this.FEE_TIERS) {
            try {
                const quote = await quoterContract.quoteExactInputSingle.staticCall(
                    tokenIn,
                    tokenOut,
                    fee,
                    amountInWei,
                    0
                );
                
                if (!bestQuote || quote > bestQuote) {
                    bestQuote = quote;
                    bestFee = fee;
                }
            } catch (error) {
                continue;
            }
        }
        
        if (!bestQuote) {
            throw new Error('No liquidity available for this pair');
        }
        
        // Create Uniswap transaction data
        const routerContract = new ethers.Contract(this.UNISWAP_V3_ROUTER, this.ROUTER_ABI, this.provider);
        const deadline = Math.floor(Date.now() / 1000) + 1800; // 30 minutes
        
        const params = {
            tokenIn,
            tokenOut,
            fee: bestFee,
            recipient: this.provider.getSigner().address,
            deadline,
            amountIn: amountInWei,
            amountOutMinimum: (bestQuote * BigInt(995)) / BigInt(1000), // 0.5% slippage
            sqrtPriceLimitX96: 0
        };
        
        const data = routerContract.interface.encodeFunctionData('exactInputSingle', [params]);
        
        return {
            to: this.UNISWAP_V3_ROUTER,
            data: data,
            value: '0',
            expectedOutput: ethers.formatEther(bestQuote)
        };
    }
    
    // Get performance metrics
    getMetrics() {
        const successRate = this.metrics.totalTrades > 0 ? 
            (this.metrics.successfulTrades / this.metrics.totalTrades * 100).toFixed(2) : 0;
        
        return {
            ...this.metrics,
            successRate: `${successRate}%`,
            averageExecutionTime: `${Math.round(this.metrics.averageExecutionTime)}ms`
        };
    }
    
    // Reset metrics
    resetMetrics() {
        this.metrics = {
            totalTrades: 0,
            successfulTrades: 0,
            averageExecutionTime: 0,
            gasOptimizationSavings: 0
        };
    }
}

module.exports = SinclaveEnhancedTradingEngine;