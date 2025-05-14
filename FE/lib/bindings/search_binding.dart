import 'package:get/get.dart';
import '../services/location_service.dart';
import '../controllers/search_controller.dart';
import '../../services/api_service.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ApiService>()) {
      Get.put(ApiService());
    }
    Get.lazyPut(() => LocationService());
    if (!Get.isRegistered<WeaveSearchController>()) {
      Get.put(WeaveSearchController(
        locationService: Get.find<LocationService>(),
      ), permanent: true);
    }
  }
}
