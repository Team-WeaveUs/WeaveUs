import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/comment_input_controller.dart';

class CommentSectionWidget extends GetView<CommentInputController> {
  final int postId;

  const CommentSectionWidget({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {

    controller.fetchComments(postId);

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemCount: controller.comments.length,
        itemBuilder: (context, index) {
          final comment = controller.comments[index];
          return ListTile(
            title: Text(comment.nickname),
            subtitle: Text(comment.content),
          );
        },
      );
    });
  }
}
