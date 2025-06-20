import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../controllers/profile_controller.dart';

class MySubscribeWidget extends GetView<ProfileController> {
  const MySubscribeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.profile.value.nickname == '') {
        return const Center(child: CircularProgressIndicator());
      } else {
        return ListView.builder(
            itemCount: controller.mySubscribeList.length,
            itemBuilder: (context, index) {
              final subscribe = controller.mySubscribeList[index];
              return ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 10),
                onTap: () {
                  if (Get.isRegistered<ProfileController>()) {
                    Get.delete<ProfileController>();
                  }
                  Get.toNamed('/profile/${subscribe.id}?from=${Get.currentRoute}');
                },
                leading: subscribe.mediaUrl == ""
                    ? const CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 50,
                  child: Icon(
                    HugeIcons.strokeRoundedUser,
                    size: 50,
                    color: Colors.white,
                  ),
                )
                    : CircleAvatar(
                  backgroundImage: NetworkImage(subscribe.mediaUrl),
                ),
                title: Text(subscribe.nickname),
              );
            });
      }
    });
  }
}
