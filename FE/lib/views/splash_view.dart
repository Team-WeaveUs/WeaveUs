import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weave_us/routes/app_routes.dart';
import '../controllers/auth_controller.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthController _authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    bool isValid = await _authController.isAuthenticated.value
        ? true
        : await _authController.checkAuthStatus();
    if (isValid) {
        Get.offAllNamed(AppRoutes.HOME);
    } else {
      Get.offAllNamed(AppRoutes.AUTH);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()), // 로딩 인디케이터
    );
  }
}
