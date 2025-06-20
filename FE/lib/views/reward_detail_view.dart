import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:weave_us/controllers/reward_detail_controller.dart';

class RewardDetailView extends GetView<RewardDetailController> {
  const RewardDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('리워드 상세'),
        ),
        body: Obx(() => controller.reward.value.rewardId == 0
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(HugeIcons.strokeRoundedTicketStar, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      controller.reward.value.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller.reward.value.description,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (controller.reward.value.weaveTitle != '') ...[
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () => Get.toNamed('/weave/${controller.reward.value.weaveId}?from=${Get.currentRoute}'),
                        child: Text(
                          '위브: ${controller.reward.value.weaveTitle}',
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      )
                      ,
                      const SizedBox(height: 32),
                      TextField(
                        controller: controller.passwordController,
                        decoration: const InputDecoration(
                          labelText: '비밀번호',
                          hintText: '쿠폰 사용을 위한 비밀번호를 입력하세요',
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 16),
                      Obx(() => ElevatedButton(
                            onPressed: controller.isPasswordValid.value
                                ? () => controller.useReward()
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: const BorderSide(color: Colors.orange),
                              ),
                            ),
                            child: const Text('쿠폰 사용하기'),
                          )),
                    ],
                  ],
                ),
              )));
  }
}
