import 'package:flutter/material.dart';

class RelativeSizeImage extends StatelessWidget {
  final String imageURL;

  const RelativeSizeImage({super.key, required this.imageURL});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageURL,
      width: 800,
      height: 600,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        } else {
          return LinearProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!.toDouble()
                : null,
          );
        }
      },
      errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
    );
  }
}
