#!/usr/bin/env node

const { ethers } = require('ethers');
const inquirer = require('inquirer');
const chalk = require('chalk');
const ora = require('ora');
const Table = require('cli-table3');
const fs = require('fs-extra');
const path = require('path');
const cron = require('node-cron');

// Configuration
const CONFIG = {
    primaryRpc: 'https://worldchain-mainnet.g.alchemy.com/public',
    fallbackRpc: 'https://worldchain-mainnet.g.alchemy.com/v2/7MFAWnvGmZk3tDjmofyx6',
    wldAddress: '0x2cFc85d8E48F8EAB294be644d9E25C3030863003',
    holdstationContract: '0x0281c83C8F53314DFF3ebE24A90ee2412A2aA970',
    chainId: 480,
    dataFile: './trading-data.json',
    defaultSlippage: '0.5',
    defaultFee: '0.2'
};

// Global variables
let cachedSDK = null;
let cachedProvider = null;
let wallets = [];
let tradingPairs = [];
let portfolio = {};

// Colors for better UI
const colors = {
    success: chalk.green,
    error: chalk.red,
    warning: chalk.yellow,
    info: chalk.blue,
    highlight: chalk.cyan,
    title: chalk.bold.white
};

class TradingBot {
    constructor() {
        this.initialize();
    }

    async initialize() {
        console.clear();
        console.log(colors.title('🌍 WORLDCHAIN INTERACTIVE TRADING BOT 🌍'));
        console.log(colors.info('=========================================='));
        console.log();
        
        await this.loadData();
        await this.initializeProvider();
        await this.initializeSDK();
        
        // Start portfolio update cron job
        this.startPortfolioUpdates();
        
        this.showMainMenu();
    }

    async initializeProvider() {
        try {
            cachedProvider = new ethers.providers.StaticJsonRpcProvider(CONFIG.primaryRpc, {
                chainId: CONFIG.chainId,
                name: "worldchain",
            });
            await cachedProvider.getBlockNumber();
            console.log(colors.success('✓ Connected to WorldChain RPC'));
        } catch (error) {
            console.log(colors.warning('⚠ Primary RPC failed, using fallback...'));
            cachedProvider = new ethers.providers.StaticJsonRpcProvider(CONFIG.fallbackRpc, {
                chainId: CONFIG.chainId,
                name: "worldchain",
            });
            console.log(colors.success('✓ Connected to fallback RPC'));
        }
    }

    async initializeSDK() {
        try {
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

            setPartnerCode("INTERACTIVE_TRADING_BOT_2025");

            const client = new Client(cachedProvider);
            config.client = client;
            config.multicall3 = new Multicall3(cachedProvider);

            const swapHelper = new SwapHelper(client, {
                tokenStorage: inmemoryTokenStorage,
            });

            const tokenProvider = new TokenProvider({ client, multicall3: config.multicall3 });
            const zeroX = new ZeroX(tokenProvider, inmemoryTokenStorage);
            const worldswap = new HoldSo(tokenProvider, inmemoryTokenStorage);
            
            swapHelper.load(zeroX);
            swapHelper.load(worldswap);

            cachedSDK = { swapHelper, client, tokenProvider };
            console.log(colors.success('✓ SDK initialized successfully'));
        } catch (error) {
            console.log(colors.error('✗ Failed to initialize SDK:', error.message));
        }
    }

    async loadData() {
        try {
            if (await fs.pathExists(CONFIG.dataFile)) {
                const data = await fs.readJson(CONFIG.dataFile);
                wallets = data.wallets || [];
                tradingPairs = data.tradingPairs || [];
                portfolio = data.portfolio || {};
                console.log(colors.success('✓ Data loaded successfully'));
            }
        } catch (error) {
            console.log(colors.warning('⚠ No existing data found, starting fresh'));
        }
    }

    async saveData() {
        try {
            await fs.writeJson(CONFIG.dataFile, {
                wallets,
                tradingPairs,
                portfolio
            }, { spaces: 2 });
        } catch (error) {
            console.log(colors.error('✗ Failed to save data:', error.message));
        }
    }

    startPortfolioUpdates() {
        // Update portfolio every 5 minutes
        cron.schedule('*/5 * * * *', () => {
            this.updateAllPortfolios();
        });
    }

