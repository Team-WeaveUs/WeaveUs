import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:weave_us/models/reward_model.dart';
import 'package:weave_us/services/api_service.dart';
import 'package:weave_us/services/token_service.dart';
import 'package:weave_us/routes/app_routes.dart';

class RewardDetailController extends GetxController {
  ApiService apiService;
  TokenService tokenService;

  RewardDetailController(
      {required this.apiService, required this.tokenService});

  final reward = Reward.empty().obs;
  final passwordController = TextEditingController();
  final rewardId = 0.obs;
  final isPasswordValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['reward'] != null) {
      reward.value = Get.arguments['reward'];
      // 비밀번호 입력 감지
      passwordController.addListener(() {
        isPasswordValid.value = passwordController.text.isNotEmpty;
      });
      validityParser();
    } else {
      // 마이크로태스크 큐를 사용하여 네비게이션 지연
      Future.microtask(() {
        Get.offNamed(AppRoutes.REWARDS);
        Get.snackbar(
          '알림',
          '유효하지 않은 접근입니다.',
          snackPosition: SnackPosition.BOTTOM,
        );
      });
    }
  }

  Future<void> validityParser() async {
    if (reward.value.validity == '0d'){
      reward.value.validity = '만료됨';
    }
    else if (reward.value.validity.contains('d')){
      reward.value.validity = reward.value.validity.replaceAll('d', '일');
    }
  }

  @override
  void onClose() {
    passwordController.dispose();
    super.onClose();
  }

  Future<void> useReward() async {
    try {
      final userId = await tokenService.loadUserId();
      final weaveId = reward.value.weaveId;
      final rewardHistoryId = reward.value.id;
      final rewardId = reward.value.rewardId;
      final password = passwordController.text;
      final response = await apiService.postRequest('reward/use', {
        "user_id": userId,
        "weave_id": weaveId,
        "reward_history_id": rewardHistoryId,
        "reward_id": rewardId,
        "password": password
      });
      if (response['message'] == "리워드 사용 완료되었습니다.") {
        Get.snackbar("성공", response['message']);
        Get.offAllNamed(AppRoutes.REWARDS);
      } else {
        Get.snackbar("실패", response['message']);
      }
    } catch (e) {
      print("use reward error : $e");
    }
  }
}
