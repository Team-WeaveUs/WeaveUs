import 'package:get/get.dart';
import 'package:weave_us/controllers/reward_controller.dart';

class RewardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RewardController>(() => RewardController());
  }
}
