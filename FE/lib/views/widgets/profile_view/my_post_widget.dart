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
      }
      else {
        return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, childAspectRatio: 1),
              itemCount: controller.postList.length,
              itemBuilder: (context, index) {
                final post = controller.postList[index];
                return Image.network(post.img);
              },
            );
      }
    });
  }
}