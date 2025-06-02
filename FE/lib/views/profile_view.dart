import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:weave_us/controllers/profile_controller.dart';
import '../controllers/tab_view_controller.dart';
import 'components/app_nav_bar.dart';
import 'components/bottom_nav_bar.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final tabController = Get.find<TabViewController>();
  final controller = Get.find<ProfileController>();
  final RxInt myUserId = 0.obs;


  @override
  void initState() {
    super.initState();
    _loadUserId();
    _checkRedirectToOwnerProfile();
  }

  Future<void> _loadUserId() async {
    final userIdStr = await controller.tokenService.loadUserId();
    myUserId.value = int.tryParse(userIdStr) ?? 0;
  }

  Future<void> _checkRedirectToOwnerProfile() async {
    await Future.delayed(Duration(milliseconds: 300)); // 데이터 로딩 기다리기
    final isMine = myUserId.value == controller.profile.value.userId;
    final isOwner = controller.profile.value.isOwner == 1;

    if (!isMine && isOwner == 1) {
      Get.offNamed('/owner/profile/${controller.profile.value.userId}',
          arguments: {
            'userId': controller.profile.value.userId,
            'nickname': controller.profile.value.nickname,
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final profile = controller.profile.value;
      final isMine = myUserId.value == profile.userId;
      final nickname = profile.nickname;

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppNavBar(title: isMine ? '내 프로필' : '$nickname 님의 프로필'),
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
                    radius: 50,
                    backgroundImage: NetworkImage(profile.img),
                  ),
                  const SizedBox(width: 10),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(nickname,
                            style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontFamily: 'Pretendard')),
                         Row(children: [
                          const Icon(Icons.favorite,
                              color: Colors.orange, size: 20),
                          const SizedBox(width: 5),
                          Text(profile.likes.toString(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              )),
                        ]),
                        Row(
                          children: [
                            const Icon(HugeIcons.strokeRoundedUser,
                                color: Colors.black, size: 20),
                            const SizedBox(width: 5),
                            Text(
                              profile.subscribes.toString(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
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
                          ],
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
                  body: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: TabBarView(
                      controller: tabController.tabController,
                      children: tabController.tabViews,
                    ),
                  ),
                ),
              ),
            );
          }),
        ]),
        bottomNavigationBar: BottomNavigation(),
      );
    });
  }
}