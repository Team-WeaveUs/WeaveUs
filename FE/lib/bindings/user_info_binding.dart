import 'package:get/get.dart';

import 'package:weave_us/services/token_service.dart';

import '../controllers/auth_controller.dart';
import '../controllers/profile_controller.dart';
import '../services/api_service.dart';

class UserInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TokenService>(() => TokenService());
    Get.lazyPut<ApiService>(() => ApiService());
    Get.lazyPut<ProfileController>(() => ProfileController(apiService: Get.find(), tokenService: Get.find()));
    Get.lazyPut<AuthController>(() => AuthController());
  }
}