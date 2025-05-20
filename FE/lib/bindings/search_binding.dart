import 'package:get/get.dart';
import 'package:weave_us/services/map_service.dart';
import '../services/location_service.dart';
import '../controllers/search_controller.dart';
import '../controllers/new_join_weave_controller.dart';
import '../../services/api_service.dart';
import '../services/token_service.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ApiService>()) {
      Get.put(ApiService());
    }
    Get.lazyPut(() => LocationService());
    Get.lazyPut(() => NewJoinWeaveController(locationService: LocationService(), mapService: MapService(), apiService: ApiService(), tokenService: TokenService()));
    if (!Get.isRegistered<WeaveSearchController>()) {
      Get.put(WeaveSearchController(
        locationService: Get.find<LocationService>(),
      ), permanent: true);
    }
  }
}
