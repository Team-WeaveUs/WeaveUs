import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:http/http.dart' as http;
import '../models/token_model.dart';
import '../routes/app_routes.dart';
import '../services/auth_service.dart';
import '../services/token_service.dart';

class AuthController extends GetxController {
  final TokenService _tokenService = TokenService();
  final AuthService _authService = AuthService();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  var isAuthenticated = false.obs;
  var isOwner = false.obs;
  var isLoading = false.obs;
  var isLoginSuccess = false.obs;
  final isFormValid = false.obs;

  final emailError = RxnString();
  final _emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,4}$');

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
      Get.offAllNamed(AppRoutes.HOME);
    }
  }

  void validateEmail() {
    final value = emailController.text.trim();
    if (_emailRegex.hasMatch(value)) {
      emailError.value = null;
    } else {
      emailError.value = '이메일 형식이 올바르지 않습니다.';
    }
    updateFormValidity();
  }

  void updateFormValidity() {
    isFormValid.value = emailError.value == null &&
        emailController.text.trim().isNotEmpty &&
        passwordController.text.trim().isNotEmpty &&
        nameController.text.trim().isNotEmpty &&
        nicknameController.text.trim().isNotEmpty &&
        numberController.text.trim().isNotEmpty &&
        genderController.text.trim().isNotEmpty;
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
      Get.offAllNamed(AppRoutes.HOME);
    } else {
      Get.back();
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

  Future<bool> validateBusinessNumber(String bno) async {
    const serviceKey =
        "RK1Tb5xIod4LWDuarSN6uUOZpHG%2BZgpTmbySBU8n2yiBcpZWwrYoUY6h80Chcv0EGXCRKTszOFCDpItZ4ZO%2FMA%3D%3D";
    final url = Uri.parse(
        "https://api.odcloud.kr/api/nts-businessman/v1/status?serviceKey=$serviceKey");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "b_no": [bno]
        }),
      );

      if (response.statusCode != 200) {
        return false;
      }

      final data = jsonDecode(response.body);
      final statusList = data['data'] as List<dynamic>?;

      if (statusList == null || statusList.isEmpty) {
        return false;
      }

      // 사업자 상태 코드 확인
      final status = statusList[0]['b_stt_cd'];
      return status != null && status.toString().isNotEmpty;
    }
    // 예외 처리 추가
    catch (e) {
      print("사업자 유효성 검사 중 오류 발생: $e");
      return false;
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
      Get.toNamed(AppRoutes.LOGIN);
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
