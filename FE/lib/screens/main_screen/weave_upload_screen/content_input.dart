import 'package:flutter/material.dart';

class PostContentInput extends StatelessWidget {
  final TextEditingController controller;

  const PostContentInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: TextField(
        controller: controller,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.black,
          letterSpacing: 1.0
        ),
        decoration: const InputDecoration(
          hintText: '게시물에 대한 설명을 적어주세요.',
          hintStyle: TextStyle(
            fontSize: 20,
            color: Colors.grey,
              letterSpacing: null
          ),
          border: InputBorder.none,
        ),
        maxLines: null,
      ),
    );
  }
}