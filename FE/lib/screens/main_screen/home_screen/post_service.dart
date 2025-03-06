import 'package:weave_us/screens/main_screen/home_screen/simple_post.dart';

import '../../../Auth/api_client.dart';

class PostService {
  static Future<List<SimplePost>> fetchPosts(List<int> postId) async {
    final response = await ApiService.sendRequest('WeaveAPI/Post/Simple', {
      "post_id": postId,
    });
    if (response != null && response.containsKey('body') && response['body'] != null) {
      var posts = response['body']['post'];
      // posts 리스트를 SimplePost 객체로 변환
      return posts.map<SimplePost>((post) => SimplePost.fromJson(post)).toList();
    } else {
      throw Exception("응답 데이터가 잘못되었습니다.");
    }
  }
}