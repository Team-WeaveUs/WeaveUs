import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../models/reward_condition_model.dart';
import '../services/api_service.dart';
import '../services/location_service.dart';
import '../services/token_service.dart';

class OwnerNewWeaveController extends GetxController {
  final ApiService apiService;
  final TokenService tokenService;
  final LocationService locationService;

  OwnerNewWeaveController({
    required this.apiService,
    required this.tokenService,
    required this.locationService,
  });

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final rewardConditionFilter = TextEditingController();
  final nameFocusNode = FocusNode();
  final descriptionFocusNode = FocusNode();

  final Rx<DateTime> selectedDate = DateTime.now().obs;

  final isFormValid = false.obs;

  RxString closestAreaName = ''.obs;
  RxString error = ''.obs;
  RxString selectedRewardText = ''.obs;
  RxString rewardGiveType = ''.obs;
  RxString rewardConditionName = ''.obs;
  RxString rewardConditionType = ''.obs;

  RxInt rewardConditionId = 0.obs;
  RxInt selectedRewardId = 0.obs;

  RxBool isLoading = false.obs;
  Rxn<Position> position = Rxn<Position>();

  final rewardConditionList = <RewardCondition>[].obs;
  RxList<RewardCondition> filteredRewardConditionList = <RewardCondition>[].obs;

  Rxn<LatLng> selectedLocation = Rxn<LatLng>();

  @override
  void onInit() {
    super.onInit();
    fetchLocation();
    fetchRewardConditions();

    // 텍스트 필드 리스너 추가
    nameController.addListener(_validateForm);
    descriptionController.addListener(_validateForm);

    // 포커스 노드 리스너 추가
    nameFocusNode.addListener(() {
      if (!nameFocusNode.hasFocus) {
        Get.focusScope?.unfocus();
      }
    });

    descriptionFocusNode.addListener(() {
      if (!descriptionFocusNode.hasFocus) {
        Get.focusScope?.unfocus();
      }
    });
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    nameFocusNode.dispose();
    descriptionFocusNode.dispose();
    selectedRewardText.close();
    selectedRewardId.close();
    closestAreaName.close();
    position.close();
    super.onClose();
  }

  void _validateForm() {
    isFormValid.value = nameController.text.trim().isNotEmpty &&
        descriptionController.text.trim().isNotEmpty &&
        selectedRewardId.value != 0;
  }

  void selectReward(String title, int id) {
    selectedRewardText.value = title;
    selectedRewardId.value = id;
    _validateForm();
  }

  void filterRewardCondition(String query) async {
    if (query.isEmpty) {
      filteredRewardConditionList.assignAll(rewardConditionList);
    }
    filteredRewardConditionList.value = rewardConditionList.where((condition) {
      return condition.name.toLowerCase().contains(query.toLowerCase());
    }).toList();
    print(rewardConditionList.length);
  }

  Future<void> fetchLocation() async {
    isLoading.value = true;
    error.value = '';
    try {
      final location = await locationService.getCurrentLocation();

      closestAreaName.value = await locationService.findClosestArea(
          location.latitude, location.longitude);
      position.value = location;
      selectedLocation.value = LatLng(location.latitude, location.longitude);
    } catch (e) {
      error.value = e.toString();
      print('error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchRewardConditions() async {
    try {
      final userId = await tokenService.loadUserId();
      final rewardConditions =
          await apiService.postRequest("reward/condition/get", {
        "user_id": userId,
      });
      rewardConditionList.value =
          List<Map<String, dynamic>>.from(rewardConditions['conditions'])
              .map((e) => RewardCondition.fromJson(e))
              .toList();
      filteredRewardConditionList.assignAll(rewardConditionList);
      rewardConditionId.value = rewardConditionList.first.id;
    } catch (e) {
      print('Error fetching reward conditions: $e');
    }
  }

  Future<void> createJoinWeave() async {
    final locationString =
        '${selectedLocation.value!.latitude} ${selectedLocation.value!.longitude}';
    final userId = await tokenService.loadUserId();
    final rewardId = selectedRewardId.value;
    final areaId = closestAreaName.value;
    final title = nameController.text;
    final description = descriptionController.text;
    final date = selectedDate.value.toString().split(' ')[0];
    final rewardCondition = rewardConditionId.value;

    try {
      final bodies = {
        "user_id": userId,
        "title": title,
        "description": description,
        "reward_id": rewardId,
        "reward_condition_id": rewardCondition, // 지급 조건을 만들고, 그 아이디를 넣으면 된다.
        "reward_validity": date, // 날짜 yyyy.mm.dd 형식으로 넣어야 한다.
        "location": locationString,
        "area_id": areaId
      };
      print(bodies);
      apiService.postRequest('weave/join/create', bodies);
    } catch (e) {
      print('join weave upload error: $e');
    } finally {
      Get.snackbar('성공', '위브 생성 완료!');
      Get.offAllNamed('/home');
    }
  }
}
