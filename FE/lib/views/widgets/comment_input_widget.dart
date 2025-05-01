// views/widgets/comment_input_widget.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/comment_input_controller.dart';

class CommentInputWidget extends GetView<CommentInputController> {
  final int postId;

  const CommentInputWidget({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.commentController,
              decoration: const InputDecoration(hintText: '댓글을 입력하세요'),
            ),
          ),
          Obx(() => IconButton(
            icon: controller.isSubmitting.value
                ? const CircularProgressIndicator()
                : const Icon(Icons.send),
            onPressed: controller.isSubmitting.value
                ? null
                : () => {controller.submitComment(postId)},
          )),
        ],
      ),
    );
  }
}
