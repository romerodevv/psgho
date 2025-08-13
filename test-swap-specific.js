#!/usr/bin/env node

// Test script to get swap quote for 1 WLD to specific token
console.log('🧪 Testing WLD to Custom Token Swap Quote with HoldStation SDK...');

async function testCustomSwapQuote() {
    try {
        console.log('📦 Importing required packages...');
        
        // Import ethers and HoldStation SDK
        const { ethers } = await import("ethers");
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

        console.log('✅ All packages imported successfully');

        // Set partner code
        console.log('🎯 Setting partner code...');
        try {
            setPartnerCode("WORLDCHAIN_TRADING_BOT_TEST");
            console.log('✅ Partner code set successfully');
        } catch (error) {
            console.log('⚠️ Partner code already set');
        }

        // Initialize provider
        console.log('🌍 Connecting to Worldchain...');
        const provider = new ethers.JsonRpcProvider('https://worldchain-mainnet.g.alchemy.com/public', {
            chainId: 480,
            name: "worldchain"
        });

        const blockNumber = await provider.getBlockNumber();
        console.log(`✅ Connected to Worldchain, block: ${blockNumber}`);

        // Initialize HoldStation components
        console.log('🔧 Initializing HoldStation SDK components...');
        const client = new Client(provider);
        config.client = client;
        config.multicall3 = new Multicall3(provider);

        const swapHelper = new SwapHelper(client, {
            tokenStorage: inmemoryTokenStorage,
        });

        const tokenProvider = new TokenProvider({ client, multicall3: config.multicall3 });
        const zeroX = new ZeroX(tokenProvider, inmemoryTokenStorage);
        const worldswap = new HoldSo(tokenProvider, inmemoryTokenStorage);
        
        // Load swap providers
        swapHelper.load(zeroX);
        swapHelper.load(worldswap);

        console.log('✅ HoldStation SDK components initialized');

        // Token addresses
        const WLD_ADDRESS = '0x2cfc85d8e48f8eab294be644d9e25c3030863003';
        const CUSTOM_TOKEN_ADDRESS = '0x1a16f733b813a59815a76293dac835ad1c7fedff';

        console.log('🪙 Token addresses:');
        console.log(`   WLD: ${WLD_ADDRESS}`);
        console.log(`   Custom Token: ${CUSTOM_TOKEN_ADDRESS}`);

        // Try to get token information
        console.log('\n🔍 Getting token information...');
        try {
            const tokenInfo = await tokenProvider.details(CUSTOM_TOKEN_ADDRESS);
            console.log('📊 Token Details:');
            console.log(`   Name: ${tokenInfo.name || 'Unknown'}`);
            console.log(`   Symbol: ${tokenInfo.symbol || 'Unknown'}`);
            console.log(`   Decimals: ${tokenInfo.decimals || 'Unknown'}`);
        } catch (error) {
            console.log('⚠️ Could not fetch token details, proceeding with swap test...');
        }

        // Get swap quote for 1 WLD to Custom Token
        console.log('\n💱 Getting swap quote: 1 WLD → Custom Token');
        console.log('─'.repeat(50));

        const swapParams = {
            tokenIn: WLD_ADDRESS,
            tokenOut: CUSTOM_TOKEN_ADDRESS,
            amountIn: "1.0", // 1 WLD
            slippage: "0.5", // 0.5% slippage
            fee: "0.2",      // 0.2% fee
            receiver: "0x0000000000000000000000000000000000000001" // Test address
        };

        console.log('📊 Swap parameters:');
        console.log(`   Amount In: ${swapParams.amountIn} WLD`);
        console.log(`   Token Out: ${CUSTOM_TOKEN_ADDRESS}`);
        console.log(`   Slippage: ${swapParams.slippage}%`);
        console.log(`   Fee: ${swapParams.fee}%`);

        try {
            console.log('\n🔄 Requesting quote from HoldStation...');
            const quote = await swapHelper.estimate.quote(swapParams);

            if (quote && quote.to) {
                console.log('\n🎉 SUCCESS - Quote received!');
                console.log('═'.repeat(50));
                console.log(`📈 Expected Output: ${quote.addons?.outAmount || 'Unknown'} tokens`);
                console.log(`📍 Router Address: ${quote.to}`);
                console.log(`⛽ Gas Estimate: ${quote.gasEstimate || 'Unknown'}`);
                console.log(`💰 Value: ${quote.value || '0'} ETH`);
                console.log(`📋 Data Length: ${quote.data ? quote.data.length : 0} bytes`);

                // Calculate exchange rate if possible
                if (quote.addons?.outAmount) {
                    const rate = parseFloat(quote.addons.outAmount);
                    console.log(`\n💹 Exchange Rate: 1 WLD = ${rate.toFixed(6)} tokens`);
                    if (rate > 0) {
                        console.log(`💹 Exchange Rate: 1 token = ${(1/rate).toFixed(8)} WLD`);
                    }
                }

                // Show additional quote details
                if (quote.addons) {
                    console.log('\n📋 Additional Quote Details:');
                    Object.keys(quote.addons).forEach(key => {
                        if (key !== 'outAmount') {
                            console.log(`   ${key}: ${quote.addons[key]}`);
                        }
                    });
                }

                console.log('\n✅ WLD/Custom Token pair has liquidity on HoldStation!');
                console.log('🚀 Your trading bot should be able to execute this trade successfully!');
                
                return true;
            } else {
                console.log('\n❌ No quote received from HoldStation');
                console.log('💡 This could mean:');
                console.log('   • No liquidity for WLD/Custom Token pair');
                console.log('   • Invalid token address');
                console.log('   • Token not supported on HoldStation DEX');
                console.log('   • HoldStation SDK configuration issue');
                return false;
            }

        } catch (quoteError) {
            console.log('\n❌ Error getting quote from HoldStation:');
            console.log(`💥 ${quoteError.message}`);
            
            if (quoteError.message.includes('No route found')) {
                console.log('\n💡 No trading route found for this pair');
                console.log('🔍 Possible reasons:');
                console.log('   • Token pair has no liquidity on HoldStation DEX');
                console.log('   • Token address is invalid or not a valid ERC20');
                console.log('   • Token is not listed on HoldStation exchange');
                console.log('   • Try different token addresses or amounts');
            } else if (quoteError.message.includes('insufficient')) {
                console.log('\n💡 Insufficient liquidity for this trade size');
                console.log('🔍 Try:');
                console.log('   • Smaller trade amounts');
                console.log('   • Check if pair exists with smaller test amounts');
            }
            
            return false;
        }

    } catch (error) {
        console.log('\n❌ Test failed with error:');
        console.log(`💥 ${error.message}`);
        console.log(`📋 Stack: ${error.stack}`);
        return false;
    }
}

// Run the test
console.log('🚀 Starting WLD → Custom Token swap quote test...\n');

testCustomSwapQuote().then(success => {
    console.log('\n' + '═'.repeat(60));
    if (success) {
        console.log('🎯 RESULT: WLD/Custom Token trading is AVAILABLE!');
        console.log('✅ Your bot should be able to trade this pair successfully');
        console.log('💡 Token address: 0x1a16f733b813a59815a76293dac835ad1c7fedff');
    } else {
        console.log('⚠️  RESULT: WLD/Custom Token trading is NOT available');
        console.log('💡 This token pair may not have liquidity on HoldStation DEX');
        console.log('🔍 Token address: 0x1a16f733b813a59815a76293dac835ad1c7fedff');
    }
    console.log('═'.repeat(60));
    
    process.exit(success ? 0 : 1);
}).catch(error => {
    console.log('\n💥 Test script error:', error.message);
    process.exit(1);
});