    async showMainMenu() {
        const choices = [
            { name: '💰 Wallet Management', value: 'wallet' },
            { name: '🔄 Trading Pairs', value: 'pairs' },
            { name: '📊 Portfolio Overview', value: 'portfolio' },
            { name: '🚀 Execute Trade', value: 'trade' },
            { name: '⚡ Quick Swap (WLD)', value: 'quickswap' },
            { name: '🔍 Token Discovery', value: 'discovery' },
            { name: '⚙️  Settings', value: 'settings' },
            { name: '❌ Exit', value: 'exit' }
        ];

        const { action } = await inquirer.prompt([
            {
                type: 'list',
                name: 'action',
                message: 'What would you like to do?',
                choices
            }
        ]);

        await this.handleMainMenuAction(action);
    }

    async handleMainMenuAction(action) {
        switch (action) {
            case 'wallet':
                await this.showWalletMenu();
                break;
            case 'pairs':
                await this.showTradingPairsMenu();
                break;
            case 'portfolio':
                await this.showPortfolioMenu();
                break;
            case 'trade':
                await this.showTradingMenu();
                break;
            case 'quickswap':
                await this.quickSwap();
                break;
            case 'discovery':
                await this.tokenDiscovery();
                break;
            case 'settings':
                await this.showSettingsMenu();
                break;
            case 'exit':
                console.log(colors.info('👋 Goodbye!'));
                process.exit(0);
        }
    }

    async showWalletMenu() {
        const choices = [
            { name: '➕ Add New Wallet', value: 'add' },
            { name: '🗑️  Remove Wallet', value: 'remove' },
            { name: '👁️  View Wallets', value: 'view' },
            { name: '🔍 Scan Wallet for Tokens', value: 'scan' },
            { name: '⬅️  Back to Main Menu', value: 'back' }
        ];

        const { action } = await inquirer.prompt([
            {
                type: 'list',
                name: 'action',
                message: 'Wallet Management:',
                choices
            }
        ]);

        switch (action) {
            case 'add':
                await this.addWallet();
                break;
            case 'remove':
                await this.removeWallet();
                break;
            case 'view':
                await this.viewWallets();
                break;
            case 'scan':
                await this.scanWalletForTokens();
                break;
            case 'back':
                await this.showMainMenu();
                break;
        }
    }

    async addWallet() {
        const { privateKey } = await inquirer.prompt([
            {
                type: 'password',
                name: 'privateKey',
                message: 'Enter wallet private key:',
                mask: '*'
            }
        ]);

        try {
            const wallet = new ethers.Wallet(privateKey, cachedProvider);
            const address = wallet.address;
            
            // Check if wallet already exists
            if (wallets.find(w => w.address === address)) {
                console.log(colors.warning('⚠ Wallet already exists'));
                await this.showWalletMenu();
                return;
            }

            // Get initial balance
            const balance = await cachedProvider.getBalance(address);
            
            wallets.push({
                address,
                privateKey,
                name: `Wallet ${wallets.length + 1}`,
                addedAt: new Date().toISOString()
            });

            portfolio[address] = {
                eth: ethers.utils.formatEther(balance),
                tokens: {},
                lastUpdated: new Date().toISOString()
            };

            await this.saveData();
            console.log(colors.success(`✓ Wallet added: ${address}`));
            console.log(colors.info(`Balance: ${ethers.utils.formatEther(balance)} ETH`));

            // Auto-scan for tokens
            await this.scanWalletForTokens(address);
            
        } catch (error) {
            console.log(colors.error('✗ Failed to add wallet:', error.message));
        }

        await this.showWalletMenu();
    }

    async removeWallet() {
        if (wallets.length === 0) {
            console.log(colors.warning('⚠ No wallets to remove'));
            await this.showWalletMenu();
            return;
        }

        const choices = wallets.map(w => ({
            name: `${w.name} (${w.address})`,
            value: w.address
        }));

        const { address } = await inquirer.prompt([
            {
                type: 'list',
                name: 'address',
                message: 'Select wallet to remove:',
                choices
            }
        ]);

        const wallet = wallets.find(w => w.address === address);
        if (wallet) {
            wallets = wallets.filter(w => w.address !== address);
            delete portfolio[address];
            await this.saveData();
            console.log(colors.success(`✓ Wallet removed: ${wallet.name}`));
        }

        await this.showWalletMenu();
    }

    async viewWallets() {
        if (wallets.length === 0) {
            console.log(colors.warning('⚠ No wallets found'));
            await this.showWalletMenu();
            return;
        }

        const table = new Table({
            head: ['Name', 'Address', 'ETH Balance', 'Tokens', 'Added'],
            colWidths: [15, 42, 15, 10, 20]
        });

        for (const wallet of wallets) {
            const portfolioData = portfolio[wallet.address] || {};
            const tokenCount = Object.keys(portfolioData.tokens || {}).length;
            table.push([
                wallet.name,
                wallet.address,
                portfolioData.eth || '0',
                tokenCount.toString(),
                new Date(wallet.addedAt).toLocaleDateString()
            ]);
        }

        console.log(table.toString());
        await this.showWalletMenu();
    }

