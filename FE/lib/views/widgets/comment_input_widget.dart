// views/widgets/comment_input_widget.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../controllers/comment_input_controller.dart';

class CommentInputWidget extends GetView<CommentInputController> {
  final int postId;

  const CommentInputWidget({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: Container(
    padding: const EdgeInsets.all(5),
    decoration: BoxDecoration(
    color: const Color(0xFFD9D9D9),
    borderRadius: BorderRadius.circular(10),
    ),
      child: Row(
        children: [
    Padding(
      padding: const EdgeInsets.only(left: 5.0),
      child: const CircleAvatar(
      radius: 15,
      backgroundColor: Colors.grey,
      child: Icon(Icons.person, color: Colors.white),),
    ),

          Expanded(child:
          TextField(
              controller: controller.commentController,
              decoration: InputDecoration(
                  hintText: '댓글을 입력하세요...',
                hintStyle: const TextStyle(color: Colors.black),
                filled: true,
                fillColor: Color(0xFFD9D9D9),
                contentPadding: const EdgeInsets.only(left: 20, right: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,

                ),
              ),
            ),
          ),
          Obx(() => IconButton(
            icon: controller.isSubmitting.value
                ? const CircularProgressIndicator()
                : const Icon(HugeIcons.strokeRoundedUploadSquare02,
                size: 30),
            onPressed: controller.isSubmitting.value
                ? null
                : () => {controller.submitComment(postId)},
          )),
        ],

      ),
    )
    );

  }
}
