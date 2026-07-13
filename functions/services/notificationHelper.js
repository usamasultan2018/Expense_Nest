const { getFirestore, FieldValue } = require("firebase-admin/firestore");
const { getMessaging } = require("firebase-admin/messaging");

const db = getFirestore();

/**
 * Notification types — mirrors NotificationType in the Flutter app.
 */
const NotificationType = {
  BUDGET_ALERT: "budget_alert",
  TRANSACTION: "transaction",
  DAILY_REMINDER: "daily_reminder",
  FCM: "fcm",
  OTHER: "other",
};

/**
 * Saves a notification document to the `notifications` Firestore collection.
 *
 * @param {string} userId    Firestore user ID.
 * @param {string} title     Notification title.
 * @param {string} body      Notification body.
 * @param {string} type      One of NotificationType values.
 * @param {string} [payload] Optional extra payload string.
 * @return {Promise<string|null>} The created document ID, or null on failure.
 */
async function saveNotificationToFirestore(userId, title, body, type, payload) {
  if (!userId) return null;

  try {
    const ref = db.collection("notifications").doc();
    await ref.set({
      id: ref.id,
      userId,
      title,
      body,
      type,
      isRead: false,
      ...(payload ? { payload } : {}),
      createdAt: FieldValue.serverTimestamp(),
    });
    return ref.id;
  } catch (err) {
    console.error("saveNotificationToFirestore error:", err);
    return null;
  }
}

/**
 * Sends an FCM push notification to a device token AND saves the notification
 * to Firestore — all in one call.
 *
 * @param {object} options
 * @param {string}  options.userId       Firestore user ID (for Firestore record).
 * @param {string}  options.fcmToken     Device FCM token.
 * @param {string}  options.title        Notification title.
 * @param {string}  options.body         Notification body.
 * @param {string}  options.type         NotificationType value.
 * @param {object}  [options.data]       Optional FCM data payload (key/value strings).
 * @param {string}  [options.channelId]  Android channel ID (default: "fcm_general").
 * @return {Promise<void>}
 */
async function sendAndSaveNotification({
  userId,
  fcmToken,
  title,
  body,
  type,
  data = {},
  channelId = "fcm_general",
}) {
  // ── 1. Send FCM push ──────────────────────────────────────────────────────
  if (fcmToken) {
    try {
      await getMessaging().send({
        token: fcmToken,
        notification: { title, body },
        data: { type, ...data },
        android: {
          notification: {
            channelId,
            priority: "high",
            sound: "default",
          },
        },
        apns: {
          payload: {
            aps: { sound: "default" },
          },
        },
      });
      console.log(`FCM sent [${type}] to user ${userId}`);
    } catch (err) {
      // Token might be stale — log but don't block Firestore save
      console.error(`FCM send error [${type}] for user ${userId}:`, err.message);
    }
  } else {
    console.warn(`No FCM token for user ${userId} — skipping push.`);
  }

  // ── 2. Persist to Firestore ───────────────────────────────────────────────
  const payloadStr = Object.keys(data).length ? JSON.stringify(data) : undefined;
  await saveNotificationToFirestore(userId, title, body, type, payloadStr);
}

module.exports = {
  NotificationType,
  saveNotificationToFirestore,
  sendAndSaveNotification,
};
