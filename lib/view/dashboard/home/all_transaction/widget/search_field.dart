import 'package:expense_tracker/view%20model/transaction_controller/transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SearchField extends StatelessWidget {
  const SearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionController>(
      builder:
          (BuildContext context, TransactionController value, Widget? child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            onChanged: (val) {
              value.updateSearchQuery(val);
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
              prefixIcon: Icon(
                FontAwesomeIcons.search,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              hintText: "Search transactions...",
              hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        );
      },
    );
  }
}
