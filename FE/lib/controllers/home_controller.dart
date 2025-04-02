import 'package:get/get.dart';
import 'package:weave_us/services/api_service.dart';
import 'package:weave_us/services/token_service.dart';
import '../models/post_model.dart';

class HomeController extends GetxController {
  final ApiService _apiService = ApiService();
  final TokenService _tokenService = TokenService();
  @override
  void onInit() {
    super.onInit();
    fetchPostList1(); // 초기 데이터 로드
  }
  var postList1 = <Post>[].obs; // 가로 스크롤용 메인 포스트 리스트
  var postList2 = <Post>[].obs; // 각 weave_id에 따른 세로 리스트 (Map 형태)
  var currentIndex = 0.obs; // 현재 가로 스크롤 인덱스


  Future<void> fetchPostList1() async {
    try {
      String userId = await _tokenService.loadUserId();
      var response = await _apiService.postRequest('main', {'user_id': userId});
      List<int> postIdList1 = List<int>.from(response['post_id']);

      // 2. post/simple 호출하여 postList1 가져오기
      var postResponse = await _apiService.postRequest('Post/Simple', {'post_id': postIdList1});
      postList1.value = (postResponse['post'] as List).map((e) => Post.fromJson(e)).toList();

      if (postList1.isNotEmpty) {
        fetchPostList2(postList1[0].weaveId); // 첫 번째 postList1의 weave_id로 postList2 가져오기
      }
    } catch (e) {
      print('Error fetching postList1: $e');
    }
  }

  // 4~5. 특정 weave_id로 postList2 가져오기
  Future<void> fetchPostList2(int weaveId) async {
    try {
      String userId = await _tokenService.loadUserId();
      var response = await _apiService.postRequest('weave', {'user_id': userId,'weave_id': weaveId, "startat": 0, "offset": 10});
      List<int> postIdList2 = List<int>.from(response['post_id']);

      var postResponse = await _apiService.postRequest('Post/Simple', {'post_id': postIdList2});
      postList2.value = (postResponse['post'] as List).map((e) => Post.fromJson(e)).toList();
    } catch (e) {
      print('Error fetching postList2: $e');
    }
  }

  // 가로 스크롤 시 다음 postList1에 맞는 postList2를 불러오기
  void onHorizontalScroll(int index) {
    currentIndex.value = index;
    fetchPostList2(postList1[index].weaveId);
  }
}

