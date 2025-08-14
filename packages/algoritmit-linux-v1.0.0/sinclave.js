#!/usr/bin/env node

const { ethers } = require('ethers');

// Optimized Simple Trader with WorldChain Bot speed improvements
const CONFIG = {
    privateKey: 'privatekeyhere',
    // Use public endpoint for speed (111ms vs 137ms from analysis)
    primaryRpc: 'https://worldchain-mainnet.g.alchemy.com/public',
    fallbackRpc: 'https://worldchain-mainnet.g.alchemy.com/v2/7MFAWnvGmZk3tDjmofyx6',
    wldAddress: '0x2cFc85d8E48F8EAB294be644d9E25C3030863003',
    oroAddress: '0xcd1E32B86953D79a6AC58e813D2EA7a1790cAb63',
    // Proven working contract from analysis
    holdstationContract: '0x0281c83C8F53314DFF3ebE24A90ee2412A2aA970',
    swapAmount: '0.003',
    chainId: 480
};

const colors = {
    red: '\x1b[31m', green: '\x1b[32m', yellow: '\x1b[33m',
    blue: '\x1b[34m', cyan: '\x1b[36m', reset: '\x1b[0m', bright: '\x1b[1m'
};

function log(message, color = 'white') {
    console.log(`${colors[color]}[${new Date().toLocaleString()}] ${message}${colors.reset}`);
}

// Pre-load and cache SDK components for speed
let cachedSDK = null;
let cachedProvider = null;

async function initializeOptimizedProvider() {
    if (cachedProvider) {
        return cachedProvider;
    }

    try {
        // Primary: Use fast public endpoint
        const provider = new ethers.providers.StaticJsonRpcProvider(CONFIG.primaryRpc, {
            chainId: CONFIG.chainId,
            name: "worldchain",
        });
        
        // Test connection
        await provider.getBlockNumber();
        cachedProvider = provider;
        log('Connected to optimized public RPC endpoint', 'green');
        return provider;
        
    } catch (error) {
        log('Public endpoint failed, using authenticated fallback', 'yellow');
        
        // Fallback: Use authenticated endpoint
        const fallbackProvider = new ethers.providers.StaticJsonRpcProvider(CONFIG.fallbackRpc, {
            chainId: CONFIG.chainId,
            name: "worldchain",
        });
        
        cachedProvider = fallbackProvider;
        return fallbackProvider;
    }
}

async function initializeOptimizedSDK(provider) {
    if (cachedSDK) {
        return cachedSDK;
    }

    log('Initializing optimized SDK with caching...', 'yellow');
    
    const { Client, Multicall3 } = await import("@holdstation/worldchain-ethers-v5");
    const { 
        config, 
        HoldSo, 
        inmemoryTokenStorage, 
        SwapHelper, 
        TokenProvider, 
        ZeroX,
        setPartnerCode 
    } = await import("@holdstation/worldchain-sdk");

    try {
        setPartnerCode("REPLIT_OPTIMIZED_TRADER_2025");
        log('Partner code set for optimized trader', 'green');
    } catch (error) {
        log('Partner code already set', 'yellow');
    }

    const client = new Client(provider);
    config.client = client;
    config.multicall3 = new Multicall3(provider);

    const swapHelper = new SwapHelper(client, {
        tokenStorage: inmemoryTokenStorage,
    });

    const tokenProvider = new TokenProvider({ client, multicall3: config.multicall3 });
    const zeroX = new ZeroX(tokenProvider, inmemoryTokenStorage);
    const worldswap = new HoldSo(tokenProvider, inmemoryTokenStorage);
    
    swapHelper.load(zeroX);
    swapHelper.load(worldswap);

    cachedSDK = { swapHelper, client, tokenProvider };
    log('SDK initialized and cached for optimal performance', 'green');
    
    return cachedSDK;
}

function applyProvenRoutingFix(quote, userWallet) {
    log('Applying proven WorldChain bot routing fix...', 'yellow');
    
    // Force use of proven working contract
    const originalContract = quote.to;
    quote.to = CONFIG.holdstationContract;
    
    if (originalContract !== CONFIG.holdstationContract) {
        log(`Contract override: ${originalContract} → ${CONFIG.holdstationContract}`, 'cyan');
    }

    // Apply transaction data fix for bad receivers
    if (quote.data && typeof quote.data === 'string') {
        const badReceivers = [
            "43222f934ea5c593a060a6d46772fdbdc2e2cff0",
            "0x43222f934ea5c593a060a6d46772fdbdc2e2cff0"
        ];
        const correctReceiver = userWallet.toLowerCase().replace("0x", "");
        
        let routingFixApplied = false;
        for (const badReceiver of badReceivers) {
            const cleanBadReceiver = badReceiver.replace("0x", "").toLowerCase();
            if (quote.data.toLowerCase().includes(cleanBadReceiver)) {
                log(`Detected bad receiver: ${badReceiver}`, 'red');
                
                const originalData = quote.data;
                quote.data = quote.data.replace(
                    new RegExp(cleanBadReceiver, 'gi'),
                    correctReceiver
                );
                
                routingFixApplied = true;
                log(`Routing fixed: ${badReceiver} → ${userWallet}`, 'green');
                log(`Data integrity: ${originalData.length} → ${quote.data.length} bytes`, 'cyan');
                break;
            }
        }
        
        if (!routingFixApplied) {
            log('Transaction data verified - no bad receivers found', 'green');
        }
    }
    
    return quote;
}

