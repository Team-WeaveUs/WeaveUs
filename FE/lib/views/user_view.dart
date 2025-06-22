import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:weave_us/controllers/auth_controller.dart';

import '../controllers/profile_controller.dart';
import 'package:get/get.dart';

class UserInfoView extends GetView<ProfileController> {
  UserInfoView({super.key});

  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('내 정보',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w900,
              )),
        ),
        body: Center(
            child: Column(children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(children: [
              Obx(
                () => controller.profile.value.img == ""
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
                        backgroundImage:
                            NetworkImage(controller.profile.value.img),
                      ),
              ),
              const SizedBox(width: 20),
              Obx(() => Text(
                    controller.profile.value.nickname,
                    style: const TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontFamily: 'Pretendard',
                    ),
                  )),
            ]),
          ),
          ListView(shrinkWrap: true, children: [
            const Divider(
              height: 1,
              indent: 0,
              endIndent: 0,
            ),
            ListTile(
              onTap: () {
                Get.snackbar("미구현", "사용자 정보 편집 페이지로 넘어갈 예정.");
              },
              title: Text("사용자 정보 편집"),
              trailing: const Icon(
                Icons.arrow_forward_ios_sharp,
                color: Colors.orange,
              ),
            ),
            const Divider(
              height: 0,
              indent: 0,
              endIndent: 0,
            ),
            ListTile(
              onTap: () {
                authController.logout();
              },
              title: Text("로그아웃"),
              trailing: const Icon(
                Icons.arrow_forward_ios_sharp,
                color: Colors.orange,
              ),
            ),
            const Divider(
              height: 0,
              indent: 0,
              endIndent: 0,
            ),
          ])
        ])));
  }
}
