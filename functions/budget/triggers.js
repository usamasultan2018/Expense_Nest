const { onDocumentUpdated } = require("firebase-functions/v2/firestore");
const { onSchedule } = require("firebase-functions/v2/scheduler");
const { getFirestore, FieldValue } = require("firebase-admin/firestore");
const { sendAndSaveNotification, NotificationType } = require("../services/notificationHelper");

const db = getFirestore();

// ─────────────────────────────────────────────────────────────────────────────
// SEND FCM + SAVE TO FIRESTORE WHEN BUDGET ALERT THRESHOLD IS HIT
// Triggers when a budget document is updated.
// If alertSent flips false → true, look up the user's FCM token, send them
// a push notification, AND write the notification to Firestore.
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

    const percentSpent = amount > 0
      ? Math.round((spent / amount) * 100)
      : 0;

    const title = "⚠️ Budget Alert";
    const body = `You've used ${percentSpent}% of your ${categoryTitle} budget ` +
      `(threshold: ${thresholdPercent}%). Consider reducing expenses.`;

    // Fetch the user's FCM token
    const userDoc = await db.collection("users").doc(userId).get();
    const fcmToken = userDoc.exists ? userDoc.data()?.fcmToken : null;

    // Send FCM push + persist to Firestore
    await sendAndSaveNotification({
      userId,
      fcmToken,
      title,
      body,
      type: NotificationType.BUDGET_ALERT,
      channelId: "budget_alerts",
      data: {
        budgetId: event.params.budgetId,
        categoryTitle,
        percentSpent: String(percentSpent),
        thresholdPercent: String(thresholdPercent),
      },
    });

    console.log(`Budget alert sent + saved for user ${userId} (${categoryTitle})`);
    return null;
  },
);

// ─────────────────────────────────────────────────────────────────────────────
// SCHEDULED: RESET MONTHLY BUDGETS ON THE 1ST OF EVERY MONTH
// Resets spent → 0, remaining → amount, alertSent → false for every
// budget whose (month, year) matches the NEW current month.
// Runs at 00:05 on the 1st of each month (UTC).
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
