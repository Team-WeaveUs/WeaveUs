import 'package:get/get.dart';

import '../services/token_service.dart';
import '../services/api_service.dart';

import '../controllers/new_reward_condition_controller.dart';

class NewRewardConditionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TokenService>(() => TokenService());
    Get.lazyPut<ApiService>(() => ApiService());
    Get.lazyPut<RewardConditionController>(() => RewardConditionController(
      apiService: Get.find<ApiService>(),
      tokenService: Get.find<TokenService>(),
    ));

  }
}