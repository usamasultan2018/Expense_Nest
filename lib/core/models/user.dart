import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String username;
  final String email;
  final String profilePicture;
  final DateTime createdAt;
  final String? deviceToken; // New optional field

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.profilePicture,
    required this.createdAt,
    this.deviceToken, // Optional in constructor
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Handle both Timestamp and String formats for backwards compatibility
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
      deviceToken: json['deviceToken'], // Parse deviceToken if present
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'profilePicture': profilePicture,
      'createdAt': createdAt.toIso8601String(),
      if (deviceToken != null)
        'deviceToken': deviceToken, // Include if not null
    };
  }

  Map<String, dynamic> toFirestoreMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'profilePicture': profilePicture,
      'createdAt': Timestamp.fromDate(createdAt),
      if (deviceToken != null) 'deviceToken': deviceToken,
    };
  }
}
