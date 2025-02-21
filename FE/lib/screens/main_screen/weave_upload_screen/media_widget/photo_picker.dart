import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';

class PhotoPicker {
  static Future<void> selectPhotos({
    required List<String> selectedFiles,
    required Function(List<String>) onImagesSelected,
    required BuildContext context,
  }) async {
    int maxImages = 9;

    // 이미지는 최대 9장 추가 가능

    if (selectedFiles.length >= maxImages) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("이미지는 최대 9개까지 추가할 수 있습니다.")),
      );
      return;
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true, // 여러 개 선택 가능
    );

    // 비디오 있을땐 최대 8장 사진 가능
    if (result != null && result.files.isNotEmpty) {
      List<String> newImages = [];
      int currentImageCount = selectedFiles.length;

      for (var file in result.files) {
        if (currentImageCount + newImages.length < maxImages) {
          if (kIsWeb && file.bytes != null) {
            newImages.add('data:image/jpeg;base64,${base64Encode(file.bytes!)}');
          } else {
            newImages.add(file.path!);
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("이미지는 최대 $maxImages개까지 추가할 수 있습니다.")),
          );
          break;
        }
      }

      if (newImages.isNotEmpty) onImagesSelected(newImages);
    }
  }
}
