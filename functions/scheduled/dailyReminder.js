const { onSchedule } = require("firebase-functions/v2/scheduler");
const { getFirestore, Timestamp } = require("firebase-admin/firestore");
const { sendAndSaveNotification, NotificationType } = require("../services/notificationHelper");

const db = getFirestore();

/**
 * DAILY REMINDER — runs every day at 21:00 UTC (9 PM).
 *
 * For each user who has NOT logged any transaction today, sends an FCM
 * push notification AND saves it to the `notifications` Firestore collection.
 *
 * Looks up users via the `users` collection. Skips users without an FCM token.
 */
exports.sendDailyReminder = onSchedule("0 21 * * *", async () => {
  const now = new Date();

  // Start and end of today (UTC)
  const todayStart = new Date(now);
  todayStart.setUTCHours(0, 0, 0, 0);

  const todayEnd = new Date(now);
  todayEnd.setUTCHours(23, 59, 59, 999);

  // Fetch all users
  const usersSnapshot = await db.collection("users").get();

  if (usersSnapshot.empty) {
    console.log("No users found for daily reminder.");
    return;
  }

  let reminded = 0;
  let skipped = 0;

  for (const userDoc of usersSnapshot.docs) {
    const user = userDoc.data();
    const userId = userDoc.id;
    const fcmToken = user.fcmToken;
    const userName = (user.username ?? "there").split(" ")[0];

    // Skip users who registered after today (brand new accounts)
    if (user.createdAt) {
      const createdAt = user.createdAt.toDate ? user.createdAt.toDate() : new Date(user.createdAt);
      if (createdAt > todayEnd) {
        skipped++;
        continue;
      }
    }

    // Check whether this user has any transaction today
    const txSnapshot = await db
      .collection("transactions")
      .where("userId", "==", userId)
      .where("dateTime", ">=", Timestamp.fromDate(todayStart))
      .where("dateTime", "<=", Timestamp.fromDate(todayEnd))
      .limit(1)
      .get();

    if (!txSnapshot.empty) {
      // User already logged a transaction today — skip
      skipped++;
      continue;
    }

    const title = `📒 Hey ${userName}, don't forget!`;
    const body = "You haven't logged any transactions today. " +
      "Keep your finances on track — add one now!";

    // Send FCM + save to Firestore
    await sendAndSaveNotification({
      userId,
      fcmToken,
      title,
      body,
      type: NotificationType.DAILY_REMINDER,
      channelId: "daily_reminder",
      data: { date: todayStart.toISOString().split("T")[0] },
    });

    reminded++;
  }

  console.log(
    `Daily reminder: sent to ${reminded} user(s), skipped ${skipped} user(s).`,
  );
});
