import 'package:expense_tracker/components/category_tile.dart';
import 'package:expense_tracker/components/fade_effect.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/utils/helpers/constant.dart';
import 'package:expense_tracker/utils/helpers/geticons.dart';
import 'package:expense_tracker/view model/transaction_controller/transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionController>(
      builder: (context, controller, child) {
        print(
            "Categories in CategoryWidget: ${controller.selectedType == TransactionType.expense ? controller.expenseCategories.length : controller.incomeCategories.length}");

        return InkWell(
          onTap: () => _showCategorySelectionBottomSheet(context, controller),
          child: _buildCategorySelector(context, controller),
        );
      },
    );
  }

  void _showCategorySelectionBottomSheet(
      BuildContext context, TransactionController controller) {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: FadeTransitionEffect(
                  child: _buildCategorySelectionContent(context, controller)),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategorySelectionContent(
      BuildContext context, TransactionController controller) {
    String searchQuery = ''; // Maintain search state across builds
    List<CategoryModel> filteredCategories =
        controller.selectedType == TransactionType.expense
            ? controller.expenseCategories
            : controller.incomeCategories;

    return StatefulBuilder(
      builder: (context, setState) {
        // Function to update filtered categories
        void updateSearchQuery(String query) {
          setState(() {
            searchQuery = query;
            filteredCategories = (controller.selectedType ==
                        TransactionType.expense
                    ? controller.expenseCategories
                    : controller.incomeCategories)
                .where((category) =>
                    category.name.toLowerCase().contains(query.toLowerCase()))
                .toList();
          });
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Select Category",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            TextField(
              onChanged: updateSearchQuery,
              decoration: InputDecoration(
                filled: true,
                fillColor: Theme.of(context)
                    .colorScheme
                    .surface, // Change color based on readOnly
                prefixIcon: Icon(
                  FontAwesomeIcons.search,

                  color: Theme.of(context)
                      .colorScheme
                      .onSurface, // Use theme color for icon
                ),
                hintText: "Search transactions...",
                hintStyle: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6)), // Adjust hint text color
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (filteredCategories.isEmpty)
              const Center(child: Text('No categories found.'))
            else
              _buildCategoryListView(filteredCategories, controller),
          ],
        );
      },
    );
  }

  Widget _buildCategoryListView(
      List<CategoryModel> categories, TransactionController controller) {
    return FadeTransitionEffect(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final indexData = categories[index];
          return CategoryTile(
              iconData: indexData.icon,
              onpressed: () {
                print(indexData.icon);
                controller.setCategory(indexData.name);
                Navigator.pop(context);
              },
              title: indexData.name,
              bckColor: indexData.color);
        },
      ),
    );
  }

  Widget _buildCategorySelector(
      BuildContext context, TransactionController controller) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 17),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            controller.selectedCategory?.isNotEmpty == true
                ? controller.selectedCategory!
                : "Select Category",
            style: theme.textTheme.bodyLarge!.copyWith(
              fontSize: 15,
            ),
          ),
          const Icon(
            Icons.arrow_drop_down,
            size: 20,
          ),
        ],
      ),
    );
  }
}
