import 'package:get/get.dart';
import 'package:weave_us/services/api_service.dart';
import 'package:weave_us/services/token_service.dart';
import '../models/post_model.dart';

class OwnerMainController extends GetxController {
  final ApiService apiService;
  final TokenService tokenService;

  OwnerMainController({
    required this.apiService,
    required this.tokenService,
  });

  final ownerPostList = <Post>[].obs;
  final myId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchOwnerPosts();
  }

  Future<void> _fetchOwnerPosts() async {
    try {
      final userId = await tokenService.loadUserId();
      myId.value = userId;

      final response = await apiService.postRequest('owner/posts', {
        'user_id': userId,
      });

      final posts = (response['post'] as List)
          .map((e) => Post.fromJson(e))
          .toList();

      ownerPostList.value = posts;

      print('✅ 오너 게시물 불러오기 성공');
    } catch (e) {
      print('❌ 오너 게시물 불러오기 실패: $e');
    }
  }

  void goToNewPost() {
    Get.toNamed('/owner/new_post');
  }

  void goToNewWeave() {
    Get.toNamed('/owner/new_weave');
  }

  void goToRewards() {
    Get.toNamed('/owner/rewards');
  }
}