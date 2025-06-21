import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
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

      return ListView.separated(
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemCount: controller.comments.length,
        itemBuilder: (context, index) {
          final comment = controller.comments[index];
          return ListTile(
            onTap: () {
              Get.toNamed("/profile/${controller.comments[index].userId}");
            },
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
            leading: comment.mediaUrl == ""
                ? const CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 20,
              child: Icon(
                HugeIcons.strokeRoundedUser,
                size: 20,
                color: Colors.white,
              ),
            )
                : CircleAvatar(
              backgroundImage: NetworkImage(comment.mediaUrl),
            ),
            title: Text(comment.nickname,
              style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: Colors.grey,
            ),),
            subtitle: Text(comment.content,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 20,
                color: Colors.black,
              ),),
          );
        },
        separatorBuilder: (context, index) => Divider(
          color: Colors.grey[850],
          height: 1,
          thickness: 1,
        ),
      );
    });
  }
}
