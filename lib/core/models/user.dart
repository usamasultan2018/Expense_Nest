import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/core/models/subscription_status.dart';

class UserModel {
  final String id;
  final String username;
  final String email;
  final String profilePicture;
  final DateTime createdAt;
  final String? deviceToken;
  final bool isPremium;
  final SubscriptionStatus? subscriptionStatus;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.profilePicture,
    required this.createdAt,
    this.deviceToken,
    this.isPremium = false,
    this.subscriptionStatus,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate;
    if (json['createdAt'] is Timestamp) {
      parsedDate = (json['createdAt'] as Timestamp).toDate();
    } else if (json['createdAt'] is String) {
      parsedDate = DateTime.parse(json['createdAt']);
    } else {
      parsedDate = DateTime.now();
    }

    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      profilePicture: json['profilePicture'],
      createdAt: parsedDate,
      deviceToken: json['deviceToken'],
      isPremium: json['isPremium'] ?? false,
      subscriptionStatus: json['subscriptionStatus'] != null
          ? SubscriptionStatus.fromMap(json['subscriptionStatus'])
          : null,
    );
  }

  /// Used for profile updates only — never writes isPremium or subscriptionStatus
  /// so the webhook-managed fields are never clobbered
  Map<String, dynamic> toProfileUpdateMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'profilePicture': profilePicture,
      'createdAt': Timestamp.fromDate(createdAt),
      if (deviceToken != null) 'deviceToken': deviceToken,
    };
  }

  /// Full map — only used when creating a new user document
  Map<String, dynamic> toFirestoreMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'profilePicture': profilePicture,
      'createdAt': Timestamp.fromDate(createdAt),
      if (deviceToken != null) 'deviceToken': deviceToken,
      'isPremium': isPremium,
      if (subscriptionStatus != null)
        'subscriptionStatus': subscriptionStatus!.toMap(),
    };
  }

  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    String? profilePicture,
    DateTime? createdAt,
    String? deviceToken,
    bool? isPremium,
    SubscriptionStatus? subscriptionStatus,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      profilePicture: profilePicture ?? this.profilePicture,
      createdAt: createdAt ?? this.createdAt,
      deviceToken: deviceToken ?? this.deviceToken,
      isPremium: isPremium ?? this.isPremium,
      subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
    );
  }
}
