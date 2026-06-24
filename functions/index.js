const { onRequest } = require("firebase-functions/v2/https");
const { initializeApp } = require("firebase-admin/app");
const { getFirestore, FieldValue } = require("firebase-admin/firestore");

initializeApp();
const db = getFirestore();

exports.revenuecatWebhook = onRequest(async (req, res) => {
    // Step 1: only allow POST requests
    if (req.method !== "POST") {
        return res.status(405).json({ error: "Method Not Allowed" });
    }

    // Step 2: read the event from request body
    const event = req.body && req.body.event;
    if (!event) {
        return res.status(400).json({ error: "Missing event" });
    }

    // Step 3: read the user id from event
    const userId = event.app_user_id;
    if (!userId) {
        return res.status(400).json({ error: "Missing user id" });
    }

    // Step 4: determine isPremium from event type
    const activeEvents = [
        "INITIAL_PURCHASE",
        "RENEWAL",
        "UNCANCELLATION",
        "PRODUCT_CHANGE",
    ];

    const inactiveEvents = [
        "EXPIRATION",
        "REFUND",
        "CANCELLATION",
    ];

    let isPremium;
    if (activeEvents.includes(event.type)) {
        isPremium = true;
    } else if (inactiveEvents.includes(event.type)) {
        isPremium = false;
    }

    try {

        // Step 5: update user document
        const update = {
            subscriptionStatus: {
                eventType: event.type,
                productId: event.product_id || null,
                expiresAt: event.expiration_at_ms ?
                    new Date(event.expiration_at_ms).toISOString() : null,
                environment: event.environment || "PRODUCTION",
                lastUpdated: FieldValue.serverTimestamp(),
            },
        };

        if (isPremium !== undefined) {
            update.isPremium = isPremium;
        }

        await db.collection("users").doc(userId).set(update, { merge: true });

        // Step 6: save receipt in separate collection
        await db.collection("receipts").add({
            userId: userId,
            eventId: event.id || null,
            eventType: event.type,
            productId: event.product_id || null,
            environment: event.environment || "PRODUCTION",
            purchasedAt: event.purchased_at_ms ?
                new Date(event.purchased_at_ms).toISOString() : null,
            expiresAt: event.expiration_at_ms
                ? new Date(Number(event.expiration_at_ms))
                : null,
            store: event.store || null,
            createdAt: FieldValue.serverTimestamp(),
        });

        console.log("Event type: " + event.type);
        console.log("User id: " + userId);
        console.log("isPremium: " + isPremium);
        console.log("Firestore updated successfully");

        return res.status(200).json({ status: "ok" });
    } catch (error) {
        console.error("Webhook error: " + error);
        return res.status(500).json({ error: "Internal Server Error" });
    }
});