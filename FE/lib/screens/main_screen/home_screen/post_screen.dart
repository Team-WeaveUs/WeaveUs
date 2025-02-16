import 'package:flutter/material.dart';
import 'package:weave_us/screens/main_screen/weave_upload_screen.dart';
import 'post.dart';

class PostScreen extends StatefulWidget {
  final Post postData; // 초기 Post 데이터
  const PostScreen({super.key, required this.postData});

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  bool _isFetchingNewPosts = false;
  List<Post> _posts = []; // 게시물 리스트
  Set<String> _requestedPosts = {}; // 요청한 게시물 ID 저장 (중복 방지)

  @override
  void initState() {
    super.initState();
    _posts.add(widget.postData); // 초기 게시물 추가
    _requestedPosts.add(widget.postData.weaveTitle); // 요청한 게시물에 추가
  }

  // 새로운 게시물 요청
  Future<void> _fetchNewPost() async {
    if (_isFetchingNewPosts) return; // 중복 요청 방지

    setState(() => _isFetchingNewPosts = true);

    await Future.delayed(const Duration(seconds: 2), () {
      Post newPost = Post(
        weaveTitle: "새로운 위브 제목",
        urls: ["https://via.placeholder.com/150"],
        name: "새로운 사용자",
        userProfile: 'https://via.placeholder.com/50',
        content: "새로운 게시물 내용",
        postLikes: 0,
        types: [],
        userLikePost: 0,
      );

      if (!_requestedPosts.contains(newPost.weaveTitle)) {
        setState(() {
          _posts.add(newPost);
          _requestedPosts.add(newPost.weaveTitle);
        });
      }
      _isFetchingNewPosts = false;
    });
  }

  // 게시물이 없을 때 나타나는 버튼
  Widget _buildCreateNewPostButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // 새 게시물 업로드 페이지로 이동
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WeaveUploadScreen()),
          );
        },
        child: const Text("새로운 게시물 생성"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        // Title과 Type은 고정
        Container(
          margin: const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 0),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            border: Border.all(color: Colors.black),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.postData.weaveTitle,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Text("weaveType"),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black),
                ),
                child: const IconButton(
                  onPressed: null,
                  icon: Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              // 게시물 리스트 (수직 스크롤)
              PageView.builder(
                itemCount: _posts.length + 1, // 마지막에 "새 게시물 생성" 버튼 추가
                scrollDirection: Axis.vertical,
                onPageChanged: (index) {
                  if (index == _posts.length - 1) {
                    _fetchNewPost(); // 마지막 게시물 도달 시 새로운 게시물 요청
                  }
                },
                itemBuilder: (context, index) {
                  if (index < _posts.length) {
                    final post = _posts[index];
                    return Container(
                      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                      decoration: const BoxDecoration(
                        border: Border(left: BorderSide(color: Colors.black), right: BorderSide(color: Colors.black), bottom: BorderSide(color: Colors.black)),
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                      ),
                      child: Column(
                        children: [
                          if (post.urls.isNotEmpty)
                            Image.network(
                              height: size.height * 0.6,
                              fit: BoxFit.cover,
                              post.urls.first,
                            ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              border: Border(top: BorderSide(color: Colors.black)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 35 / 2,
                                      backgroundImage: post.userProfile == '0'
                                          ? null
                                          : NetworkImage(post.userProfile),
                                      backgroundColor: Colors.grey,
                                      child: post.userProfile == '0'
                                          ? const Icon(
                                        size: 35 / 2,
                                        Icons.person,
                                        color: Colors.white,
                                      )
                                          : null,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      post.name,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const TextButton(
                                    onPressed: null,
                                    child: Text(
                                      "구독",
                                      style: TextStyle(fontSize: 18, color: Colors.black),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            width: size.width,
                            child: Text(
                              post.content,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return _buildCreateNewPostButton(); // 더 이상 게시물이 없을 때 버튼 표시
                  }
                },
              ),
              // 로딩 중이면 로딩 화면 표시
              if (_isFetchingNewPosts)
                const Center(
                  child: CircularProgressIndicator(color: Colors.orange),
                ),
            ],
          ),
        ),
      ],
    );
  }
}