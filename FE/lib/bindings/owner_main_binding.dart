import 'package:get/get.dart';
import 'package:weave_us/controllers/owner_main_controller.dart';

class OwnerMainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OwnerMainController(
      apiService: Get.find(),
      tokenService: Get.find(),
    ));
  }
}