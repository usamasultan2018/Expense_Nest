import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final File? localImage;
  final String? networkImageUrl;
  final String placeholderImagePath;

  final double radius;

  final Color borderColor;
  final double borderWidth;

  final double shadowBlurRadius;
  final Offset shadowOffset;
  final double shadowOpacity;

  final VoidCallback? onTap;

  const ProfileAvatar({
    super.key,
    this.localImage,
    this.networkImageUrl,
    this.placeholderImagePath = 'assets/images/boy.png',
    this.radius = 60,
    this.borderColor = Colors.blue,
    this.borderWidth = 2.5,
    this.shadowBlurRadius = 10,
    this.shadowOffset = const Offset(0, 2),
    this.shadowOpacity = 0.25,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: borderWidth > 0
              ? Border.all(
                  color: borderColor,
                  width: borderWidth,
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: primaryColor.withValues(alpha: shadowOpacity),
              blurRadius: shadowBlurRadius,
              offset: shadowOffset,
            ),
          ],
        ),
        child: ClipOval(
          child: _buildImage(),
        ),
      ),
    );
  }

  Widget _buildImage() {
    // Local image
    if (localImage != null && localImage!.existsSync()) {
      return Image.file(
        localImage!,
        fit: BoxFit.cover,
      );
    }

    // Network image
    if (networkImageUrl != null && networkImageUrl!.trim().isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: networkImageUrl!,
        fit: BoxFit.cover,
        placeholder: (_, __) => _placeholder(),
        errorWidget: (_, __, ___) => _placeholder(),
      );
    }

    // Fallback placeholder
    return _placeholder();
  }

  Widget _placeholder() {
    return Image.asset(
      placeholderImagePath,
      fit: BoxFit.cover,
    );
  }
}
