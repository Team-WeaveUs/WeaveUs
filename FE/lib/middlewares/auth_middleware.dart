import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../routes/app_routes.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();
    return authController.isAuthenticated.value ? null : const RouteSettings(name: AppRoutes.LOGIN);
  }
}