import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/owner_new_weave_controller.dart';

import '../widgets/new_weave_widget/new_name.input.dart';
import '../widgets/new_weave_widget/weave_explanation.dart';
import '../widgets/reward_invite_dialog.dart';
import '../widgets/owner_reward_post_widgets/reward_selector_widget.dart';
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
            NewNameInput(controller: controller.nameController),
            Divider(color: Colors.grey[850], thickness: 1),
            WeaveExplanation(controller: controller.descriptionController),
            Divider(color: Colors.grey[850], thickness: 1),

            Obx(() => Column(
              children: [
                // ✅ 리워드 선택 위젯
                RewardSelector(
                  selectedReward: controller.selectedRewardText.value,
                  onRewardSelected: () {
                    Get.dialog(
                      RewardInviteDialog(
                        onRewardSelected: (rewardModel) {
                          controller.selectReward(// 표시용 텍스트
                            rewardModel.reward,
                            rewardModel.rewardId,// 실제 rewardId
                          );
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 30),
                // ✅ 지도 위젯
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                      child: MapSelectPin(),
                    )),
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

              ],
            )),
          ],
        ),
      ),
    );
  }
}
