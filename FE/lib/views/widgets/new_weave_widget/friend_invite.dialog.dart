import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/friend_invite_dialog_controller.dart';
import '../../../models/friend_invite_model.dart';

class FriendInviteDialog extends StatelessWidget {
  final Function(FriendInviteModel friend) onFriendSelected;

  const FriendInviteDialog({super.key, required this.onFriendSelected});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FriendInviteDialogController>();

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
                "누구를 초대할까요?",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Pretendard',
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "나를 팔로우하고 있는 사람만 초대가 가능합니다",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                  fontFamily: 'Pretendard',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                onChanged: controller.updateSearchQuery,
                decoration: InputDecoration(
                  hintText: "친구 이름 검색",
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
                      leading: user.mediaUrl.isEmpty
                          ? const CircleAvatar(child: Icon(Icons.person))
                          : CircleAvatar(backgroundImage: NetworkImage(user.mediaUrl)),
                      title: Text(user.nickname),
                      trailing: IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () {
                          onFriendSelected(user);
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
