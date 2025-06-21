import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/profile_controller.dart';

class MyPostWidget extends GetView<ProfileController> {
  const MyPostWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.profile.value.nickname == '') {
        return const Center(child: CircularProgressIndicator());
      } else {
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1,
          ),
          itemCount: controller.postList.length,
          itemBuilder: (context, index) {
            final post = controller.postList[index];
            return GestureDetector(
              onTap: () {
                Get.toNamed('/post/${post.postId}?from=${Get.currentRoute}');
              },
              child: AspectRatio(
                aspectRatio: 1, // ⬅️ 정사각형 유지
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    post.img,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        );
      }
    });
  }
}
