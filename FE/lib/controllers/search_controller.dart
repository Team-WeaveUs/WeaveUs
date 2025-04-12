import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';

class WeaveSearchController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  // 📌 검색창 텍스트 컨트롤러
  final TextEditingController textController = TextEditingController();

  // 📌 상태값
  final RxList<Map<String, dynamic>> searchResults = <Map<String, dynamic>>[].obs;
  final RxList<String> recentSearches = <String>[].obs;
  final RxBool isNoResults = false.obs;
  final RxBool isShowMap = false.obs;
  final RxBool isMapFolded = false.obs;

  @override
  void onInit() {
    super.onInit();
    print('WeaveSearchController initialized');
  }

  // 📌 검색 실행
  Future<void> search(String query) async {
    if (query.isEmpty) {
      print("🚨 검색어를 입력하세요!");
      return;
    }

    print("🔄 API 호출 시작: $query");

    try {
      Map<String, dynamic> response;

      if (query.startsWith('@')) {
        response = await _apiService.postRequest("search/user", {
          "nickname": query.substring(1),
        });
      } else {
        response = await _apiService.postRequest("search/weave", {
          "title": query,
        });
      }

      if (response.isNotEmpty) {
        if (response['weaves'] is List && response['weaves'].isNotEmpty) {
          searchResults.value = List<Map<String, dynamic>>.from(response['weaves']);
          isNoResults.value = false;
        } else if (response['users'] is List && response['users'].isNotEmpty) {
          searchResults.value = List<Map<String, dynamic>>.from(response['users']);
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

  // 📌 지도 상태 토글
  void toggleMapView() => isShowMap.toggle();
  void foldMap() => isMapFolded.value = true;
  void unfoldMap() => isMapFolded.value = false;
}