const { initializeApp } = require("firebase-admin/app");

initializeApp();

exports.revenuecatWebhook =
    require("./webhooks/revenuecat").revenuecatWebhook;

exports.processRecurring = require("./scheduled/recurringTransactions").processRecurring;

// ── Budget Functions ──────────────────────────────────────────────────────────
const budget = require("./budget/triggers");

/** Send FCM push notification when a budget alert threshold is crossed */
exports.onBudgetAlertTriggered = budget.onBudgetAlertTriggered;

/** Reset spent/remaining/alertSent at the start of each month */
exports.resetMonthlyBudgets = budget.resetMonthlyBudgets;
