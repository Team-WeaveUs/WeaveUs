import 'package:flutter/material.dart';

class WeaveExplanation extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  const WeaveExplanation({
    super.key,
    required this.controller,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        maxLines: 5,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: '위브 설명을 입력해주세요.',
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
