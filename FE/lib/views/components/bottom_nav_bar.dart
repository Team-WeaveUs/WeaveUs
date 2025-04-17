import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:weave_us/routes/app_routes.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

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
            Get.offNamed(AppRoutes.HOME);
            break;
          case 1:
            Get.offNamed(AppRoutes.SEARCH);
            break;
          case 2:
            Get.toNamed(AppRoutes.NEW_POST);
            break;
          case 3:
            Get.offNamed(AppRoutes.REWARDS);
            break;
          case 4:
            Get.offNamed(AppRoutes.PROFILE);
            break;
        }
      },
      items: [
        const BottomNavigationBarItem(
          icon: Icon(HugeIcons.strokeRoundedHome05, color: Colors.black), label: "",
        ),
        const BottomNavigationBarItem(
          icon: Icon(HugeIcons.strokeRoundedSearch02, color: Colors.black), label: "",
        ),
        BottomNavigationBarItem(
          icon: GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.NEW_POST),
            onLongPress: () => Get.toNamed(AppRoutes.NEW_WEAVE),
            child: const Icon(Icons.add_circle_outline_sharp, color: Colors.black),
          ),
          label: "",
        ),
        const BottomNavigationBarItem(
          icon: Icon(HugeIcons.strokeRoundedGift, color: Colors.black), label: "",
        ),
        const BottomNavigationBarItem(
          icon: Icon(HugeIcons.strokeRoundedUser, color: Colors.black), label: "",
        ),
      ],
    );
  }
}