import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceModal extends StatelessWidget {
  const ImageSourceModal({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Text('Image Source'),
          const Spacer(),
          IconButton.outlined(
            onPressed: () {
              Navigator.pop(context, null);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context, ImageSource.camera);
            },
            icon: const Icon(Icons.camera_alt),
            label: const Text("Camera"),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context, ImageSource.gallery);
            },
            icon: const Icon(Icons.browse_gallery),
            label: const Text("Gallery"),
          ),
        ],
      ),
    );
  }
}
