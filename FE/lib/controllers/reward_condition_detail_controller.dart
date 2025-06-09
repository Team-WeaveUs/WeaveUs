import 'package:get/get.dart';

import '../models/reward_condition_model.dart';

class RewardConditionDetailController extends GetxController {
  final rewardCondition = RewardCondition.empty().obs;

  @override
  void onInit() {
    super.onInit();
    rewardCondition.value = Get.arguments['reward_condition'] as RewardCondition;
  }
  Future<void> fetchRewardCondition() async {
    try {

    } catch (e) {
      print('Error fetching reward condition: $e');
    }
  }
}