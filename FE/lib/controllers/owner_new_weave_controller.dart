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

  final selectedWeave = Rxn<String>();
  final selectedRange = Rxn<String>();
  final selectedInvite = Rxn<String>();

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
    isFormValid.value = nameController.text.trim().isNotEmpty &&
        descriptionController.text.trim().isNotEmpty &&
        selectedWeave.value != null &&
        selectedRange.value != null &&
        selectedInvite.value != null;
  }

  void selectReward(String title) {
    selectedRewardText.value = title;
  }

  void onMapTap(NPoint point, NLatLng latLng) async {
    mapService.setSelectedPosition(latLng);
    closestAreaName.value = await locationService.findClosestArea(latLng.latitude, latLng.longitude);
    selectedLatLng.value = latLng;
  }

  Future<void> fetchLocation() async {
    isLoading.value = true;
    error.value = '';
    try {
      final location = await locationService.getCurrentLocation();
      selectedLatLng.value = NLatLng(location.latitude, location.longitude);
      closestAreaName.value = await locationService.findClosestArea(location.latitude, location.longitude);
      position.value = location;
    } catch (e) {
      error.value = e.toString();
      print('error: $e');
    } finally {
      isLoading.value = false;
    }
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
