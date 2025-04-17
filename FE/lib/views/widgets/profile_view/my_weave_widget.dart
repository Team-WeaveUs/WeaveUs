import 'package:get/get.dart';
import 'package:weave_us/controllers/profile_controller.dart';
import 'package:flutter/material.dart';

class MyWeaveWidget extends GetView<ProfileController> {
  MyWeaveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return const Placeholder();
    });
  }
}