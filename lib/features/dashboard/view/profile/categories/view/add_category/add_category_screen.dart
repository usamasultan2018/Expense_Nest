import 'package:expense_tracker/core/components/app_toggle.dart';
import 'package:expense_tracker/core/components/custom_button.dart';
import 'package:expense_tracker/core/components/custom_textfield.dart';
import 'package:expense_tracker/core/utils/snackbar_util.dart';
import 'package:expense_tracker/features/dashboard/view/profile/categories/controller/category_controller.dart';
import 'package:expense_tracker/features/dashboard/view/profile/categories/widgets/category_color_picker.dart';
import 'package:expense_tracker/features/dashboard/view/profile/categories/widgets/category_icon_picker.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final TextEditingController _titleController = TextEditingController();

  String selectedType = 'Income';

  Color selectedColor = Colors.teal;
  IconData selectedIcon = Icons.shopping_bag;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> showColorPickerBottomSheet() async {
    Color tempColor = selectedColor;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ColorPicker(
                        color: tempColor,
                        onColorChanged: (color) {
                          setModalState(() {
                            tempColor = color;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedColor = tempColor;
                            });

                            Navigator.pop(context);
                          },
                          child: const Text('Apply'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> showIconPickerBottomSheet() async {
    final icons = [
      // Shopping
      Icons.shopping_bag,
      Icons.shopping_cart,
      Icons.local_grocery_store,
      Icons.store,

      // Food
      Icons.restaurant,
      Icons.fastfood,
      Icons.lunch_dining,
      Icons.local_cafe,
      Icons.cake,

      // Home
      Icons.home,
      Icons.chair,
      Icons.bed,
      Icons.kitchen,

      // Transport
      Icons.directions_car,
      Icons.local_taxi,
      Icons.train,
      Icons.flight,
      Icons.directions_bus,

      // Bills
      Icons.electric_bolt,
      Icons.water_drop,
      Icons.wifi,
      Icons.phone_android,

      // Entertainment
      Icons.movie,
      Icons.music_note,
      Icons.sports_esports,
      Icons.tv,

      // Education
      Icons.school,
      Icons.menu_book,
      Icons.edit_note,

      // Health
      Icons.health_and_safety,
      Icons.medical_services,
      Icons.local_hospital,
      Icons.fitness_center,

      // Travel
      Icons.luggage,
      Icons.beach_access,
      Icons.map,

      // Work
      Icons.work,
      Icons.business_center,
      Icons.computer,

      // Pets
      Icons.pets,

      // Gifts
      Icons.card_giftcard,
      Icons.celebration,

      // Finance
      Icons.account_balance_wallet,
      Icons.attach_money,
      Icons.savings,

      // Family
      Icons.child_care,
      Icons.family_restroom,

      // Misc
      Icons.favorite,
      Icons.star,
      Icons.camera_alt,
      Icons.brush,
      Icons.spa,
      Icons.local_florist,
    ];
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: icons.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              final icon = icons[index];
              final isSelected = icon == selectedIcon;

              return InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  setState(() {
                    selectedIcon = icon;
                  });

                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Theme.of(context).dividerColor,
                    ),
                    color: isSelected ? selectedColor.withOpacity(0.85) : null,
                  ),
                  child: Icon(
                    icon,
                    color: isSelected
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryController>(
      builder: (context, controller, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Add Category'),
            centerTitle: true,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  AppToggle(
                    selectedValue: selectedType,
                    onChanged: (value) {
                      setState(() {
                        selectedType = value;
                      });
                    },
                    options: const [
                      ToggleOption(
                        label: 'Income',
                        value: 'Income',
                      ),
                      ToggleOption(
                        label: 'Expense',
                        value: 'Expense',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Category Title',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    controller: _titleController,
                    hintText: 'Category title',
                    maxLength: 20,
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Category Color',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  CategoryColorField(
                    selectedColor: selectedColor,
                    onTap: showColorPickerBottomSheet,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Category Icon',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  CategoryIconField(
                    selectedIcon: selectedIcon,
                    selectedColor: selectedColor,
                    onTap: showIconPickerBottomSheet,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: RoundButton(
                      onPressed: () {},
                      title: "Add Category",
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
