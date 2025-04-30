import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/post_model.dart';
import '../services/api_service.dart';
import '../services/token_service.dart';

class WeaveSearchController extends GetxController {
  final ApiService apiService;
  final TokenService tokenService;

  WeaveSearchController({required this.apiService, required this.tokenService});

  final TextEditingController textController = TextEditingController();

  final RxList<Map<String, dynamic>> searchResults = <Map<String, dynamic>>[].obs;
  final RxList<String> recentSearches = <String>[].obs;
  final RxBool isNoResults = false.obs;
  final RxBool isShowMap = false.obs;
  final RxBool isMapFolded = false.obs;
  final RxBool isLoading = false.obs;
  final RxMap<int, List<Post>> postListMap = <int, List<Post>>{}.obs;
  final RxSet<String> subscribedUserIds = <String>{}.obs;
  final RxInt currentIndex = 0.obs;
  final myUId = ''.obs;

  final RxBool isUserSearch = false.obs; // ✅ 이 줄 추가! 꼭 밖에 선언해야 함

  late Worker _debouncer;

  @override
  void onInit() {
    super.onInit();

    _debouncer = debounce(
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

    print("API 호출 시작: $query");

    try {
      Map<String, dynamic> response;

      if (query.startsWith('@')) {
        isUserSearch.value = true;
        response = await apiService.postRequest("search/user", {
          "nickname": query.substring(1),
        });
      } else {
        isUserSearch.value = false;
        response = await apiService.postRequest("search/weave", {
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
    } finally{
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

  void toggleSubscribe(Post post) async {
    try {
      final myId = await tokenService.loadUserId();
      final isNowSubscribed = !subscribedUserIds.contains(post.userId);

      await apiService.postRequest('user/subscribe/update', {
        'user_id': myId,
        'target_user_id': post.userId,
      });

      final index = postListMap[currentIndex.value]!
          .indexWhere((p) => p.id == post.id);

      if (isNowSubscribed) {
        subscribedUserIds.add(post.userId as String);
        final updatedPost = post.copyWith(isSubscribed: true);
        postListMap[currentIndex.value]![index] = updatedPost;
        postListMap.refresh();

      } else {
        subscribedUserIds.remove(post.userId);
        final updatedPost = post.copyWith(isSubscribed: false);
        postListMap[currentIndex.value]![index] = updatedPost;
        postListMap.refresh();
      }
      print('구독 상태 반영 완료');
    } catch (e) {
      print('구독 처리 실패: $e');
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