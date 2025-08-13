// Configuration file for WorldChain Interactive Trading Bot
// Modify these settings according to your preferences

module.exports = {
    // RPC Configuration
    rpc: {
        primary: 'https://worldchain-mainnet.g.alchemy.com/public',
        fallback: 'https://worldchain-mainnet.g.alchemy.com/v2/7MFAWnvGmZk3tDjmofyx6',
        chainId: 480,
        name: 'worldchain'
    },

    // Token Addresses
    tokens: {
        wld: '0x2cFc85d8E48F8EAB294be644d9E25C3030863003',
        oro: '0xcd1E32B86953D79a6AC58e813D2EA7a1790cAb63',
        // Add more token addresses here
        // yield: '0x1234567890123456789012345678901234567890',
    },

    // Contract Addresses
    contracts: {
        holdstation: '0x0281c83C8F53314DFF3ebE24A90ee2412A2aA970',
        // Add more contract addresses as needed
    },

    // Trading Configuration
    trading: {
        defaultSlippage: '0.5', // Percentage
        defaultFee: '0.2', // Percentage
        gasLimit: 280000,
        maxPriorityFee: '0.0001', // gwei
        baseGasPrice: '0.001' // gwei
    },

    // Auto-Update Settings
    updates: {
        portfolioInterval: '*/5 * * * *', // Cron expression: every 5 minutes
        enableAutoUpdates: true,
        enableTokenDiscovery: true,
        enableTradingPairUpdates: true
    },

    // UI Configuration
    ui: {
        enableColors: true,
        enableSpinners: true,
        enableTables: true,
        refreshRate: 1000 // ms
    },

    // Security Settings
    security: {
        maxSlippage: 10, // Maximum allowed slippage percentage
        minGasPrice: '0.0001', // Minimum gas price in gwei
        maxGasPrice: '1.0', // Maximum gas price in gwei
        requireConfirmation: true // Require user confirmation for large trades
    },

    // Performance Settings
    performance: {
        enableCaching: true,
        cacheTimeout: 300000, // 5 minutes in ms
        maxRetries: 3,
        retryDelay: 1000 // ms
    },

    // Logging Configuration
    logging: {
        level: 'info', // debug, info, warn, error
        enableFileLogging: false,
        logFile: './trading-bot.log',
        enableConsoleLogging: true
    },

    // Data Storage
    storage: {
        dataFile: './trading-data.json',
        backupFile: './trading-data.backup.json',
        enableBackups: true,
        backupInterval: 24 * 60 * 60 * 1000 // 24 hours in ms
    },

    // Network Settings
    network: {
        timeout: 30000, // 30 seconds
        maxConcurrentRequests: 5,
        enableRetry: true,
        retryAttempts: 3
    },

    // Trading Pairs Configuration
    tradingPairs: {
        autoCreate: true, // Automatically create pairs for discovered tokens
        defaultBase: 'WLD', // Default base token for all pairs
        minLiquidity: '0.001', // Minimum liquidity required for trading
        enableAllPairs: false // Enable all discovered pairs by default
    },

    // Portfolio Settings
    portfolio: {
        autoScan: true, // Automatically scan wallets for tokens
        scanInterval: 300000, // 5 minutes in ms
        enableNotifications: false,
        minBalanceThreshold: '0.001' // Minimum balance to display
    },

    // Quick Swap Settings
    quickSwap: {
        enabled: true,
        defaultToken: 'ORO', // Default token for quick swaps
        maxAmount: '100', // Maximum amount for quick swaps
        requireConfirmation: false
    }
};