import 'package:get/get.dart';
import '../controllers/search_controller.dart';
import '../../services/api_service.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ApiService>()) {
      Get.put(ApiService());
    }
    if (!Get.isRegistered<WeaveSearchController>()) {
      Get.put(WeaveSearchController(), permanent: true);
    }
  }
}
