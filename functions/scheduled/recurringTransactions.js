const { onSchedule } = require("firebase-functions/v2/scheduler");
const { processRecurringTransactions } = require("../services/recurringService");

exports.processRecurring = onSchedule("every day 00:05", async () => {
    await processRecurringTransactions();
});