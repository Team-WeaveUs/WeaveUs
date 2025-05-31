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

  final selectedRewardText = ''.obs;
  final selectedRewardId = 0.obs;

  // final selectedWeave = Rxn<String>();
  // final selectedRange = Rxn<String>();
  // final selectedInvite = Rxn<String>();

  final isFormValid = false.obs;

  RxString closestAreaName = ''.obs;
  Rxn<Position> position = Rxn<Position>();
  Rxn<NLatLng> selectedLatLng = Rxn<NLatLng>();
  RxBool isLoading = false.obs;
  RxString error = ''.obs;

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
  }

  void _validateForm() {
    isFormValid.value = nameController.text.trim().isNotEmpty &&
        descriptionController.text.trim().isNotEmpty &&
    position.value != null;
  }

  void selectReward(String title, int id) {
    selectedRewardText.value = title;
    selectedRewardId.value = id;
  }

  void onMapTap(NPoint point, NLatLng latLng) async {
    _validateForm();
    mapService.setSelectedPosition(latLng);
    closestAreaName.value = await locationService.findClosestArea(
        latLng.latitude, latLng.longitude);
    selectedLatLng.value = latLng;
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

    try {
      final bodies = {
        "user_id": userId,
        "title": title,
        "description": description,
        "reward_id": rewardId,
        "reward_condition_id": 1,
        "reward_validity": "30d",
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

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    selectedRewardText.close();
    selectedRewardId.close();
    closestAreaName.close();
    position.close();
    selectedLatLng.close();
    super.onClose();
  }
}
