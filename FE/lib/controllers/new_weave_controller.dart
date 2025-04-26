import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../models/friend_invite_model.dart';
import '../services/api_service.dart';
import '../services/token_service.dart';
import 'friend_invite_dialog_controller.dart';

class NewWeaveController extends GetxController {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  final ApiService apiService;
  final TokenService tokenService;

  NewWeaveController({required this.apiService, required this.tokenService});

  final RxString selectedWeave = ''.obs;
  final RxString selectedOpenRange = ''.obs;
  final RxString selectedInviteOption = ''.obs;

  final RxList<FriendInviteModel> selectedFriends = <FriendInviteModel>[].obs;
  final RxBool isFormValid = false.obs;

  int get typeId => switch (selectedWeave.value) {
    '내 Weave' => 1,
    'Global' => 2,
    'Private' => 3,
    _ => 1,
  };

  int get privacyId => switch (selectedOpenRange.value) {
    '모두 공개' => 1,
    '초대한 사용자' => 2,
    '나만 보기' => 3,
    _ => 1,
  };

  void updateSelections({String? weave, String? range, String? invite}) {
    selectedWeave.value = weave ?? '';
    selectedOpenRange.value = range ?? '';
    selectedInviteOption.value = invite ?? '';
    validateForm();
  }

  void addFriend(FriendInviteModel friend) {
    if (!selectedFriends.contains(friend)) {
      selectedFriends.add(friend);
    }
  }

  void validateForm() {
    isFormValid.value = selectedWeave.value.isNotEmpty &&
        nameController.text.trim().isNotEmpty &&
        descriptionController.text.trim().isNotEmpty;
  }

  Future<void> createWeave() async {
    if (!Get.isDialogOpen!) {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
    }

    try {
      final res = await apiService.postRequest("WeaveUpload", {
        "title": nameController.text.trim(),
        "description": descriptionController.text.trim(),
        "privacy_id": privacyId,
        "type_id": typeId,
      });

      if (res['message'] == '위브 생성 성공') {
        Get.back();
        Get.snackbar("성공", "위브가 생성되었습니다");
        Get.offAllNamed('/home');
      } else {
        Get.back();
        Get.snackbar("실패", "위브 생성 실패");
      }
    } catch (e) {
      Get.back();
      Get.snackbar("에러", "네트워크 오류");
    }
  }

  @override
  void onInit() {
    super.onInit();
    nameController.addListener(validateForm);
    descriptionController.addListener(validateForm);
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}