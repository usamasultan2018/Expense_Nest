const { onRequest } = require("firebase-functions/v2/https");

const {
    updateSubscription,
    saveReceipt,
} = require("../services/firestoreService");

exports.revenuecatWebhook = onRequest(async (req, res) => {
    if (req.method !== "POST") {
        return res.status(405).json({ error: "Method Not Allowed" });
    }

    const event = req.body && req.body.event;

    if (!event) {
        return res.status(400).json({ error: "Missing event" });
    }

    const userId = event.app_user_id;

    if (!userId) {
        return res.status(400).json({ error: "Missing user id" });
    }

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
        await updateSubscription(event, userId, isPremium);
        await saveReceipt(event, userId);

        console.log("Event:", event.type);
        console.log("User:", userId);

        return res.status(200).json({ status: "ok" });
    } catch (error) {
        console.error(error);
        return res.status(500).json({ error: "Internal Server Error" });
    }
});