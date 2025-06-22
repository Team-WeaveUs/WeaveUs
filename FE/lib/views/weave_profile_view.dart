import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../controllers/weave_profile_controller.dart';
import '../routes/app_routes.dart';

class WeaveProfileView extends GetView<WeaveProfileController> {
  const WeaveProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final from = Get.parameters['from'] ?? 'home'; // 기본값: home
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(HugeIcons.strokeRoundedComplaint),
              onPressed: () {
                Get.snackbar("미구현","신고페이지로 넘어갈 예정.");
              },
            )
          ],
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                if (from.isNotEmpty) {
                  Get.offAllNamed(from.trim());
                } else {
                  Get.offAllNamed('/home');
                }
              }
            },
          ),
          title: Obx(() => Text(
                controller.weaveProfile.value.weaveTitle,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Pretendard',
                ),
              )),
          centerTitle: true,
        ),
        body: Obx(
          () => controller.weaveProfile.value.weaveId == 0
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(controller.weaveProfile.value.weaveTitle,
                          style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: 'Pretendard')),
                      Text(
                        controller.weaveProfile.value.createUserNickname,
                      ),
                      const SizedBox(height: 8),
                      Text(controller.weaveProfile.value.weaveDescription,
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              fontFamily: 'Pretendard')),
                      const SizedBox(height: 12),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 왼쪽: 좋아요 + 참여 인원 (세로 정렬)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.favorite,
                                        color: Colors.orange),
                                    const SizedBox(width: 4),
                                    Text(
                                      controller.weaveProfile.value.weaveLikes
                                          .toString(),
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.person_outline,
                                        color: Colors.black),
                                    const SizedBox(width: 4),
                                    Text(
                                      controller
                                          .weaveProfile.value.weaveContributers
                                          .toString(),
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            // 오른쪽: + 버튼
                            Container(
                              width: 36,
                              height: 36,
                              child: IconButton(
                                onPressed: () {
                                  Get.toNamed(
                                      "${AppRoutes.NEW_POST}?from=${Get.currentRoute}&weaveId=${controller.weaveProfile.value.weaveId}&weaveTitle=${controller.weaveProfile.value.weaveTitle}");
                                },
                                icon: Icon(controller.weaveProfile.value.isJoinWeave == 1 ? HugeIcons.strokeRoundedGift : Icons.add_circle_outline),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: controller.postList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                final bcryptWeaveUserId = BCrypt.hashpw(
                                    controller.weaveProfile.value.weaveUserId
                                        .toString(),
                                    BCrypt.gensalt());
                                Get.toNamed(
                                    "/post/${controller.postList[index].postId}?from=/weave/${controller.weaveProfile.value.weaveId}&grantUser=$bcryptWeaveUserId&postUserId=${controller.userId.value}&reward_condition_id=${controller.weaveProfile.value.rewardConditionId}&reward_condition_type=${controller.weaveProfile.value.rewardConditionType}&rewardId=${controller.weaveProfile.value.rewardId}");
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                    controller.postList[index].img,
                                    fit: BoxFit.cover),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
        ));
  }
}
