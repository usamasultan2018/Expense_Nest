import 'package:expense_tracker/view%20model/transaction_controller/transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TimePeriodSelector extends StatelessWidget {
  const TimePeriodSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> timePeriods = [
      'All Time',
      'This Year',
      'This Month',
      'This Week',
      'Yesterday',
      'Today',
    ];
    return Consumer<TransactionController>(
      builder:
          (BuildContext context, TransactionController value, Widget? child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            height: 35,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: timePeriods.length,
              itemBuilder: (context, index) {
                String timePeriod = timePeriods[index];
                return GestureDetector(
                  onTap: () {
                    value.selectedTimePeriod = timePeriod;
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(right: 5),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(15),
                      border: value.selectedTimePeriod == timePeriod
                          ? Border.all(
                              color: Theme.of(context).colorScheme.secondary,
                              width: 1,
                            )
                          : null,
                    ),
                    child: Text(
                      timePeriod,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
