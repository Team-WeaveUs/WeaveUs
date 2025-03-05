import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weave_us/config.dart';
import 'package:weave_us/screens/main_screen/search_screen/floating_map_button.dart';
import 'package:weave_us/screens/main_screen/search_screen/search_input.dart';
import 'package:weave_us/screens/main_screen/search_screen/search_title.dart';
import 'package:weave_us/screens/main_screen/search_screen/search_results.dart';
import 'package:weave_us/screens/main_screen/search_screen/search_guide.dart'; // ✅ 추가
import 'package:weave_us/screens/main_screen/home_screen/post.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;
  final FocusNode _focusNode = FocusNode();
  List<Post> _filteredPosts = [];
  bool _isSearching = false;
  bool _isEmptyResult = false;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  // 🔹 서버에서 검색된 데이터 가져오기
  Future<void> _search(String query) async {
    if (query.isEmpty) {
      setState(() {
        _filteredPosts.clear();
        _isEmptyResult = false; // 🔹 "검색 결과가 없습니다"가 안 뜨도록 설정
        _isSearching = false;
        _isTyping = false; // 🔹 검색어 없을 때 다시 가이드 표시
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _isEmptyResult = false;
      _isTyping = true; // 🔹 검색 중이면 가이드 숨김
    });

    final url = Uri.parse(
        'https://v79h9dyx08.execute-api.ap-northeast-2.amazonaws.com/WeaveAPI/GetPostList');

    final body = jsonEncode({
      'user_id': '1',
      'post_type': '12345678'
    });

    final headers = {
      'Content-Type': 'application/json; charset=utf-8',
      'x-api-key': EnvironmentConfig.apiKey,
    };

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> data = jsonDecode(decodedBody);

        if (data["results"] != null) {
          List<Post> allPosts = [];
          for (var item in data["results"]) {
            allPosts.add(Post.fromJson(item));
          }

          String searchText = query.toLowerCase();
          List<Post> results = [];

          if (query.startsWith("@")) {
            String searchName = searchText.substring(1);
            results = allPosts
                .where((post) => post.name.toLowerCase().contains(searchName))
                .toList();
          } else if (query.startsWith("#")) {
            String searchContent = searchText.substring(1);
            results = allPosts
                .where((post) => post.content.toLowerCase().contains(searchContent))
                .toList();
          } else {
            results = allPosts
                .where((post) => post.weaveTitle.toLowerCase().contains(searchText))
                .toList();
          }

          setState(() {
            _filteredPosts = results;
            _isSearching = false;
            _isEmptyResult = results.isEmpty && query.isNotEmpty; // 🔹 검색어가 있을 때만 "검색 결과가 없습니다" 표시
          });

          Future.delayed(Duration(milliseconds: 100), () {
            _focusNode.requestFocus();
          });
        } else {
          setState(() {
            _filteredPosts = [];
            _isEmptyResult = true;
            _isSearching = false;
          });
        }
      } else {
        setState(() {
          _filteredPosts = [];
          _isEmptyResult = true;
          _isSearching = false;
        });
      }
    } catch (e) {
      print('API 요청 실패: $e');
      setState(() {
        _filteredPosts = [];
        _isEmptyResult = true;
        _isSearching = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingMapButton(onPressed: () {}),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchTitle(),
          SearchInput(
            searchController: _searchController,
            focusNode: _focusNode,
            onSearch: _search,
          ),
          if (!_isTyping) SearchGuide(),
          Expanded(
            child: _isSearching
                ? Center(child: CircularProgressIndicator()) // 🔄 검색 중
                : _filteredPosts.isNotEmpty
                ? SearchResults(
              filteredPosts: _filteredPosts,
              content: _filteredPosts.first.content, // ✅ 검색된 첫 번째 게시물의 content 사용
            )
                : _isEmptyResult
                ? Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "검색 결과가 없습니다.",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ),
            )
                : Container(), // ✅ 검색어 없을 때 가이드 표시
          ),

        ],
      ),
    );
  }
}