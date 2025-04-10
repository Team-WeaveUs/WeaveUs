import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weave_us/routes/app_routes.dart';
import 'package:weave_us/views/new_weave_view.dart';

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
          icon: Icon(Icons.home, color: Colors.black),
          label: "",
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.search, color: Colors.black),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.NEW_POST),
            onLongPress: () => Get.to(() => const NewWeaveView()),
            child: const Icon(Icons.add_box, color: Colors.black),
          ),
          label: "",
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.redeem, color: Colors.black),
          label: "",
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person, color: Colors.black),
          label: "",
        ),
      ],
    );
  }
}