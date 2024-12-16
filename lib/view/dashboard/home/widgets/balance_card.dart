import 'package:expense_tracker/components/balance_card_tile.dart';
import 'package:expense_tracker/components/fade_effect.dart';
import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/repository/user_repositpory.dart';
import 'package:expense_tracker/utils/helpers/shared_preference.dart';
import 'package:expense_tracker/utils/helpers/skeleton_loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    var user = UserPreferences.getUser();

    if (user == null) {
      return const Center(
        child: Text("User is not logged in."),
      );
    }

    return StreamBuilder<AccountModel?>(
      stream: UserRepository().streamAccount(user.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const FadeTransitionEffect(child: BalanceCardTileSkeleton());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        } else if (!snapshot.hasData) {
          return const Center(child: Text('No account data available.'));
        } else {
          AccountModel accountModel = snapshot.data!;
          return FadeTransitionEffect(
            child: BalanceCardTile(accountModel: accountModel),
          );
        }
      },
    );
  }
}