    async scanWalletForTokens(walletAddress = null) {
        if (!walletAddress) {
            if (wallets.length === 0) {
                console.log(colors.warning('⚠ No wallets to scan'));
                await this.showWalletMenu();
                return;
            }

            const choices = wallets.map(w => ({
                name: `${w.name} (${w.address})`,
                value: w.address
            }));

            const { address } = await inquirer.prompt([
                {
                    type: 'list',
                    name: 'address',
                    message: 'Select wallet to scan:',
                    choices
                }
            ]);
            walletAddress = address;
        }

        const spinner = ora('Scanning wallet for tokens...').start();
        
        try {
            const wallet = wallets.find(w => w.address === walletAddress);
            if (!wallet) {
                spinner.fail('Wallet not found');
                return;
            }

            // Get ETH balance
            const ethBalance = await cachedProvider.getBalance(walletAddress);
            portfolio[walletAddress].eth = ethers.utils.formatEther(ethBalance);

            // Scan for common tokens (you can expand this list)
            const commonTokens = [
                { symbol: 'WLD', address: CONFIG.wldAddress, name: 'Worldcoin' },
                { symbol: 'ORO', address: '0xcd1E32B86953D79a6AC58e813D2EA7a1790cAb63', name: 'ORO' },
                { symbol: 'YIELD', address: '0x1234567890123456789012345678901234567890', name: 'YIELD' }
            ];

            for (const token of commonTokens) {
                try {
                    const contract = new ethers.Contract(
                        token.address,
                        ['function balanceOf(address) view returns (uint256)', 'function decimals() view returns (uint8)'],
                        cachedProvider
                    );

                    const [balance, decimals] = await Promise.all([
                        contract.balanceOf(walletAddress),
                        contract.decimals()
                    ]);

                    if (balance.gt(0)) {
                        portfolio[walletAddress].tokens[token.symbol] = {
                            address: token.address,
                            name: token.name,
                            balance: ethers.utils.formatUnits(balance, decimals),
                            decimals: decimals
                        };

                        // Auto-add to trading pairs if not exists
                        if (!tradingPairs.find(p => p.base === 'WLD' && p.quote === token.symbol)) {
                            tradingPairs.push({
                                base: 'WLD',
                                quote: token.symbol,
                                baseAddress: CONFIG.wldAddress,
                                quoteAddress: token.address,
                                active: true
                            });
                        }
                    }
                } catch (error) {
                    // Token contract might not exist or be invalid
                    continue;
                }
            }

            portfolio[walletAddress].lastUpdated = new Date().toISOString();
            await this.saveData();

            spinner.succeed(`Found ${Object.keys(portfolio[walletAddress].tokens).length} tokens`);
            
            // Show discovered tokens
            if (Object.keys(portfolio[walletAddress].tokens).length > 0) {
                console.log(colors.info('Discovered tokens:'));
                for (const [symbol, token] of Object.entries(portfolio[walletAddress].tokens)) {
                    console.log(`  ${symbol}: ${token.balance} ${token.name}`);
                }
            }

        } catch (error) {
            spinner.fail(`Failed to scan wallet: ${error.message}`);
        }

        if (!walletAddress) {
            await this.showWalletMenu();
        }
    }

    async showTradingPairsMenu() {
        const choices = [
            { name: '➕ Add Trading Pair', value: 'add' },
            { name: '🗑️  Remove Trading Pair', value: 'remove' },
            { name: '👁️  View Trading Pairs', value: 'view' },
            { name: '🔄 Toggle Pair Status', value: 'toggle' },
            { name: '⬅️  Back to Main Menu', value: 'back' }
        ];

        const { action } = await inquirer.prompt([
            {
                type: 'list',
                name: 'action',
                message: 'Trading Pairs Management:',
                choices
            }
        ]);

        switch (action) {
            case 'add':
                await this.addTradingPair();
                break;
            case 'remove':
                await this.removeTradingPair();
                break;
            case 'view':
                await this.viewTradingPairs();
                break;
            case 'toggle':
                await this.toggleTradingPair();
                break;
            case 'back':
                await this.showMainMenu();
                break;
        }
    }

