import 'package:flutter/material.dart';
import '../profile.dart';

class PostGrid extends StatelessWidget {
  final List<MiniPost> postList;

  const PostGrid({super.key, required this.postList});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: postList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 그리드의 열 수
        crossAxisSpacing: 10, // 열 간격
        mainAxisSpacing: 10, // 행 간격
      ),
      itemBuilder: (context, index) {
        final post = postList[index];
        return GestureDetector(
          onTap: () {
            // 포스트 클릭 시 원하는 동작 (예: 상세보기)
          },
          child: Card(
            elevation: 4,
            child: Image.network(post.img.toString(), fit: BoxFit.cover), // 포스트 이미지
          ),
        );
      },
    );
  }
}
