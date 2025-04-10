import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../services/api_service.dart';
import '../services/token_service.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TokenService>(() => TokenService());
    Get.lazyPut<ApiService>(() => ApiService());

    Get.lazyPut<ProfileController>(() => ProfileController(
      apiService: Get.find(),
      tokenService: Get.find(),
    ));
  }
}