    async addTradingPair() {
        const { contractAddress } = await inquirer.prompt([
            {
                type: 'input',
                name: 'contractAddress',
                message: 'Enter token contract address:',
                validate: (input) => {
                    if (ethers.utils.isAddress(input)) return true;
                    return 'Please enter a valid contract address';
                }
            }
        ]);

        try {
            // Get token info
            const contract = new ethers.Contract(
                contractAddress,
                ['function name() view returns (string)', 'function symbol() view returns (string)', 'function decimals() view returns (uint8)'],
                cachedProvider
            );

            const [name, symbol, decimals] = await Promise.all([
                contract.name(),
                contract.symbol(),
                contract.decimals()
            ]);

            // Check if pair already exists
            if (tradingPairs.find(p => p.quoteAddress.toLowerCase() === contractAddress.toLowerCase())) {
                console.log(colors.warning('⚠ Trading pair already exists'));
                await this.showTradingPairsMenu();
                return;
            }

            tradingPairs.push({
                base: 'WLD',
                quote: symbol,
                baseAddress: CONFIG.wldAddress,
                quoteAddress: contractAddress,
                active: true,
                tokenName: name,
                decimals: decimals
            });

            await this.saveData();
            console.log(colors.success(`✓ Trading pair added: WLD-${symbol}`));
            console.log(colors.info(`Token: ${name} (${symbol})`));

        } catch (error) {
            console.log(colors.error('✗ Failed to add trading pair:', error.message));
        }

        await this.showTradingPairsMenu();
    }

    async removeTradingPair() {
        if (tradingPairs.length === 0) {
            console.log(colors.warning('⚠ No trading pairs to remove'));
            await this.showTradingPairsMenu();
            return;
        }

        const choices = tradingPairs.map(p => ({
            name: `${p.base}-${p.quote} (${p.tokenName || 'Unknown'})`,
            value: `${p.base}-${p.quote}`
        }));

        const { pair } = await inquirer.prompt([
            {
                type: 'list',
                name: 'pair',
                message: 'Select trading pair to remove:',
                choices
            }
        ]);

        tradingPairs = tradingPairs.filter(p => `${p.base}-${p.quote}` !== pair);
        await this.saveData();
        console.log(colors.success(`✓ Trading pair removed: ${pair}`));

        await this.showTradingPairsMenu();
    }

    async viewTradingPairs() {
        if (tradingPairs.length === 0) {
            console.log(colors.warning('⚠ No trading pairs found'));
            await this.showTradingPairsMenu();
            return;
        }

        const table = new Table({
            head: ['Pair', 'Token Name', 'Base Address', 'Quote Address', 'Status'],
            colWidths: [15, 20, 42, 42, 10]
        });

        for (const pair of tradingPairs) {
            table.push([
                `${pair.base}-${pair.quote}`,
                pair.tokenName || 'Unknown',
                pair.baseAddress,
                pair.quoteAddress,
                pair.active ? '🟢 Active' : '🔴 Inactive'
            ]);
        }

        console.log(table.toString());
        await this.showTradingPairsMenu();
    }

    async toggleTradingPair() {
        if (tradingPairs.length === 0) {
            console.log(colors.warning('⚠ No trading pairs to toggle'));
            await this.showTradingPairsMenu();
            return;
        }

        const choices = tradingPairs.map(p => ({
            name: `${p.base}-${p.quote} (${p.active ? 'Active' : 'Inactive'})`,
            value: `${p.base}-${p.quote}`
        }));

        const { pair } = await inquirer.prompt([
            {
                type: 'list',
                name: 'pair',
                message: 'Select trading pair to toggle:',
                choices
            }
        ]);

        const tradingPair = tradingPairs.find(p => `${p.base}-${p.quote}` === pair);
        if (tradingPair) {
            tradingPair.active = !tradingPair.active;
            await this.saveData();
            console.log(colors.success(`✓ Trading pair ${tradingPair.active ? 'activated' : 'deactivated'}: ${pair}`));
        }

        await this.showTradingPairsMenu();
    }

    async showPortfolioMenu() {
        const choices = [
            { name: '👁️  View All Portfolios', value: 'view' },
            { name: '🔄 Update All Portfolios', value: 'update' },
            { name: '📈 Portfolio Summary', value: 'summary' },
            { name: '⬅️  Back to Main Menu', value: 'back' }
        ];

        const { action } = await inquirer.prompt([
            {
                type: 'list',
                name: 'action',
                message: 'Portfolio Management:',
                choices
            }
        ]);

        switch (action) {
            case 'view':
                await this.viewAllPortfolios();
                break;
            case 'update':
                await this.updateAllPortfolios();
                break;
            case 'summary':
                await this.showPortfolioSummary();
                break;
            case 'back':
                await this.showMainMenu();
                break;
        }
    }

