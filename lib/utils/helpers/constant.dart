// Enum to define CategoryType
enum CategoryType { income, expense }
// Enum for transaction type
enum TransactionType {
  income,
  expense,
}

// Enum for payment method
// utils/constants.dart

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
        return 'Wallet';
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
