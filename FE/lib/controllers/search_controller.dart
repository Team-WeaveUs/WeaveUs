import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

import '../models/weave_data_model.dart';

import '../services/token_service.dart';
import '../services/api_service.dart';
import '../services/location_service.dart';

class WeaveSearchController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final TokenService _tokenService = Get.find<TokenService>();
  final LocationService locationService;

  final TextEditingController textController = TextEditingController();

  final RxList<Map<String, dynamic>> searchResults =
      <Map<String, dynamic>>[].obs;
  final RxList<String> recentSearches = <String>[].obs;
  final RxBool isNoResults = false.obs;
  final RxBool isShowMap = false.obs;
  final RxBool isMapFolded = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool mapLoading = false.obs;
  final Rxn<Position> position = Rxn<Position>();
  final RxList<JoinWeave> joinWeaveData = <JoinWeave>[].obs;
  final RxBool isWeaveResult = true.obs;
  final RxString myUId = ''.obs;

  WeaveSearchController({required this.locationService});

  @override
  void onInit() {
    super.onInit();
    getRecentLocation();
    debounce(
      RxString(''),
      (_) => search(textController.text),
      time: const Duration(milliseconds: 500),
    );

  }

  // 📌 검색 실행
  Future<void> search(String query) async {
    if (query.isEmpty) {
      print("검색어를 입력하세요!");
      return;
    }
    isLoading.value = true;

    try {
      Map<String, dynamic> response;

      if (query.startsWith('@')) {
        isWeaveResult.value = false;
        response = await _apiService.postRequest("search/user", {
          "nickname": query.substring(1),
        });
      } else {
        isWeaveResult.value = true;
        response = await _apiService.postRequest("search/weave", {
          "title": query,
        });
      }

      if (response.isNotEmpty) {
        if (response['weaves'] is List && response['weaves'].isNotEmpty) {
          searchResults.value =
              List<Map<String, dynamic>>.from(response['weaves']);
          isNoResults.value = false;
        } else if (response['users'] is List && response['users'].isNotEmpty) {
          searchResults.value =
              List<Map<String, dynamic>>.from(response['users']);
          isNoResults.value = false;
        } else {
          searchResults.clear();
          isNoResults.value = true;
        }
      } else {
        searchResults.clear();
        isNoResults.value = true;
      }
    } catch (e) {
      print("❌ 검색 실패: $e");
      searchResults.clear();
      isNoResults.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  // 📌 최근 검색 추가
  void addRecentSearch(String query) {
    if (!recentSearches.contains(query)) {
      recentSearches.insert(0, query);
      if (recentSearches.length > 10) {
        recentSearches.removeLast();
      }
    }
  }

  // 📌 최근 검색 초기화
  void clearRecentSearches() {
    recentSearches.clear();
  }

  void toggleSubscribe(int targetUserId) async {
    try {
      final userId = await _tokenService.loadUserId();
      await _apiService.postRequest('user/subscribe/update', {
        'user_id': userId,
        'target_user_id': targetUserId,
      });

      // 상태 반전 (0 -> 1, 1 -> 0)
      final index = searchResults
          .indexWhere((result) => result['user_id'] == targetUserId);
      if (index != -1) {
        final currentStatus = searchResults[index]['subscribe_status'] ?? 0;
        searchResults[index]['subscribe_status'] = currentStatus == 1 ? 0 : 1;
        searchResults.refresh();
      }
    } catch (e) {
      print('구독 처리 실패: $e');
    }
  }

  Future<void> getRecentLocation() async {
    isLoading.value = true;
    mapLoading.value = true;
    myUId.value = await _tokenService.loadUserId();
    try {
      position.value = await locationService.getCurrentLocation();
    } catch (e) {
      print("locationerror : $e");
    } finally {
      isLoading.value = false;
    }
    fetchMapMarker();
  }

  Future<void> fetchMapMarker() async {
    final userId = await _tokenService.loadUserId();
    final areaId = await locationService.findNeighbors(
        position.value!.latitude, position.value!.longitude);
    areaId.forEach((a) => print(a));
    print('areaid: $areaId');
    final response = await _apiService.postRequest(
        'weave/join/get/area', {'user_id': userId, 'area_ids': areaId});
    joinWeaveData.value =
        (response['weaves'] as List).map((e) => JoinWeave.fromJson(e)).toList();

    // 각 위브와의 거리 계산
    if (position.value != null) {
      for (var weave in joinWeaveData) {
        final distanceInMeters = Geolocator.distanceBetween(
          position.value!.latitude,
          position.value!.longitude,
          weave.lat,
          weave.lng,
        );
        weave.distance = distanceInMeters / 1000; // 미터를 킬로미터로 변환
      }
      joinWeaveData.sort((a, b) => a.distance.compareTo(b.distance));
    }

    mapLoading.value = false;
  }

  // 📌 지도 상태 토글
  void toggleMapView() => isShowMap.toggle();

  void foldMap() => isMapFolded.value = true;

  void unfoldMap() => isMapFolded.value = false;

}
