import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import '../../controllers/owner_new_weave_controller.dart';

import '../widgets/new_weave_widget/new_name.input.dart';
import '../widgets/new_weave_widget/weave_explanation.dart';
import '../widgets/reward_invite_dialog.dart';
import '../widgets/new_reward_widgets/reward_selector_widget.dart';

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
            Column(
              children: [
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
                const SizedBox(height: 30),
                // ✅ 지도 위젯
                Obx(() => controller.position.value == null
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 1000,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: FlutterMap(
                                options: MapOptions(
                                  onTap: (tapPosition, latLng) {
                                    controller.selectedLocation.value = latLng;
                                  },
                                  initialCenter: LatLng(
                                      controller.position.value!.latitude,
                                      controller.position.value!.longitude),
                                  initialZoom: 13,
                                ),
                                children: [
                                  TileLayer(
                                    urlTemplate:
                                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                    tileProvider:
                                        CancellableNetworkTileProvider(),
                                  ),
                                  MarkerLayer(markers: [
                                    Marker(
                                      point: controller.selectedLocation.value!,
                                      child: Icon(
                                        Icons.location_on_rounded,
                                        color: Colors.orange,
                                        size: 40,
                                      ),
                                    )
                                  ])
                                ])))),
                const SizedBox(height: 30),
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
                  child: Text("종료 날짜 선택"),
                ),
                Obx(() => controller.rewardConditionList.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : DropdownButton<int>(
                        value: controller.rewardConditionId.value,
                        onChanged: (int? newValue) {
                          if (newValue != null) {
                            controller.rewardConditionId.value = newValue;
                          }
                        },
                        items: controller.rewardConditionList.map((item) {
                          return DropdownMenuItem<int>(
                            value: item.id,
                            child: Text(item.name),
                          );
                        }).toList())),
                const SizedBox(height: 30),
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
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
