import 'package:get/get.dart';
import 'package:weave_us/controllers/reward_controller.dart';

import '../services/api_service.dart';
import '../services/token_service.dart';

class RewardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiService>(() => ApiService());
    Get.lazyPut<TokenService>(() => TokenService());
    Get.lazyPut<RewardController>(() => RewardController(
      apiService: Get.find<ApiService>(),
      tokenService: Get.find<TokenService>(),
    ));
  }
}
