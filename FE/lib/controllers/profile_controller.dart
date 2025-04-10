import 'package:get/get.dart';

import '../services/api_service.dart';
import '../services/token_service.dart';

import '../models/profile_model.dart';

class ProfileController extends GetxController {
  final ApiService apiService;
  final TokenService tokenService;

  ProfileController({required this.apiService, required this.tokenService});

  final profile = Profile(
    message: '',
    userId: 0,
    nickname: '',
    img: '',
    likes: 0,
    subscribes: 0,
    postList: [],
  ).obs;
  final postList = <ProfilePostList>[].obs;

  @override
  void onInit() {
    super.onInit();
    Future.microtask(() {
      _fetchMyProfile();
    });
  }

  Future<void> _fetchMyProfile() async {
    try {
      String userId = await tokenService.loadUserId();
      var response = await apiService.postRequest('ProfileInfo', {'target_user_id': userId, 'user_id': userId, 'post_count':10});
      final Profile fetchedProfile = Profile.fromJson(response);
      profile.value = fetchedProfile;
      postList.value = fetchedProfile.postList;
    } catch (e) {
      print('Error fetching profile: $e');
    }
  }

  Future<void> fetchProfile(int targetUserId) async {
    try {
      String userId = await tokenService.loadUserId();
      var response = await apiService.postRequest('ProfileInfo', {'target_user_id': targetUserId, 'user_id': userId, 'post_count':10});
      final Profile fetchedProfile = Profile.fromJson(response);
      profile.value = fetchedProfile;
    } catch (e) {
      print('Error fetching profile: $e');
    }
  }
}
