import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weave_us/controllers/profile_controller.dart';

import 'components/app_nav_bar.dart';
import 'components/bottom_nav_bar.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavBar(title: '내 프로필'),
      body: Column(children: [
        Expanded(child: Obx(() {
          if (controller.profile.value.nickname == '') {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(children: [
            Text(controller.profile.value.nickname),
            Text(controller.postList.length.toString()),
            Image.network(controller.postList[0].img),
            Expanded(child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 1),
              itemCount: controller.postList.length,
              itemBuilder: (context, index) {
                final post = controller.postList[index];
                return Image.network(post.img);
              },
            ))
          ]);
        }))
      ]),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}
