import 'package:get/get.dart';
import '../models/friend_invite_model.dart';
import '../services/api_service.dart';
import '../services/token_service.dart';

class FriendInviteDialogController extends GetxController {
  final ApiService apiService;
  final TokenService tokenService;

  FriendInviteDialogController({
    required this.apiService,
    required this.tokenService,
  });

  final RxList<FriendInviteModel> mySubscribeList = <FriendInviteModel>[].obs;
  final RxList<FriendInviteModel> selectedFriends = <FriendInviteModel>[].obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMySubscribe();
  }

  // 친구 검색 필터
  void updateSearchQuery(String value) {
    searchQuery.value = value.trim();
  }

  // 검색 결과 필터
  List<FriendInviteModel> get filteredList {
    if (searchQuery.value.isEmpty) return mySubscribeList;
    return mySubscribeList
        .where((u) => u.nickname.contains(searchQuery.value))
        .toList();
  }

  // 친구 초대 추가 함수
  void addFriend(FriendInviteModel friend) {
    if (!selectedFriends.contains(friend)) {
      selectedFriends.add(friend);
    }
  }

  // 친구 삭제
  void removeFriend(FriendInviteModel friend) {
    selectedFriends.remove(friend);
  }

  // 구독자 리스트 불러오기
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
      print("구독자 불러오기 실패: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
