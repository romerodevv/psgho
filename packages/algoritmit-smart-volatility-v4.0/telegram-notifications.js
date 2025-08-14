/**
 * ALGORITMIT Telegram Notifications Module
 * Send position updates, trade alerts, and strategy notifications via Telegram
 */

const https = require('https');

class TelegramNotifications {
    constructor(config) {
        this.config = config;
        this.botToken = process.env.TELEGRAM_BOT_TOKEN;
        this.chatId = process.env.TELEGRAM_CHAT_ID;
        this.enabled = false;
        this.lastNotificationTime = new Map();
        this.notificationSettings = {
            positionUpdates: true,
            tradeExecutions: true,
            profitAlerts: true,
            lossAlerts: true,
            strategyUpdates: true,
            priceAlerts: true,
            minimumInterval: 300000, // 5 minutes between similar notifications
            profitThreshold: 5, // Notify on 5%+ profit changes
            lossThreshold: -10 // Notify on 10%+ losses
        };
        
        this.initialize();
    }

    async initialize() {
        if (this.botToken && this.chatId) {
            try {
                await this.testConnection();
                this.enabled = true;
                console.log('✅ Telegram notifications initialized successfully');
            } catch (error) {
                console.log('⚠️  Telegram notifications disabled:', error.message);
                this.enabled = false;
            }
        } else {
            console.log('ℹ️  Telegram notifications not configured (missing bot token or chat ID)');
        }
    }

    async testConnection() {
        const message = '🤖 ALGORITMIT Telegram Notifications Connected!\n\n' +
                       '✅ Bot is ready to send trading updates\n' +
                       '📊 Position status notifications enabled\n' +
                       '💹 Trade execution alerts enabled\n\n' +
                       `🕐 Connected at: ${new Date().toLocaleString()}`;
        
        return await this.sendMessage(message);
    }

