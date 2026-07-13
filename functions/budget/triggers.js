const { onDocumentUpdated } = require("firebase-functions/v2/firestore");
const { onSchedule } = require("firebase-functions/v2/scheduler");
const { getFirestore, FieldValue } = require("firebase-admin/firestore");
const { getMessaging } = require("firebase-admin/messaging");

const db = getFirestore();


// ─────────────────────────────────────────────────────────────────────────────
// 2. SEND PUSH NOTIFICATION WHEN BUDGET ALERT THRESHOLD IS HIT
//    Triggers when a budget document is updated.  If alertSent flips
//    from false → true, look up the user's FCM token and send them
//    a notification.
// ─────────────────────────────────────────────────────────────────────────────
exports.onBudgetAlertTriggered = onDocumentUpdated(
  "budgets/{budgetId}",
  async (event) => {
    const before = event.data.before.data();
    const after = event.data.after.data();

    // Only act when alertSent flips false → true
    if (before.alertSent === true || after.alertSent !== true) return null;
    if (!after.receiveAlert) return null;

    const userId = after.userId;
    const categoryTitle = after.categoryTitle ?? "Unknown";
    const thresholdPercent = after.alertThresholdPercent ?? 40;
    const spent = after.spent ?? 0;
    const amount = after.amount ?? 0;

    // Fetch the user document to get their FCM token
    const userDoc = await db.collection("users").doc(userId).get();
    if (!userDoc.exists) return null;

    const fcmToken = userDoc.data()?.fcmToken;
    if (!fcmToken) return null;

    const percentSpent = amount > 0
      ? Math.round((spent / amount) * 100)
      : 0;

    const message = {
      token: fcmToken,
      notification: {
        title: "⚠️ Budget Alert",
        body: `You've used ${percentSpent}% of your ${categoryTitle} budget (threshold: ${thresholdPercent}%).`,
      },
      data: {
        type: "budget_alert",
        budgetId: event.params.budgetId,
        categoryTitle,
      },
      android: {
        notification: {
          channelId: "budget_alerts",
          priority: "high",
        },
      },
      apns: {
        payload: {
          aps: { sound: "default" },
        },
      },
    };

    try {
      await getMessaging().send(message);
      console.log(`Budget alert sent to user ${userId} for ${categoryTitle}`);
    } catch (err) {
      console.error("Failed to send budget alert FCM:", err);
    }

    return null;
  },
);

// ─────────────────────────────────────────────────────────────────────────────
// 3. SCHEDULED: RESET MONTHLY BUDGETS ON THE 1ST OF EVERY MONTH
//    Resets spent → 0, remaining → amount, alertSent → false for every
//    budget whose (month, year) matches the NEW current month.
//    Runs at 00:05 on the 1st of each month (server time / UTC).
// ─────────────────────────────────────────────────────────────────────────────
exports.resetMonthlyBudgets = onSchedule("5 0 1 * *", async () => {
  const now = new Date();
  const currentMonth = now.getMonth() + 1; // 1-12
  const currentYear = now.getFullYear();

  const snapshot = await db
    .collection("budgets")
    .where("month", "==", currentMonth)
    .where("year", "==", currentYear)
    .get();

  if (snapshot.empty) {
    console.log("No budgets to reset for", currentMonth, currentYear);
    return;
  }

  const batch = db.batch();

  snapshot.docs.forEach((doc) => {
    const amount = doc.data().amount ?? 0;
    batch.update(doc.ref, {
      spent: 0,
      remaining: amount,
      alertSent: false,
      updatedAt: FieldValue.serverTimestamp(),
    });
  });

  await batch.commit();
  console.log(
    `Reset ${snapshot.size} budget(s) for ${currentMonth}/${currentYear}`,
  );
});

