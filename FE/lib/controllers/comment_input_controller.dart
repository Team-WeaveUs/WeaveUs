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

  Future<void> submitComment(int postId) async {
    final rawPostId = Get.parameters['post_id'];
    print('📌 받은 post_id: $rawPostId');
    final postId = int.tryParse(rawPostId ?? '');
    if (postId == null) {
      print('❗ 유효하지 않은 post_id');
      return;
    }
    final content = commentController.text.trim();
    if (content.isEmpty) return;

    isSubmitting.value = true;

    try {
      final userId = await tokenService.loadUserId();
      final input = CommentInput(userId: userId.toString(), postId: postId, content: content);

      // 🔍 여기 로그 찍기
      print('📤 요청 데이터: ${input.toJson()}');

      final res = await apiService.postRequest('CreateComment', input.toJson());
      print('✅ 댓글 작성 성공: $res');

      commentController.clear();
      Get.snackbar('성공', '댓글이 작성되었습니다');
    } catch (e) {
      print('❌ 댓글 작성 실패: $e');
    } finally {
      isSubmitting.value = false;
    }
  }
}
