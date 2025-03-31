import 'package:get/get.dart';
import 'package:weave_us/routes/app_routes.dart';
import '../services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  RxBool isAuthenticated = false.obs;

  Future<void> login(String email, String password) async {
    bool success = await _authService.login(email, password);
    if (success) {
      isAuthenticated.value = true;
      Get.offNamed(AppRoutes.HOME);
    } else {
      Get.snackbar("Error", "Invalid credentials");
    }
  }

  void logout() {
    _authService.logout();
    isAuthenticated.value = false;
    Get.offNamed(AppRoutes.LOGIN);
  }
}