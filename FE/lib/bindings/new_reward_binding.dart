import 'package:get/get.dart';
import 'package:weave_us/controllers/new_reward_controller.dart';

import '../services/api_service.dart';
import '../services/token_service.dart';

class OwnerRewardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TokenService>(() => TokenService());
    Get.lazyPut<ApiService>(() => ApiService());

    // OwnerRewardController에 주입
    Get.lazyPut<NewRewardController>(() => NewRewardController(
      apiService: Get.find<ApiService>(),
      tokenService: Get.find<TokenService>(),
    ));
  }
}