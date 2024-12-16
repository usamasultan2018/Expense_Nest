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
                    onTap: () {
                      value.pickImageCamera();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
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
                          const Icon(FontAwesomeIcons.camera),
                          const SizedBox(
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
                      value.pickImageGallery();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
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
                          const Icon(FontAwesomeIcons.photoFilm),
                          const SizedBox(
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
            const SizedBox(
              height: 10,
            ),
            (value.imageUrlTrasaction.isNotEmpty || value.images != null)
                ? Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: value.images != null
                            ? FileImage(value
                                .images!) // Use FileImage if images is not null
                            : value.imageUrlTrasaction.isNotEmpty
                                ? NetworkImage(value
                                    .imageUrlTrasaction) // Network image if URL is not empty
                                : const AssetImage(
                                        'assets/placeholder_image.png')
                                    as ImageProvider, // Placeholder image if no image is found
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () {
                          value.removeImage(); // Remove image on button press
                        },
                        icon: const Icon(Icons.close, color: Colors.red),
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        );
      },
    );
  }
}
