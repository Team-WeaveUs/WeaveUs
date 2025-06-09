import 'package:get/get.dart';

import '../controllers/reward_condition_detail_controller.dart';

class RewardConditionDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RewardConditionDetailController>(() => RewardConditionDetailController());
  }

}