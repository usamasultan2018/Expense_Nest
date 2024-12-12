import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class CustomImagePicker {
  static final ImagePicker _picker = ImagePicker();

  // Method to pick multiple images
  static Future<List<File>> pickImages({required ImageSource source}) async {
    List<File> images = [];
    try {
      // Pick multiple images
      final List<XFile>? pickedFiles = await _picker.pickMultiImage();

      if (pickedFiles != null) {
        for (var pickedFile in pickedFiles) {
          images.add(File(pickedFile.path));
        }
      }
    } catch (e) {
      debugPrint("Error picking images: $e");
    }
    return images;
  }

  // Method to pick a single image
  static Future<File?> pickImage({required ImageSource source}) async {
    File? image;
    try {
      // Pick a single image
      final XFile? pickedFile = await _picker.pickImage(source: source);

      if (pickedFile != null) {
        image = File(pickedFile.path);
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
    return image;
  }
}
