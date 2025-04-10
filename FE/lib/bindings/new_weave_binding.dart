import 'package:get/get.dart';
import 'package:weave_us/controllers/new_weave_controller.dart';

class NewWeaveBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewWeaveController>(() => NewWeaveController());
  }
}