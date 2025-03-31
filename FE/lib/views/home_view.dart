import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weave_us/views/components/app_nav_bar.dart';
import '../controllers/home_controller.dart';
import 'components/bottom_nav_bar.dart';

class HomeView extends StatelessWidget {
  final HomeController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavBar(title: "Weave Us"),
      body: Center(
        child: Obx(() => Text('Count: ${controller.count}')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.increment,
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}
