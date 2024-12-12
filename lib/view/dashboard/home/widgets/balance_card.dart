import 'package:expense_tracker/components/balance_card_tile.dart';
import 'package:expense_tracker/components/fade_effect.dart';
import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/repository/user_repositpory.dart';
import 'package:expense_tracker/utils/helpers/Skeleton.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    var auth = FirebaseAuth.instance;

    if (auth.currentUser == null) {
      // Optionally, navigate to login or show a message
      return Center(
        child: Text("User is not logged in."),
      );
    }

    return StreamBuilder<AccountModel?>(
      stream: UserRepository().streamAccount(auth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const FadeTransitionEffect(child: BalanceCardTileSkeleton());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        } else if (!snapshot.hasData) {
          return Center(child: Text('No account data available.'));
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
