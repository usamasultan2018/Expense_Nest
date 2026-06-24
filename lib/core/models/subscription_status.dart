
class SubscriptionStatus {
  final String? eventType;
  final String? productId;
  final String? periodType;
  final String? expiresAt;
  final String? environment;

  SubscriptionStatus({
    this.eventType,
    this.productId,
    this.periodType,
    this.expiresAt,
    this.environment,
  });

  factory SubscriptionStatus.fromMap(Map<String, dynamic> map) {
    return SubscriptionStatus(
      eventType: map['eventType'],
      productId: map['productId'],
      periodType: map['periodType'],
      expiresAt: map['expiresAt'],
      environment: map['environment'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'eventType': eventType,
      'productId': productId,
      'periodType': periodType,
      'expiresAt': expiresAt,
      'environment': environment,
    };
  }
}
