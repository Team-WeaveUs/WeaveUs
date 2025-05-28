import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../routes/app_routes.dart';

class OwnerMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();
    authController.checkIsOwner();
    if (route == AppRoutes.NEW_WEAVE) {
      if (authController.isOwner.value) {
        return const RouteSettings(name: AppRoutes.OWNER_NEW_WEAVE);
      } else {
        return null;
      }
    }
    return null; // 기본적으로 리다이렉트하지 않음
  }
}