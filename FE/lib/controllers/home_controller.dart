import 'package:get/get.dart';
import 'package:weave_us/routes/app_routes.dart';
import 'package:weave_us/services/api_service.dart';
import 'package:weave_us/services/token_service.dart';
import '../models/post_model.dart';

class HomeController extends GetxController {
  final ApiService _apiService = ApiService();
  final TokenService _tokenService = TokenService();

  @override
  void onInit() {
    super.onInit();
    _initialize(); // 초기 데이터 로드
  }

  var postList1 = <Post>[].obs; // 가로 스크롤용 메인 포스트 리스트
  var currentIndex = 0.obs; // 현재 가로 스크롤 인덱스

  RxMap<int, RxList<Post>> postListMap = <int, RxList<Post>>{}.obs; //post_id 로 list의 첫번째 에는 postList1을 각각 mapping, 두번째 부터는 각 게시물에 해당하는 postList2를 저장할 맵
  var nextStartAt = <int>[].obs;

  Future<void> _initialize() async {
    final token = await _tokenService.loadToken();
    if (token == null || token.accessToken.isEmpty) {
      Get.offAllNamed(AppRoutes.SPLASH);
      return;
    }

    _fetchPostList1();
  }
  Future<void> _fetchPostList1() async {
    try {
      String userId = await _tokenService.loadUserId();
      var response = await _apiService.postRequest('main', {'user_id': userId});
      List<int> postIdList1 = List<int>.from(response['post_id']);

      nextStartAt.value = List<int>.filled(postIdList1.length, 0);

      // 2. post/simple 호출하여 postList1 가져오기
      var postResponse = await _apiService.postRequest('Post/Simple', {'post_id': postIdList1});

      postList1.value = (postResponse['post'] as List).map((e) => Post.fromJson(e)).toList();


      if (postList1.isNotEmpty) {
        _initializePostListMap();
        fetchPostList2();// 첫 번째 postList1의 weave_id로 postList2 가져오기
      }
    } catch (e) {
      print('Error fetching postList1: $e');
    }
  }

  // 4~5. 특정 weave_id로 postList2 가져오기
  Future<void> fetchPostList2() async {
    try {
      String userId = await _tokenService.loadUserId();
      int weaveId = postList1[currentIndex.value].weaveId;
      int startAt = nextStartAt[currentIndex.value];

      var response = await _apiService.postRequest('weave', {'user_id': userId,'weave_id': weaveId, "startat": startAt, "offset": 10});

      List<int> postIdList2 = List<int>.from(response['post_id']);

      var postResponse = await _apiService.postRequest('Post/Simple', {'post_id': postIdList2});
      List<Post> fetchedPostList2 = (postResponse['post'] as List).map((e) => Post.fromJson(e)).toList();

      nextStartAt[currentIndex.value] = response['next_startat'];
      _updatePostListMap(currentIndex.value, fetchedPostList2);

    } catch (e) {
      print('Error fetching postListMap: $e');
    }
  }

  // 가로 스크롤 시 다음 postList1에 맞는 postList2를 불러오기
  Future<void> onHorizontalScroll(int index) async {
    currentIndex.value = index;
    if (postListMap[index]!.length < 2) fetchPostList2();
  }
}

