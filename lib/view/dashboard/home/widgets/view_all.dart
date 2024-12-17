import 'package:expense_tracker/view/dashboard/home/all_transaction/all_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class ViewAll extends StatelessWidget {
  const ViewAll({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppLocalizations.of(context)!.transaction,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        GestureDetector(
          onTap: () {
            (context).push("/view-all");
          },
          child: Text(
            AppLocalizations.of(context)!.viewAll,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.outline,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
