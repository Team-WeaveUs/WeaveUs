import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/new_reward_controller.dart';

import '../widgets/new_post_widgets/post_content.input.dart';
import '../widgets/new_reward_widgets/reward_content_input.dart';

class NewRewardView extends GetView<NewRewardController> {
  const NewRewardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('새 리워드', style: TextStyle(color: Colors.black,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w900,
          )),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(color: Colors.grey[850], thickness: 1),
              RewardContentInput(
                  controller: controller.rewardContentController),
              Divider(color: Colors.grey[850], thickness: 1),
              PostContentInput(
                controller: controller.postContentController,
                onChanged: controller.setDescription,
              ),
              const SizedBox(height: 16),
              const Text('지급일로부터 만료일자'),
              const SizedBox(height: 8),
              Obx(() => DropdownButton<String>(
                    value: controller.validityString.value,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        controller.validityString.value = newValue;
                      }
                    },
                    items: [
                      DropdownMenuItem(
                        value: '30d',
                        child: Text('30일'),
                      ),
                      DropdownMenuItem(
                        value: '60d',
                        child: Text('60일'),
                      ),
                      // 필요하면 더 추가 가능
                      DropdownMenuItem(
                        value: '90d',
                        child: Text('90일'),
                      ),
                      DropdownMenuItem(
                        value: '0d',
                        child: Text('무제한'),
                      ),
                    ],
                  )),
              TextField(
                controller: controller.passwordController,
                decoration: const InputDecoration(labelText: '비밀번호'),
                obscureText: true,
              ),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: controller.submitReward,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 80),
                  ),
                  child: const Text('리워드 생성하기'),
                ),
              ),
            ],
          ),
        ));
  }
}
