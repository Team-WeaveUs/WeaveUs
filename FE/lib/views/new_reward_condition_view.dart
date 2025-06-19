import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/new_reward_condition_controller.dart';

class NewRewardConditionView extends GetView<RewardConditionController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('새 리워드 조건'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Obx(() => Column(
          children: [
            TextField(
              controller: controller.titleController,
              decoration: InputDecoration(labelText: '조건 이름'),
            ),
            TextField(
              controller: controller.descriptionController,
              decoration: InputDecoration(labelText: '조건 설명'),
            ),
            TextField(
              controller: controller.counterController,
              decoration: InputDecoration(labelText: '리워드 총량'),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
            DropdownButton<String>(
              value: controller.selectedCode.value,
              items: controller.rewardTypes.entries.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  controller.selectedCode.value = value;
                }
              },
            ),
            if (controller.selectedCode.value == 'RANDOM_THRESHOLD' || controller.selectedCode.value == 'TOP_LIKED')
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  decoration: InputDecoration(labelText: '좋아요 수'),
                  controller: controller.likeCountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
              ),
            TextButton(onPressed: controller.createRewardCondition, child: const Text("리워드 조건 생성하기"))
          ],
        ),
      ))
    );
  }

}