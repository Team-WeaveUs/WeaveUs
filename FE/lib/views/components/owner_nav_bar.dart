import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:weave_us/routes/app_routes.dart';

import '../../services/token_service.dart';

class OwnerNavBar extends StatelessWidget {
  OwnerNavBar({super.key});
  final tokenService = TokenService();

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: 0,
      onTap: (index) {
        switch (index) {
          case 0:
            Get.offNamed(AppRoutes.OWNER_HOME);
            break;
          case 1:
            Get.offNamed(AppRoutes.SEARCH);
            break;
          case 2:
            Get.toNamed(AppRoutes.OWNER_NEW_POST);
            break;
          case 3:
            Get.offNamed(AppRoutes.OWNER_REWARDS);
            break;
          case 4:
            Get.offNamed(AppRoutes.PROFILE);
            break;
        }
      },
      items: [
        const BottomNavigationBarItem(
          icon: Icon(HugeIcons.strokeRoundedHome05, color: Colors.orange), label: "",
        ),
        const BottomNavigationBarItem(
          icon: Icon(HugeIcons.strokeRoundedSearch02, color: Colors.orange), label: "",
        ),
        BottomNavigationBarItem(
          icon: GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.NEW_POST),
            onLongPress: () => Get.toNamed(AppRoutes.OWNER_NEW_WEAVE),
            child: const Icon(Icons.add_circle_outline_sharp, color: Colors.orange),
          ),
          label: "",
        ),
        const BottomNavigationBarItem(
          icon: Icon(HugeIcons.strokeRoundedGift, color: Colors.orange), label: "",
        ),
        const BottomNavigationBarItem(
          icon: Icon(HugeIcons.strokeRoundedUser, color: Colors.orange), label: "",
        ),
      ],
    );
  }
}