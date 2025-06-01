import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/owner_reward_model.dart';
import '../services/api_service.dart';
import '../services/token_service.dart';

class NewRewardController extends GetxController {
  // 텍스트 필드
  final title = ''.obs;
  final descriptionController = TextEditingController();
  final descriptionText = ''.obs;
  final validityString = '0d'.obs;

  final rewardContentController = TextEditingController();
  final postContentController = TextEditingController();
  final passwordController = TextEditingController();
  final ApiService apiService;
  final TokenService tokenService;

  NewRewardController({required this.apiService, required this.tokenService});


  final Rxn<DateTime> startDate = Rxn<DateTime>();
  final Rxn<DateTime> endDate = Rxn<DateTime>();


  void setTitle(String value) => title.value = value;
  void setDescriptionText(String value) => descriptionText.value = value;
  void setDescription(String value) {
    descriptionController.text = value;
    descriptionText.value = value;
  }

  void pickDate(BuildContext context, bool isStart) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );

    if (picked != null) {
      if (isStart) {
        startDate.value = picked;
        if (endDate.value != null && endDate.value!.isBefore(picked)) {
          endDate.value = null;
        }
      } else {
        endDate.value = picked;
      }
    }
  }

  Future<void> submitReward() async
  {
    final titleVal = title.value.trim();
    final descriptionVal = descriptionController.text.trim();
    final validityVal = validityString.value;
    final userId = await tokenService.loadUserId();
    final passwordVal = passwordController.text.trim();

    if (titleVal.isEmpty || descriptionVal.isEmpty || passwordVal.isEmpty) {
      print("❌ [submitReward] 유효하지 않은 입력값 있음");
      Get.snackbar("에러", "모든 항목을 입력해주세요");
      return;
    }

    final rewardPayload = CreateRewardRequest(
      userId: userId,
      title: titleVal,
      description: descriptionVal,
      validity: validityVal,
      password: passwordVal,
    );

    print("📤 [submitReward] Payload → ${rewardPayload.toJson()}");

    try {
      final res = await apiService.postRequest("reward/create", rewardPayload.toJson());
      print("📥 [submitReward] 응답 데이터 → $res");

      if ((res['statusCode'] == 200 ||
              res['message']?.toString().contains("성공") == true)) {
        Get.back();
        Get.snackbar("성공", "리워드가 등록되었습니다.");
        Get.offAllNamed('/owner/home');
      } else {
        print("❌ [submitReward] 실패 응답: $res");
        throw Exception("리워드 생성 실패: $res");
      }
    } catch (e) {
      print("❌ [submitReward] 예외 발생: $e");
      Get.snackbar("오류", "리워드 등록 중 오류 발생: $e");
    }
  }

}
