import 'package:get/get.dart';
import 'package:weave_us/controllers/new_weave_controller.dart';
import '../controllers/friend_invite_dialog_controller.dart';

import '../services/api_service.dart';
import '../services/token_service.dart';

class NewWeaveBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TokenService>(() => TokenService());
    Get.lazyPut<ApiService>(() => ApiService());

    Get.lazyPut<NewWeaveController>(() => NewWeaveController(
      apiService: Get.find<ApiService>(),
      tokenService: Get.find<TokenService>(),
    ));
    Get.lazyPut<FriendInviteDialogController>(() => FriendInviteDialogController(
      apiService: Get.find<ApiService>(),
      tokenService: Get.find<TokenService>(),
    ), fenix: true);
  }
}