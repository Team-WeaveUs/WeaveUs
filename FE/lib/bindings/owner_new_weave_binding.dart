import 'package:get/get.dart';
import '../controllers/owner_new_weave_controller.dart';
import '../controllers/reward_invite_dialog_controller.dart';
import '../services/api_service.dart';
import '../services/token_service.dart';

class OwnerNewWeaveBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TokenService>(() => TokenService());
    Get.lazyPut<ApiService>(() => ApiService());

    Get.lazyPut<OwnerNewWeaveController>(() => OwnerNewWeaveController(
      apiService: Get.find<ApiService>(),
      tokenService: Get.find<TokenService>(),
    ));

    Get.lazyPut<RewardInviteDialogController>(() => RewardInviteDialogController(
      apiService: Get.find<ApiService>(),
      tokenService: Get.find<TokenService>(),
    ));
  }
}
