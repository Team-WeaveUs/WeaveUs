import 'package:flutter/material.dart';

class PostContentInput extends StatelessWidget {
  final TextEditingController controller;

  const PostContentInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: const InputDecoration(
        hintText: '게시물 내용을 입력하세요...',
        border: OutlineInputBorder(),
      ),
      maxLines: 3,
    );
  }
}