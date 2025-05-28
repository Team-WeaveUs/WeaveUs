import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/post_model.dart';
import '../models/comment_model.dart';
import '../services/api_service.dart';
import '../services/token_service.dart';

class PostDetailController extends GetxController {
  final ApiService apiService;
  final TokenService tokenService;

  PostDetailController({required this.apiService, required this.tokenService});

  final post = Post
      .empty()
      .obs;
  final RxList<Comment> comments = <Comment>[].obs;
  final commentController = TextEditingController();
  final isLoading = true.obs;
  final postId = ''.obs;
  final rewardConditionId = 0.obs;
  final rewardId = 0.obs;
  final grantUser = ''.obs;
  final canReward = false.obs;


  @override
  onInit() {
    super.onInit();
    postId.value = Get.parameters['post_id'] ?? '';
    final postUserId = Get.arguments['postUserId'];
    rewardConditionId.value = Get.arguments['rewardConditionId'] ?? 0;
    rewardId.value = Get.arguments['rewardId'] ?? 0;
    grantUser.value = Get.arguments['grantUser'] ?? '';

    if (postId.value != "" && postUserId != null) {
      _fetchPost(postId.value);
    } else {
      print('❌ postId 또는 postUserId 누락');
    }
  }

  Future<void> _fetchPost(String postId) async {
    try {
      isLoading.value = true;
      final userId = await tokenService.loadUserId();
      final List<String>list = [postId];
      if(grantUser.value == userId){
        canReward.value = true;
      }
      final postResponse = await apiService.postRequest('Post/Simple', {
        'user_id': userId,
        'post_id': list,
      });

    post.value = (postResponse['post'] as List).map((e) => Post.fromJson(e)).toList()[0];

    } catch (e) {
      print('❌ 예외 발생: $e');
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> giveReward() async {
     try {
       final userId = await tokenService.loadUserId();
       final bodies = {
         "user_id": post.value.userId,
         "granted_by": userId,
         "reward_id": rewardId.value,
         "reward_condition_id": rewardConditionId.value,
         "weave_id": post.value.weaveId,
         "post_id": postId.value,
       };
       final rewards = {"rewards": [bodies]};
       final response = await apiService.postRequest("reward/give", rewards);
       print(response);
     } catch (e) {
       print('$e');
     }
  }

}