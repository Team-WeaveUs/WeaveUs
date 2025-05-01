import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:weave_us/controllers/profile_controller.dart';

import '../controllers/tab_view_controller.dart';
import 'components/app_nav_bar.dart';
import 'components/bottom_nav_bar.dart';

class ProfileView extends GetView<ProfileController> {
  final tabController = Get.find<TabViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppNavBar(title: '내 프로필'),
      body: Column(children: [
        Obx(() {
          if (controller.profile.value.nickname == '') {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(children: [
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: Row(children: [
                controller.profile.value.img == ""
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
                        backgroundImage:
                            NetworkImage(controller.profile.value.img),
                      ),
                const SizedBox(width: 10),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(controller.profile.value.nickname,
                      style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: 'Pretendard')),
                  Row(
                    children: [
                      const Icon(HugeIcons.strokeRoundedUser,
                          color: Colors.black, size: 20),
                      const SizedBox(width: 5),
                      Text(
                        controller.profile.value.subscribes.toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Row(children: [
                    const Icon(Icons.favorite,
                        color: Colors.orange, size: 20),
                    const SizedBox(width: 5),
                    Text(controller.profile.value.likes.toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        )),
                    TextButton(
                      onPressed: controller.toggleTabs,
                      child: Text(controller.toggleLabel),
                    )
                  ]),
                ])
              ]),
            ),

          ]);
        }),
        Obx(() {
          if (!tabController.isTabReady.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return Expanded(
            child: GetBuilder<TabViewController>(
                builder: (_) => Scaffold(
                  appBar: TabBar(
                    controller: tabController.tabController,
                    tabs: tabController.tabs,
                  ),
                  body: TabBarView(
                    controller: tabController.tabController,
                    children: tabController.tabViews,
                  ),
                )),
          );
        })
      ]),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}
