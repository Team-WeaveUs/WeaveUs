import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/friend_invite_dialog_controller.dart';

class FriendInviteDialog extends StatelessWidget {
  const FriendInviteDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      FriendInviteDialogController(
        apiService: Get.find(),
        tokenService: Get.find(),
      ),
    );

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final filteredList = controller.filteredSubscribeList;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "누구를 초대할까요?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                "나를 팔로우하고 있는 사람만 초대가 가능합니다.",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
              ),
              const SizedBox(height: 16),

              TextField(
                onChanged: controller.updateSearchQuery,
                decoration: InputDecoration(
                  hintText: "친구 이름을 검색하세요",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
              const SizedBox(height: 12),

              if (filteredList.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text("검색 결과가 없습니다."),
                )
              else
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 300),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final user = filteredList[index];
                      return ListTile(
                        leading: user.mediaUrl.isEmpty
                            ? const CircleAvatar(child: Icon(Icons.person))
                            : CircleAvatar(backgroundImage: NetworkImage(user.mediaUrl)),
                        title: Text(user.nickname),
                        trailing: IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () {
                            Get.back();
                            Get.snackbar("초대 완료", "${user.nickname}님을 초대했습니다!");
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
                  child: const Text(
                    "닫기",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
