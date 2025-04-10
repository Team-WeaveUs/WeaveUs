import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weave_us/views/components/app_nav_bar.dart';
import '../controllers/home_controller.dart';
import 'components/bottom_nav_bar.dart';


class HomeView extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavBar(title: "Weave Us"),
      body: Column(
        children: [
          // 1️⃣ 가로 스크롤 (postList1)
          Expanded(
            child: Obx(() => PageView.builder(
              scrollDirection: Axis.horizontal,
              onPageChanged: controller.onHorizontalScroll,
              itemCount: controller.postList1.length,
              itemBuilder: (context, index) {
                final post = controller.postList1[index];
                return Column(
                  children: [
                    Expanded(
                      child: Image.network(post.mediaUrl, fit: BoxFit.cover),
                    ),
                    Text(post.weaveTitle, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(post.textContent, style: TextStyle(fontSize: 15)),
                  ],
                );
              },
            )),
          ),

          Divider(),

          // 2️⃣ 세로 스크롤 (postList2)
          Expanded(
            child: Obx(() => PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: controller.postList2.length,
              itemBuilder: (context, index) {
                final post = controller.postList2[index];
                return Column(
                  children: [
                    Expanded(
                      child: Image.network(post.mediaUrl, fit: BoxFit.cover),
                    ),
                    Text(post.weaveTitle, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(post.textContent, style: TextStyle(fontSize: 15)),
                  ],
                );
              },
            )),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}
