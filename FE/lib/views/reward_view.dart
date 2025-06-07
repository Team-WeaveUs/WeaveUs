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
      backgroundColor: Colors.white,
      appBar: AppNavBar(title: '리워드'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
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
                          return GestureDetector(
                            onTap: reward.isUsed == 1
                                ? () {
                              Get.snackbar("오류", "이미 사용된 리워드입니다.");
                            }
                                : () {
                              Get.toNamed(
                                AppRoutes.REWARD_DETAIL,
                                arguments: {'reward': reward},
                              );
                            },
                              child: _buildRewardItem(
                                title: reward.title,
                                subtitle: reward.grantedByNickname,
                                reward: reward,
                              )
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
        color: reward.isUsed == 1 ? Colors.grey[200] : Colors.white,
      ),
      child: Row(
        children: [
          Icon(HugeIcons.strokeRoundedTicketStar, color: reward.isUsed == 1 ? Colors.grey : Colors.black),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: reward.isUsed == 1 ? const TextStyle(color: Colors.grey) : TextStyle(fontWeight: FontWeight.bold)),
                Text(subtitle, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
