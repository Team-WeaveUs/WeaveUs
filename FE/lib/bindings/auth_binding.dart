import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../services/token_service.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<TokenService>(() => TokenService());
  }
}