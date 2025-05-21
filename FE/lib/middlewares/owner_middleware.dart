import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../routes/app_routes.dart';

class OwnerMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();
    authController.checkIsOwner();
    print('위치 : $route');
    print("오너? ${authController.isOwner.value}");
    if (route == AppRoutes.NEW_WEAVE) {
      if (authController.isOwner.value) {
        return const RouteSettings(name: AppRoutes.OWNER_NEW_WEAVE);
      } else {
        return null;
      }
    } else if (route == AppRoutes.REWARDS) {
      if (authController.isOwner.value) {
        return const RouteSettings(name: AppRoutes.OWNER_REWARDS);
      } else {
        return null;
      }
    }
    return null;
  }
}
