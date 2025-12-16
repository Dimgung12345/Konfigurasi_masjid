import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

class UploadCard extends StatelessWidget {
  final String? imageUrl;
  final VoidCallback onPickFile;
  final double height;

  const UploadCard({
    super.key,
    this.imageUrl,
    required this.onPickFile,
    this.height = 180,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPickFile,
      child: imageUrl != null && imageUrl!.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: height,
              ),
            )
          : DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(12),
              dashPattern: const [6, 3],
              color: Colors.grey,
              strokeWidth: 1.5,
              child: Container(
                width: double.infinity,
                height: height,
                color: Colors.grey[200],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.add, size: 40, color: Colors.grey),
                    SizedBox(height: 8),
                    Text(
                      "Drag & Drop file(s)\nOr Browse",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}