import 'package:get/get.dart';
import 'package:weave_us/services/map_service.dart';
import '../controllers/owner_new_weave_controller.dart';
import '../controllers/reward_invite_dialog_controller.dart';
import '../services/api_service.dart';
import '../services/location_service.dart';
import '../services/token_service.dart';

class OwnerNewWeaveBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TokenService>(() => TokenService());
    Get.lazyPut<ApiService>(() => ApiService());
    Get.lazyPut<LocationService>(() => LocationService());
    Get.lazyPut<MapService>(() => MapService());

    Get.lazyPut<OwnerNewWeaveController>(() => OwnerNewWeaveController(
      apiService: Get.find<ApiService>(),
      tokenService: Get.find<TokenService>(),
      locationService: Get.find<LocationService>(),
      mapService: Get.find<MapService>(),
    ));

    Get.lazyPut<RewardInviteDialogController>(() => RewardInviteDialogController(
      apiService: Get.find<ApiService>(),
      tokenService: Get.find<TokenService>(),
    ), fenix: true);
  }
}
