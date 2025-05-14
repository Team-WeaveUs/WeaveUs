import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import 'package:weave_us/controllers/new_weave_controller.dart';
import 'package:weave_us/services/location_service.dart';

import '../services/map_service.dart';

class NewJoinWeaveController extends NewWeaveController {
  final MapService mapService;
  final LocationService locationService;

  RxString closestAreaName = ''.obs;
  Rxn<Position> position = Rxn<Position>();
  Rxn<NLatLng> selectedLatLng = Rxn<NLatLng>();
  RxBool isLoading = false.obs;
  RxString error = ''.obs;

  NewJoinWeaveController({
    required this.locationService,
    required this.mapService,
    required super.apiService,
    required super.tokenService,
  });

  @override
  void onInit() {
    super.onInit();
    fetchLocation();
  }

  void onMapTap(NLatLng latLng) async {
    mapService.setSelectedPosition(latLng);
    closestAreaName.value = await locationService.findClosestArea(latLng.latitude, latLng.longitude);
    selectedLatLng.value = latLng;
  }

  void onMarkerTap(NMarker marker) {

  }

  Future<void> fetchLocation() async {
    isLoading.value = true;
    error.value = '';
    try {
      final location = await locationService.getCurrentLocation();
      selectedLatLng.value = NLatLng(location.latitude, location.longitude);
      position.value = location;
    } catch (e) {
      error.value = e.toString();
      print('error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
