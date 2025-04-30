import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/comment_controller.dart';

class CommentSectionWidget extends StatelessWidget {
  final int postId;

  const CommentSectionWidget({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CommentController(
      apiService: Get.find(),
      tokenService: Get.find(),
    ));

    controller.fetchComments(postId);

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
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
