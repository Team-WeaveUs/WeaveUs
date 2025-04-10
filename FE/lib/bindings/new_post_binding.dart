import 'package:get/get.dart';
import '../controllers/new_post_controller.dart';
import '../services/api_service.dart';
import '../services/token_service.dart';

class NewPostBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TokenService>(() => TokenService());
    Get.lazyPut<ApiService>(() => ApiService());

    // NewPostController에 주입
    Get.lazyPut<NewPostController>(() => NewPostController(
      apiService: Get.find<ApiService>(),
      tokenService: Get.find<TokenService>(),
    ));
  }
}