    async sendMessage(text, options = {}) {
        if (!this.enabled || !this.botToken || !this.chatId) {
            return { success: false, error: 'Telegram not configured' };
        }

        const data = JSON.stringify({
            chat_id: this.chatId,
            text: text,
            parse_mode: 'HTML',
            disable_web_page_preview: true,
            ...options
        });

        return new Promise((resolve) => {
            const req = https.request({
                hostname: 'api.telegram.org',
                port: 443,
                path: `/bot${this.botToken}/sendMessage`,
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Content-Length': data.length
                }
            }, (res) => {
                let responseData = '';
                res.on('data', (chunk) => {
                    responseData += chunk;
                });
                res.on('end', () => {
                    try {
                        const result = JSON.parse(responseData);
                        if (result.ok) {
                            resolve({ success: true, result });
                        } else {
                            resolve({ success: false, error: result.description });
                        }
                    } catch (error) {
                        resolve({ success: false, error: error.message });
                    }
                });
            });

            req.on('error', (error) => {
                resolve({ success: false, error: error.message });
            });

            req.write(data);
            req.end();
        });
    }

    shouldNotify(type, key = '') {
        const now = Date.now();
        const lastTime = this.lastNotificationTime.get(`${type}-${key}`) || 0;
        
        if (now - lastTime < this.notificationSettings.minimumInterval) {
            return false;
        }
        
        this.lastNotificationTime.set(`${type}-${key}`, now);
        return true;
    }

    async notifyTradeExecution(trade) {
        if (!this.notificationSettings.tradeExecutions || !this.shouldNotify('trade', trade.tokenSymbol)) {
            return;
        }

        const emoji = trade.type === 'buy' ? '🟢' : '🔴';
        const action = trade.type === 'buy' ? 'BOUGHT' : 'SOLD';
        
        let message = `${emoji} <b>TRADE EXECUTED</b>\n\n`;
        message += `💹 <b>${action} ${trade.tokenSymbol}</b>\n`;
        message += `💰 Amount: ${trade.amount} ${trade.type === 'buy' ? 'WLD' : trade.tokenSymbol}\n`;
        message += `💱 Received: ${trade.outputAmount} ${trade.type === 'buy' ? trade.tokenSymbol : 'WLD'}\n`;
        message += `💸 Price: ${trade.price} WLD per token\n`;
        
        if (trade.gasUsed) {
            message += `⛽ Gas Used: ${trade.gasUsed}\n`;
        }
        
        if (trade.executionTime) {
            message += `⏱️ Execution Time: ${trade.executionTime}ms\n`;
        }
        
        message += `\n🕐 ${new Date().toLocaleString()}`;

        await this.sendMessage(message);
    }

    async notifyPositionUpdate(position) {
        if (!this.notificationSettings.positionUpdates) {
            return;
        }

        const profitPercent = ((position.currentPrice - position.entryPrice) / position.entryPrice) * 100;
        
        // Only notify on significant profit/loss changes
        if (Math.abs(profitPercent) < this.notificationSettings.profitThreshold && 
            profitPercent > this.notificationSettings.lossThreshold) {
            return;
        }

        if (!this.shouldNotify('position', position.tokenSymbol)) {
            return;
        }

        const emoji = profitPercent >= 0 ? '📈' : '📉';
        const profitEmoji = profitPercent >= 0 ? '🟢' : '🔴';
        
        let message = `${emoji} <b>POSITION UPDATE</b>\n\n`;
        message += `🪙 <b>${position.tokenSymbol}</b>\n`;
        message += `📊 Entry Price: ${position.entryPrice?.toFixed(8)} WLD\n`;
        message += `📊 Current Price: ${position.currentPrice?.toFixed(8)} WLD\n`;
        message += `💰 Amount: ${position.amount?.toFixed(6)} tokens\n`;
        message += `${profitEmoji} P&L: ${profitPercent >= 0 ? '+' : ''}${profitPercent.toFixed(2)}%\n`;
        
        if (position.unrealizedPnL) {
            message += `💹 Unrealized: ${position.unrealizedPnL >= 0 ? '+' : ''}${position.unrealizedPnL.toFixed(6)} WLD\n`;
        }
        
        if (position.strategy) {
            message += `🎯 Strategy: ${position.strategy}\n`;
        }
        
        message += `\n🕐 ${new Date().toLocaleString()}`;

        await this.sendMessage(message);
    }

    async notifyProfitAlert(position, profitPercent) {
        if (!this.notificationSettings.profitAlerts || !this.shouldNotify('profit', position.tokenSymbol)) {
            return;
        }

        let message = `🚀 <b>PROFIT ALERT!</b>\n\n`;
        message += `🪙 <b>${position.tokenSymbol}</b>\n`;
        message += `🎉 Profit: <b>+${profitPercent.toFixed(2)}%</b>\n`;
        message += `📊 Entry: ${position.entryPrice?.toFixed(8)} WLD\n`;
        message += `📊 Current: ${position.currentPrice?.toFixed(8)} WLD\n`;
        message += `💰 Value: ${position.currentValue?.toFixed(6)} WLD\n`;
        message += `💹 Gain: +${position.unrealizedPnL?.toFixed(6)} WLD\n`;
        message += `\n🎯 Consider taking profits!\n`;
        message += `🕐 ${new Date().toLocaleString()}`;

        await this.sendMessage(message);
    }

    async notifyLossAlert(position, lossPercent) {
        if (!this.notificationSettings.lossAlerts || !this.shouldNotify('loss', position.tokenSymbol)) {
            return;
        }

        let message = `⚠️ <b>LOSS ALERT!</b>\n\n`;
        message += `🪙 <b>${position.tokenSymbol}</b>\n`;
        message += `📉 Loss: <b>${lossPercent.toFixed(2)}%</b>\n`;
        message += `📊 Entry: ${position.entryPrice?.toFixed(8)} WLD\n`;
        message += `📊 Current: ${position.currentPrice?.toFixed(8)} WLD\n`;
        message += `💰 Value: ${position.currentValue?.toFixed(6)} WLD\n`;
        message += `💸 Loss: ${position.unrealizedPnL?.toFixed(6)} WLD\n`;
        message += `\n🛡️ Consider stop loss!\n`;
        message += `🕐 ${new Date().toLocaleString()}`;

        await this.sendMessage(message);
    }

    async notifyStrategyUpdate(strategy, action, details = {}) {
        if (!this.notificationSettings.strategyUpdates || !this.shouldNotify('strategy', strategy.id)) {
            return;
        }

        const actionEmojis = {
            'started': '🟢',
            'stopped': '🔴',
            'created': '🆕',
            'updated': '🔄',
            'executed': '⚡'
        };

        const emoji = actionEmojis[action] || '🎯';
        
        let message = `${emoji} <b>STRATEGY ${action.toUpperCase()}</b>\n\n`;
        message += `🎯 <b>${strategy.name}</b>\n`;
        message += `🪙 Token: ${strategy.tokenSymbol}\n`;
        
        if (action === 'executed' && details.trade) {
            message += `💹 Action: ${details.trade.type.toUpperCase()}\n`;
            message += `💰 Amount: ${details.trade.amount}\n`;
            message += `💱 Price: ${details.trade.price} WLD\n`;
        }
        
        if (strategy.totalTrades) {
            message += `📊 Total Trades: ${strategy.totalTrades}\n`;
        }
        
        if (strategy.totalProfit) {
            message += `💹 Total Profit: ${strategy.totalProfit >= 0 ? '+' : ''}${strategy.totalProfit.toFixed(6)} WLD\n`;
        }
        
        message += `\n🕐 ${new Date().toLocaleString()}`;

        await this.sendMessage(message);
    }

    async notifyDailyReport(stats) {
        if (!this.shouldNotify('daily-report')) {
            return;
        }

        let message = `📊 <b>DAILY TRADING REPORT</b>\n\n`;
        message += `📈 Total Trades: ${stats.totalTrades}\n`;
        message += `✅ Successful: ${stats.successfulTrades}\n`;
        message += `❌ Failed: ${stats.failedTrades}\n`;
        message += `📊 Success Rate: ${stats.successRate?.toFixed(1)}%\n`;
        message += `💰 Total P&L: ${stats.totalPnL >= 0 ? '+' : ''}${stats.totalPnL?.toFixed(6)} WLD\n`;
        message += `📊 Open Positions: ${stats.openPositions}\n`;
        message += `🎯 Active Strategies: ${stats.activeStrategies}\n`;
        message += `\n📅 ${new Date().toDateString()}`;

        await this.sendMessage(message);
    }

    async notifyPriceAlert(token, currentPrice, targetPrice, alertType) {
        if (!this.notificationSettings.priceAlerts || !this.shouldNotify('price-alert', token.symbol)) {
            return;
        }

        const emoji = alertType === 'above' ? '🚀' : '📉';
        const direction = alertType === 'above' ? 'ABOVE' : 'BELOW';
        
        let message = `${emoji} <b>PRICE ALERT!</b>\n\n`;
        message += `🪙 <b>${token.symbol}</b>\n`;
        message += `📊 Current Price: ${currentPrice.toFixed(8)} WLD\n`;
        message += `🎯 Target Price: ${targetPrice.toFixed(8)} WLD\n`;
        message += `📈 Price is now ${direction} target!\n`;
        message += `\n🕐 ${new Date().toLocaleString()}`;

        await this.sendMessage(message);
    }

    // Configuration methods
    getSettings() {
        return {
            enabled: this.enabled,
            configured: !!(this.botToken && this.chatId),
            settings: this.notificationSettings
        };
    }

    updateSettings(newSettings) {
        this.notificationSettings = { ...this.notificationSettings, ...newSettings };
        return this.notificationSettings;
    }

    async enable() {
        if (!this.botToken || !this.chatId) {
            throw new Error('Telegram bot token and chat ID must be configured first');
        }
        
        await this.testConnection();
        this.enabled = true;
        return true;
    }

    disable() {
        this.enabled = false;
        return true;
    }

    // Utility method for manual messages
    async sendCustomMessage(message) {
        return await this.sendMessage(message);
    }
}

module.exports = TelegramNotifications;