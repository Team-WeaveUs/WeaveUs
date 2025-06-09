import 'package:get/get.dart';
import 'package:weave_us/routes/app_routes.dart';

import '../models/profile_post_list_model.dart';
import '../models/subscribe_data_model.dart';
import '../models/weave_data_model.dart';
import '../services/api_service.dart';
import '../services/token_service.dart';

import '../models/profile_model.dart';

class ProfileController extends GetxController {
  final ApiService apiService;
  final TokenService tokenService;

  ProfileController({required this.apiService, required this.tokenService});

  var isToggled = false.obs;

  String get toggleLabel => isToggled.value ? "프로필" : "구독";

  final subscribeToggle = false.obs;

  final profile = Profile(
    message: '',
    userId: 0,
    nickname: '',
    img: '',
    likes: 0,
    subscribes: 0,
    postList: [],
    isOwner: 0,
    sValid: '',
  ).obs;

  final subscribeData = SubscribeData(
    message: '',
    data: [],
  ).obs;

  final weaveData = WeaveData(
    message: '',
    data: [],
  ).obs;

  final myWeaveData = MyWeaveData(
    message: '',
    data: [],
  ).obs;

  final otherWeaveData = WeaveData(
    message: '',
    data: [],
  ).obs;

  final otherContributedWeaveData = MyWeaveData(
    message: '',
    data: [],
  ).obs;

  final toggleButton = false.obs;

  final postList = <ProfilePostList>[].obs;
  final otherPostList = <ProfilePostList>[].obs;
  final iSubscribeList = <SubscribeDataList>[].obs;
  final mySubscribeList = <SubscribeDataList>[].obs;
  final weaveList = <WeaveDataList>[].obs;
  final myWeaveList = <WeaveDataList>[].obs;
  final otherWeaveList = <WeaveDataList>[].obs;
  final otherContributedWeaveList = <WeaveDataList>[].obs;
  final targetId = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      profile.value = Profile.empty();
      String userId = await tokenService.loadUserId();
      targetId.value = Get.parameters['user_id'] ?? userId;
      if (Get.currentRoute == AppRoutes.MY_PROFILE) {
        targetId.value = userId;
      }
      var response = await apiService.postRequest('ProfileInfo', {
        'target_user_id': targetId.value,
        'user_id': userId,
        'post_count': 20
      });
      final Profile fetchedProfile = Profile.fromJson(response);
      subscribeToggle.value = fetchedProfile.sValid == '1' ? true : false;
      profile.value = fetchedProfile;
      if (targetId.value == userId) {
        postList.value = fetchedProfile.postList;
        fetchMySubscriber();
        fetchISubscribe();
        fetchWeaveList();
        fetchMyWeaveList();
      } else {
        otherPostList.value = fetchedProfile.postList;
        fetchOtherWeaveList();
        fetchOtherContributedWeaveList();
      }
    } catch (e) {
      print('Error fetching profile: $e');
    }
  }

  Future<void> fetchMySubscriber() async {
    try {
      String userId = await tokenService.loadUserId();
      var response = await apiService.postRequest('GetProfileSubscribeInfo',
          {'target_user_id': userId, 'selection_type': 0});
      final SubscribeData fetchedProfile = SubscribeData.fromJson(response);
      subscribeData.value = fetchedProfile;
      mySubscribeList.value = fetchedProfile.data;
    } catch (e) {
      print('Error fetching mySubscriber: $e');
    }
  }

  Future<void> fetchISubscribe() async {
    try {
      String userId = await tokenService.loadUserId();
      var response = await apiService.postRequest('GetProfileSubscribeInfo',
          {'target_user_id': userId, 'selection_type': 1});
      final SubscribeData fetchedProfile = SubscribeData.fromJson(response);
      subscribeData.value = fetchedProfile;
      iSubscribeList.value = fetchedProfile.data;
    } catch (e) {
      print('Error fetching iSubscribe: $e');
    }
  }

  Future<void> fetchWeaveList() async {
    try {
      String userId = await tokenService.loadUserId();
      var response = await apiService.postRequest('weave/get/user',
          {'target_user_id': targetId.value, 'user_id': userId});
      final WeaveData fetchedWeave = WeaveData.fromJson(response);
      weaveData.value = fetchedWeave;
      weaveList.value = fetchedWeave.data;
    } catch (e) {
      print('Error fetching weaveList: $e');
    }
  }

  Future<void> fetchMyWeaveList() async {
    try {
      String userId = await tokenService.loadUserId();
      var response = await apiService.postRequest(
          'weave/get/user-post', {'user_id': userId, 'target_user_id': userId});
      final MyWeaveData fetchedWeave = MyWeaveData.fromJson(response);
      myWeaveData.value = fetchedWeave;
      myWeaveList.value = fetchedWeave.data;
    } catch (e) {
      print('Error fetching myWeaveList: $e');
    }
  }

  Future<void> fetchOtherContributedWeaveList() async {
    try {
      String userId = await tokenService.loadUserId();
      var response = await apiService
          .postRequest('weave/get/user-post', {'user_id': userId, 'target_user_id': targetId.value});
      final MyWeaveData fetchedWeave = MyWeaveData.fromJson(response);
      otherContributedWeaveData.value = fetchedWeave;
      otherContributedWeaveList.value = fetchedWeave.data;
    } catch (e) {
      print("Error fetching otherContributedWeaveList : $e");
    }
  }

  Future<void> fetchOtherWeaveList() async {
    try {
      String userId = await tokenService.loadUserId();
      var response = await apiService.postRequest('weave/get/user',
          {'target_user_id': targetId.value, 'user_id': userId});
      final WeaveData fetchedWeave = WeaveData.fromJson(response);
      otherWeaveData.value = fetchedWeave;
      otherWeaveList.value = fetchedWeave.data;
    } catch (e) {
      print("Error fetching otherWeaveList : $e");
    }
  }

  Future<void> toggleSubscribe() async {
    try {
      String userId = await tokenService.loadUserId();
      var response = await apiService.postRequest('user/subscribe/update', {
        'target_user_id': targetId.value,
        'user_id': userId,
      });
      if (response['message'].contains('변경되었습니다.')) {
        Get.snackbar('구독', '구독 상태가 변경되었습니다.');
        subscribeToggle.value = !subscribeToggle.value;
      }
    } catch (e) {
      print('Error fetching profile: $e');
    }
  }

  void toggleTabs() {
    isToggled.value = !isToggled.value;
  }

  void goToNewWeave(int weaveId, String weaveTitle) {
    Get.toNamed(AppRoutes.NEW_POST,
        arguments: {'weaveId': weaveId, 'weaveTitle': weaveTitle});
  }
}