    async viewAllPortfolios() {
        if (wallets.length === 0) {
            console.log(colors.warning('⚠ No wallets found'));
            await this.showPortfolioMenu();
            return;
        }

        for (const wallet of wallets) {
            console.log(colors.title(`\n${wallet.name} (${wallet.address})`));
            console.log(colors.info('='.repeat(50)));
            
            const portfolioData = portfolio[wallet.address] || {};
            console.log(`ETH: ${portfolioData.eth || '0'} ETH`);
            
            if (Object.keys(portfolioData.tokens || {}).length > 0) {
                console.log(colors.info('Tokens:'));
                for (const [symbol, token] of Object.entries(portfolioData.tokens)) {
                    console.log(`  ${symbol}: ${token.balance} ${token.name}`);
                }
            } else {
                console.log(colors.warning('  No tokens found'));
            }
            
            if (portfolioData.lastUpdated) {
                console.log(colors.info(`Last updated: ${new Date(portfolioData.lastUpdated).toLocaleString()}`));
            }
        }

        await this.showPortfolioMenu();
    }

    async updateAllPortfolios() {
        const spinner = ora('Updating all portfolios...').start();
        
        try {
            for (const wallet of wallets) {
                await this.scanWalletForTokens(wallet.address);
            }
            
            spinner.succeed('All portfolios updated successfully');
        } catch (error) {
            spinner.fail(`Failed to update portfolios: ${error.message}`);
        }

        await this.showPortfolioMenu();
    }

    async showPortfolioSummary() {
        if (wallets.length === 0) {
            console.log(colors.warning('⚠ No wallets found'));
            await this.showPortfolioMenu();
            return;
        }

        let totalEth = 0;
        let totalTokens = 0;
        let uniqueTokens = new Set();

        for (const wallet of wallets) {
            const portfolioData = portfolio[wallet.address] || {};
            totalEth += parseFloat(portfolioData.eth || 0);
            totalTokens += Object.keys(portfolioData.tokens || {}).length;
            
            for (const symbol of Object.keys(portfolioData.tokens || {})) {
                uniqueTokens.add(symbol);
            }
        }

        console.log(colors.title('\n📊 PORTFOLIO SUMMARY'));
        console.log(colors.info('='.repeat(30)));
        console.log(`Total Wallets: ${wallets.length}`);
        console.log(`Total ETH: ${totalEth.toFixed(6)} ETH`);
        console.log(`Total Token Holdings: ${totalTokens}`);
        console.log(`Unique Tokens: ${uniqueTokens.size}`);
        console.log(`Trading Pairs: ${tradingPairs.filter(p => p.active).length}`);

        await this.showPortfolioMenu();
    }

    async showTradingMenu() {
        if (wallets.length === 0) {
            console.log(colors.warning('⚠ No wallets found. Please add a wallet first.'));
            await this.showMainMenu();
            return;
        }

        if (tradingPairs.filter(p => p.active).length === 0) {
            console.log(colors.warning('⚠ No active trading pairs found. Please add trading pairs first.'));
            await this.showMainMenu();
            return;
        }

        const choices = [
            { name: '🔄 Swap WLD → Token', value: 'swap_wld' },
            { name: '🔄 Swap Token → WLD', value: 'swap_token' },
            { name: '📊 Get Quote', value: 'quote' },
            { name: '⬅️  Back to Main Menu', value: 'back' }
        ];

        const { action } = await inquirer.prompt([
            {
                type: 'list',
                name: 'action',
                message: 'Trading Options:',
                choices
            }
        ]);

        switch (action) {
            case 'swap_wld':
                await this.executeSwap('WLD');
                break;
            case 'swap_token':
                await this.executeSwap('TOKEN');
                break;
            case 'quote':
                await this.getQuote();
                break;
            case 'back':
                await this.showMainMenu();
                break;
        }
    }

