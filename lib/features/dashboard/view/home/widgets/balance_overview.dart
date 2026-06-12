import 'package:expense_tracker/core/components/balance_card_tile.dart';
import 'package:expense_tracker/core/models/account.dart' show AccountModel;
import 'package:expense_tracker/core/repository/user_repositpory.dart';
import 'package:expense_tracker/core/utils/skeleton_loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BalanceOverview extends StatelessWidget {
  const BalanceOverview({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return const Center(
        child: Text("User not logged in"),
      );
    }

    return StreamBuilder<AccountModel?>(
      stream: UserRepository().streamAccount(userId),
      builder: (context, snapshot) {
        /// Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const BalanceCardTileSkeleton();
        }

        /// Error
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Something went wrong',
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          );
        }

        /// No Data
        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(
            child: Text('No account data available.'),
          );
        }

        final accountModel = snapshot.data!;

        return BalanceCardTile(
          accountModel: accountModel,
        );
      },
    );
  }
}
