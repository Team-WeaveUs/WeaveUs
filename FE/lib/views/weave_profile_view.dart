import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../controllers/weave_profile_controller.dart';
import '../routes/app_routes.dart';
import 'components/app_nav_bar.dart';

class WeaveProfileView extends GetView<WeaveProfileController> {
  const WeaveProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppNavBar(title: 'Weave 정보'),
      body: Obx(() => controller.weaveProfile.value.weaveId == 0 ? const Center(child: CircularProgressIndicator()) : Padding(
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
            Text(controller.weaveProfile.value.createUserNickname,),
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
                          const Icon(Icons.favorite_border, color: Colors.orange),
                          const SizedBox(width: 4),
                          Text(
                            controller.weaveProfile.value.weaveLikes.toString(),
                            style: const TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.person_outline, color: Colors.black),
                          const SizedBox(width: 4),
                          Text(
                            controller.weaveProfile.value.weaveContributers.toString(),
                            style: const TextStyle(fontSize: 16, color: Colors.black),
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
                        Get.toNamed(AppRoutes.NEW_POST, arguments: {'weaveId': controller.weaveProfile.value.weaveId, 'weaveTitle': controller.weaveProfile.value.weaveTitle});
                      },
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: controller.postList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Get.toNamed("/post/${controller.postList[index].postId}", arguments: {
                        'postUserId': controller.userId.value
                        ,'reward_condition_id': controller.weaveProfile.value.rewardConditionId
                        ,'reward_condition_type': controller.weaveProfile.value.rewardConditionType
                        ,'rewardId': controller.weaveProfile.value.rewardId
                        ,'grantUser': controller.weaveProfile.value.weaveUserId.toString(),
                      });
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(controller.postList[index].img, fit: BoxFit.cover),
                    ),
                  );

                },
              ),),],),),));
  }
}