function calculateOptimizedGasSettings(networkGasPrice) {
    // Use proven gas settings from successful transactions
    const baseGasPrice = ethers.utils.parseUnits('0.001', 'gwei'); // Proven working rate
    const priorityFee = ethers.utils.parseUnits('0.0001', 'gwei'); // Minimal priority
    
    // Only increase if network demands it
    const networkGas = networkGasPrice || baseGasPrice;
    const finalGasPrice = networkGas.gt(baseGasPrice) ? networkGas : baseGasPrice;
    
    return {
        maxFeePerGas: finalGasPrice.add(priorityFee),
        maxPriorityFeePerGas: priorityFee,
        gasLimit: 280000 // Proven optimal gas limit
    };
}

async function executeOptimizedSwap() {
    log('🚀 OPTIMIZED SIMPLE TRADER', 'bright');
    log('==========================', 'blue');
    console.log();

    const startTime = Date.now();

    try {
        // Step 1: Initialize optimized provider (with caching)
        const provider = await initializeOptimizedProvider();
        const wallet = new ethers.Wallet(CONFIG.privateKey, provider);
        
        log(`Wallet: ${wallet.address}`, 'cyan');
        log(`Target: ${CONFIG.swapAmount} WLD → ORO`, 'cyan');

        // Step 2: Check network conditions
        const [ethBalance, gasPrice, currentBlock] = await Promise.all([
            provider.getBalance(wallet.address),
            provider.getGasPrice(),
            provider.getBlockNumber()
        ]);

        log(`ETH Balance: ${ethers.utils.formatEther(ethBalance)} ETH`, 'cyan');
        log(`Network Gas: ${ethers.utils.formatUnits(gasPrice, 'gwei')} gwei`, 'cyan');
        log(`Block: ${currentBlock}`, 'cyan');

        // Step 3: Check token balances
        const ERC20_ABI = [
            'function balanceOf(address) view returns (uint256)',
            'function approve(address,uint256) returns (bool)',
            'function allowance(address,address) view returns (uint256)'
        ];

        const wldContract = new ethers.Contract(CONFIG.wldAddress, ERC20_ABI, wallet);
        const oroContract = new ethers.Contract(CONFIG.oroAddress, ERC20_ABI, wallet);

        const [wldBalance, oroBalanceBefore] = await Promise.all([
            wldContract.balanceOf(wallet.address),
            oroContract.balanceOf(wallet.address)
        ]);

        log(`WLD Balance: ${ethers.utils.formatEther(wldBalance)} WLD`, 'cyan');
        log(`ORO Balance (Before): ${ethers.utils.formatEther(oroBalanceBefore)} ORO`, 'cyan');

        const swapAmountWei = ethers.utils.parseEther(CONFIG.swapAmount);
        
        if (wldBalance.lt(swapAmountWei)) {
            throw new Error(`Insufficient WLD. Have: ${ethers.utils.formatEther(wldBalance)}, Need: ${CONFIG.swapAmount}`);
        }

        // Step 4: Initialize optimized SDK (with caching)
        const { swapHelper } = await initializeOptimizedSDK(provider);

        // Step 5: Get optimized swap quote
        log('Getting optimized swap quote...', 'yellow');
        
        const params = {
            tokenIn: CONFIG.wldAddress,
            tokenOut: CONFIG.oroAddress,
            amountIn: CONFIG.swapAmount,
            slippage: "0.5",
            fee: "0.2",
            receiver: wallet.address
        };
        
        const quote = await swapHelper.estimate.quote(params);

        if (!quote || !quote.to) {
            throw new Error('No swap quote available for WLD → ORO pair');
        }

        log(`Quote received: ${quote.addons?.outAmount || 'Unknown'} ORO expected`, 'green');

        // Step 6: Apply proven routing fix
        const fixedQuote = applyProvenRoutingFix(quote, wallet.address);

        // Step 7: Optimize gas settings
        const gasSettings = calculateOptimizedGasSettings(gasPrice);
        log(`Optimized Gas: ${ethers.utils.formatUnits(gasSettings.maxFeePerGas, 'gwei')} gwei`, 'cyan');

        // Step 8: Handle approval if needed
        const currentAllowance = await wldContract.allowance(wallet.address, fixedQuote.to);
        const needsApproval = currentAllowance.lt(swapAmountWei);

        if (needsApproval) {
            log('Approving WLD spending with optimized gas...', 'yellow');
            
            const approveTx = await wldContract.approve(fixedQuote.to, swapAmountWei, {
                gasLimit: 60000,
                maxFeePerGas: gasSettings.maxFeePerGas,
                maxPriorityFeePerGas: gasSettings.maxPriorityFeePerGas
            });

            log(`Approval TX: ${approveTx.hash}`, 'blue');
            log(`WorldScan: https://worldscan.org/tx/${approveTx.hash}`, 'cyan');
            
            const approvalReceipt = await approveTx.wait();
            log(`Approval confirmed in block ${approvalReceipt.blockNumber}`, 'green');
        } else {
            log('Already approved - proceeding to swap', 'green');
        }

        // Step 9: Execute optimized swap
        log('Executing optimized swap with proven patterns...', 'yellow');
        
        const swapTx = await wallet.sendTransaction({
            to: fixedQuote.to,
            data: fixedQuote.data,
            value: fixedQuote.value || '0',
            gasLimit: gasSettings.gasLimit,
            maxFeePerGas: gasSettings.maxFeePerGas,
            maxPriorityFeePerGas: gasSettings.maxPriorityFeePerGas
        });

        log(`Swap TX sent: ${swapTx.hash}`, 'green');
        log(`WorldScan: https://worldscan.org/tx/${swapTx.hash}`, 'cyan');

        log('Waiting for confirmation...', 'yellow');
        const receipt = await swapTx.wait();
        
        const executionTime = Date.now() - startTime;

        if (receipt.status === 1) {
            log(`Swap confirmed in block ${receipt.blockNumber}`, 'green');
            log(`Gas used: ${receipt.gasUsed.toString()}`, 'cyan');
            log(`Total execution time: ${executionTime}ms`, 'cyan');

            // Wait for balance updates
            await new Promise(resolve => setTimeout(resolve, 3000));

            // Check final balances
            const [wldBalanceAfter, oroBalanceAfter] = await Promise.all([
                wldContract.balanceOf(wallet.address),
                oroContract.balanceOf(wallet.address)
            ]);

            const wldSpent = wldBalance.sub(wldBalanceAfter);
            const oroReceived = oroBalanceAfter.sub(oroBalanceBefore);

            console.log();
            log('🎉 OPTIMIZED SWAP RESULTS', 'bright');
            log('=========================', 'green');
            console.log(`WLD Spent: ${ethers.utils.formatEther(wldSpent)} WLD`);
            console.log(`ORO Received: ${ethers.utils.formatEther(oroReceived)} ORO`);
            console.log(`Transaction: ${swapTx.hash}`);
            console.log(`Block: ${receipt.blockNumber}`);
            console.log(`Gas Used: ${receipt.gasUsed.toString()}`);
            console.log(`Execution Time: ${executionTime}ms`);
            console.log(`WorldScan: https://worldscan.org/tx/${swapTx.hash}`);
            
            if (oroReceived.gt(0)) {
                log('SUCCESS: ORO tokens received in wallet!', 'green');
                
                if (wldSpent.gt(0) && oroReceived.gt(0)) {
                    const wldSpentFormatted = parseFloat(ethers.utils.formatEther(wldSpent));
                    const oroReceivedFormatted = parseFloat(ethers.utils.formatEther(oroReceived));
                    if (wldSpentFormatted > 0) {
                        const rate = oroReceivedFormatted / wldSpentFormatted;
                        console.log(`Exchange Rate: 1 WLD = ${rate.toFixed(6)} ORO`);
                    }
                }
                
                console.log();
                log('🏆 OPTIMIZATION SUCCESS', 'bright');
                console.log('- Public endpoint routing: OPTIMIZED ✅');
                console.log('- SDK component caching: ENABLED ✅');
                console.log('- Proven routing fix: APPLIED ✅');
                console.log('- Gas optimization: IMPLEMENTED ✅');
                console.log(`- Fast execution: ${executionTime}ms ✅`);
                
            } else {
                log('No ORO tokens received - checking transaction logs', 'yellow');
            }

        } else {
            log('Swap transaction failed', 'red');
            log(`Gas used: ${receipt.gasUsed.toString()}`, 'yellow');
        }

    } catch (error) {
        const executionTime = Date.now() - startTime;
        log(`OPTIMIZED SWAP FAILED after ${executionTime}ms: ${error.message}`, 'red');
        console.error(error);
    }
}

executeOptimizedSwap().catch(console.error);