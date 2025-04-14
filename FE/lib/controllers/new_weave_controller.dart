import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../services/api_service.dart';
import '../services/token_service.dart';

class NewWeaveController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final ApiService apiService;
  final TokenService tokenService;

  NewWeaveController({required this.apiService, required this.tokenService});

  final RxString selectedWeave = ''.obs;
  final RxString selectedOpenRange = ''.obs;
  final RxString selectedInviteOption = ''.obs;

  final RxBool isFormValid = false.obs; // ✅ 이걸로만 사용

  int get typeId {
    switch (selectedWeave.value) {
      case '내 Weave': return 1;
      case 'Global': return 2;
      case 'Private': return 3;
      default: return 1;
    }
  }

  int get privacyId {
    switch (selectedOpenRange.value) {
      case '모두 공개': return 1;
      case '초대한 사용자': return 2;
      case '나만 보기': return 3;
      default: return 1;
    }
  }

  void updateSelections({String? weave, String? range, String? invite}) {
    selectedWeave.value = weave ?? '';
    selectedOpenRange.value = range ?? '';
    selectedInviteOption.value = invite ?? '';
    validateForm();
  }

  void validateForm() {
    isFormValid.value = selectedWeave.value.isNotEmpty &&
        nameController.text.trim().isNotEmpty &&
        descriptionController.text.trim().isNotEmpty;
  }

  Future<void> createWeave() async {
    final title = nameController.text.trim();
    final desc = descriptionController.text.trim();

    try {
      final response = await apiService.postRequest("WeaveUpload", {
        "title": title,
        "description": desc,
        "privacy_id": privacyId,
        "type_id": typeId
      });

      if (response != null && response['message'] == '위브 생성 성공') {
        debugPrint("위브 생성 성공!");
        Get.snackbar("성공", "위브가 성공적으로 생성되었습니다");
        Get.offAllNamed('/home');
      } else {
        debugPrint("위브 생성 실패: ${response.toString()}");
        Get.snackbar("실패", "위브 생성에 실패했습니다");
      }
    } catch (e) {
      debugPrint("오류 발생: $e");
      Get.snackbar("에러", "서버 오류가 발생했습니다");
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
