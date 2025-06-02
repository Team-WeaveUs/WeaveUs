import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../models/reward_condition_model.dart';
import '../routes/app_routes.dart';
import '../services/token_service.dart';
import '../services/api_service.dart';

class RewardConditionController extends GetxController {
  ApiService apiService;
  TokenService tokenService;
  RewardConditionController({required this.apiService, required this.tokenService});
  final rewardCondition = RewardCondition.empty().obs;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final counterController = TextEditingController();
  final likeCountController = TextEditingController();

  // 코드와 표시명을 쌍으로 구성
  final Map<String, String> rewardTypes = {
    'RANDOM_AUTHOR': '랜덤',
    'INSERT': '직접지급',
    'TOP_LIKED': '좋아요 많은 순',
    'RANDOM_THRESHOLD': '조건부 무작위',
    'FIRST_N': '선착순',
    // 'CUSTOM': '조건 설정',
  };

  // 현재 선택된 코드값
  var selectedCode = 'RANDOM_AUTHOR'.obs;

  String get selectedLabel => rewardTypes[selectedCode.value] ?? '';

  Future<void> createRewardCondition() async {
    try {
      final userId = await tokenService.loadUserId();
      final bodies = {
        'user_id': userId,
        'name': titleController.text.trim(),
        'description': descriptionController.text.trim(),
        'reward_count': int.tryParse(counterController.text) ?? 0,
        'type': selectedCode.value,
      };
      if (selectedCode.value == 'RANDOM_THRESHOLD' || selectedCode.value == 'TOP_LIKED') {
        final likeThreshold = int.tryParse(likeCountController.text);
        if (likeThreshold != null) {
          bodies['like_threshold'] = likeThreshold;
        } else {
          // 유효하지 않은 숫자일 경우 예외 처리
          Get.snackbar('입력 오류', '좋아요 수를 올바르게 입력하세요.');
          return; // 요청 중단
        }
      }
      final response = await apiService.postRequest('reward/condition/create', bodies);
      if (response['message'] == "RewardCondition이 성공적으로 생성되었습니다.") {
        Get.snackbar("생성 성공", "리워드 지급조건이 성공적으로 생성되었습니다.");
        Get.offAllNamed(AppRoutes.REWARDS);
      } else {
        Get.snackbar("생성 실패", "${response['message']}");
      }
    } catch (e) {
      print('failed create reward condition : $e');
    }

  }

}
//    "user_id": 1,
//   	"name" : "이름",
//     "description" : "커뮤",
//     "type" : "INSERT",
//     "typesample" : "이부분 주석임 // 'RANDOM_AUTHOR', 'INSERT', 'TOP_LIKED', 'RANDOM_THRESHOLD', 'FIRST_N', 'CUSTOM'  이 string중 택 1",
//     "reward_count" : 1,
//     "like_threshold" : 10