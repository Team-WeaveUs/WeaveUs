import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class SelectedMediaWidget extends StatelessWidget {
  final List<String> selectedFiles;
  final Function(int) onImageRemove;
  final VoidCallback onAddMedia;

  const SelectedMediaWidget({
    super.key,
    required this.selectedFiles,
    required this.onImageRemove,
    required this.onAddMedia,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
                // 이미지 UI 추가
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 3,
            mainAxisSpacing: 3,
          ),
          itemCount: selectedFiles.length + (selectedFiles.length < 9 ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == selectedFiles.length && selectedFiles.length < 9) {
              return GestureDetector(
                onTap: onAddMedia,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Icon(Icons.add_a_photo, size: 40, color: Colors.black54),
                  ),
                ),
              );
            }

            return Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: kIsWeb && selectedFiles[index].startsWith('data:image')
                      ? Image.network(selectedFiles[index])
                      : Image.file(File(selectedFiles[index]), fit: BoxFit.cover),
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: GestureDetector(
                    onTap: () => onImageRemove(index),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(60),
                      ),
                      height: 25,
                      width: 25,
                      child: const Icon(Icons.close, color: Colors.black, size: 20),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
