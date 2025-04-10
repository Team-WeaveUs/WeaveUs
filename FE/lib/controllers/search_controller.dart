import 'package:get/get.dart';
import '../services/api_service.dart';

class WeaveSearchController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  
  // Observable 변수들
  final RxList<Map<String, dynamic>> searchResults = <Map<String, dynamic>>[].obs;
  final RxBool isNoResults = false.obs;
  final RxBool isShowMap = false.obs;

  @override
  void onInit() {
    super.onInit();
    print('WeaveSearchController initialized');
  }

  // 검색 메서드
  Future<void> search(String query) async {
    if (query.isEmpty) {
      print("🚨 검색어를 입력하세요!");
      return;
    }

    print("🔄 API 호출 시작: $query");

    try {
      Map<String, dynamic> response;
      if (query.startsWith('@')) {
        response = await _apiService.postRequest(
          "search/user",
          {"nickname": query.substring(1)}
        );
      } else {
        response = await _apiService.postRequest(
          "search/weave",
          {"title": query}
        );
      }

      if (response != null && response is Map) {
        if (response['weaves'] is List && response['weaves'].isNotEmpty) {
          searchResults.value = List<Map<String, dynamic>>.from(response['weaves']);
          isNoResults.value = false;
          print("✅ 검색 성공: ${searchResults}");
        } else if (response['users'] is List && response['users'].isNotEmpty) {
          searchResults.value = List<Map<String, dynamic>>.from(response['users']);
          isNoResults.value = false;
          print("✅ 검색 성공: ${searchResults}");
        } else {
          searchResults.clear();
          isNoResults.value = true;
          print("❌ 검색 결과가 없음");
        }
      } else {
        searchResults.clear();
        isNoResults.value = true;
        print("❌ 검색 실패: ${response}");
      }
    } catch (e) {
      print("❌ API 요청 실패: $e");
      searchResults.clear();
      isNoResults.value = true;
    }
  }

  // 지도/리스트 뷰 토글
  void toggleMapView() {
    isShowMap.toggle();
  }

  // 검색 결과 초기화
  void clearResults() {
    searchResults.clear();
    isNoResults.value = false;
  }
} 