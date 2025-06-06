import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/reward_invite_dialog_controller.dart';
import '../../models/reward_model.dart';

class RewardInviteDialog extends StatelessWidget {
  final Function(Reward friend) onRewardSelected;

  const RewardInviteDialog({super.key, required this.onRewardSelected});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RewardInviteDialogController>();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final filteredList = controller.filteredList;

          return Column(
            mainAxisSize: MainAxisSize.min, // ✅ 핵심! 크기 맞추기
            children: [
              const Text(
                "리워드를 선택하세요?",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Pretendard',
                ),
              ),
              const SizedBox(height: 4),
              const SizedBox(height: 12),
              TextField(
                onChanged: controller.updateSearchQuery,
                decoration: InputDecoration(
                  hintText: "리워드 검색",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 12),

              // 리스트는 최대 300 높이까지만
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 300), // ✅ 핵심
                child: ListView.builder(
                  shrinkWrap: true, // ✅ 핵심
                  itemCount: filteredList.length,
                  itemBuilder: (_, index) {
                    final user = filteredList[index];
                    return ListTile(
                      title: Text(user.title),
                      trailing: IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () {
                          onRewardSelected(user);
                          Get.back();
                        },
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 12),
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () => Get.back(),
                  child: const Text("닫기"),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
