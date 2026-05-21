import 'package:expense_tracker/core/theme/appColors.dart';
import 'package:flutter/material.dart';

class NoGraphTransaction extends StatelessWidget {
  const NoGraphTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Padding(
            padding: EdgeInsets.all(10.0),
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
                  "No transactions",
                  style: TextStyle(
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
