import 'package:get/get.dart';
import '../routes/app_routes.dart';
import '../services/auth_service.dart';
import '../services/token_service.dart';

class AuthController extends GetxController {
  final TokenService _tokenService = TokenService();
  final AuthService _authService = AuthService();

  var isAuthenticated = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkAuthStatus();
  }

  // ✅ 앱 실행 시 토큰 검증 및 자동 로그인 처리
  Future<void> _checkAuthStatus() async {
    bool isValid = await _tokenService.refreshToken();
    if (isValid) {
      isAuthenticated.value = true;
      Get.offAllNamed(AppRoutes.HOME); // 자동 로그인 시 /home으로 이동
    } else {
      Get.snackbar("자동 로그인", "실패");
      isAuthenticated.value = false;
      Get.offAllNamed(AppRoutes.LOGIN); // 인증 실패 시 로그인 페이지로 이동
    }
  }

  Future<bool> checkAuthStatus() async {
    bool isValid = await _tokenService.refreshToken();
    isAuthenticated.value = isValid;
    return isValid;
  }

  // ✅ 로그인 처리
  Future<void> login(String email, String password) async {
    bool success = await _authService.login(email, password);
    if (success) {
      isAuthenticated.value = true;
      Get.offNamed(AppRoutes.HOME);
      Get.snackbar("로그인", "성공");
    } else {
      Get.snackbar("로그인", "실패");
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
