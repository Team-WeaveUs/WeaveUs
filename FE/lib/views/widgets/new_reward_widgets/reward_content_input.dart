import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/new_reward_controller.dart';

class RewardContentInput extends StatelessWidget {
  final TextEditingController controller;

  const RewardContentInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20),
      child: TextField(
        controller: controller,
        onChanged: (value) {
          Get.find<NewRewardController>().setTitle(value);
        },
        style: const TextStyle(
          fontSize: 20,
          fontFamily: 'Pretendard',
          color: Colors.black,
          letterSpacing: 0.5,
        ),
        decoration: const InputDecoration(
          hintText: '리워드 이름을 적어주세요.',
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
