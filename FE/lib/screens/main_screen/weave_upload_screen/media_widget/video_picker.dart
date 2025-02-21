import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';

class VideoPicker {
  static Future<void> selectVideo({
    required String? selectedVideo,
    required Function(String) onVideoSelected,
    required BuildContext context,
  }) async {
    if (selectedVideo != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("영상은 최대 1개만 추가 가능합니다.")),
      );
      return;
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: false, // 영상은 1개만 선택 가능
    );

    if (result != null && result.files.isNotEmpty) {
      String videoPath;

      var file = result.files.first;
      if (kIsWeb && file.bytes != null) {
        videoPath = "data:video/mp4;base64,${base64Encode(file.bytes!)}";
      } else {
        videoPath = file.path!;
      }

      onVideoSelected(videoPath);
    }
  }
}