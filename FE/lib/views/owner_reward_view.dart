import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:weave_us/views/components/app_nav_bar.dart';
import 'package:weave_us/views/components/bottom_nav_bar.dart';

import '../controllers/reward_controller.dart';
import '../models/reward_model.dart';
import '../routes/app_routes.dart';

class OwnerRewardView extends GetView<RewardController> {
  const OwnerRewardView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Builder(
        builder: (context) {
          final tabController = DefaultTabController.of(context);
          return Scaffold(
            appBar: AppNavBar(title: "내 리워드"),
            body: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: '',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Icon(Icons.cancel, color: Colors.grey),
                    ],
                  ),
                ),
                TabBar(
                  labelColor: Colors.black,
                  indicatorColor: Colors.orange,
                  onTap: (i) => controller.tabIndex.value = i,
                  tabs: const [
                    Tab(text: "리워드"),
                    Tab(text: "조건"),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      Obx(() =>
                      controller.rewardList.isEmpty
                          ? const Center(child: CircularProgressIndicator())
                          : Padding(padding: const EdgeInsets.symmetric(
                          horizontal: 10),
                          child: ListView(
                              children: controller.rewardList.map((reward) {
                                return GestureDetector(
                                    onTap: () {
                                      Get.toNamed(
                                        AppRoutes.REWARD_DETAIL,
                                        arguments: {'reward': reward},
                                      );
                                    },
                                    child: _buildRewardItem(
                                      title: reward.title,
                                      subtitle: reward.description,
                                      reward: reward,
                                    ));
                              }).toList()))),
                      Obx(() =>
                      controller.rewardConditionList.isEmpty
                          ? const Center(child: CircularProgressIndicator())
                          : Padding(padding: const EdgeInsets.symmetric(
                          horizontal: 10),
                        child: ListView(
                            children: controller.rewardConditionList.map((
                                reward) {
                              return ListTile(
                                  leading: () {
                                    if (reward.type == 'RANDOM_AUTHOR') {
                                      return Icon(HugeIcons.strokeRoundedDice, color: Colors.black54);
                                    } else if (reward.type == 'TOP_LIKED') {
                                      return Icon(HugeIcons.strokeRoundedRanking, color: Colors.black54);
                                    } else if (reward.type == 'INSERT') {
                                      return Icon(HugeIcons.strokeRoundedGiveBlood, color: Colors.black54);
                                    } else if (reward.type == 'RANDOM_THRESHOLD') {
                                      return Icon(HugeIcons.strokeRoundedFilterReset, color: Colors.black54);
                                    } else if (reward.type == 'FIRST_N') {
                                      return Icon(HugeIcons.strokeRoundedMedalFirstPlace, color: Colors.black54);
                                    }else {
                                      return Icon(HugeIcons.strokeRoundedTicketStar, color: Colors.black54);
                                    }
                                  }(),
                              title: Text(reward.name),
                              subtitle: Text(reward.description),
                                onTap: () {
                                  Get.toNamed(
                                    AppRoutes.OWNER_REWARD_DETAIL,
                                    arguments: {'reward_condition': reward},
                                  );}
                              );
                            }).toList()
                        ),
                      )
                      ),
                    ],
                  ),
                ),
              ],
            ),
            floatingActionButton: Obx(() =>
                FloatingActionButton(
                  onPressed: () {
                    final currentIndex = tabController.index;
                    if (currentIndex == 0) {
                      Get.toNamed(AppRoutes.NEW_REWARDS);
                    } else {
                      Get.toNamed(AppRoutes.REWARD_CONDITION);
                    }
                  },
                  child: controller.tabIndex.value == 0
                      ? Icon(HugeIcons.strokeRoundedGift)
                      : Icon(HugeIcons.strokeRoundedSettings01),
                )),
            bottomNavigationBar: BottomNavigation(),
          );
        },
      ),
    );
  }

  Widget _buildRewardItem({required String title,
    required String subtitle,
    required Reward reward}) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black26),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(children: [
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
        ]));
  }
}
