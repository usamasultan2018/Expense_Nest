import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/utils/helpers/constant.dart';

class TransactionFiltering {
  static List<TransactionModel> filterTransactions(
    List<TransactionModel> transactions,
    String timePeriod,
    String query,
  ) {
    DateTime now = DateTime.now();
    DateTime? startDate;
    DateTime? endDate;

    switch (timePeriod) {
      case "This Year":
        startDate = DateTime(now.year, 1, 1);
        endDate = DateTime(now.year + 1, 1, 1);
        break;
      case "This Month":
        startDate = DateTime(now.year, now.month, 1);
        endDate = (now.month < 12)
            ? DateTime(now.year, now.month + 1, 1)
            : DateTime(now.year + 1, 1, 1);
        break;
      case "This Week":
        startDate = now.subtract(Duration(days: now.weekday - 1)); // Monday
        startDate = DateTime(startDate.year, startDate.month, startDate.day);
        endDate = startDate.add(Duration(days: 7)); // Next Monday midnight
        break;
      case "Yesterday":
        startDate =
            DateTime(now.year, now.month, now.day).subtract(Duration(days: 1));
        endDate = DateTime(now.year, now.month, now.day);
        break;
      case "Today":
        startDate = DateTime(now.year, now.month, now.day);
        endDate = startDate.add(Duration(days: 1));
        break;
      case "All Time":
        startDate = null;
        endDate = null;
        break;
      default:
        throw ArgumentError("Invalid time period: $timePeriod");
    }

    return transactions
        .where((transaction) {
          if (startDate != null && endDate != null) {
            // Parse transaction date as a DateTime
            DateTime transactionDate = transaction.date;
            // Ensure comparison is inclusive of startDate and exclusive of endDate
            return !transactionDate.isBefore(startDate) &&
                transactionDate.isBefore(endDate);
          }
          return true;
        })
        .where((transaction) =>
            transaction.note.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  static List<TransactionModel> filterByType(
    List<TransactionModel> transactions,
    TransactionType type,
  ) {
    return transactions
        .where((transaction) => transaction.type == type)
        .toList();
  }
}
