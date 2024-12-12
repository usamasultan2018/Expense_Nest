// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:provider/provider.dart';
// import 'package:expense_tracker/view%20model/transaction_controller/transaction_controller.dart';

// class CategoryDropdown extends StatelessWidget {
//   const CategoryDropdown({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context); // Access the current theme
//     return Consumer<TransactionController>(
//       builder: (context, transactionController, child) {
//         return DropdownButtonFormField<String>(
//           value: transactionController.selectedCategory,
//           items: ['Salary', 'Business', 'Investments', 'Other']
//               .map((String category) {
//             return DropdownMenuItem<String>(
//               value: category,
//               child: Text(category),
//             );
//           }).toList(),
//           onChanged: (String? newValue) {
//             transactionController.setCategory(newValue);
//           },
//           decoration: InputDecoration(
//             filled: true,
//             fillColor:
//                 theme.colorScheme.surface, // Change color based on readOnly
//             prefixIcon: Icon(
//               Icons.category_rounded,
//               size: 16,
//               color: theme.colorScheme.onSurface, // Use theme color for icon
//             ),

//             hintStyle: TextStyle(
//                 color: theme.colorScheme.onSurface
//                     .withOpacity(0.6)), // Adjust hint text color
//             border: const OutlineInputBorder(
//               borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
//               borderSide: BorderSide.none,
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
