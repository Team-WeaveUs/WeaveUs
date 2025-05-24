import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  //현재 위치 반환
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('위치 서비스가 비활성화되어 있습니다.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('위치 권한이 거부되었습니다.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('위치 권한이 영구적으로 거부되었습니다.');
    }

    return await Geolocator.getCurrentPosition();
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