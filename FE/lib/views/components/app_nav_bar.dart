import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';

class AppNavBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;
  final AuthController authController = Get.find<AuthController>();

  AppNavBar({
    Key? key, required this.title,
    this.centerTitle = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
          title,
          style: const TextStyle(
              color: Colors.black,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w900,
          )
      ),
      backgroundColor: Colors.white, // 원하는 색상 설정
      actions: [
        IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {
            authController.logout();
          },
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}