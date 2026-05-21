import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart'; // Import the flutter_animate package

class FadeTransitionEffect extends StatelessWidget {
  final Widget child;

  const FadeTransitionEffect({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child.animate().fadeIn(duration: 500.ms, curve: Curves.easeIn);
  }
}
