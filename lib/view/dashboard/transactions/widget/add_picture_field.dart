import 'dart:io';

import 'package:expense_tracker/view%20model/transaction_controller/transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class AddPictureField extends StatelessWidget {
  const AddPictureField({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionController>(
      builder:
          (BuildContext context, TransactionController value, Widget? child) {
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(FontAwesomeIcons.camera),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Take Photo",
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      value.pickSingleImage();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(FontAwesomeIcons.photoFilm),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Gallery",
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: value.images.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0),
                itemBuilder: (context, index) {
                  dynamic image = value.images[index];

                  return Container(
                    alignment: Alignment.topRight,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: image is File
                                ? FileImage(image) // Local file image
                                : NetworkImage(image) as ImageProvider)),
                    child: IconButton(
                        onPressed: () {
                          value.removeImageAtIndex(index);
                        },
                        icon: Icon(
                          Icons.close,
                          color: Colors.red,
                        )),
                  );
                }),
          ],
        );
      },
    );
  }
}
