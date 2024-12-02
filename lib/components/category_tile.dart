import 'package:expense_tracker/utils/helpers/geticons.dart';
import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  final String iconData;
  final VoidCallback onpressed;
  final String title;
  final String bckColor;
  const CategoryTile(
      {super.key,
      required this.iconData,
      required this.onpressed,
      required this.title,
      required this.bckColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onpressed,
      child: Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: getColorFromHex(bckColor).withOpacity(0.2),
                ),
                child: getIconFromName(iconData, bckColor)),
            SizedBox(
              width: 10,
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
