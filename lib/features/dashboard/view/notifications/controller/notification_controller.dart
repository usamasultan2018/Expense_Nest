import 'dart:async';

import 'package:expense_tracker/core/models/notification_model.dart';
import 'package:expense_tracker/core/repository/notification_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationController extends ChangeNotifier {
  NotificationController({NotificationRepository? repository})
      : _repository = repository ?? NotificationRepository() {
    // Automatically re-listen to the stream whenever user auth state changes (login/logout/switch account)
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      _listenToNotifications();
    });
  }

  final NotificationRepository _repository;
  StreamSubscription<User?>? _authSubscription;

  List<NotificationModel> _notifications = [];
  bool isLoading = false;
  String? error;

  StreamSubscription<List<NotificationModel>>? _subscription;

  // ─────────────────────────────────────────────────────────
  // Getters
  // ─────────────────────────────────────────────────────────

  List<NotificationModel> get notifications => _notifications;

  int get unreadCount =>
      _notifications.where((n) => !n.isRead).length;

  bool get hasUnread => unreadCount > 0;

  // ─────────────────────────────────────────────────────────
  // Real-time listener
  // ─────────────────────────────────────────────────────────

  void _listenToNotifications() {
    _subscription?.cancel();
    _subscription = _repository.notificationsStream().listen(
      (list) {
        _notifications = list;
        notifyListeners();
      },
      onError: (e) {
        debugPrint('NotificationController stream error: $e');
      },
    );
  }

  /// Call this after login to restart the stream with the new user's data.
  void refresh() {
    _listenToNotifications();
  }

  // ─────────────────────────────────────────────────────────
  // Actions
  // ─────────────────────────────────────────────────────────

  Future<void> markAsRead(String notificationId) async {
    await _repository.markAsRead(notificationId);
    // Stream update will arrive via listener — no manual notifyListeners needed.
  }

  Future<void> markAllAsRead() async {
    await _repository.markAllAsRead();
  }

  Future<void> deleteNotification(String notificationId) async {
    await _repository.deleteNotification(notificationId);
  }

  Future<void> deleteAll() async {
    await _repository.deleteAllNotifications();
  }

  // ─────────────────────────────────────────────────────────
  // Dispose
  // ─────────────────────────────────────────────────────────

  @override
  void dispose() {
    _subscription?.cancel();
    _authSubscription?.cancel();
    super.dispose();
  }
}
