import 'package:expense_tracker/utils/appColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NoGraphTransaction extends StatelessWidget {
  const NoGraphTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Icon(
                  Icons.pie_chart,
                  color: AppColors.grey,
                  size: 40,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  AppLocalizations.of(context)!.noTransactions,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
