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
    super.onInit();
    final postId = int.tryParse(Get.parameters['post_id'] ?? '');
    if (postId != null) {
      _fetchPost(postId);
    }
  }

  Future<void> _fetchPost(int postId) async {
    try {
      isLoading.value = true;
      final userId = await tokenService.loadUserId();

      final postRes = await apiService.postRequest('ProfileInfo', {
        'user_id': userId,
        'post_id': postId,

      });
      post.value = Post.fromJson(postRes);

      final commentRes = await apiService.postRequest('Post/getComments', {
        'user_id': userId,
        'post_id': postId,
      });
      comments.value = (commentRes['comments'] as List)
          .map((e) => Comment.fromJson(e))
          .toList();
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
      await _fetchPost(post.value.id); // 새로고침

    } catch (e) {
      print('❌ 댓글 작성 실패: $e');
    }
  }
}