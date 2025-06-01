import 'package:get/get.dart';
import 'package:weave_us/controllers/reward_detail_controller.dart';
import 'package:weave_us/services/api_service.dart';
import 'package:weave_us/services/token_service.dart';

class RewardDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiService>(() => ApiService());
    Get.lazyPut<TokenService>(() => TokenService());
    Get.lazyPut<RewardDetailController>(() => RewardDetailController(
        apiService: Get.find<ApiService>(),
        tokenService: Get.find<TokenService>()));
  }
}
