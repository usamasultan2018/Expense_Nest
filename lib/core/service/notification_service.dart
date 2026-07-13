import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Top-level FCM background message handler (must be a top-level function).
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await NotificationService.instance._showFCMNotification(message);
}

class NotificationService {
  NotificationService._internal();
  static final NotificationService instance = NotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  // ─────────────────────────────────────────────────────────
  // Notification IDs
  // ─────────────────────────────────────────────────────────
  static const int _dailyReminderId = 888888;

  // ─────────────────────────────────────────────────────────
  // Android notification channels
  // ─────────────────────────────────────────────────────────
  static const AndroidNotificationChannel _budgetChannel =
      AndroidNotificationChannel(
    'budget_alerts',
    'Budget Alerts',
    description: 'Notifies you when spending approaches your budget limit.',
    importance: Importance.high,
    playSound: true,
  );

  static const AndroidNotificationChannel _transactionChannel =
      AndroidNotificationChannel(
    'transactions',
    'Transactions',
    description: 'Notifies you when a transaction is added or updated.',
    importance: Importance.defaultImportance,
  );

  static const AndroidNotificationChannel _fcmChannel =
      AndroidNotificationChannel(
    'fcm_general',
    'General Notifications',
    description: 'General push notifications from ExpenseNest.',
    importance: Importance.high,
    playSound: true,
  );

  static const AndroidNotificationChannel _reminderChannel =
      AndroidNotificationChannel(
    'daily_reminder',
    'Daily Reminders',
    description: 'Reminds you to log your daily transactions in ExpenseNest.',
    importance: Importance.high,
    playSound: true,
  );

