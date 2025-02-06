import 'package:flutter/material.dart';
import 'post.dart';

class PostScreen extends StatefulWidget {
  final Post postData; // Post 데이터 받기

  const PostScreen({Key? key, required this.postData}) : super(key: key);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.postData.weaveTitle)), // 제목 표시
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.postData.content, style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            if (widget.postData.urls.isNotEmpty)
              Image.network(widget.postData.urls.first), // 첫 번째 이미지 표시
          ],
        ),
      ),
    );
  }
}