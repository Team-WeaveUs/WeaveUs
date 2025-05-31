import 'package:get/get.dart';

import '../services/location_service.dart';
import '../../services/api_service.dart';

import '../controllers/search_controller.dart';


class SearchBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ApiService>()) {
      Get.put(ApiService());
    }
    Get.lazyPut(() => LocationService(), fenix: true);
      Get.lazyPut(() => WeaveSearchController(
        locationService: Get.find<LocationService>(),
      ));
  }
}