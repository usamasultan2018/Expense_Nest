const { getFirestore, Timestamp } = require("firebase-admin/firestore");
const { sendRecurringNotification } = require("./notificationService");

const db = getFirestore();

/**
 * Processes all due recurring transactions.
 * @return {Promise<void>}
 */
async function processRecurringTransactions() {
    const now = new Date();

    const snapshot = await db.collection("transactions")
        .where("recurringInterval", "!=", null)
        .where("nextDueDate", "<=", Timestamp.fromDate(now))
        .get();

    const batch = db.batch();
    const notifications = [];

    for (const doc of snapshot.docs) {
        const data = doc.data();

        // Create new transaction
        const newTransaction = {
            ...data,
            id: undefined,
            createdAt: Date.now(),
            dateTime: Timestamp.fromDate(now),
            lastRecurredAt: Timestamp.fromDate(now),
        };

        const newDoc = db.collection("transactions").doc();
        newTransaction.id = newDoc.id;

        batch.set(newDoc, newTransaction);

        // Save notification info for later
        notifications.push({
            userId: data.userId,
            category: data.category.title,
            amount: data.amount,
            type: data.type,
        });

        // Calculate next due date
        const next = new Date(data.nextDueDate.toDate());

        switch (data.recurringInterval) {
            case "daily":
                next.setDate(next.getDate() + 1);
                break;
            case "weekly":
                next.setDate(next.getDate() + 7);
                break;
            case "monthly":
                next.setMonth(next.getMonth() + 1);
                break;
            case "yearly":
                next.setFullYear(next.getFullYear() + 1);
                break;
        }

        batch.update(doc.ref, {
            lastRecurredAt: Timestamp.fromDate(now),
            nextDueDate: Timestamp.fromDate(next),
        });
    }

    // First save everything
    await batch.commit();

    // Then send notifications
    for (const item of notifications) {
        const userDoc = await db.collection("users").doc(item.userId).get();

        if (!userDoc.exists) continue;

        const user = userDoc.data();

        await sendRecurringNotification(
            user.fcmToken,
            item.category,
            item.amount,
            item.type,
        );
    }

    console.log(`Processed ${snapshot.size} recurring transactions.`);
}

module.exports = {
    processRecurringTransactions,
};