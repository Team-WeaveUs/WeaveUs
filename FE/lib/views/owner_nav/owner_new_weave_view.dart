import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:weave_us/routes/app_routes.dart';
import '../../controllers/owner_new_weave_controller.dart';

import '../widgets/new_weave_widget/new_name.input.dart';
import '../widgets/new_weave_widget/weave_explanation.dart';
import '../widgets/reward_invite_dialog.dart';
import '../widgets/new_reward_widgets/reward_selector_widget.dart';
import 'map_section.dart';

class OwnerNewWeaveView extends GetView<OwnerNewWeaveController> {
  const OwnerNewWeaveView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () => Get.offAllNamed(AppRoutes.HOME),
            icon: Icon(Icons.arrow_back_outlined)),
        centerTitle: true,
        title: const Text(
          '새 Join 위브',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 25,
            letterSpacing: 1.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(color: Colors.grey[850], thickness: 1),
            NewNameInput(
              controller: controller.nameController,
              focusNode: controller.nameFocusNode,
            ),
            Divider(color: Colors.grey[850], thickness: 1),
            WeaveExplanation(
              controller: controller.descriptionController,
              focusNode: controller.descriptionFocusNode,
            ),
            Divider(color: Colors.grey[850], thickness: 1),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const SizedBox(
                    width: 20,
                  ),
                  const Text(
                    '리워드 선택',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Pretendard',
                    ),
                  ),
                ]),
                // ✅ 리워드 선택 위젯
                Obx(() => RewardSelector(
                      selectedReward: controller.selectedRewardText.value,
                      onRewardSelected: () {
                        Get.dialog(
                          RewardInviteDialog(
                            onRewardSelected: (rewardModel) {
                              controller.selectReward(
                                // 표시용 텍스트
                                rewardModel.title,
                                rewardModel.rewardId, // 실제 rewardId
                              );
                            },
                          ),
                        );
                      },
                    )),
                // ✅ 지급 조건 선택 위젯
                Obx(
                  () => controller.selectedRewardText.value == ''
                      ? const SizedBox.shrink()
                      : controller.rewardConditionList.isEmpty
                          ? Container(child: CircularProgressIndicator())
                          : Column(
                              children: [
                                Divider(color: Colors.grey[850], thickness: 1),
                                ListTile(
                                    title: Text('리워드 지급조건 설정'),
                                    trailing:
                                        Icon(Icons.arrow_forward_ios_rounded),
                                    onTap: () {
                                      Get.dialog(Obx(() => Dialog(
                                          backgroundColor: Colors.white,
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    TextField(
                                                      controller: controller
                                                          .rewardConditionFilter,
                                                      onChanged: controller
                                                          .filterRewardCondition,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: "리워드 조건 검색",
                                                        prefixIcon: const Icon(
                                                            Icons.search),
                                                        border:
                                                            OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8)),
                                                      ),
                                                    ),
                                                    ListView(
                                                      shrinkWrap: true,
                                                      padding: EdgeInsets.zero,
                                                      children: controller
                                                          .filteredRewardConditionList
                                                          .map((condition) {
                                                        return ListTile(
                                                          contentPadding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      8.0),
                                                          leading: () {
                                                            final reward =
                                                                condition;
                                                            if (reward.type ==
                                                                'RANDOM_AUTHOR') {
                                                              return Icon(
                                                                  HugeIcons
                                                                      .strokeRoundedDice,
                                                                  color: Colors
                                                                      .black54);
                                                            } else if (reward
                                                                    .type ==
                                                                'TOP_LIKED') {
                                                              return Icon(
                                                                  HugeIcons
                                                                      .strokeRoundedRanking,
                                                                  color: Colors
                                                                      .black54);
                                                            } else if (reward
                                                                    .type ==
                                                                'INSERT') {
                                                              return Icon(
                                                                  HugeIcons
                                                                      .strokeRoundedGiveBlood,
                                                                  color: Colors
                                                                      .black54);
                                                            } else if (reward
                                                                    .type ==
                                                                'RANDOM_THRESHOLD') {
                                                              return Icon(
                                                                  HugeIcons
                                                                      .strokeRoundedFilterReset,
                                                                  color: Colors
                                                                      .black54);
                                                            } else if (reward
                                                                    .type ==
                                                                'FIRST_N') {
                                                              return Icon(
                                                                  HugeIcons
                                                                      .strokeRoundedMedalFirstPlace,
                                                                  color: Colors
                                                                      .black54);
                                                            } else {
                                                              return Icon(
                                                                  HugeIcons
                                                                      .strokeRoundedTicketStar,
                                                                  color: Colors
                                                                      .black54);
                                                            }
                                                          }(),
                                                          title: Text(
                                                            condition.name,
                                                            textAlign:
                                                                TextAlign.left,
                                                          ),
                                                          onTap: () {
                                                            controller
                                                                    .rewardConditionId
                                                                    .value =
                                                                condition.id;
                                                            controller
                                                                    .rewardConditionName
                                                                    .value =
                                                                condition.name;
                                                            controller
                                                                    .rewardConditionType
                                                                    .value =
                                                                condition.type;
                                                            Get.back();
                                                          },
                                                        );
                                                      }).toList(),
                                                    )
                                                  ])))));
                                    }),
                                controller.rewardConditionName.value == ""
                                    ? const SizedBox.shrink()
                                    : ListTile(
                                        leading: () {
                                          final reward = controller
                                              .rewardConditionType.value;
                                          if (reward == 'RANDOM_AUTHOR') {
                                            return Icon(
                                                HugeIcons.strokeRoundedDice,
                                                color: Colors.black54);
                                          } else if (reward == 'TOP_LIKED') {
                                            return Icon(
                                                HugeIcons.strokeRoundedRanking,
                                                color: Colors.black54);
                                          } else if (reward == 'INSERT') {
                                            return Icon(
                                                HugeIcons
                                                    .strokeRoundedGiveBlood,
                                                color: Colors.black54);
                                          } else if (reward ==
                                              'RANDOM_THRESHOLD') {
                                            return Icon(
                                                HugeIcons
                                                    .strokeRoundedFilterReset,
                                                color: Colors.black54);
                                          } else if (reward == 'FIRST_N') {
                                            return Icon(
                                                HugeIcons
                                                    .strokeRoundedMedalFirstPlace,
                                                color: Colors.black54);
                                          } else {
                                            return Icon(
                                                HugeIcons
                                                    .strokeRoundedTicketStar,
                                                color: Colors.black54);
                                          }
                                        }(),
                                        title: Text(controller
                                            .rewardConditionName.value),
                                      )
                              ],
                            ),
                ),
                // ✅ 지도 위젯
                Divider(color: Colors.grey[850], thickness: 1),
                const SizedBox(height: 10),
                Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GestureDetector(
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: controller.selectedDate.value,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2099),
                          );
                          if (picked != null) {
                            controller.selectedDate.value = picked;
                            print(controller.selectedDate.value);
                          }
                        },
                        child: Obx(() => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("종료 날짜 선택",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                      )),
                                  Text(
                                      "${controller.selectedDate.value.toString().split(' ')[0]}",
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontFamily: 'Pretendard',
                                      ))
                                ])))),
                const SizedBox(height: 10),
                Divider(color: Colors.grey[850], thickness: 1),
                const SizedBox(height: 10),
                const MapSection(),
                const SizedBox(height: 10),
                Divider(color: Colors.grey[850], thickness: 1),
                const SizedBox(height: 10),
                // ✅ 생성 버튼
                Obx(() => SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ElevatedButton(
                          onPressed: controller.isFormValid.value
                              ? controller.createJoinWeave
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF434343),
                            disabledBackgroundColor: Colors.grey.shade300,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              "위브 생성",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Pretendard',
                              ),
                            ),
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
