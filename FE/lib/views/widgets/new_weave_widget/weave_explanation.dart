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
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '위브 소개',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              fontFamily: 'Pretendard',
            ),
          ),
          TextField(
            controller: controller,
            focusNode: focusNode,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              fontFamily: 'Pretendard',
              color: Colors.black,
              letterSpacing: 1,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: '위브를 소개해주세요.',
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 20,
                fontWeight: FontWeight.w400,
                fontFamily: 'Pretendard',
              ),
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
            maxLines: null,
            keyboardType: TextInputType.multiline,
          ),
        ],
      ),
    );
  }
}
