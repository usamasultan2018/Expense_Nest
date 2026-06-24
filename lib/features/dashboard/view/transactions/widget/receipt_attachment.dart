// receipt_attachment.dart
// lib/features/dashboard/view/transactions/widget/receipt_attachment.dart

import 'dart:io';
import 'package:expense_tracker/core/components/custom_button.dart';
import 'package:expense_tracker/core/utils/image_picker.dart';
import 'package:expense_tracker/features/dashboard/view/profile/controller/user_controller.dart';
import 'package:expense_tracker/features/subscription/screens/subscription_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReceiptAttachment extends StatelessWidget {
  const ReceiptAttachment({
    super.key,
    this.imageFile,
    this.imageUrl,
    required this.onImagePicked,
    required this.onRemove,
  });

  final File? imageFile;
  final String? imageUrl;
  final ValueChanged<File> onImagePicked;
  final VoidCallback onRemove;

  bool get _hasImage =>
      imageFile != null || (imageUrl != null && imageUrl!.isNotEmpty);

  Future<void> _pick(
    BuildContext context,
    ImageSource source,
    bool isPremium,
  ) async {
    if (!isPremium) {
      SubscriptionScreen.show(context);
      return;
    }
    final file = await CustomImagePicker.pickImage(source: source);
    if (file != null) onImagePicked(file);
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<UserController>();
    final isPremium = controller.isLoading
        ? false
        : controller.currentUser?.isPremium ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Receipt Attachment",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 10),
        if (_hasImage) ...[
          _ReceiptPreview(
            imageFile: imageFile,
            imageUrl: imageUrl,
            onRemove: onRemove,
          ),
          const SizedBox(height: 10),
        ],
        Row(
          children: [
            Expanded(
              child: RoundButton(
                title: _hasImage ? "Retake" : "Camera",
                onPressed: () => _pick(context, ImageSource.camera, isPremium),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: RoundButton(
                title: _hasImage ? "Replace" : "Gallery",
                onPressed: () => _pick(context, ImageSource.gallery, isPremium),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
// ─── Preview card ─────────────────────────────────────────────────────────────

class _ReceiptPreview extends StatelessWidget {
  const _ReceiptPreview({
    this.imageFile,
    this.imageUrl,
    required this.onRemove,
  });

  final File? imageFile;
  final String? imageUrl;
  final VoidCallback onRemove;

  ImageProvider get _provider => imageFile != null
      ? FileImage(imageFile!)
      : NetworkImage(imageUrl!) as ImageProvider;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        // Thumbnail — tap to view full screen
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (_) => _FullScreenReceipt(provider: _provider),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image(
              image: _provider,
              width: double.infinity,
              height: 160,
              fit: BoxFit.cover,
            ),
          ),
        ),

        // Remove button
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.close_rounded,
                size: 16,
                color: colorScheme.error,
              ),
            ),
          ),
        ),

        // Tap-to-expand hint
        Positioned(
          bottom: 8,
          left: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.zoom_in_rounded, size: 12, color: Colors.white),
                SizedBox(width: 4),
                Text(
                  'Tap to view',
                  style: TextStyle(color: Colors.white, fontSize: 11),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Full-screen viewer ───────────────────────────────────────────────────────

class _FullScreenReceipt extends StatelessWidget {
  const _FullScreenReceipt({required this.provider});
  final ImageProvider provider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Receipt'),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: Image(image: provider, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
