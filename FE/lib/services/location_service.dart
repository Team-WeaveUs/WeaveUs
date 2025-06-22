import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  //현재 위치 반환
  Future<Position> getCurrentLocation({
    double fallbackLat = 37.339962, // 한국공학대학교
    double fallbackLng = 126.734236,
  }) async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw Exception('위치 서비스 꺼짐');

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('위치 권한 거부됨');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('위치 권한 영구 거부됨');
      }

      return await Geolocator.getCurrentPosition();
    } catch (e) {
      print("⚠️ 위치 요청 실패: $e");
      // 기본 좌표 반환
      return Position(
        latitude: fallbackLat,
        longitude: fallbackLng,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0, altitudeAccuracy: 0, headingAccuracy: 0,
      );
    }
  }

  //읍면동 데이터 불러오기.
  Future<List<dynamic>> loadData() async {
    final String response = await rootBundle.loadString(
        'assets/emd_touch_neighbors.json');
    return json.decode(response);
  }

  double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    final distance = Geolocator.distanceBetween(lat1, lng1, lat2, lng2);
    return distance / 1000; // meter to kilometer
  }

  Future<String> findClosestArea(double lat, double lng) async {
    final data = await loadData();
    double minDistance = double.infinity;
    String closestArea = '';
    for (var area in data) {
      double distance = calculateDistance(lat, lng, area['lat'], area['lng']);
      if (distance < minDistance) {
        minDistance = distance;
        closestArea = area['adm_cd'];
      }
    }
    return closestArea;
  }

  Future<List<dynamic>> findNeighbors(double lat, double lng) async {
    final data = await loadData();
    String closestArea = '';
    List<dynamic> neighbors = [];
    closestArea = await findClosestArea(lat, lng);
    print(closestArea);

    for (var neighbor in data) {
      if (neighbor['adm_cd'] == closestArea) {
        neighbors = neighbor['neighbors'].map((n) => n['adm_cd']).toList();
        break;
      }
    }
    neighbors.add(closestArea);
    return neighbors;
  }
}