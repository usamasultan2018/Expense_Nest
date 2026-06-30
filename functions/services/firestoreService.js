const { getFirestore, FieldValue } = require("firebase-admin/firestore");

const db = getFirestore();

/**
 * Updates the user's subscription status in Firestore.
 * @param {Object} event RevenueCat event.
 * @param {string} userId Firebase user ID.
 * @param {boolean|undefined} isPremium Premium status.
 * @return {Promise<void>}
 */
async function updateSubscription(event, userId, isPremium) {
    const update = {
        subscriptionStatus: {
            eventType: event.type,
            productId: event.product_id || null,
            expiresAt: event.expiration_at_ms
                ? new Date(Number(event.expiration_at_ms)).toISOString()
                : null,
            environment: event.environment || "PRODUCTION",
            lastUpdated: FieldValue.serverTimestamp(),
        },
    };

    if (isPremium !== undefined) {
        update.isPremium = isPremium;
    }

    await db.collection("users").doc(userId).set(update, { merge: true });
}

/**
 * Saves the RevenueCat event as a receipt.
 * @param {Object} event RevenueCat event.
 * @param {string} userId Firebase user ID.
 * @return {Promise<void>}
 */
async function saveReceipt(event, userId) {
    await db.collection("receipts").add({
        userId,
        eventId: event.id || null,
        eventType: event.type,
        productId: event.product_id || null,
        environment: event.environment || "PRODUCTION",
        purchasedAt: event.purchased_at_ms
            ? new Date(Number(event.purchased_at_ms)).toISOString()
            : null,
        expiresAt: event.expiration_at_ms
            ? new Date(Number(event.expiration_at_ms))
            : null,
        store: event.store || null,
        createdAt: FieldValue.serverTimestamp(),
    });
}

module.exports = {
    updateSubscription,
    saveReceipt,
};