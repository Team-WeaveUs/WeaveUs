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
  Future<void> fetchComments(int postId) async {
    try {
      final userId = await tokenService.loadUserId();
      final res = await apiService.postRequest('comment/get', {
        'user_id': userId,
        'post_id': postId,
      });
      comments.value = (res['comments'] as List)
          .map((e) => Comment.fromJson(e))
          .toList();
      print('✅ 댓글 가져오기 성공: $res');
    } catch (e) {
      print('❌ 댓글 가져오기 실패: $e');
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
      final cores = res['comment'];
      // 받은 comment_id를 사용하여 새로운 댓글 생성
      final newComment = Comment(
        commentId: cores['comment_id'],   // 서버에서 받은 comment_id
        nickname: cores['nickname'],  // 실제 앱에서는 사용자 닉네임을 넣어야 함
        content: cores['content'],
      );

      comments.add(newComment); // 댓글을 리스트 맨 위에 추가
      commentController.clear();
      comments.refresh(); // 댓글 목록 UI 업데이트

    } catch (e) {
      print('❌ 댓글 작성 실패: $e');
    }
  }
}