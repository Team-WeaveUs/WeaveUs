import 'package:get/get.dart';
import '../services/api_service.dart';
import '../models/reward_model.dart';
import '../services/token_service.dart';

class RewardController extends GetxController {
  ApiService apiService;
  TokenService tokenService;
  
  RewardController({required this.apiService, required this.tokenService});
  
  final RxList<Reward> rewardList = <Reward>[].obs;
  final RxBool isOwner = false.obs;

  @override
  void onInit() {
    super.onInit();
    initRewards();
  }
  void initRewards() async {
    try {
      final isOwner = await tokenService.loadIsOwner();
      print("isOwner: $isOwner");
      this.isOwner.value = isOwner;
      print("isOwner: $isOwner");
      if (isOwner) {
        await fetchMyRewards();
      } else {
        await fetchRewards();
      }
    } catch(e) {
      print('Error fetching rewards: $e');
    }
  }
  Future<void> fetchRewards() async {
    try {
      final userId = await tokenService.loadUserId();
      final rewards = await apiService.postRequest("user/get/reward", {
        "user_id": userId,
      });
      rewardList.value = List<Map<String, dynamic>>.from(rewards['rewards'])
          .map((e) => Reward.fromJson(e))
          .toList();
    } catch (e) {
      print('Error fetching rewards: $e');
    }
  }
  Future<void> fetchMyRewards() async {
    try {
      final userId = await tokenService.loadUserId();
      final rewards = await apiService.postRequest("reward/get", {
        "target_user_id": userId,
        "selection_type": 0,
      });
      rewardList.value = List<Map<String, dynamic>>.from(rewards['rewards'])
          .map((e) => Reward.fromJson(e))
          .toList();
    } catch (e) {
      print('Error fetching My rewards: $e');
    }
  }
}
