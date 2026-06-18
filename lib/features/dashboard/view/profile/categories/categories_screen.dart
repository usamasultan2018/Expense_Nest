import 'package:expense_tracker/core/components/app_toggle.dart';
import 'package:expense_tracker/core/utils/constant.dart';
import 'package:expense_tracker/features/dashboard/view/profile/categories/controller/category_controller.dart';
import 'package:expense_tracker/features/dashboard/view/profile/categories/data/default_categories.dart';
import 'package:expense_tracker/features/dashboard/view/profile/categories/widgets/category_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: false,
        title: const Text(
          "Categories",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Consumer<CategoryController>(
            builder: (context, controller, _) {
              final defaultCategories =
                  controller.selectedType == TransactionType.expense
                      ? DefaultCategories.expense
                      : DefaultCategories.income;

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    AppToggle<TransactionType>(
                      selectedValue: controller.selectedType,
                      onChanged: (value) => controller.changeType(value),
                      options: const [
                        ToggleOption(
                            label: 'Income', value: TransactionType.income),
                        ToggleOption(
                            label: 'Expense', value: TransactionType.expense),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Categories',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: defaultCategories.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: .9,
                      ),
                      itemBuilder: (_, index) {
                        final category = defaultCategories[index];
                        return CategoryCard(
                          title: category.title,
                          icon: category.icon,
                          color: category.color,
                        );
                      },
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
