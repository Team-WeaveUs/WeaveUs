import 'package:flutter/material.dart';

class NewNameInput extends StatelessWidget {
  final TextEditingController controller;

  const NewNameInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
