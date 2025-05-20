import 'package:get/get.dart';

import '../controllers/new_join_weave_controller.dart';

import '../services/api_service.dart';
import '../services/location_service.dart';
import '../services/map_service.dart';
import '../services/token_service.dart';

class NewJoinWeaveBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MapService>(() => MapService());
    Get.lazyPut<LocationService>(() => LocationService());
    Get.lazyPut<NewJoinWeaveController>(() => NewJoinWeaveController(
      locationService: Get.find<LocationService>(),
      mapService: Get.find<MapService>(), apiService: Get.find<ApiService>(), tokenService: Get.find<TokenService>(),
    ));

  }
}