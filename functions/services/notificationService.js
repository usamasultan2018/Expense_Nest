const { sendAndSaveNotification, NotificationType } = require("./notificationHelper");

/**
 * Sends a recurring transaction FCM notification AND saves it to Firestore.
 *
 * @param {string} userId   Firestore user ID.
 * @param {string} fcmToken User FCM device token.
 * @param {string} category Transaction category title.
 * @param {number} amount   Transaction amount.
 * @param {string} type     "income" or "expense".
 * @return {Promise<void>}
 */
async function sendRecurringNotification(userId, fcmToken, category, amount, type) {
  const isExpense = type.toLowerCase() === "expense";
  const title = isExpense ? "💸 Recurring Expense" : "💰 Recurring Income";
  const body = `${category} of PKR ${amount} has been added automatically.`;

  await sendAndSaveNotification({
    userId,
    fcmToken,
    title,
    body,
    type: NotificationType.TRANSACTION,
    channelId: "transactions",
    data: {
      category,
      amount: String(amount),
      transactionType: type,
    },
  });
}

module.exports = {
  sendRecurringNotification,
};