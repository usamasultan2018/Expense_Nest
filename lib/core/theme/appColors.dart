// utils/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const Color primary = Color(0xff00b2e7);
  static const Color secondary = Color(0xffe064f7);
  static const Color tertiary = Color(0xffff8d6c);

  // Basic colors
  static const Color surface = Color(0xfff3f4f6);
  static const Color outline = Colors.grey;
  static const Color onSurface = Colors.black;
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  // Additional colors
  static const Color green = Color.fromARGB(255, 100, 225, 104);
  static const Color orange = Color(0xffffa726);
  static const Color grey = Colors.grey;
  static const Color lightGrey = Color(0xffd3d3d3);
  static const Color darkGrey = Color(0xff616161);
  static const Color blue = Color(0xff2196F3);
  static const Color red = Color.fromARGB(255, 236, 78, 67);
  static const Color yellow = Color(0xffFFEB3B);

  // Soft/pastel colors for backgrounds or highlights
  static const Color softBlue = Color(0xffbbdefb);
  static const Color softGreen = Color(0xffc8e6c9);
  static const Color softOrange = Color(0xffffe0b2);
  static const Color softRed = Color(0xffffcdd2);
  static const Color softYellow = Color(0xfffff9c4);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      primary,
      secondary,
      tertiary,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Optional: You can add more gradients as needed
  static const LinearGradient softGradient = LinearGradient(
    colors: [
      softBlue,
      softGreen,
      softOrange,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
