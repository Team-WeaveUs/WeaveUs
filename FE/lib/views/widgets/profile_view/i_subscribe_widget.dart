import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../controllers/profile_controller.dart';

class ISubscribeWidget extends GetView<ProfileController> {
  const ISubscribeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.profile.value.nickname == '') {
        return const Center(child: CircularProgressIndicator());
      } else {
        return ListView.builder(
            itemCount: controller.iSubscribeList.length,
            itemBuilder: (context, index) {
              final subscribe = controller.iSubscribeList[index];
              return ListTile(
                onTap: () {
                  if (Get.isRegistered<ProfileController>()) {
                    Get.delete<ProfileController>();
                  }
                  Get.toNamed('/profile/${subscribe.id}');
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