    async executeSwap(direction) {
        // Select wallet
        const walletChoices = wallets.map(w => ({
            name: `${w.name} (${w.address})`,
            value: w.address
        }));

        const { walletAddress } = await inquirer.prompt([
            {
                type: 'list',
                name: 'walletAddress',
                message: 'Select wallet:',
                choices: walletChoices
            }
        ]);

        // Select trading pair
        const activePairs = tradingPairs.filter(p => p.active);
        const pairChoices = activePairs.map(p => ({
            name: `${p.base}-${p.quote}`,
            value: `${p.base}-${p.quote}`
        }));

        const { pair } = await inquirer.prompt([
            {
                type: 'list',
                name: 'pair',
                message: 'Select trading pair:',
                choices: pairChoices
            }
        ]);

        const tradingPair = activePairs.find(p => `${p.base}-${p.quote}` === pair);
        if (!tradingPair) {
            console.log(colors.error('✗ Trading pair not found'));
            await this.showTradingMenu();
            return;
        }

        // Get amount
        const { amount } = await inquirer.prompt([
            {
                type: 'input',
                name: 'amount',
                message: `Enter amount to swap:`,
                validate: (input) => {
                    const num = parseFloat(input);
                    if (isNaN(num) || num <= 0) return 'Please enter a valid positive number';
                    return true;
                }
            }
        ]);

        // Get slippage
        const { slippage } = await inquirer.prompt([
            {
                type: 'input',
                name: 'slippage',
                message: 'Enter slippage tolerance (%):',
                default: CONFIG.defaultSlippage,
                validate: (input) => {
                    const num = parseFloat(input);
                    if (isNaN(num) || num < 0 || num > 100) return 'Please enter a valid percentage between 0-100';
                    return true;
                }
            }
        ]);

        try {
            const wallet = wallets.find(w => w.address === walletAddress);
            const privateKey = wallet.privateKey;
            const walletInstance = new ethers.Wallet(privateKey, cachedProvider);

            const spinner = ora('Executing swap...').start();

            // Get quote first
            const params = {
                tokenIn: direction === 'WLD' ? tradingPair.baseAddress : tradingPair.quoteAddress,
                tokenOut: direction === 'WLD' ? tradingPair.quoteAddress : tradingPair.baseAddress,
                amountIn: amount,
                slippage: slippage.toString(),
                fee: CONFIG.defaultFee,
                receiver: walletAddress
            };

            const quote = await cachedSDK.swapHelper.estimate.quote(params);
            
            if (!quote || !quote.to) {
                spinner.fail('No swap quote available');
                await this.showTradingMenu();
                return;
            }

            // Apply routing fix
            const fixedQuote = this.applyRoutingFix(quote, walletAddress);

            // Execute swap
            const swapTx = await walletInstance.sendTransaction({
                to: fixedQuote.to,
                data: fixedQuote.data,
                value: fixedQuote.value || '0',
                gasLimit: 280000
            });

            spinner.succeed(`Swap transaction sent: ${swapTx.hash}`);
            console.log(colors.info(`WorldScan: https://worldscan.org/tx/${swapTx.hash}`));

            // Wait for confirmation
            const receipt = await swapTx.wait();
            if (receipt.status === 1) {
                console.log(colors.success('✓ Swap completed successfully!'));
                
                // Update portfolio
                await this.scanWalletForTokens(walletAddress);
            } else {
                console.log(colors.error('✗ Swap failed'));
            }

        } catch (error) {
            console.log(colors.error(`✗ Swap failed: ${error.message}`));
        }

        await this.showTradingMenu();
    }

    async getQuote() {
        // Similar to executeSwap but only gets quote
        const activePairs = tradingPairs.filter(p => p.active);
        const pairChoices = activePairs.map(p => ({
            name: `${p.base}-${p.quote}`,
            value: `${p.base}-${p.quote}`
        }));

        const { pair } = await inquirer.prompt([
            {
                type: 'list',
                name: 'pair',
                message: 'Select trading pair for quote:',
                choices: pairChoices
            }
        ]);

        const { amount } = await inquirer.prompt([
            {
                type: 'input',
                name: 'amount',
                message: 'Enter amount:',
                validate: (input) => {
                    const num = parseFloat(input);
                    if (isNaN(num) || num <= 0) return 'Please enter a valid positive number';
                    return true;
                }
            }
        ]);

        try {
            const tradingPair = activePairs.find(p => `${p.base}-${p.quote}` === pair);
            const params = {
                tokenIn: tradingPair.baseAddress,
                tokenOut: tradingPair.quoteAddress,
                amountIn: amount,
                slippage: CONFIG.defaultSlippage,
                fee: CONFIG.defaultFee,
                receiver: '0x0000000000000000000000000000000000000000'
            };

            const quote = await cachedSDK.swapHelper.estimate.quote(params);
            
            if (quote && quote.addons) {
                console.log(colors.title('\n📊 SWAP QUOTE'));
                console.log(colors.info('='.repeat(30)));
                console.log(`Input: ${amount} ${tradingPair.base}`);
                console.log(`Expected Output: ${quote.addons.outAmount || 'Unknown'} ${tradingPair.quote}`);
                console.log(`Slippage: ${CONFIG.defaultSlippage}%`);
                console.log(`Fee: ${CONFIG.defaultFee}%`);
            } else {
                console.log(colors.warning('⚠ No quote available'));
            }

        } catch (error) {
            console.log(colors.error(`✗ Failed to get quote: ${error.message}`));
        }

        await this.showTradingMenu();
    }

