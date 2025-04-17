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

  var postList1 = <Post>[].obs; // 가로 스크롤용 메인 포스트 리스트
  var currentIndex = 0.obs; // 현재 가로 스크롤 인덱스

  RxMap<int, RxList<Post>> postListMap = <int, RxList<Post>>{}.obs; //post_id 로 list의 첫번째 에는 postList1을 각각 mapping, 두번째 부터는 각 게시물에 해당하는 postList2를 저장할 맵
  var nextStartAt = <int>[].obs;



  Future<void> _fetchPostList1() async {
    try {
      String userId = await tokenService.loadUserId();
      var response = await apiService.postRequest('main', {'user_id': userId});
      List<int> postIdList1 = List<int>.from(response['post_id']);

      nextStartAt.value = List<int>.filled(postIdList1.length, 0);

      // 2. post/simple 호출하여 postList1 가져오기
      var postResponse = await apiService.postRequest('Post/Simple', {'post_id': postIdList1});

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
      String userId = await tokenService.loadUserId();
      int weaveId = postList1[currentIndex.value].weaveId;
      int startAt = nextStartAt[currentIndex.value];

      var response = await apiService.postRequest('weave', {'user_id': userId,'weave_id': weaveId, "startat": startAt, "offset": 10});

      List<int> postIdList2 = List<int>.from(response['post_id']);

      var postResponse = await apiService.postRequest('Post/Simple', {'post_id': postIdList2});
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

  Future<void> onVerticalScroll(int index) async {
    if (index == nextStartAt[currentIndex.value]) {
      fetchPostList2();
    }
  }

  void _initializePostListMap() {
    postListMap.clear(); // Clear any existing data
    for (int index = 0; index < postList1.length; index++) {
      List<Post> appendList = [];
      appendList.add(postList1[index]);
      postListMap[index] = appendList.obs;
    }
  }

  void _updatePostListMap(int index, List<Post> fetchedPostList2) {
    List<Post> appendPost = [];
    appendPost.addAll(postListMap[index]!);
    appendPost.addAll(fetchedPostList2);
    if (postListMap.isNotEmpty) {
      postListMap[index] = appendPost.obs;
    } else {
      // Handle the case where weaveId is not in postListMap (shouldn't happen in normal flow)
      print('Warning: Index $index not found in postListMap');
    }
  }
}

