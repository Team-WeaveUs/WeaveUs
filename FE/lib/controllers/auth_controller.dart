import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/token_model.dart';
import '../routes/app_routes.dart';
import '../services/auth_service.dart';
import '../services/token_service.dart';

class AuthController extends GetxController {
  final TokenService _tokenService = TokenService();
  final AuthService _authService = AuthService();

  var isAuthenticated = false.obs;
  var isLoading = false.obs;
  var isLoginSuccess = false.obs;

  @override
  onInit(){
    super.onInit();
    _checkAuthStatus();
  }

  // ✅ 앱 실행 시 토큰 검증 및 자동 로그인 처리
  Future<bool> checkAuthStatus() async {
    bool isValid = await _tokenService.refreshToken();
    isAuthenticated.value = isValid;
    Get.offAllNamed(AppRoutes.LOGIN);
    return isValid;
  }

  Future<void> _checkAuthStatus() async {
    Token token = await _tokenService.loadToken() ?? Token(accessToken: '', refreshToken: '', userId: '');
    bool isValid = token.accessToken != '';
    isAuthenticated.value = isValid;
    if (isValid) {
      Get.offAllNamed(AppRoutes.HOME);
    }
  }

  // ✅ 로그인 처리
  Future<void> login(String email, String password) async {
    isLoading.value = true;

    // 로그인 다이얼로그 띄우기
    if (!Get.isDialogOpen!) {
      Get.dialog(
        PopScope(
          canPop: false,
          child: Dialog(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("로그인 중입니다..."),
                ],
              ),
            ),
          ),
        ),
        barrierDismissible: false,
      );
    }

    final success = await _authService.login(email, password);

    if (success) {
      await _tokenService.loadToken();
      isAuthenticated.value = true;
      isLoading.value = false;
      Get.offAllNamed(AppRoutes.HOME);
    } else {
      isLoading.value = false;
      Get.snackbar("로그인 실패", "아이디나 비밀번호를 확인하세요");
    }
  }

  // ✅ 로그아웃 처리
  Future<void> logout() async {
    await _tokenService.clearToken();
    _authService.logout();
    isAuthenticated.value = false;
    Get.offAllNamed(AppRoutes.LOGIN);
  }

  // ✅ 401 오류 발생 시 토큰 갱신
  Future<bool> handle401() async {
    bool success = await _tokenService.refreshToken();
    if (success) {
      isAuthenticated.value = true;
    } else {
      await logout();
    }
    return success;
  }
}
