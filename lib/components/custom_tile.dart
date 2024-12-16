import 'package:auto_size_text/auto_size_text.dart';
import 'package:expense_tracker/utils/appColors.dart';
import 'package:flutter/material.dart';

class CustomTile extends StatelessWidget {
  final String title;
  final IconData iconData;
  final Color? bckColor;
  final Function()? onTap;

  const CustomTile({
    super.key,
    required this.title,
    required this.iconData,
    this.onTap,
    this.bckColor = AppColors.secondary,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: bckColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    iconData,
                    color: AppColors.white,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                AutoSizeText(
                  title,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
            ),
          ],
        ),
      ),
    );
  }
}
