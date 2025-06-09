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
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          '게시물 상세',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'Pretendard',
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final post = controller.post.value;
        return Container(
            color: Colors.white,
            child: Stack(
            children: [
          ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(height: 10,),
              Divider(color: Colors.grey[850], height: 1, thickness: 1),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.weaveTitle,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            fontFamily: 'Pretendard',
                          ),
                        ),
                        Text(
                          post.weaveType == 1
                              ? 'Global'
                              : post.weaveType == 2
                                  ? 'Join'
                                  : 'Local',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF868583),
                            fontFamily: 'Pretendard',
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: controller.goToNewWeave,
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.grey[850], height: 1, thickness: 1),
              AspectRatio(
                aspectRatio: 1,
                child: Stack(
                  children: [
                    ClipRRect(
                      child: Image.network(
                        post.mediaUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                    Obx(() => Positioned(
                          bottom: 10,
                          right: 10,
                          child: GestureDetector(
                              onTap: () => controller
                                  .toggleLikeInDetail(controller.post.value),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Icon(
                                    size: 39,
                                    controller.post.value.isLiked
                                        ? Icons.favorite
                                        : Icons.favorite,
                                    color: controller.post.value.isLiked
                                        ? const Color(0xFFFF8000)
                                        : Colors.grey,
                                  ),
                                  Text(
                                    '${controller.post.value.likes}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              )),
                        )),
                  ],
                ),
              ),
              Divider(color: Colors.grey[850], height: 1, thickness: 1),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        post.userMediaUrl != null
                            ? CircleAvatar(
                                radius: 15,
                                backgroundImage:
                                    NetworkImage(post.userMediaUrl!),
                                backgroundColor: Colors.transparent,
                              )
                            : const CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.grey,
                                child: Icon(Icons.person, color: Colors.white),
                              ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed("/profile/${post.userId}");
                          },
                          child: Text(post.nickname),
                        ),
                        const Spacer(),
                        if (controller.canReward.value)
                          GestureDetector(
                            onTap: () => controller.giveReward(),
                            child: controller.myUId.value == post.userId.toString()
                                ? const SizedBox.shrink()
                            : Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF8000),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                "선물 주기",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(width: 6),
                        if (!post.isSubscribed &&
                            post.userId.toString() != controller.myUId.value)
                          GestureDetector(
                            onTap: () =>
                                controller.toggleSubscribeInDetail(post),
                            child:  Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF8000),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                "구독",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      post.textContent,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w200,
                        color: Colors.black,
                        fontFamily: 'Pretendard',
                      ),
                    ),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        '${post.commentCount}개의 댓글',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.grey[850], height: 1, thickness: 1),
              CommentSectionWidget(postId: post.id),
              const SizedBox(height: 100),
            ],
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: CommentInputWidget(
                postId: post.id,
              )),
        ]));
      }),
    );
  }
}
