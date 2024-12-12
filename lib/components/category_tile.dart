import 'package:expense_tracker/utils/helpers/geticons.dart';
import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  final IconData iconData;
  final VoidCallback onpressed;
  final String title;
  final Color bckColor;
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
                color: bckColor.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
              child: Icon(
                iconData,
                color: getCategoryDarkColor(title),
                size: 20,
              ),
            ),
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
