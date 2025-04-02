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
      Get.offAllNamed(AppRoutes.HOME); // 자동 로그인 성공 시 메인 페이지로 이동
    } else {
      Get.offAllNamed(AppRoutes.LOGIN); // 로그인 필요 시 로그인 페이지로 이동
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Placeholder()), // 로딩 인디케이터
    );
  }
}
