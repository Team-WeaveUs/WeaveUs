import 'package:get/get.dart';

import '../models/profile_post_list_model.dart';
import '../models/weave_profile_model.dart';

import '../services/api_service.dart';
import '../services/token_service.dart';

class WeaveProfileController extends GetxController{
  final ApiService apiService;
  final TokenService tokenService;

  WeaveProfileController({required this.apiService, required this.tokenService});

  final weaveProfile = WeaveProfile(
    message: '',
    weaveId: 0,
    weaveTitle: '',
    weaveDescription: '',
    isJoinWeave: 0,
    privacyId: 0,
    rewardId: 0,
    rewardConditionId: 0,
    weaveLikes: 0,
    weaveContributers: 0,
    posts: [],
    createUserNickname: '',
    weaveUserId: 0,
    rewardConditionType: '',
  ).obs;
  final postList = <ProfilePostList>[].obs;
  final userId = ''.obs;

  @override
  onInit(){
    super.onInit();
    int? parsedUserId = int.tryParse(Get.parameters['weave_id'] ?? '');
    final weaveId = parsedUserId?.toString();
    fetchWeaveProfile(weaveId!);
  }
  Future<void> fetchWeaveProfile(String weaveId) async {
    try {
      final userId = await tokenService.loadUserId();
      this.userId.value = userId;
      final bodies = {
        "user_id": userId,
        "weave_id": weaveId,
        "start_at": 0,
        "count": 10
      };
      final response = await apiService.postRequest("weave/get/id", bodies);
      weaveProfile.value = WeaveProfile.fromJson(response);
      postList.value = weaveProfile.value.posts;
    } catch (e) {
      print("Error fetching weave profile: $e");
    }
  }
}