import 'package:flutter/material.dart';
import 'package:weave_us/screens/main_screen/weave_upload_screen/media_widget/photo_picker.dart';

class MediaPicker {
  static Future<void> selectMedia({
    required List<String> selectedFiles,
    required Function(List<String>) onImagesSelected,
    required BuildContext context,
  }) async {
    // 바텀 시트 사용 (화면 하단 모달 시트 띄움)
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('사진 선택'),
              onTap: () {
                Navigator.pop(context);
                PhotoPicker.selectPhotos(
                  selectedFiles: selectedFiles,
                  onImagesSelected: onImagesSelected,
                  context: context,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
