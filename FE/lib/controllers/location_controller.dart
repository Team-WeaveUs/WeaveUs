import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';  // 위치를 받아오는 서비스

class LocationController extends GetxController {
  final LocationService _locationService = LocationService();

  Rxn<Position> position = Rxn<Position>();
  RxString error = ''.obs;
  RxBool isLoading = false.obs;
  RxString closestAreaName = ''.obs;
  RxList<String> neighbors = <String>[].obs;

  // JSON 데이터를 로드하는 함수
  Future<List<dynamic>> loadData() async {
    final String response = await rootBundle.loadString('assets/emd_touch_neighbors.json');
    return json.decode(response);
  }

  // 두 위치 간의 거리 계산 함수 (단위: km)
  double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    final distance = Geolocator.distanceBetween(lat1, lng1, lat2, lng2);
    return distance / 1000; // meter to kilometer
  }

  // 가장 가까운 읍면동을 찾는 함수
  Future<void> findClosestArea() async {
    if (position.value == null) return;

    final data = await loadData();

    double minDistance = double.infinity;
    Map<String, dynamic> closestArea = {};

    for (var area in data) {
      double distance = calculateDistance(
        position.value!.latitude,
        position.value!.longitude,
        area['lat'],
        area['lng'],
      );

      if (distance < minDistance) {
        minDistance = distance;
        closestArea = area;
      }
    }

    closestAreaName.value = closestArea['name'];
    neighbors.value = closestArea['neighbors']
        .map<String>((neighbor) => neighbor['name'] as String)
        .toList();
  }

  // 현재 위치를 가져오는 메서드
  Future<void> fetchLocation() async {
    isLoading.value = true;
    error.value = '';
    try {
      position.value = await _locationService.getCurrentLocation();
      await findClosestArea();  // 위치가 업데이트되면 가장 가까운 읍면동을 찾음
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
