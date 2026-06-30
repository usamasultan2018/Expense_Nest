const { getMessaging } = require("firebase-admin/messaging");

/**
 * Sends a recurring transaction notification.
 * @param {string} token User FCM token.
 * @param {string} category Transaction category.
 * @param {number} amount Transaction amount.
 * @param {string} type Transaction type.
 * @return {Promise<void>}
 */
async function sendRecurringNotification(token, category, amount, type) {
    if (!token) return;

    const isExpense = type.toLowerCase() === "expense";

    await getMessaging().send({
        token,
        notification: {
            title: isExpense ? "💸 Recurring Expense" : "💰 Recurring Income",
            body: `${category} of PKR ${amount} has been added.`,
        },
    });
}

module.exports = {
    sendRecurringNotification,
};