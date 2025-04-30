import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/comment_model.dart';
import '../services/api_service.dart';
import '../services/token_service.dart';

class CommentInputController extends GetxController {
  final ApiService apiService;
  final TokenService tokenService;

  CommentInputController({required this.apiService, required this.tokenService});

  final commentController = TextEditingController();
  final isSubmitting = false.obs;
  final comments = <Comment>[].obs;
  final isLoading = false.obs;

  get res => null;

  Future<void> submitComment(int postId) async {
    final rawPostId = Get.parameters['post_id'];
    final postId = int.tryParse(rawPostId ?? '');
    if (postId == null) {
      return;
    }
    final content = commentController.text.trim();
    if (content.isEmpty) return;

    isSubmitting.value = true;

    try {
      final userId = await tokenService.loadUserId();
      final input = CommentInput(userId: userId.toString(), postId: postId, content: content);

      final res = await apiService.postRequest('CreateComment', input.toJson());

      final commentJson = res['comment'];
      final newComment = Comment(
        commentId: commentJson['comment_id'],
        nickname: commentJson['nickname'],
        content: commentJson['content'],
      );

      comments.add(newComment);

      commentController.clear();
      Get.snackbar('성공', '댓글이 작성되었습니다');
    } catch (e) {
      print('❌ 댓글 작성 실패: $e');
    } finally {
      isSubmitting.value = false;
    }
  }
  Future<void> fetchComments(int postId) async {
    try {
      final rawPostId = Get.parameters['post_id'];
      final postId = int.tryParse(rawPostId ?? '');
      final userId = await tokenService.loadUserId();
      final res = await apiService.postRequest('Post/comment/get', {
        'user_id': userId,
        'post_id': postId,
      });

      final body = res['body'] ?? res; // 혹시 'body'로 감싸져 있다면 대비
      final commentList = body['comments'];

      if (commentList is List) {
        comments.value = commentList.map((e) => Comment.fromJson(e)).toList();
      } else {
        print('❗ 댓글 없음 또는 잘못된 응답');
      }
    } catch(e) {
      print('❗ 댓글 가져오기 실패: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
