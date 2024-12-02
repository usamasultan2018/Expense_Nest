import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/utils/helpers/constant.dart';
import 'package:expense_tracker/view%20model/transaction_controller/transaction_controller.dart';
import 'package:expense_tracker/view/dashboard/stats/widgets/stats_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class Transactiontype extends StatelessWidget {
  const Transactiontype({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionController>(
      builder: (context, provider, child) {
        return StatsTransactionType(
          onTransactionTypeChanged: (TransactionType type) {
            provider.setType(type); // Updates the provider
          },
        );
      },
    );
  }
}
