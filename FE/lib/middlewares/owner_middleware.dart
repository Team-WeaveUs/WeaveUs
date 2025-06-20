import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../controllers/auth_controller.dart';
import '../routes/app_routes.dart';

class OwnerMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();
    authController.checkIsOwner();
    if (route == AppRoutes.NEW_WEAVE) {
      if (authController.isOwner.value) {
        if (kIsWeb) {
          Get.snackbar("오류", "웹브라우저에서 지원하지 않는 기능입니다.");
          return const RouteSettings(name: AppRoutes.OWNER_NEW_WEAVE);
          // return const RouteSettings(name: AppRoutes.NEW_POST);
        } else {
          return const RouteSettings(name: AppRoutes.OWNER_NEW_WEAVE);
        }
      } else {
        return null;
      }
    }
    if (route == AppRoutes.REWARDS) {
      if (authController.isOwner.value) {
        return const RouteSettings(name: AppRoutes.OWNER_REWARDS);
      } else {
        return null;
      }
    }
    return null; // 기본적으로 리다이렉트하지 않음
  }
}
