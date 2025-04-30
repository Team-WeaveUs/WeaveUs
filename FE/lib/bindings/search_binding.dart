import 'package:get/get.dart';
import '../controllers/search_controller.dart';
import '../../services/api_service.dart';
import '../services/token_service.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiService>(() => ApiService());
    Get.lazyPut<TokenService>(() => TokenService());
    Get.lazyPut<WeaveSearchController>(() => WeaveSearchController(
      apiService: Get.find(),
      tokenService: Get.find(),
    ));
  }
}
