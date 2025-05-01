import 'package:get/get.dart';
import '../services/api_service.dart';
import '../services/token_service.dart';
import '../controllers/post_controller.dart';

class PostBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiService>(() => ApiService());
    Get.lazyPut<TokenService>(() => TokenService());
    Get.lazyPut<PostController>(() => PostController(
      apiService: Get.find(),
      tokenService: Get.find(),
    ));
  }
}