    async quickSwap() {
        if (wallets.length === 0) {
            console.log(colors.warning('⚠ No wallets found. Please add a wallet first.'));
            await this.showMainMenu();
            return;
        }

        const { walletAddress } = await inquirer.prompt([
            {
                type: 'list',
                name: 'walletAddress',
                message: 'Select wallet for quick swap:',
                choices: wallets.map(w => ({
                    name: `${w.name} (${w.address})`,
                    value: w.address
                }))
            }
        ]);

        const { amount } = await inquirer.prompt([
            {
                type: 'input',
                name: 'amount',
                message: 'Enter WLD amount to swap:',
                validate: (input) => {
                    const num = parseFloat(input);
                    if (isNaN(num) || num <= 0) return 'Please enter a valid positive number';
                    return true;
                }
            }
        ]);

        try {
            const wallet = wallets.find(w => w.address === walletAddress);
            const walletInstance = new ethers.Wallet(wallet.privateKey, cachedProvider);

            const spinner = ora('Executing quick swap...').start();

            // Quick swap WLD to ORO (default)
            const params = {
                tokenIn: CONFIG.wldAddress,
                tokenOut: '0xcd1E32B86953D79a6AC58e813D2EA7a1790cAb63', // ORO
                amountIn: amount,
                slippage: CONFIG.defaultSlippage,
                fee: CONFIG.defaultFee,
                receiver: walletAddress
            };

            const quote = await cachedSDK.swapHelper.estimate.quote(params);
            
            if (!quote || !quote.to) {
                spinner.fail('No swap quote available');
                await this.showMainMenu();
                return;
            }

            // Apply routing fix
            const fixedQuote = this.applyRoutingFix(quote, walletAddress);

            // Execute swap
            const swapTx = await walletInstance.sendTransaction({
                to: fixedQuote.to,
                data: fixedQuote.data,
                value: fixedQuote.value || '0',
                gasLimit: 280000
            });

            spinner.succeed(`Quick swap completed: ${swapTx.hash}`);
            console.log(colors.info(`WorldScan: https://worldscan.org/tx/${swapTx.hash}`));

            // Update portfolio
            await this.scanWalletForTokens(walletAddress);

        } catch (error) {
            console.log(colors.error(`✗ Quick swap failed: ${error.message}`));
        }

        await this.showMainMenu();
    }

    async tokenDiscovery() {
        const choices = [
            { name: '🔍 Scan All Wallets', value: 'scan_all' },
            { name: '🔍 Scan Specific Wallet', value: 'scan_specific' },
            { name: '📋 View Discovered Tokens', value: 'view_tokens' },
            { name: '⬅️  Back to Main Menu', value: 'back' }
        ];

        const { action } = await inquirer.prompt([
            {
                type: 'list',
                name: 'action',
                message: 'Token Discovery:',
                choices
            }
        ]);

        switch (action) {
            case 'scan_all':
                await this.scanAllWalletsForTokens();
                break;
            case 'scan_specific':
                await this.scanSpecificWalletForTokens();
                break;
            case 'view_tokens':
                await this.viewDiscoveredTokens();
                break;
            case 'back':
                await this.showMainMenu();
                break;
        }
    }

    async scanAllWalletsForTokens() {
        if (wallets.length === 0) {
            console.log(colors.warning('⚠ No wallets to scan'));
            await this.tokenDiscovery();
            return;
        }

        const spinner = ora('Scanning all wallets for tokens...').start();
        
        try {
            for (const wallet of wallets) {
                await this.scanWalletForTokens(wallet.address);
            }
            
            spinner.succeed('All wallets scanned successfully');
        } catch (error) {
            spinner.fail(`Failed to scan wallets: ${error.message}`);
        }

        await this.tokenDiscovery();
    }

    async scanSpecificWalletForTokens() {
        if (wallets.length === 0) {
            console.log(colors.warning('⚠ No wallets to scan'));
            await this.tokenDiscovery();
            return;
        }

        const { walletAddress } = await inquirer.prompt([
            {
                type: 'list',
                name: 'walletAddress',
                message: 'Select wallet to scan:',
                choices: wallets.map(w => ({
                    name: `${w.name} (${w.address})`,
                    value: w.address
                }))
            }
        ]);

        await this.scanWalletForTokens(walletAddress);
        await this.tokenDiscovery();
    }

