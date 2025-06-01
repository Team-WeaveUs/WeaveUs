import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

import '../controllers/reward_controller.dart';
import '../models/reward_model.dart';
import '../routes/app_routes.dart';
import 'components/app_nav_bar.dart';
import 'components/bottom_nav_bar.dart';

class RewardView extends GetView<RewardController> {
  const RewardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Obx(() => !controller.isOwner.value
          ? const SizedBox.shrink()
          : FloatingActionButton(
              onPressed: () {
                Get.toNamed(AppRoutes.NEW_REWARDS);
              },
              child: Icon(HugeIcons.strokeRoundedGift),
            )),
      appBar: AppNavBar(title: '리워드'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 검색창
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: '',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const Icon(Icons.cancel, color: Colors.grey),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
                child: Obx(() => controller.rewardList.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : ListView(
                        shrinkWrap: true,
                        children: controller.rewardList.map((reward) {
                          return _buildRewardItem(
                            title: reward.title,
                            subtitle: reward.description,
                            reward: reward,
                          );
                        }).toList())))
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }

  Widget _buildRewardItem(
      {required String title,
      required String subtitle,
      required Reward reward}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(HugeIcons.strokeRoundedTicketStar, color: Colors.black54),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(subtitle, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: reward.isUsed == 1
                ? null
                : () {
                    Get.toNamed(
                      AppRoutes.REWARD_DETAIL,
                      arguments: {'reward': reward},
                    );
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: reward.isUsed == 1 ? Colors.grey : Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: reward.isUsed == 1 ? Colors.grey : Colors.orange,
                ),
              ),
            ),
            child: Text(reward.isUsed == 1 ? "사용됨" : "사용"),
          ),
        ],
      ),
    );
  }
}
