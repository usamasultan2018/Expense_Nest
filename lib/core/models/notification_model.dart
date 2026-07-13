import 'package:cloud_firestore/cloud_firestore.dart';

/// The type/source of a notification stored in Firestore.
enum NotificationType {
  budgetAlert,
  transaction,
  dailyReminder,
  fcm,
  other;

  String get firestoreValue {
    switch (this) {
      case NotificationType.budgetAlert:
        return 'budget_alert';
      case NotificationType.transaction:
        return 'transaction';
      case NotificationType.dailyReminder:
        return 'daily_reminder';
      case NotificationType.fcm:
        return 'fcm';
      case NotificationType.other:
        return 'other';
    }
  }

  static NotificationType fromString(String? value) {
    switch (value) {
      case 'budget_alert':
        return NotificationType.budgetAlert;
      case 'transaction':
        return NotificationType.transaction;
      case 'daily_reminder':
        return NotificationType.dailyReminder;
      case 'fcm':
        return NotificationType.fcm;
      default:
        return NotificationType.other;
    }
  }
}

class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String body;
  final NotificationType type;
  final bool isRead;
  final String? payload;
  final Timestamp createdAt;

  const NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    this.isRead = false,
    this.payload,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      type: NotificationType.fromString(json['type'] as String?),
      isRead: json['isRead'] as bool? ?? false,
      payload: json['payload'] as String?,
      createdAt: json['createdAt'] as Timestamp? ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
      'type': type.firestoreValue,
      'isRead': isRead,
      if (payload != null) 'payload': payload,
      'createdAt': createdAt,
    };
  }

  NotificationModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? body,
    NotificationType? type,
    bool? isRead,
    String? payload,
    Timestamp? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
