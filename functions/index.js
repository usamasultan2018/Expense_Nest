const { initializeApp } = require("firebase-admin/app");

initializeApp();

exports.revenuecatWebhook =
    require("./webhooks/revenuecat").revenuecatWebhook;

exports.processRecurring = require("./scheduled/recurringTransactions").processRecurring;

// ── Daily Reminder ────────────────────────────────────────────────────────────
/** Send daily reminder to users who haven't logged a transaction today (9 PM UTC) */
exports.sendDailyReminder = require("./scheduled/dailyReminder").sendDailyReminder;

// ── Budget Functions ──────────────────────────────────────────────────────────
const budget = require("./budget/triggers");

/** Send FCM push + save to Firestore when a budget alert threshold is crossed */
exports.onBudgetAlertTriggered = budget.onBudgetAlertTriggered;

/** Reset spent/remaining/alertSent at the start of each month */
exports.resetMonthlyBudgets = budget.resetMonthlyBudgets;
