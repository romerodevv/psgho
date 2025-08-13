#!/usr/bin/env node

// Test script to get swap quote for 1 WLD to ORO
console.log('🧪 Testing WLD to ORO Swap Quote with HoldStation SDK...');

async function testSwapQuote() {
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

        // Token addresses (from sinclave.js)
        const WLD_ADDRESS = '0x2cfc85d8e48f8eab294be644d9e25c3030863003';
        const ORO_ADDRESS = '0xcd1E32B86953D79a6AC58e813D2EA7a1790cAb63';

        console.log('🪙 Token addresses:');
        console.log(`   WLD: ${WLD_ADDRESS}`);
        console.log(`   ORO: ${ORO_ADDRESS}`);

        // Get swap quote for 1 WLD to ORO
        console.log('\n💱 Getting swap quote: 1 WLD → ORO');
        console.log('─'.repeat(50));

        const swapParams = {
            tokenIn: WLD_ADDRESS,
            tokenOut: ORO_ADDRESS,
            amountIn: "1.0", // 1 WLD
            slippage: "0.5", // 0.5% slippage
            fee: "0.2",      // 0.2% fee
            receiver: "0x0000000000000000000000000000000000000001" // Test address
        };

        console.log('📊 Swap parameters:');
        console.log(`   Amount In: ${swapParams.amountIn} WLD`);
        console.log(`   Slippage: ${swapParams.slippage}%`);
        console.log(`   Fee: ${swapParams.fee}%`);

        try {
            console.log('\n🔄 Requesting quote from HoldStation...');
            const quote = await swapHelper.estimate.quote(swapParams);

            if (quote && quote.to) {
                console.log('\n🎉 SUCCESS - Quote received!');
                console.log('═'.repeat(50));
                console.log(`📈 Expected Output: ${quote.addons?.outAmount || 'Unknown'} ORO`);
                console.log(`📍 Router Address: ${quote.to}`);
                console.log(`⛽ Gas Estimate: ${quote.gasEstimate || 'Unknown'}`);
                console.log(`💰 Value: ${quote.value || '0'} ETH`);
                console.log(`📋 Data Length: ${quote.data ? quote.data.length : 0} bytes`);

                // Calculate exchange rate
                if (quote.addons?.outAmount) {
                    const rate = parseFloat(quote.addons.outAmount);
                    console.log(`\n💹 Exchange Rate: 1 WLD = ${rate.toFixed(6)} ORO`);
                    console.log(`💹 Exchange Rate: 1 ORO = ${(1/rate).toFixed(6)} WLD`);
                }

                console.log('\n✅ WLD/ORO pair has liquidity on HoldStation!');
                console.log('🚀 Your trading bot should be able to execute this trade successfully!');
                
                return true;
            } else {
                console.log('\n❌ No quote received from HoldStation');
                console.log('💡 This could mean:');
                console.log('   • No liquidity for WLD/ORO pair');
                console.log('   • Invalid token addresses');
                console.log('   • HoldStation SDK configuration issue');
                return false;
            }

        } catch (quoteError) {
            console.log('\n❌ Error getting quote from HoldStation:');
            console.log(`💥 ${quoteError.message}`);
            
            if (quoteError.message.includes('No route found')) {
                console.log('\n💡 This means WLD/ORO pair has no liquidity on HoldStation DEX');
                console.log('🔍 Try checking:');
                console.log('   • Token addresses are correct');
                console.log('   • Pair exists on HoldStation exchange');
                console.log('   • Try smaller amounts');
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
console.log('🚀 Starting WLD → ORO swap quote test...\n');

testSwapQuote().then(success => {
    console.log('\n' + '═'.repeat(60));
    if (success) {
        console.log('🎯 RESULT: WLD/ORO trading is AVAILABLE on HoldStation!');
        console.log('✅ Your bot should be able to trade this pair successfully');
    } else {
        console.log('⚠️  RESULT: WLD/ORO trading may not be available');
        console.log('💡 Check token addresses and liquidity availability');
    }
    console.log('═'.repeat(60));
    
    process.exit(success ? 0 : 1);
}).catch(error => {
    console.log('\n💥 Test script error:', error.message);
    process.exit(1);
});