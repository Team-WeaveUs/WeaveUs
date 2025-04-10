import 'package:get/get.dart';

import '../models/post_model.dart';
import '../services/api_service.dart';
import '../services/token_service.dart';

class PostController extends GetxController {
  final ApiService apiService;
  final TokenService tokenService;
  PostController({required this.apiService, required this.tokenService});

  final post = Post(
    id: 0,
    userId: 0,
    privacyId: 0,
    weaveId: 0,
    thumbnailMediaId: 0,
    textContent: '',
    location: '',
    areaId: 0,
    likes: 0,
    createdAt: '',
    updatedAt: '',
    weaveTitle: '',
    nickname: '',
    userMediaUrl: '',
    subValid: 0,
    commentCount: 0,
    mediaUrl: '',
    weaveType: 0,
  ).obs;

  Future<void> fetchPost(int postId) async {
    try {
      String userId = await tokenService.loadUserId();
      var response = await apiService.postRequest('PostInfo', {'post_id': postId, 'user_id': userId});
      final Post fetchedPost = Post.fromJson(response);
      post.value = fetchedPost;
    } catch (e) {
      print('Error fetching post: $e');
    }
  }

}