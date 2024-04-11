import 'package:flutter/material.dart';

class ImageThumb extends StatelessWidget {
  final String imageURL;

  const ImageThumb({super.key, required this.imageURL});

  @override
  Widget build(BuildContext context) {
    // debugInvertOversizedImages = true;
    return Image.network(
      imageURL,
      cacheWidth: 200,
      cacheHeight: 250,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        } else {
          return CircularProgressIndicator(
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