    async viewDiscoveredTokens() {
        const allTokens = new Set();
        
        for (const wallet of wallets) {
            const portfolioData = portfolio[wallet.address] || {};
            for (const symbol of Object.keys(portfolioData.tokens || {})) {
                allTokens.add(symbol);
            }
        }

        if (allTokens.size === 0) {
            console.log(colors.warning('⚠ No tokens discovered yet'));
            await this.tokenDiscovery();
            return;
        }

        console.log(colors.title('\n🔍 DISCOVERED TOKENS'));
        console.log(colors.info('='.repeat(30)));
        
        for (const symbol of allTokens) {
            console.log(`• ${symbol}`);
        }

        console.log(colors.info(`\nTotal unique tokens: ${allTokens.size}`));
        await this.tokenDiscovery();
    }

    async showSettingsMenu() {
        const choices = [
            { name: '🔧 RPC Configuration', value: 'rpc' },
            { name: '⚡ Trading Settings', value: 'trading' },
            { name: '🔄 Auto-Update Settings', value: 'auto_update' },
            { name: '⬅️  Back to Main Menu', value: 'back' }
        ];

        const { action } = await inquirer.prompt([
            {
                type: 'list',
                name: 'action',
                message: 'Settings:',
                choices
            }
        ]);

        switch (action) {
            case 'rpc':
                await this.showRpcSettings();
                break;
            case 'trading':
                await this.showTradingSettings();
                break;
            case 'auto_update':
                await this.showAutoUpdateSettings();
                break;
            case 'back':
                await this.showMainMenu();
                break;
        }
    }

    async showRpcSettings() {
        console.log(colors.title('\n🔧 RPC Configuration'));
        console.log(colors.info('='.repeat(30)));
        console.log(`Primary RPC: ${CONFIG.primaryRpc}`);
        console.log(`Fallback RPC: ${CONFIG.fallbackRpc}`);
        console.log(`Chain ID: ${CONFIG.chainId}`);

        const { action } = await inquirer.prompt([
            {
                type: 'list',
                name: 'action',
                message: 'What would you like to do?',
                choices: [
                    { name: '⬅️  Back to Settings', value: 'back' }
                ]
            }
        ]);

        if (action === 'back') {
            await this.showSettingsMenu();
        }
    }

    async showTradingSettings() {
        console.log(colors.title('\n⚡ Trading Settings'));
        console.log(colors.info('='.repeat(30)));
        console.log(`Default Slippage: ${CONFIG.defaultSlippage}%`);
        console.log(`Default Fee: ${CONFIG.defaultFee}%`);
        console.log(`WLD Address: ${CONFIG.wldAddress}`);

        const { action } = await inquirer.prompt([
            {
                type: 'list',
                name: 'action',
                message: 'What would you like to do?',
                choices: [
                    { name: '⬅️  Back to Settings', value: 'back' }
                ]
            }
        ]);

        if (action === 'back') {
            await this.showSettingsMenu();
        }
    }

    async showAutoUpdateSettings() {
        console.log(colors.title('\n🔄 Auto-Update Settings'));
        console.log(colors.info('='.repeat(30)));
        console.log('Portfolio updates: Every 5 minutes');
        console.log('Token discovery: Automatic on wallet scan');
        console.log('Trading pair updates: Automatic on token discovery');

        const { action } = await inquirer.prompt([
            {
                type: 'list',
                name: 'action',
                message: 'What would you like to do?',
                choices: [
                    { name: '⬅️  Back to Settings', value: 'back' }
                ]
            }
        ]);

        if (action === 'back') {
            await this.showSettingsMenu();
        }
    }

    applyRoutingFix(quote, userWallet) {
        // Apply proven routing fix from original sinclave.js
        const originalContract = quote.to;
        quote.to = CONFIG.holdstationContract;
        
        if (originalContract !== CONFIG.holdstationContract) {
            console.log(colors.info(`Contract override: ${originalContract} → ${CONFIG.holdstationContract}`));
        }

        // Apply transaction data fix for bad receivers
        if (quote.data && typeof quote.data === 'string') {
            const badReceivers = [
                "43222f934ea5c593a060a6d46772fdbdc2e2cff0",
                "0x43222f934ea5c593a060a6d46772fdbdc2e2cff0"
            ];
            const correctReceiver = userWallet.toLowerCase().replace("0x", "");
            
            for (const badReceiver of badReceivers) {
                const cleanBadReceiver = badReceiver.replace("0x", "").toLowerCase();
                if (quote.data.toLowerCase().includes(cleanBadReceiver)) {
                    quote.data = quote.data.replace(
                        new RegExp(cleanBadReceiver, 'gi'),
                        correctReceiver
                    );
                    console.log(colors.success(`Routing fixed: ${badReceiver} → ${userWallet}`));
                    break;
                }
            }
        }
        
        return quote;
    }
}

// Start the trading bot
const bot = new TradingBot();