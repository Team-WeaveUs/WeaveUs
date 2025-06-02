import 'package:get/get.dart';
import 'package:weave_us/controllers/tab_view_controller.dart';

import '../controllers/weave_profile_controller.dart';
import '../services/api_service.dart';
import '../services/token_service.dart';

class WeaveBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TokenService>(() => TokenService());
    Get.lazyPut<ApiService>(() => ApiService());
    Get.lazyPut<TabViewController>(() => TabViewController(
    ));

    Get.lazyPut<WeaveProfileController>(() => WeaveProfileController(
      apiService: Get.find(),
      tokenService: Get.find(),
    ));
  }
}