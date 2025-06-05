import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/owner_new_weave_controller.dart';

import '../widgets/new_weave_widget/new_name.input.dart';
import '../widgets/new_weave_widget/weave_explanation.dart';
import '../widgets/reward_invite_dialog.dart';
import '../widgets/new_reward_widgets/reward_selector_widget.dart';
import 'set_latlng_on_map.dart';

class OwnerNewWeaveView extends GetView<OwnerNewWeaveController> {
  const OwnerNewWeaveView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start, // ← 요거 꼭 추가!!
                  children: [
                    // ✅ 리워드 선택 위젯
                    RewardSelector(
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
                    ),
                    Divider(color: Colors.grey[850], thickness: 1),
                    const SizedBox(height: 30),
                    // ✅ 지도 위젯
                    SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 300,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: MapSelectPin(),
                        )),
                    ElevatedButton(
                      onPressed: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2099),
                        );
                        if (picked != null) {
                          controller.selectedDate.value = picked;
                          print(controller.selectedDate.value);
                        }
                      },
                      child: const Text('날짜 선택',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Pretendard',
                          )),
                    ),
                    Divider(color: Colors.grey[850], thickness: 1),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20),
                  child: const Text('리워드 조건',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Pretendard',
                      )),
                ),
                    Obx(() => Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
                      child: controller.rewardConditionList.isEmpty ? const Column(
                          children: [
                          CircularProgressIndicator()]) : DropdownButtonFormField2<int>(
                          value: controller.rewardConditionId.value == 0
                              ? null
                              : controller.rewardConditionId.value,
                          hint: const Text(
                            '리워드를 선택해주세요.',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Pretendard',
                              color: Colors.grey,
                              letterSpacing: 1,
                            ),
                          ),

                          onChanged: (int? newValue) {
                                if (newValue != null) {
                                  controller.rewardConditionId.value = newValue;
                                }
                              },
                          decoration: const InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(top:10, bottom: 10),
                            hintStyle: TextStyle(color: Colors.grey),
                            focusedBorder: InputBorder.none,
                          ),
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.only(left: 0.0),
                          ),
                          // 펼쳐지는 메뉴 크기, 패딩 설정
                          dropdownStyleData: const DropdownStyleData(
                            padding: EdgeInsets.all(0.0),
                          ),
                          // 드롭다운 메뉴 항목 높이와 내부 여백 설정
                          menuItemStyleData: const MenuItemStyleData
                            (
                            padding: EdgeInsets.symmetric(horizontal: 0.0),
                            height: 40.0,
                          ),
                              items: controller.rewardConditionList.map((item) {
                                return DropdownMenuItem<int>(
                                  value: item.id,
                                  child: Text(item.name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Pretendard',
                                  ),
                                      ),
                                );
                              }).toList()
                      ),
                    )),
                    Divider(color: Colors.grey[850], thickness: 1),
                    const SizedBox(height: 30),
                    // ✅ 생성 버튼
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ElevatedButton(
                          onPressed: controller.isFormValid.value
                              ? controller.createJoinWeave
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF8000),
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
                    ),
                    const SizedBox(height: 30),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
