import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weave_us/views/widgets/comment_input_widget.dart';
import 'package:weave_us/views/widgets/comment_section_widget.dart';
import '../controllers/post_detail_contoller.dart';

class PostDetailView extends GetView<PostDetailController> {
  const PostDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('게시물 상세')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final post = controller.post.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(post.mediaUrl, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                  post.textContent, style: const TextStyle(fontSize: 16)),
            ),
            const Divider(),

            // 🔻 댓글 표시
            Expanded(
              child: CommentSectionWidget(postId: post.id),
            ),

            // 🔻 댓글 입력창
            CommentInputWidget(postId: post.id),
          ],
        );
      }),
    );
  }
}