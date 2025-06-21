import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/post_model.dart';
import '../models/comment_model.dart';
import '../services/api_service.dart';
import '../services/token_service.dart';
import 'package:bcrypt/bcrypt.dart';

import 'home_controller.dart';

class PostDetailController extends GetxController {
  final ApiService apiService;
  final TokenService tokenService;

  PostDetailController({required this.apiService, required this.tokenService});

  HomeController get homeController => Get.find<HomeController>();

  final post = Post
      .empty()
      .obs;
  final RxList<Comment> comments = <Comment>[].obs;
  final commentController = TextEditingController();
  final isLoading = true.obs;
  final postId = ''.obs;
  final rewardConditionType = ''.obs;
  final rewardConditionId = 0.obs;
  final rewardId = 0.obs;
  final grantUser = ''.obs;
  final canReward = false.obs;
  final currentIndex = 0.obs;
  final myUId = ''.obs;
  final from = ''.obs;
  final RxDouble imageAspectRatio = 1.0.obs;

  @override
  onInit() {
    super.onInit();
    postId.value = Get.parameters['post_id'] ?? '';
    rewardConditionId.value = int.tryParse(Get.parameters['reward_condition_id'].toString())??0;
    rewardConditionType.value = Get.parameters['reward_condition_type'] ?? '';
    rewardId.value = int.tryParse(Get.parameters['rewardId'].toString()) ?? 0;
    grantUser.value = Get.parameters['grantUser'] ?? '';
    from.value = Get.parameters['from'] ?? '';

    if (postId.value != "") {
      _fetchPost(postId.value);
    } else {
      print('❌ postId 또는 postUserId 누락');
    }
  }

  Future<void> _fetchPost(String postId) async {
    try {
      isLoading.value = true;
      final userId = await tokenService.loadUserId();
      try{} catch(e){print(e);}
      myUId.value = userId.toString();
      final List<String>list = [postId];
      if (safeCheckPw(userId, grantUser.value) && rewardConditionType.value == 'INSERT') {
        canReward.value = true;
      }
      final postResponse = await apiService.postRequest('Post/Simple', {
        'user_id': userId,
        'post_id': list,
      });
      post.value = (postResponse['post'] as List).map((e) => Post.fromJson(e)).toList()[0];
      loadImageAspectRatio(post.value.mediaUrl);
    } catch (e) {
      print('❌ 예외 발생: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void goToNewWeave() {
    final currentPost = post.value;
    Get.toNamed('/new_post?from=${Get.currentRoute}&weaveId=${currentPost.weaveId}&weaveTitle=${currentPost.weaveTitle}');
  }

  void loadImageAspectRatio(String url) {
    final image = Image.network(url);
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((info, _) {
        final width = info.image.width;
        final height = info.image.height;
        imageAspectRatio.value = width / height;
      }),
    );
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

      if (response['message'] == '리워드가 성공적으로 지급되었습니다.') {
        Get.snackbar("성공", response['message']);
      } else {
        Get.snackbar("실패", response['message']);
      }
    } catch (e) {
      print('$e');
    }
  }

  // 댓글 작성
  Future<void> toggleSubscribeInDetail(Post post) async {
    try {
      final myId = await tokenService.loadUserId();
      final isNowSubscribed = !post.isSubscribed;

      await apiService.postRequest('user/subscribe/update', {
        'user_id': myId,
        'target_user_id': post.userId,
      });

      final updatedPost = post.copyWith(isSubscribed: isNowSubscribed);
      this.post.value = updatedPost;

    } catch (e) {
      print('❌ 상세 구독 실패: $e');
    }
  }

  // 좋아요 토글 처리
  void toggleLikeInDetail(Post post) async {
    try {
      homeController.toggleLike(post);
      final updatedPost = post.copyWith(
        isLiked: !post.isLiked,
        likes: post.isLiked ? post.likes - 1 : post.likes + 1,
      );
      this.post.value = updatedPost;
      this.post.value = updatedPost;

    } catch (e) {
      print('❌ [에러] 좋아요 처리 실패: $e');
    }
  }
  bool safeCheckPw(String plain, String? hashed) {
    if (hashed == null || hashed.trim().length < 28) return false;
    try {
      return BCrypt.checkpw(plain, hashed);
    } catch (_) {
      return false;
    }
  }
  void addComment() {

  }
}

