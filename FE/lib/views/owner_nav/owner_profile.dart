import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weave_us/views/components/bottom_nav_bar.dart';
import 'package:weave_us/views/widgets/new_post_widgets/post_content.input.dart';
import 'package:weave_us/views/widgets/owner_reward_post_widgets/reward_content_input.dart';
import '../../controllers/owner_reward_controller.dart';
import '../../controllers/tab_view_controller.dart';
import '../components/app_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:weave_us/controllers/profile_controller.dart';


class OwnerProfileView extends StatelessWidget {
  final controller = Get.find<ProfileController>();
  final tabController = Get.find<TabViewController>();
  final RxInt myUserId = 0.obs;

  OwnerProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final profile = controller.profile.value;
      final isMine = myUserId.value == profile.userId;
      final nickname = profile.nickname;

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppNavBar(
            title: isMine ? '내 프로필' : '$nickname 님의 프로필'),
        body: Column(children: [
          if (profile.nickname == '')
            const Center(child: CircularProgressIndicator())
          else
            Column(children: [
              Container(
                margin: const EdgeInsets.all(20),
                child: Row(children: [
                  profile.img == ""
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
                    backgroundImage: NetworkImage(profile.img),
                    radius: 50,
                  ),
                  const SizedBox(width: 10),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(HugeIcons.strokeRoundedGift,
                                  color: Colors.black),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              nickname,
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: 'Pretendard',
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(HugeIcons.strokeRoundedUser,
                                color: Colors.black, size: 20),
                            const SizedBox(width: 5),
                            Text(
                              profile.subscribes.toString(),
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
                          Text(profile.likes.toString(),
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              )),
                          SizedBox(width: 50),
                          TextButton(
                            onPressed: controller.toggleTabs,
                            style: TextButton.styleFrom(
                                backgroundColor: Color(0xFF868583),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )
                            ),
                            child: Text(controller.toggleLabel,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                )),
                          )
                        ]),
                        SizedBox(height: 10),
                        const Text(
                          "위브 소개가 들어갈 예정입니다.",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ])
                ]),
              ),
            ]),
          Obx(() {
            if (!tabController.isTabReady.value) {
              return const Center(child: CircularProgressIndicator());
            }
            return Expanded(
              child: GetBuilder<TabViewController>(
                builder: (_) => Scaffold(
                  appBar: PreferredSize( // ← TabBar PreferredSize
                    preferredSize: const Size.fromHeight(50),
                    child: TabBar(
                      controller: tabController.tabController,
                      tabs: tabController.tabs,
                      labelStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Pretendard',
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'Pretendard',
                      ),
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Colors.black,
                    ),
                  ),
                  body: TabBarView(
                    controller: tabController.tabController,
                    children: tabController.tabViews,
                  ),
                ),
              ),
            );
          })
        ]),
        bottomNavigationBar: BottomNavigation(),
      );
    });
  }
}
