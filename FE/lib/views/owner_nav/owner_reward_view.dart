import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weave_us/views/components/bottom_nav_bar.dart';
import 'package:weave_us/views/widgets/new_post_widgets/post_content.input.dart';
import 'package:weave_us/views/widgets/owner_reward_post_widgets/reward_content_input.dart';
import '../../controllers/owner_reward_controller.dart';
import '../components/app_nav_bar.dart';


class OwnerRewardView extends GetView<OwnerRewardController> {
  const OwnerRewardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavBar(title: '새 리워드', centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(color: Colors.grey[850], thickness: 1),
            RewardContentInput(controller: controller.rewardContentController),
            Divider(color: Colors.grey[850], thickness: 1),
            PostContentInput(
              controller: controller.postContentController,
              onChanged: controller.setDescription,
            ),
            const SizedBox(height: 16),
            const Text('시작 날짜'),
            Obx(() => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.today),
              title: Text(
                controller.startDate.value != null
                    ? '${controller.startDate.value!.year}/${controller.startDate.value!.month}/${controller.startDate.value!.day}'
                    : '시작일을 선택해주세요',
              ),
              onTap: () => controller.pickDate(context, true),
            )),
            const Text('만료 날짜'),
            Obx(() => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.event),
              title: Text(
                controller.endDate.value != null
                    ? '${controller.endDate.value!.year}/${controller.endDate.value!.month}/${controller.endDate.value!.day}'
                    : '만료일을 선택해주세요',
              ),
              onTap: () => controller.pickDate(context, false),
            )),
            const SizedBox(height: 8),
            Obx(() => Text(
              '계산된 유효기간: ${controller.validityString}',
              style: const TextStyle(color: Colors.redAccent),
            )),
            const SizedBox(height: 16),
            const Text('조건'),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: controller.submitReward,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 80),
                ),
                child: const Text('공유하기'),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}
