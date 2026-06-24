import 'package:expense_tracker/core/utils/google_fonts_helper.dart';
import 'package:expense_tracker/features/dashboard/view/profile/controller/user_controller.dart';
import 'package:expense_tracker/features/dashboard/view/profile/settings/controller/setting_controller.dart';
import 'package:expense_tracker/features/subscription/screens/subscription_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FontTile extends StatelessWidget {
  const FontTile({super.key});

  void _showFonts(BuildContext context) {
    final controller = context.read<SettingController>();
    final userController =
        context.read<UserController>(); // 👈 read before sheet

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return MultiProvider(
          // 👈 both controllers in scope
          providers: [
            ChangeNotifierProvider.value(value: controller),
            ChangeNotifierProvider.value(value: userController),
          ],
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.7,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
              return Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          "Choose Font",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Consumer2<SettingController, UserController>(
                      builder: (context, ctrl, userCtrl, _) {
                        final isPremium =
                            userCtrl.currentUser?.isPremium ?? false;
                        final colorScheme = Theme.of(context).colorScheme;

                        return ListView.builder(
                          controller: scrollController,
                          itemCount: FontOption.values.length,
                          itemBuilder: (context, index) {
                            final font = FontOption.values[index];
                            final selected = ctrl.currentFont == font;
                            final isFree = index < 3; // 👈 first 3 free
                            final isLocked = !isFree && !isPremium;

                            return ListTile(
                              onTap: () {
                                if (isLocked) {
                                  Navigator.pop(context);
                                  SubscriptionScreen.show(context);
                                  return;
                                }
                                ctrl.setFont(font);
                                Navigator.pop(context);
                              },
                              title: Opacity(
                                opacity: isLocked ? 0.55 : 1.0,
                                child: Text(
                                  font.label,
                                  style: AppFonts.getTextTheme(font)
                                      .titleMedium
                                      ?.copyWith(
                                        color: colorScheme.onSurface,
                                      ),
                                ),
                              ),
                              trailing: isLocked
                                  ? Icon(
                                      Icons.workspace_premium_rounded,
                                      size: 16,
                                      color:
                                          colorScheme.primary.withOpacity(0.5),
                                    )
                                  : Icon(
                                      selected
                                          ? Icons.check_circle_rounded
                                          : Icons.radio_button_unchecked,
                                      color: selected
                                          ? colorScheme.primary
                                          : colorScheme.outline,
                                    ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<SettingController, UserController>(
      builder: (context, controller, userCtrl, child) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        final isPremium = userCtrl.currentUser?.isPremium ?? false;
        final fontIndex = FontOption.values.indexOf(controller.currentFont);
        final currentFontLocked = fontIndex >= 3 && !isPremium;

        return InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => _showFonts(context),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.pinkAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.font_download_rounded,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Font",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Customize typography",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 👇 show crown if current font is a premium one
                    if (currentFontLocked)
                      Icon(
                        Icons.workspace_premium_rounded,
                        size: 14,
                        color: colorScheme.primary.withOpacity(0.5),
                      )
                    else
                      Text(
                        controller.currentFont.label,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: AppFonts.getTextTheme(
                            controller.currentFont,
                          ).bodyMedium?.fontFamily,
                        ),
                      ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
