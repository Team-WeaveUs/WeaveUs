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

  @override
  onInit() {
    super.onInit();
    final postId = int.tryParse(Get.parameters['post_id'] ?? '');
    final postUserId = Get.arguments['postUserId'];

    if (postId != null && postUserId != null) {
      _fetchPost(postId);
    } else {
      print('❌ postId 또는 postUserId 누락');
    }
  }

  Future<void> _fetchPost(int postId) async {
    try {
      isLoading.value = true;
      final userId = await tokenService.loadUserId();
      final List<int>list = [postId];

      final postResponse = await apiService.postRequest('Post/Simple', {
        'user_id': userId,
        'post_id': list,
      });

    post.value = (postResponse['post'] as List).map((e) => Post.fromJson(e)).toList()[0];

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
}