import 'package:get/get.dart';
import 'package:weave_us/controllers/owner_reward_controller.dart';

import '../services/api_service.dart';
import '../services/token_service.dart';

class OwnerRewardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TokenService>(() => TokenService());
    Get.lazyPut<ApiService>(() => ApiService());

    // OwnerRewardController에 주입
    Get.lazyPut<OwnerRewardController>(() => OwnerRewardController(
      apiService: Get.find<ApiService>(),
      tokenService: Get.find<TokenService>(),
    ));
  }
}