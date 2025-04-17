import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeleteImageDialog extends StatelessWidget {
  final VoidCallback onDelete;

  const DeleteImageDialog({super.key, required this.onDelete});

  // 추후 디자인 수정 예정
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("사진을 삭제하시겠습니까?"),
      actions: [
        TextButton(
          onPressed: () {
            onDelete();
            Get.back();
          },
          child: const Text("예"),
        ),
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text("아니오"),
        ),
      ],
    );
  }
}