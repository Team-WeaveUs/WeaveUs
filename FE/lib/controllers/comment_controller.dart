import 'package:get/get.dart';
import '../models/comment_model.dart';
import '../services/api_service.dart';
import '../services/token_service.dart';

class CommentController extends GetxController {
  final ApiService apiService;
  final TokenService tokenService;

  CommentController({required this.apiService, required this.tokenService});

  final comments = <Comment>[].obs;
  final isLoading = false.obs;

  get res => null;

  Future<void> fetchComments(int postId) async {
    try {
      final rawPostId = Get.parameters['post_id'];
      print('📌 받은 post_id: $rawPostId');
      final postId = int.tryParse(rawPostId ?? '');
      final userId = await tokenService.loadUserId();
      print('📤 요청 데이터: user_id=$userId, post_id=$postId');
      final res = await apiService.postRequest('Post/comment/get', {
        'user_id': userId,
        'post_id': postId,
      });

      print('🧪 raw response: $res');

      final body = res['body'] ?? res; // 혹시 'body'로 감싸져 있다면 대비
      final commentList = body['comments'];

      if (commentList is List) {
        comments.value = commentList.map((e) => Comment.fromJson(e)).toList();
        print('✅ 댓글 정상 파싱: ${comments.length}개');
      } else {
        print('❗ 댓글 없음 또는 잘못된 응답');
      }
    }catch(e) {
      print('❗ 댓글 가져오기 실패: $e');
    } finally {
      isLoading.value = false;
    }
  }
}