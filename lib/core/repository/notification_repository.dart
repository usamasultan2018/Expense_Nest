import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/core/models/notification_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class NotificationRepository {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('notifications');

  String? get _userId => FirebaseAuth.instance.currentUser?.uid;

  // ─────────────────────────────────────────────────────────
  // Save a notification (called by NotificationService)
  // ─────────────────────────────────────────────────────────

  /// Persists [notification] to Firestore.
  /// The [userId] field is auto-filled from the current auth user if not set.
  /// Returns the saved document ID, or null on failure (best-effort).
  Future<String?> saveNotification({
    required String title,
    required String body,
    required NotificationType type,
    String? payload,
    String? userId,
  }) async {
    final uid = userId ?? _userId;
    if (uid == null) return null; // Not logged in — skip silently

    try {
      final doc = await _collection.add({
        'userId': uid,
        'title': title,
        'body': body,
        'type': type.firestoreValue,
        'isRead': false,
        if (payload != null) 'payload': payload,
        'createdAt': Timestamp.now(),
      });

      await doc.update({'id': doc.id});
      return doc.id;
    } catch (e) {
      // Best-effort — never let persistence errors break notification flow
      debugPrint('NotificationRepository.save error: $e');
      return null;
    }
  }

  // ─────────────────────────────────────────────────────────
  // Fetch all notifications for the current user
  // ─────────────────────────────────────────────────────────

  Future<List<NotificationModel>> getNotifications() async {
    final uid = _userId;
    if (uid == null) return [];

    try {
      final snapshot = await _collection
          .where('userId', isEqualTo: uid)
          .get();

      final list = snapshot.docs
          .map((doc) =>
              NotificationModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      // Sort client-side by createdAt descending to avoid composite index requirement
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return list;
    } catch (e) {
      debugPrint('NotificationRepository.getNotifications error: $e');
      return [];
    }
  }

  // ─────────────────────────────────────────────────────────
  // Real-time stream
  // ─────────────────────────────────────────────────────────

  /// Stream of notifications for the current user, newest first.
  Stream<List<NotificationModel>> notificationsStream() {
    final uid = _userId;
    if (uid == null) return const Stream.empty();

    return _collection
        .where('userId', isEqualTo: uid)
        .snapshots()
        .map((snapshot) {
          final list = snapshot.docs
              .map((doc) => NotificationModel.fromJson(
                  doc.data() as Map<String, dynamic>))
              .toList();
          // Sort client-side by createdAt descending to avoid composite index requirement
          list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return list;
        });
  }

  // ─────────────────────────────────────────────────────────
  // Mark as read
  // ─────────────────────────────────────────────────────────

  Future<void> markAsRead(String notificationId) async {
    try {
      await _collection.doc(notificationId).update({'isRead': true});
    } catch (e) {
      debugPrint('NotificationRepository.markAsRead error: $e');
    }
  }

  Future<void> markAllAsRead() async {
    final uid = _userId;
    if (uid == null) return;

    try {
      final snapshot = await _collection
          .where('userId', isEqualTo: uid)
          .where('isRead', isEqualTo: false)
          .get();

      final batch = FirebaseFirestore.instance.batch();
      for (final doc in snapshot.docs) {
        batch.update(doc.reference, {'isRead': true});
      }
      await batch.commit();
    } catch (e) {
      debugPrint('NotificationRepository.markAllAsRead error: $e');
    }
  }

  // ─────────────────────────────────────────────────────────
  // Delete
  // ─────────────────────────────────────────────────────────

  Future<void> deleteNotification(String notificationId) async {
    try {
      await _collection.doc(notificationId).delete();
    } catch (e) {
      debugPrint('NotificationRepository.delete error: $e');
    }
  }

  Future<void> deleteAllNotifications() async {
    final uid = _userId;
    if (uid == null) return;

    try {
      final snapshot =
          await _collection.where('userId', isEqualTo: uid).get();

      final batch = FirebaseFirestore.instance.batch();
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } catch (e) {
      debugPrint('NotificationRepository.deleteAll error: $e');
    }
  }

  // ─────────────────────────────────────────────────────────
  // Unread count
  // ─────────────────────────────────────────────────────────

  Future<int> getUnreadCount() async {
    final uid = _userId;
    if (uid == null) return 0;

    try {
      final snapshot = await _collection
          .where('userId', isEqualTo: uid)
          .where('isRead', isEqualTo: false)
          .count()
          .get();
      return snapshot.count ?? 0;
    } catch (e) {
      debugPrint('NotificationRepository.getUnreadCount error: $e');
      return 0;
    }
  }
}