  // ─────────────────────────────────────────────────────────
  // Initialise
  // ─────────────────────────────────────────────────────────
  Future<void> initialize() async {
    // Init timezone database
    tz.initializeTimeZones();

    // ── Local notifications setup ────────────────────────
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: darwinInit,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create channels on Android
    if (Platform.isAndroid) {
      final androidPlugin =
          _localNotifications.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await androidPlugin?.createNotificationChannel(_budgetChannel);
      await androidPlugin?.createNotificationChannel(_transactionChannel);
      await androidPlugin?.createNotificationChannel(_fcmChannel);
      await androidPlugin?.createNotificationChannel(_reminderChannel);
    }

    // ── FCM permissions ──────────────────────────────────
    await _requestPermissions();

    // ── FCM handlers ────────────────────────────────────
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Foreground FCM
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showFCMNotification(message);
    });

    // Notification tap when app is opened from background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('FCM opened app from background: ${message.messageId}');
    });
  }

  // ─────────────────────────────────────────────────────────
  // Permissions
  // ─────────────────────────────────────────────────────────
  Future<void> _requestPermissions() async {
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint('FCM permission: ${settings.authorizationStatus}');

    if (Platform.isAndroid) {
      final androidPlugin =
          _localNotifications.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await androidPlugin?.requestNotificationsPermission();
    }
  }

  // ─────────────────────────────────────────────────────────
  // Public API – Budget alert
  // ─────────────────────────────────────────────────────────

  /// Show a local notification when a budget threshold is crossed.
  Future<void> showBudgetAlert({
    required String categoryName,
    required double spent,
    required double total,
    required double thresholdPercent,
  }) async {
    final percent = ((spent / total) * 100).toStringAsFixed(0);
    final threshold = thresholdPercent.toStringAsFixed(0);

    await _localNotifications.show(
      _budgetNotificationId(categoryName),
      '⚠️ Budget Alert – $categoryName',
      'You\'ve used $percent% of your $categoryName budget '
          '(threshold: $threshold%). Consider reducing expenses.',
      NotificationDetails(
        android: AndroidNotificationDetails(
          _budgetChannel.id,
          _budgetChannel.name,
          channelDescription: _budgetChannel.description,
          importance: Importance.high,
          priority: Priority.high,
          styleInformation: BigTextStyleInformation(
            'You\'ve spent \$${spent.toStringAsFixed(2)} of your '
            '\$${total.toStringAsFixed(2)} $categoryName budget. '
            'Your alert was set at $threshold%. Stay on track!',
            contentTitle: '⚠️ Budget Alert – $categoryName',
            summaryText: 'ExpenseNest',
          ),
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: 'budget:$categoryName',
    );
  }

  // ─────────────────────────────────────────────────────────
  // Public API – Transaction notification
  // ─────────────────────────────────────────────────────────

  /// Show a local notification when a transaction is saved.
  Future<void> showTransactionNotification({
    required String title,
    required String body,
  }) async {
    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _transactionChannel.id,
          _transactionChannel.name,
          channelDescription: _transactionChannel.description,
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: false,
          presentSound: false,
        ),
      ),
      payload: 'transaction',
    );
  }

  // ─────────────────────────────────────────────────────────
  // Public API – Daily reminder
  // ─────────────────────────────────────────────────────────

  /// Schedule a one-shot daily reminder at [reminderHour]:[reminderMinute]
  /// (defaults to 21:00 / 9 PM local time) for today.
  ///
  /// Call this whenever transactions are loaded and today has NO entries.
  /// If 9 PM has already passed today, the reminder is scheduled for
  /// tomorrow at 9 PM.
  ///
  /// [userName] personalises the message.
  /// [accountCreatedAt] is used to verify the reminder window has started
  /// (we only remind from the day the account was created onwards).
  Future<void> scheduleDailyReminder({
    String userName = 'there',
    DateTime? accountCreatedAt,
    int reminderHour = 21,
    int reminderMinute = 0,
  }) async {
    // Don't remind before the account creation date
    final now = DateTime.now();
    if (accountCreatedAt != null) {
      final createdDay = DateTime(
          accountCreatedAt.year, accountCreatedAt.month, accountCreatedAt.day);
      final today = DateTime(now.year, now.month, now.day);
      if (today.isBefore(createdDay)) return;
    }

    // Cancel any previously scheduled reminder before rescheduling
    await cancelDailyReminder();

    final location = tz.local;
    final nowTz = tz.TZDateTime.now(location);

    // Target: today at reminderHour:reminderMinute
    var scheduledDate = tz.TZDateTime(
      location,
      nowTz.year,
      nowTz.month,
      nowTz.day,
      reminderHour,
      reminderMinute,
    );

    // If that time has already passed today, schedule for tomorrow
    if (scheduledDate.isBefore(nowTz)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    final firstName = userName.split(' ').first;

    await _localNotifications.zonedSchedule(
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      _dailyReminderId,
      '📒 Hey $firstName, don\'t forget!',
      'You haven\'t logged any transactions today. '
          'Keep your finances on track — add one now!',
      scheduledDate,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _reminderChannel.id,
          _reminderChannel.name,
          channelDescription: _reminderChannel.description,
          importance: Importance.high,
          priority: Priority.high,
          styleInformation: const BigTextStyleInformation(
            'You haven\'t logged any transactions today. '
            'Staying on top of your spending helps you reach your goals. '
            'Open ExpenseNest and add your transactions now!',
            contentTitle: '📒 Daily Expense Reminder',
            summaryText: 'ExpenseNest',
          ),
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: 'daily_reminder',
    );

    debugPrint('Daily reminder scheduled for $scheduledDate');
  }

  /// Cancel the pending daily reminder (call after a transaction is added today).
  Future<void> cancelDailyReminder() async {
    await _localNotifications.cancel(_dailyReminderId);
    debugPrint('Daily reminder cancelled');
  }

  // ─────────────────────────────────────────────────────────
  // FCM helper
  // ─────────────────────────────────────────────────────────
  Future<void> _showFCMNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    await _localNotifications.show(
      message.hashCode,
      notification.title ?? 'ExpenseNest',
      notification.body ?? '',
      NotificationDetails(
        android: AndroidNotificationDetails(
          _fcmChannel.id,
          _fcmChannel.name,
          channelDescription: _fcmChannel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: message.data.toString(),
    );
  }

  // ─────────────────────────────────────────────────────────
  // Notification tap handler
  // ─────────────────────────────────────────────────────────
  void _onNotificationTapped(NotificationResponse response) {
    final payload = response.payload ?? '';
    debugPrint('Notification tapped: $payload');
    // Navigate to transactions screen via a global navigator key if needed.
  }

  // ─────────────────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────────────────

  /// Stable notification ID per category so multiple alerts for the same
  /// category replace each other rather than stacking.
  int _budgetNotificationId(String categoryName) =>
      categoryName.hashCode.abs() % 100000;

  /// Returns the FCM device token (useful for backend push targeting).
  Future<String?> getDeviceToken() => _fcm.getToken();
}
