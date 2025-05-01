import 'package:get/get.dart';
import 'package:weave_us/routes/app_routes.dart';

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

  final weaveData = WeaveData(
    message: '',
    data: [],
  ).obs;
  final myWeaveData = MyWeaveData(
    message: '',
    data: [],
  ).obs;

  final toggleButton = false.obs;

  final postList = <ProfilePostList>[].obs;
  final iSubscribeList = <SubscribeDataList>[].obs;
  final mySubscribeList = <SubscribeDataList>[].obs;
  final weaveList = <WeaveDataList>[].obs;
  final myWeaveList = <WeaveDataList>[].obs;



  @override
  void onInit() async {
    super.onInit();

    int? parsedUserId = int.tryParse(Get.parameters['user_id'] ?? '');
    final targetId = parsedUserId?.toString() ?? await tokenService.loadUserId();

    Future.microtask(() {
      _fetchProfile(targetId);
      fetchMySubscriber();
      fetchISubscribe();
      fetchWeaveList(targetId);
      fetchMyWeaveList();
    });
  }

  Future<void> _fetchProfile(String? targetUserId) async {
    try {
      String userId = await tokenService.loadUserId();
      var response = await apiService.postRequest('ProfileInfo', {'target_user_id': targetUserId, 'user_id': userId, 'post_count':20});
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
  Future<void> fetchWeaveList(String targetUserId) async {
    try {
      String userId = await tokenService.loadUserId();
      var response = await apiService.postRequest('weave/get/user', {'target_user_id': targetUserId, 'user_id': userId});
      final WeaveData fetchedWeave = WeaveData.fromJson(response);
      weaveData.value = fetchedWeave;
      weaveList.value = fetchedWeave.data;


    }catch (e) {
      print('Error fetching profile: $e');
    }
  }
  Future<void> fetchMyWeaveList() async {
    try {
      String userId = await tokenService.loadUserId();
      var response = await apiService.postRequest('weave/get/user-post', {'user_id': userId});
      final MyWeaveData fetchedWeave = MyWeaveData.fromJson(response);
      myWeaveData.value = fetchedWeave;
      myWeaveList.value = fetchedWeave.data;
    } catch (e) {
      print('Error fetching myweavelisg: $e');
    }
  }

  void toggleTabs() {
    isToggled.value = !isToggled.value;
  }
  void goToNewWeave(int weaveId, String weaveTitle) {
    Get.toNamed(AppRoutes.NEW_POST, arguments: {'weaveId': weaveId, 'weaveTitle': weaveTitle});
  }
}
