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
  final comments = <Comment>[].obs;
  final commentController = TextEditingController();
  final isLoading = true.obs;

  @override
  void onInit() {
    final postId = int.tryParse(Get.parameters['post_id'] ?? '');
    final postUserId = Get.arguments['postUserId'];

    print('📌 받은 post_id: $postId');
    print('📌 받은 postUserId: $postUserId');

    if (postId != null && postUserId != null) {
      _fetchPost(postId, postUserId);
    } else {
      print('❌ postId 또는 postUserId 누락');
    }
  }

  Future<void> _fetchPost(int postId, int postUserId) async {
    try {
      isLoading.value = true;
      final userId = await tokenService.loadUserId();

      print('📤 요청 보내는 중: user_id=$userId, target_user_id=$postUserId');

      final postRes = await apiService.postRequest('ProfileInfo', {
        'user_id': userId,
        'target_user_id': postUserId,
      });

      print('📦 응답: $postRes');

      // ❗ 여기 수정됨: body 안에 post_list가 있는 게 아님!
      final postList = postRes['post_list'] as List;

      final matchedPost = postList.firstWhere(
            (p) => p['post_id'] == postId,
        orElse: () => null,
      );

      final imageUrl = matchedPost != null ? (matchedPost['img'] ?? '') : '';
      print('✅ 최종 imageUrl: $imageUrl');

      post.value = post.value.copyWith(id: postId, mediaUrl: imageUrl);

      final commentRes = await apiService.postRequest('comment/get', {
        'user_id': userId,
        'post_id': postId,
      });

      comments.value = (commentRes['comments'] as List)
          .map((e) => Comment.fromJson(e))
          .toList();
    } catch (e) {
      print('❌ 예외 발생: $e');
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> submitComment(String content) async {
    if (post.value.id == 0 || content.isEmpty) {
      print("❗ 유효하지 않은 입력입니다");
      return;
    }

    try {
      final userId = await tokenService.loadUserId();
      final res = await apiService.postRequest('CreateComment', {
        'user_id': userId,
        'post_id': post.value.id,
        'content': content,
      });

      print('✅ 댓글 작성 성공: $res');
      commentController.clear();

    } catch (e) {
      print('❌ 댓글 작성 실패: $e');
    }
  }
}