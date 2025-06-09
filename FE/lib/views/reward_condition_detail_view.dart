import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../controllers/reward_condition_detail_controller.dart';

class RewardConditionDetailView
    extends GetView<RewardConditionDetailController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Obx(() => controller.rewardCondition.value.type.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Text(controller.rewardCondition.value.name))),
        body: Center(
            child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Column(children: [
                  Obx(() {
                    if (controller.rewardCondition.value.type.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (controller.rewardCondition.value.type ==
                        'RANDOM_THRESHOLD') {
                      return const Column(children: [
                        Icon(HugeIcons.strokeRoundedFilterReset,
                            color: Colors.black54),
                        Text("좋아요 추첨 지급")
                      ]);
                    } else if (controller.rewardCondition.value.type ==
                        'TOP_LIKED') {
                      return const Column(children: [
                        Icon(HugeIcons.strokeRoundedRanking,
                            color: Colors.black54),
                        Text("좋아요 상위 지급")
                      ]);
                    } else if (controller.rewardCondition.value.type ==
                        'RANDOM_AUTHOR') {
                      return const Column(children: [
                        Icon(HugeIcons.strokeRoundedDice,
                            color: Colors.black54),
                        Text("작성자 추첨 지급")
                      ]);
                    } else if (controller.rewardCondition.value.type ==
                        'INSERT') {
                      return const Column(children: [
                        Icon(HugeIcons.strokeRoundedGiveBlood,
                            color: Colors.black54),
                        Text("직접 지급")
                      ]);
                    } else if (controller.rewardCondition.value.type ==
                        'FIRST_N') {
                      return const Column(children: [
                        Icon(HugeIcons.strokeRoundedMedalFirstPlace,
                            color: Colors.black54),
                        Text("선착순 지급")
                      ]);
                    } else {
                      return const Icon(HugeIcons.strokeRoundedTicketStar,
                          color: Colors.black54);
                    }
                  }),
                  Text(controller.rewardCondition.value.name),
                  Text(controller.rewardCondition.value.description),
                  Text(
                      "리워드 총량 : ${controller.rewardCondition.value.rewardCount.toString()}"),
                ]))));
  }
}
