import 'package:flutter/material.dart';

import '../../../../core/App_Colors/Colors.dart';

class PollOptionImage extends StatelessWidget {
  final String? imageUrl;

  const PollOptionImage({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),

        child: Container(
          width: 48,

          height: 48,

          color: AppColors.grey.withOpacity(0.2),

          child: Icon(Icons.image_not_supported, color: AppColors.grey),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),

      child: Image.network(
        imageUrl!,

        width: 48,

        height: 48,

        fit: BoxFit.cover,

        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }

          return const SizedBox(
            width: 48,

            height: 48,

            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        },

        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 48,

            height: 48,

            color: AppColors.grey.withOpacity(0.2),

            child: Icon(Icons.broken_image, color: AppColors.grey),
          );
        },
      ),
    );
  }
}
