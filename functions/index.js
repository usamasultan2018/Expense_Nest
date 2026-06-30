const { initializeApp } = require("firebase-admin/app");

initializeApp();

exports.revenuecatWebhook =
    require("./webhooks/revenuecat").revenuecatWebhook;

exports.processRecurring = require("./scheduled/recurringTransactions").processRecurring;
