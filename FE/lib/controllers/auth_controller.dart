import 'package:get/get.dart';
import '../models/token_model.dart';
import '../routes/app_routes.dart';
import '../services/auth_service.dart';
import '../services/token_service.dart';

class AuthController extends GetxController {
  final TokenService _tokenService = TokenService();
  final AuthService _authService = AuthService();

  var isAuthenticated = false.obs;

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
    bool success = await _authService.login(email, password);
    isAuthenticated.value = false;

    if (success) {
      // ✅ 토큰 저장을 기다린 후 화면 전환
      await _tokenService.loadToken();

      isAuthenticated.value = true;
      Get.offAllNamed(AppRoutes.HOME);
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
