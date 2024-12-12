class TransactionModel {
  final String id;
  final String userId;
  final String category;
  final double amount;
  final String note;
  final TransactionType type; // Enum for transaction type
  final PayMethod payMethod; // Enum for payment method
  final List<String>? pictures; // Optional list of image URLs
  final DateTime date; // Date of the transaction
  final DateTime time; // Time of the transaction

  TransactionModel({
    required this.id,
    required this.userId,
    required this.category,
    required this.amount,
    required this.note,
    required this.type,
    required this.payMethod,
    this.pictures, // Optional field
    required this.date,
    required this.time,
  });

  // Convert TransactionModel to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'category': category,
      'amount': amount,
      'note': note,
      'type': type.toString().split('.').last,
      'payMethod': payMethod.toString().split('.').last,
      'pictures': pictures ?? [], // Store an empty list if pictures are null
      'date': date.toIso8601String(),
      'time': time.toIso8601String(),
    };
  }

  // Create TransactionModel from Firestore data
  static TransactionModel fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      userId: json['userId'],
      category: json['category'],
      amount: json['amount'],
      note: json['note'],
      type: TransactionType.values
          .firstWhere((e) => e.toString() == 'TransactionType.${json['type']}'),
      payMethod: PayMethod.values
          .firstWhere((e) => e.toString() == 'PayMethod.${json['payMethod']}'),
      pictures: json['pictures'] != null
          ? List<String>.from(json['pictures'])
          : null, // Handle null case for pictures
      date: DateTime.parse(json['date']),
      time: DateTime.parse(json['time']),
    );
  }
}

// Enum for transaction type
enum TransactionType {
  income,
  expense,
}

// Enum for payment method
enum PayMethod {
  cash,
  creditCard,
  debitCard,
  onlineTransfer,
  wallet,
}

extension PaymentMethodExtension on PayMethod {
  String get displayName {
    switch (this) {
      case PayMethod.creditCard:
        return 'Credit Card';
      case PayMethod.debitCard:
        return 'Debit Card';

      case PayMethod.onlineTransfer:
        return 'Online Transfer';
      case PayMethod.cash:
        return 'Cash';
      case PayMethod.wallet:
        return "Wallet";
    }
  }
}

PayMethod getPayMethodFromDisplayName(String displayName) {
  switch (displayName) {
    case 'Credit Card':
      return PayMethod.creditCard;
    case 'Debit Card':
      return PayMethod.debitCard;
    case 'Online Transfer':
      return PayMethod.onlineTransfer;
    case 'Wallet':
      return PayMethod.wallet;
    case 'Cash':
      return PayMethod.cash;
    default:
      return PayMethod.cash; // Default to PayMethod.cash if no match
  }
}
