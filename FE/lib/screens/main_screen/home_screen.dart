import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weave_us/screens/main_screen/home_screen/post_screen_physics.dart';
import '../main_screen/home_screen/post_screen.dart';
import '../main_screen/home_screen/post.dart'; // Post 모델 분리

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Post> _posts = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchPosts(); // 첫 번째 게시물 로드
  }

  // API에서 게시물 가져오기
  Future<void> _fetchPosts() async {
    final url = Uri.parse(
        'https://v79h9dyx08.execute-api.ap-northeast-2.amazonaws.com/WeaveAPI/GetPostList');

    final body = jsonEncode({
      'user_id': '1',
      'post_type': '12345678',
      'username': 'test_account',
      'password': '12345678'
    });

    final headers = {
      'Content-Type': 'application/json; charset=utf-8',
      'x-api-key': dotenv.env['AWS_API_KEY'] ?? '',
    };

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final data = jsonDecode(decodedBody);
        List<Post> newPosts = [];

        for (var item in data['results']) {
          newPosts.add(Post.fromJson(item));
        }

        setState(() {
          _posts.addAll(newPosts);
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('API 요청 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView.builder(
        controller: PageController(
          viewportFraction: 1.0, // 한 번에 한 개의 페이지만 보이게 설정
        ),
        physics: HeavySwipePhysics(),
        pageSnapping: true,
        itemCount: _posts.length + 1,
        // 다음 요청 공간 포함
        onPageChanged: (index) {
          if (index == _posts.length) {
            _fetchPosts(); // 마지막 페이지에서 추가 요청
          }
          setState(() => _currentIndex = index);
        },
        itemBuilder: (context, index) {
          if (index < _posts.length) {
            return PostScreen(postData: _posts[index]);
          } else {
            if (_fetchFailed) {
              return _buildErrorScreen(); // API 요청 실패 화면
            }

            return _buildLoadingScreen(); // 로딩 화면
          }
        },
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return const Center(
      child: CircularProgressIndicator(color: Colors.orange),
    );
  }

  Widget _buildErrorScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: Colors.red, size: 48),
          const SizedBox(height: 10),
          const Text("게시물을 불러오지 못했습니다.", style: TextStyle(fontSize: 18)),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              setState(() => _fetchFailed = false);
              _fetchPosts(); // 다시 시도
            },
            child: const Text("다시 시도"),
          ),
        ],
      ),
    );
  }
}