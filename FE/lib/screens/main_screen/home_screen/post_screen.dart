import 'package:flutter/material.dart';
import 'package:weave_us/screens/main_screen/home_screen/comment_input_widget.dart';
import 'package:weave_us/screens/main_screen/weave_upload_screen.dart';
import 'post.dart';

class PostScreen extends StatefulWidget {
  final Post postData;
  const PostScreen({super.key, required this.postData});

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
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

  Widget _buildCreateNewPostButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
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
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.add, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              PageView.builder(
                itemCount: _posts.length + 1,
                scrollDirection: Axis.vertical,
                onPageChanged: (index) {
                  if (index == _posts.length - 1) {
                    _fetchNewPost();
                  }
                },
                itemBuilder: (context, index) {
                  if (index < _posts.length) {
                    final post = _posts[index];
                    return Container(
                      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                      decoration: const BoxDecoration(
                        border: Border(
                          left: BorderSide(color: Colors.black),
                          right: BorderSide(color: Colors.black),
                          bottom: BorderSide(color: Colors.black),
                        ),
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
                                      radius: 17.5,
                                      backgroundImage: post.userProfile == '0' ? null : NetworkImage(post.userProfile),
                                      backgroundColor: Colors.grey,
                                      child: post.userProfile == '0'
                                          ? const Icon(Icons.person, size: 17.5, color: Colors.white)
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post.content,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 18),
                                ),
                                if (post.content.length > 50)
                                  TextButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('전체 내용'),
                                          content: Text(post.content),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: const Text('닫기'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    child: const Text('더보기', style: TextStyle(color: Colors.blue)),
                                  ),
                                SizedBox(height: 10),
                                CommentInputWidget(
                                  username: post.name,
                                  profileImageUrl: post.userProfile,
                                  onCommentSubmit: (value) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("댓글이 작성되었습니다: $value")),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return _buildCreateNewPostButton();
                  }
                },
              ),
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