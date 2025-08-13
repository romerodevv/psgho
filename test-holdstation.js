#!/usr/bin/env node

// Test script to verify HoldStation SDK integration
console.log('🧪 Testing HoldStation SDK Integration...');

async function testHoldStationSDK() {
    try {
        console.log('📦 Importing HoldStation SDK packages...');
        
        // Test importing the packages
        const { Client, Multicall3 } = await import("@holdstation/worldchain-ethers-v6");
        console.log('✅ @holdstation/worldchain-ethers-v6 imported successfully');
        
        const { 
            config, 
            HoldSo, 
            inmemoryTokenStorage, 
            SwapHelper, 
            TokenProvider, 
            ZeroX,
            setPartnerCode 
        } = await import("@holdstation/worldchain-sdk");
        console.log('✅ @holdstation/worldchain-sdk imported successfully');
        
        console.log('🎯 Setting partner code...');
        try {
            setPartnerCode("WORLDCHAIN_TRADING_BOT_TEST");
            console.log('✅ Partner code set successfully');
        } catch (error) {
            console.log('⚠️ Partner code already set or error:', error.message);
        }
        
        console.log('🌍 Testing provider connection...');
        const { ethers } = await import("ethers");
        
        const provider = new ethers.JsonRpcProvider('https://worldchain-mainnet.g.alchemy.com/public', {
            chainId: 480,
            name: "worldchain"
        });
        
        // Test connection
        const blockNumber = await provider.getBlockNumber();
        console.log(`✅ Connected to Worldchain, current block: ${blockNumber}`);
        
        console.log('🔧 Initializing HoldStation components...');
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
        
        console.log('✅ HoldStation SDK components initialized successfully');
        
        console.log('🎉 HoldStation SDK Integration Test PASSED!');
        console.log('💡 The SDK is ready for use in the trading bot');
        
        return true;
        
    } catch (error) {
        console.log('❌ HoldStation SDK Integration Test FAILED!');
        console.log('💥 Error:', error.message);
        console.log('📋 Stack:', error.stack);
        return false;
    }
}

// Run the test
testHoldStationSDK().then(success => {
    if (success) {
        console.log('\n🚀 Ready for trading with HoldStation SDK!');
        process.exit(0);
    } else {
        console.log('\n⚠️ HoldStation SDK needs troubleshooting');
        process.exit(1);
    }
}).catch(error => {
    console.log('\n💥 Test script error:', error.message);
    process.exit(1);
});