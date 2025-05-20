import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../routes/app_routes.dart';
import '../services/token_service.dart';

class OwnerMiddleware extends GetMiddleware {
  final TokenService _tokenService = TokenService();

  @override
  Future<RouteSettings?> redirectFuture(String? route) async {
    final authController = Get.find<AuthController>();

    if (!authController.isAuthenticated.value) {
      return const RouteSettings(name: AppRoutes.SPLASH);
    }

    final token = await _tokenService.loadToken();
    if (token == null) {
      return const RouteSettings(name: AppRoutes.HOME);
    }

    print("👉 현재 route: $route, isOwner: ${token.isOwner}");

    if (token.isOwner == 1 && !(route?.contains(AppRoutes.OWNER_HOME) ?? false)) {
      return const RouteSettings(name: AppRoutes.OWNER_HOME);
    }

    return null;
  }
}