import 'package:flutter/material.dart';

/// Simple 3-column grid delegate for the month picker.
class MonthGridDelegate extends SliverGridDelegateWithFixedCrossAxisCount {
  const MonthGridDelegate()
      : super(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 2.2,
        );
}
