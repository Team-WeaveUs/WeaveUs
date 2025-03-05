import 'package:flutter/material.dart';
import 'package:weave_us/screens/main_screen/home_screen/comment_input_widget.dart';
import 'package:weave_us/screens/main_screen/home_screen/post.dart';

class PostInfoScreen extends StatefulWidget {
  final Post postData;
  const PostInfoScreen({super.key, required this.postData});

  @override
  _PostInfoScreenState createState() => _PostInfoScreenState();
}

class _PostInfoScreenState extends State<PostInfoScreen> {
  bool _isFetchingNewPosts = false;
  List<Post> _posts = [];
  Set<String> _requestedPosts = {};

  @override
  void initState() {
    super.initState();
    _posts.add(widget.postData);
    _requestedPosts.add(widget.postData.weaveTitle);
  }

  Future<void> _fetchNewPost() async {
    if (_isFetchingNewPosts) return;

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

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.postData.weaveTitle, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), ),
              Text("weaveType", style: const TextStyle(fontSize: 15, color: Colors.orange)),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20, top: 5), // 오른쪽 여백 추가
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black),
              ),
              child: IconButton(
                icon: const Icon(Icons.add, color: Colors.black),
                onPressed: () {
                },
              ),
            ),
          ),
        ],

        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              itemCount: _posts.length,
              scrollDirection: Axis.vertical,
              onPageChanged: (index) {
                if (index == _posts.length - 1) {
                  _fetchNewPost();
                }
              },
              itemBuilder: (context, index) {
                final post = _posts[index];
                return Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black),
                  ),
                  child: Column(
                    children: [
                      if (post.urls.isNotEmpty)
                        Image.network(
                          height: size.height * 0.6,
                          fit: BoxFit.cover,
                          post.urls.first,
                        ),
                      Padding(
                        padding: const EdgeInsets.all(10),
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    post.content,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            CommentInputWidget(
                              username: post.name,
                              profileImageUrl: post.userProfile,
                              onCommentSubmit: (value) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("댓글이 작성되었습니다: $value")),
                                );
                              },
                            ),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PostInfoScreen(postData: post),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Text(
                              "@@개의 댓글 더보기",
                              style: const TextStyle(fontSize: 10, color: Colors.black),
                            ),
                          ),
                ),
                ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          if (_isFetchingNewPosts)
            const Center(
              child: CircularProgressIndicator(color: Colors.orange),
            ),
        ],
      ),
    );
  }
}
