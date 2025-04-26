import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/new_post_controller.dart';

class PostTagInput extends StatelessWidget {
  final TextEditingController controller;
  final NewPostController newPostController = Get.find<NewPostController>();

  PostTagInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 기존 입력창 유지
        Padding(
          padding: const EdgeInsets.only(right: 20, left: 20),
          child: TextField(
            controller: controller,
            style: const TextStyle(
              fontSize: 20,
              fontFamily: 'Pretendard',
              color: Colors.black,
              letterSpacing: 0.5,
            ),
            decoration: const InputDecoration(
              hintText: '#태그를 추가해주세요.',
              hintStyle: TextStyle(
                fontSize: 20,
                fontFamily: 'Pretendard',
                color: Colors.grey,
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
            maxLines: null,
            keyboardType: TextInputType.multiline,
            onSubmitted: (value) {
              newPostController.addTag(value);
            },
          ),
        ),
        const SizedBox(height: 10),

        // 추가된 태그 리스트 표시
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Obx(() => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: newPostController.tags.map((tag) => Chip(
              label: Text(tag),
              deleteIcon: const Icon(Icons.close),
              onDeleted: () {
                newPostController.removeTag(tag);
              },
            )).toList(),
          )),
        ),
      ],
    );
  }
}
