import 'package:get/get.dart';
import '../models/friend_invite_model.dart';
import '../services/api_service.dart';
import '../services/token_service.dart';

class FriendInviteDialogController extends GetxController {
  final ApiService apiService;
  final TokenService tokenService;
  final searchQuery = ''.obs;

  // ✅ 검색어 필터링된 친구 리스트
  List<FriendInviteModel> get filteredSubscribeList {
    if (searchQuery.value.isEmpty) {
      return mySubscribeList;
    }
    return mySubscribeList
        .where((user) => user.nickname.contains(searchQuery.value))
        .toList();
  }

  void updateSearchQuery(String value) {
    searchQuery.value = value.trim();
  }

  FriendInviteDialogController({
    required this.apiService,
    required this.tokenService,
  });

  final RxList<FriendInviteModel> mySubscribeList = <FriendInviteModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMySubscribe();
  }

  Future<void> fetchMySubscribe() async {
    isLoading.value = true;

    try {
      final userId = await tokenService.loadUserId();
      final response = await apiService.postRequest(
        'GetProfileSubscribeInfo',
        {
          'target_user_id': userId,
          'selection_type': 0,
        },
      );

      if (response is Map && response['data'] is List) {
        mySubscribeList.value = List<Map<String, dynamic>>.from(response['data'])
            .map((e) => FriendInviteModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      print('❌ 구독자 불러오기 실패: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
