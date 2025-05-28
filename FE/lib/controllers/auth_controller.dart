import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bcrypt/bcrypt.dart';
import '../models/token_model.dart';
import '../routes/app_routes.dart';
import '../services/auth_service.dart';
import '../services/token_service.dart';

class AuthController extends GetxController {
  final TokenService _tokenService = TokenService();
  final AuthService _authService = AuthService();

  var isAuthenticated = false.obs;
  var isOwner = false.obs;
  var userId = ''.obs;
  var isLoading = false.obs;
  var isLoginSuccess = false.obs;

  @override
  onInit() {
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

  Future<bool> checkIsOwner() async {
    Token token = await _tokenService.loadToken() ??
        Token(accessToken: '', refreshToken: '', userId: '', isOwner: 0);
    isOwner.value = token.isOwner == 1;
    return isOwner.value;
  }

  Future<void> _checkAuthStatus() async {
    Token token = await _tokenService.loadToken() ??
        Token(accessToken: '', refreshToken: '', userId: '', isOwner: 0);
    bool isValid = token.accessToken != '';
    isAuthenticated.value = isValid;
    isOwner.value = token.isOwner == 1;
    if (isValid) {
      if (token.isOwner == 1) {
        Get.offAllNamed('/owner/profile/${token.userId}');
      } else {
        Get.offAllNamed(AppRoutes.HOME);
      }
    }
  }

  Future<void> login(String email, String password) async {
    isLoading.value = true;

    if (!Get.isDialogOpen!) {
      Get.dialog(
        const PopScope(
          canPop: false,
          child: Dialog(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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

    // 실제 로그인 요청
    final success = await _authService.login(email, password);

    print(BCrypt.hashpw(password, BCrypt.gensalt()));

    if (success) {
      final token = await _tokenService.loadToken();
      isAuthenticated.value = true;
      isLoading.value = false;
      isOwner.value = token!.isOwner == 1;
      userId.value = token.userId;
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
    Get.offAllNamed(AppRoutes.AUTH);
  }

  Future<void> commonRegistration(String id, String pw, String name,
      String nickname, String number, String gender) async {
    isLoading.value = true;
    await Future.delayed(Duration(milliseconds: 100));
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
                  Text("회원가입 중입니다..."),
                ],
              ),
            ),
          ),
        ),
        barrierDismissible: false,
      );
    }
    final success = await _authService.commonRegistration(
        id, pw, name, nickname, number, gender);

    if (success) {
      isLoading.value = false;
      Get.snackbar("회원가입 성공", "로그인 해주세요");
      Get.offAllNamed(AppRoutes.LOGIN);
    } else {
      isLoading.value = false;
      Get.snackbar("회원가입 실패", "회원가입에 실패했습니다");
    }
  }

  Future<void> ownerRegistration(String id, String pw, String name,
      String nickname, String number, String gender) async {
    isLoading.value = true;
    await Future.delayed(Duration(milliseconds: 100));
    if (!Get.isDialogOpen!) {
      Get.dialog(
        const PopScope(
          canPop: false,
          child: Dialog(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("회원가입 중입니다..."),
                ],
              ),
            ),
          ),
        ),
        barrierDismissible: false,
      );
    }
    final success = await _authService.ownerRegistration(
        id, pw, name, nickname, number, gender);

    if (success) {
      isLoading.value = false;
      Get.snackbar("회원가입 성공", "로그인 해주세요");
      Get.offAllNamed(AppRoutes.LOGIN);
    } else {
      isLoading.value = false;
      Get.snackbar("회원가입 실패", "회원가입에 실패했습니다");
    }
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
