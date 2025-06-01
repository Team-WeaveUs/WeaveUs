import 'package:get/get.dart';

import '../models/reward_condition_model.dart';
import '../services/token_service.dart';
import '../services/api_service.dart';

class RewardConditionController extends GetxController {
  ApiService apiService;
  TokenService tokenService;
  RewardConditionController({required this.apiService, required this.tokenService});
  final rewardCondition = RewardCondition.empty().obs;
  
  @override
  void onInit() {
    super.onInit();
  }
  Future<void> fetchRewardCondition() async {
    try {
      final userId = await tokenService.loadUserId();

      final response = await apiService.postRequest('reward/condition/get', {
        'user_id': userId,
      });
      rewardCondition.value = RewardCondition.fromJson(response['conditions']);

    } catch (e) {
      print('failed fetch reward condition : $e');
    }
  }

}