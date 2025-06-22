import 'package:get/get.dart';
import 'package:weave_us/services/api_service.dart';
import 'package:weave_us/services/token_service.dart';
import '../models/post_model.dart';

class HomeController extends GetxController {
  final ApiService apiService;
  final TokenService tokenService;

  HomeController({required this.apiService, required this.tokenService});

  @override
  void onInit() {
    super.onInit();
    _fetchPostList1();
  }

  final postList1 = <Post>[].obs;
  final currentIndex = 0.obs;
  final postListMap = <int, RxList<Post>>{}.obs;
  final nextStartAt = <int>[].obs;
  final subscribedUserIds = <int>{}.obs;
  final myUId = ''.obs;

  Future<void> _fetchPostList1() async {
    try {
      final userId = await tokenService.loadUserId();
      myUId.value = userId;
      final response = await apiService.postRequest('main', {'user_id': userId});
      final postIdList1 = List<int>.from(response['post_id']);

      nextStartAt.value = List<int>.filled(postIdList1.length, 0);
      final postResponse = await apiService.postRequest('Post/Simple', {'post_id': postIdList1});

      postList1.value = (postResponse['post'] as List).map((e) => Post.fromJson(e)).toList();



      if (postList1.isNotEmpty) {
        _initializePostListMap();
        fetchPostList2();
      }
    } catch (e) {
      print('Error fetching postList1: $e');
    }
  }

  Future<void> fetchPostList2() async {
    try {
      final userId = await tokenService.loadUserId();
      final weaveId = postList1[currentIndex.value].weaveId;
      final postId = postList1[currentIndex.value].id;
      final startAt = nextStartAt[currentIndex.value];

      final response = await apiService.postRequest('weave', {
        'user_id': userId,
        'weave_id': weaveId,
        'startat': startAt,
        'offset': 10
      });

      var postIdList2 = List<int>.from(response['post_id']);
      postIdList2.remove(postId);

      final postResponse = await apiService.postRequest('Post/Simple', {'post_id': postIdList2});
      final fetchedPostList2 = (postResponse['post'] as List).map((e) => Post.fromJson(e)).toList();


      for (var post in fetchedPostList2) {
        if (post.isSubscribed) {
          subscribedUserIds.add(post.userId);
        }
      }

      nextStartAt[currentIndex.value] = response['next_startat'];
      _updatePostListMap(currentIndex.value, fetchedPostList2);

    } catch (e) {
      print('Error fetching postListMap: $e');
    }
  }

  Future<void> onHorizontalScroll(int index) async {
    currentIndex.value = index;
    if (postListMap[index]!.length < 2) fetchPostList2();
  }

  Future<void> onVerticalScroll(int index) async {
    if (index == nextStartAt[currentIndex.value]) fetchPostList2();
  }

  void _initializePostListMap() {
    postListMap.clear();
    for (int index = 0; index < postList1.length; index++) {
      postListMap[index] = [postList1[index]].obs;
    }
  }

  void _updatePostListMap(int index, List<Post> fetchedPostList2) {
    final appendPost = [...postListMap[index]!, ...fetchedPostList2];
    postListMap[index] = appendPost.obs;
  }

  void goToNewWeave() {
    final currentPost = postList1[currentIndex.value];
    Get.toNamed('/new_post?from=${Get.currentRoute}&weaveId=${currentPost.weaveId}&weaveTitle=${currentPost.weaveTitle}');
  }

  // 좋아요 토글 처리
  void toggleLike(Post post) async {
    try {
      final userId = await tokenService.loadUserId();
      final response = await apiService.postRequest('Post/like', {
        'user_id': userId,
        'post_id': post.id,
      });

      final index = postListMap[currentIndex.value]!
          .indexWhere((p) => p.id == post.id);

      final thisLikeCount = response['like_count'];
      final thisIsLiked = response['like_status'] == 1;
      if (index != -1) {
        final updatedPost = post.copyWith(isLiked: thisIsLiked, likes: thisLikeCount);
        postListMap[currentIndex.value]![index] = updatedPost;
        postListMap.refresh();
      }
    } catch (e) {
      print('좋아요 처리 실패: $e');
    }
  }

  void toggleSubscribe(Post post) async {
    try {
      final myId = await tokenService.loadUserId();
      final isNowSubscribed = !subscribedUserIds.contains(post.userId);

      final response = await apiService.postRequest('user/subscribe/update', {
        'user_id': myId,
        'target_user_id': post.userId,
      });
      final isSubscribed = response['subscribe_status'] == 1;

      if (isNowSubscribed) {
        subscribedUserIds.add(post.userId);
        postListMap.forEach((tab, postList) {
          for (int i = 0; i < postList.length; i++) {
            if (postList[i].userId == post.userId) {
              postList[i] = postList[i].copyWith(isSubscribed: isSubscribed);
            }
          }
        });
        postListMap.refresh();

      } else {
        subscribedUserIds.remove(post.userId);
        postListMap.forEach((tab, postList) {
          for (int i = 0; i < postList.length; i++) {
            if (postList[i].userId == post.userId) {
              postList[i] = postList[i].copyWith(isSubscribed: isSubscribed);
            }
          }
        });
        postListMap.refresh();
      }
    } catch (e) {
      print('구독 처리 실패: $e');
    }
  }

  // 홈 화면에서 좋아요 상태 반영
  void updatePostInMap(Post updatedPost) {
    for (final entry in postListMap.entries) {
      final index = entry.value.indexWhere((p) => p.id == updatedPost.id);
      if (index != -1) {
        postListMap[entry.key]![index] = updatedPost;
        postListMap.refresh();
        break;
      }
    }
  }

  void addComment(int postId) {
    final index = postListMap[currentIndex.value]!
        .indexWhere((p) => p.id == postId);
    final post = postListMap[currentIndex.value]![index];
    if (index != -1) {
      final updatedPost = post.copyWith(commentCount: post.commentCount + 1);
      postListMap[currentIndex.value]![index] = updatedPost;
      postListMap.refresh();
    }
  }
}
