import 'package:get/get.dart';
import '../models/reward_model.dart';
import '../services/api_service.dart';
import '../services/token_service.dart';

class RewardInviteDialogController extends GetxController {
  final ApiService apiService;
  final TokenService tokenService;


  RewardInviteDialogController({
    required this.apiService,
    required this.tokenService,
  });

  final RxList<Reward> myRewardList = <Reward>[].obs;
  final RxList<Reward> selectedRewards = <Reward>[].obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyReward();
  }

  /// 검색어 업데이트
  void updateSearchQuery(String value) {
    searchQuery.value = value.trim();
  }

  /// 필터링된 검색 리스트
  List<Reward> get filteredList {
    if (searchQuery.value.isEmpty) return myRewardList;
    return myRewardList
        .where((r) => r.title.contains(searchQuery.value))
        .toList();
  }

  /// 리워드 추가
  void addReward(Reward reward) {
    if (!selectedRewards.contains(reward)) {
      selectedRewards.add(reward);
    }
  }

  /// 리워드 제거
  void removeReward(Reward reward) {
    selectedRewards.remove(reward);
  }

  /// 내 리워드 목록 불러오기
  Future<void> fetchMyReward() async {

    isLoading.value = true;
    try {

      final userId = await tokenService.loadUserId();
      final response = await apiService.postRequest(
        'reward/get',
        {
          'target_user_id': userId,
          'selection_type': 0,
        },
      );

      if (response['rewards'] is List) {
        myRewardList.value = List<Map<String, dynamic>>.from(response['rewards'])
            .map((e) => Reward.fromJson(e))
            .toList();
      } else {
        print("⚠️ 서버 응답 형식 오류: $response");
      }
    } catch (e) {
      print("❌ 리워드 불러오기 실패: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
