import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../services/api_service.dart';
import '../services/location_service.dart';
import '../services/map_service.dart';
import '../services/token_service.dart';

class OwnerNewWeaveController extends GetxController {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final nameFocusNode = FocusNode();
  final descriptionFocusNode = FocusNode();

  final selectedRewardText = ''.obs;
  final selectedRewardId = 0.obs;
  final rewardGiveType = ''.obs;

  final Rx<DateTime> selectedDate = DateTime.now().obs;
  // final selectedWeave = Rxn<String>();
  // final selectedRange = Rxn<String>();
  // final selectedInvite = Rxn<String>();

  final isFormValid = false.obs;

  RxString closestAreaName = ''.obs;
  Rxn<Position> position = Rxn<Position>();
  Rxn<NLatLng> selectedLatLng = Rxn<NLatLng>();
  RxBool isLoading = false.obs;
  RxString error = ''.obs;
  RxInt rewardConditionId = 2.obs;

  final ApiService apiService;
  final TokenService tokenService;
  final MapService mapService;
  final LocationService locationService;

  OwnerNewWeaveController({
    required this.apiService,
    required this.tokenService,
    required this.locationService,
    required this.mapService,
  });

  @override
  void onInit() {
    super.onInit();
    fetchLocation();

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
    selectedLatLng.close();
    super.onClose();
  }

  void _validateForm() {
    isFormValid.value = nameController.text.trim().isNotEmpty &&
        descriptionController.text.trim().isNotEmpty &&
        selectedRewardId.value != 0 &&
        selectedLatLng.value != null;
  }

  void selectReward(String title, int id) {
    selectedRewardText.value = title;
    selectedRewardId.value = id;
    _validateForm();
  }

  void onMapTap(NPoint point, NLatLng latLng) async {
    mapService.setSelectedPosition(latLng);
    closestAreaName.value = await locationService.findClosestArea(
        latLng.latitude, latLng.longitude);
    selectedLatLng.value = latLng;
    _validateForm();
  }

  Future<void> fetchLocation() async {
    isLoading.value = true;
    error.value = '';
    try {
      final location = await locationService.getCurrentLocation();
      selectedLatLng.value = NLatLng(location.latitude, location.longitude);
      closestAreaName.value = await locationService.findClosestArea(
          location.latitude, location.longitude);
      position.value = location;
    } catch (e) {
      error.value = e.toString();
      print('error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createJoinWeave() async {
    final locationString =
        '${selectedLatLng.value!.latitude} ${selectedLatLng.value!.longitude}';
    final userId = await tokenService.loadUserId();
    final rewardId = selectedRewardId.value;
    final areaId = closestAreaName.value;
    final title = nameController.text;
    final description = descriptionController.text;
    final date = selectedDate.value.toString().split(' ')[0];

    try {
      final bodies = {
        "user_id": userId,
        "title": title,
        "description": description,
        "reward_id": rewardId,
        "reward_condition_id": 2, // 지급 조건을 만들고, 그 아이디를 넣으면 된다.
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
