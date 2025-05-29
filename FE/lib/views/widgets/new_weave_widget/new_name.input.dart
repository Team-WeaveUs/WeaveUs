import 'package:flutter/material.dart';

class NewNameInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  const NewNameInput({
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
        style: const TextStyle(
          fontSize: 20,
          fontFamily: 'Pretendard',
          color: Colors.black,
          letterSpacing: 1,
        ),
        decoration: const InputDecoration(
          hintText: '위브 이름을 입력해주세요.',
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
      ),
    );
  }
}
