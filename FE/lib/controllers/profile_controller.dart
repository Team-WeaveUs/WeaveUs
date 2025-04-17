import 'package:get/get.dart';

import '../models/subscribe_data_model.dart';
import '../services/api_service.dart';
import '../services/token_service.dart';

import '../models/profile_model.dart';

class ProfileController extends GetxController {
  final ApiService apiService;
  final TokenService tokenService;

  ProfileController({required this.apiService, required this.tokenService});
  var isToggled = false.obs;

  String get toggleLabel => isToggled.value ? "프로필" : "구독";

  final profile = Profile(
    message: '',
    userId: 0,
    nickname: '',
    img: '',
    likes: 0,
    subscribes: 0,
    postList: [],
  ).obs;

  final subscribeData = SubscribeData(
    message: '',
    data: [],
  ).obs;

  final toggleButton = false.obs;

  final postList = <ProfilePostList>[].obs;
  final iSubscribeList = <SubscribeDataList>[].obs;
  final mySubscribeList = <SubscribeDataList>[].obs;



  @override
  void onInit() {
    super.onInit();
    Future.microtask(() {
      _fetchMyProfile();
      fetchMySubscriber();
      fetchISubscribe();
    });
  }

  Future<void> _fetchMyProfile() async {
    try {
      String userId = await tokenService.loadUserId();
      var response = await apiService.postRequest('ProfileInfo', {'target_user_id': userId, 'user_id': userId, 'post_count':20});
      final Profile fetchedProfile = Profile.fromJson(response);
      profile.value = fetchedProfile;
      postList.value = fetchedProfile.postList;
    } catch (e) {
      print('Error fetching profile: $e');
    }
  }

  Future<void> fetchMySubscriber() async {
    try {
      String userId = await tokenService.loadUserId();
      var response = await apiService.postRequest('GetProfileSubscribeInfo', {'target_user_id': userId, 'selection_type': 0});
      final SubscribeData fetchedProfile = SubscribeData.fromJson(response);
      subscribeData.value = fetchedProfile;
      mySubscribeList.value = fetchedProfile.data;
    } catch (e) {
      print('Error fetching profile: $e');
    }
  }

  Future<void> fetchISubscribe() async {
    try {
      String userId = await tokenService.loadUserId();
      var response = await apiService.postRequest('GetProfileSubscribeInfo', {'target_user_id': userId, 'selection_type': 1});
      final SubscribeData fetchedProfile = SubscribeData.fromJson(response);
      subscribeData.value = fetchedProfile;
      iSubscribeList.value = fetchedProfile.data;
    } catch (e) {
      print('Error fetching profile: $e');
    }
  }

  Future<void> fetchProfile(int targetUserId) async {
    try {
      String userId = await tokenService.loadUserId();
      var response = await apiService.postRequest('ProfileInfo', {'target_user_id': targetUserId, 'user_id': userId, 'post_count':20});
      final Profile fetchedProfile = Profile.fromJson(response);
      profile.value = fetchedProfile;
    } catch (e) {
      print('Error fetching profile: $e');
    }
  }
  void toggleTabs() {
    isToggled.value = !isToggled.value;
  }
}
