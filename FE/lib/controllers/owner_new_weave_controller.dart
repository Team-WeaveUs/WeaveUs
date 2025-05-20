import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/api_service.dart';
import '../services/token_service.dart';

class OwnerNewWeaveController extends GetxController {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  final selectedRewardText = ''.obs;

  final selectedWeave = Rxn<String>();
  final selectedRange = Rxn<String>();
  final selectedInvite = Rxn<String>();

  final isFormValid = false.obs;

  final ApiService apiService;
  final TokenService tokenService;

  OwnerNewWeaveController({required this.apiService, required this.tokenService});

  void updateSelections({
    required String weave,
    required String range,
    required String invite,
  }) {
    selectedWeave.value = weave;
    selectedRange.value = range;
    selectedInvite.value = invite;
    _validateForm();
  }

  void _validateForm() {
    isFormValid.value =
        nameController.text.trim().isNotEmpty &&
            descriptionController.text.trim().isNotEmpty &&
            selectedWeave.value != null &&
            selectedRange.value != null &&
            selectedInvite.value != null;
  }

  void selectReward(String title) {
    selectedRewardText.value = title;
  }

  void createWeave() {

    // TODO: 실제 API 호출 로직 추가
    Get.snackbar('성공', '위브 생성 완료!');
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
