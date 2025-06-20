import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:weave_us/views/components/app_nav_bar.dart';
import '../controllers/home_controller.dart';
import '../models/post_model.dart';
import 'components/bottom_nav_bar.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppNavBar(title: "Weave Us"),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.postListMap.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              return PageView.builder(
                pageSnapping: true,
                scrollDirection: Axis.horizontal,
                onPageChanged: controller.onHorizontalScroll,
                itemCount: controller.postListMap.length,
                itemBuilder: (context, index) {
                  List<Post> currentPostList = controller.postListMap[index]!;

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        final weaveId =
                                            controller.postList1[index].weaveId;
                                        Get.toNamed("/weave/$weaveId?from=${Get.currentRoute}");
                                      },
                                      child: Text(
                                        controller.postList1[index].weaveTitle,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                          fontFamily: 'Pretendard',
                                        ),
                                      ),
                                    ),
                                    Text(
                                      controller.postList1[index].weaveType == 1
                                          ? 'Global'
                                          : controller.postList1[index]
                                                      .weaveType ==
                                                  2
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
                                  icon: Icon(controller.postList1[index].weaveType == 1
                                      ? Icons.add_circle_outline
                                      : controller.postList1[index]
                                      .weaveType ==
                                      2
                                      ? HugeIcons.strokeRoundedGift
                                      : Icons.add_circle_outline),
                                )
                              ],
                            ),
                          ),
                          Divider(
                              color: Colors.grey[850], height: 1, thickness: 1),
                          Expanded(
                            child: PageView.builder(
                              physics: const ClampingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              onPageChanged: controller.onVerticalScroll,
                              itemCount: controller.postListMap[index]?.length,
                              itemBuilder: (context, index2) {
                                var verticalPost = currentPostList[index2];

                                return Column(
                                  children: [
                                    Expanded(
                                      child: Stack(
                                        children: [
                                          Positioned.fill(
                                            child: Image.network(
                                              verticalPost.mediaUrl,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Positioned(
                                              bottom: 10,
                                              right: 10,
                                              child: GestureDetector(
                                                onTap: () => controller
                                                    .toggleLike(verticalPost),
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    Icon(
                                                      size: 39,
                                                      verticalPost.isLiked
                                                          ? Icons.favorite
                                                          : Icons.favorite,
                                                      color:
                                                          verticalPost.isLiked
                                                              ? const Color(
                                                                  0xFFFF8000)
                                                              : Colors.grey,
                                                    ),
                                                    Text(
                                                      '${verticalPost.likes}',
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors
                                                            .white, // 하트 위에서 잘 보이도록 흰색
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                        color: Colors.grey[850],
                                        height: 1,
                                        thickness: 1),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Get.toNamed(
                                                      "/profile/${verticalPost.userId}");
                                                },
                                                child: Row(
                                                  children: [
                                                    verticalPost.userMediaUrl !=
                                                            null
                                                        ? CircleAvatar(
                                                            radius: 15,
                                                            backgroundImage:
                                                                NetworkImage(
                                                                    verticalPost
                                                                        .userMediaUrl!),
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                          )
                                                        : const CircleAvatar(
                                                            radius: 15,
                                                            backgroundColor:
                                                                Colors.grey,
                                                            child: Icon(
                                                                Icons.person,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                    const SizedBox(width: 6),
                                                    Text(verticalPost.nickname),
                                                  ],
                                                ),
                                              ),
                                              const Spacer(),
                                              if (verticalPost.userId
                                                      .toString() !=
                                                  controller.myUId.value)
                                                !verticalPost.isSubscribed ?
                                                GestureDetector(
                                                  onTap: () => controller
                                                      .toggleSubscribe(
                                                          verticalPost),
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 16,
                                                        vertical: 6),
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xFFFF8000),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                    ),
                                                    child: const Text(
                                                      "구독",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                                    : GestureDetector(
                                                  onTap: () => controller.toggleSubscribe(verticalPost),
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 16,
                                                        vertical: 6),
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey,
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          6),
                                                    ),
                                                    child: const Text(
                                                      "구독중",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            verticalPost.textContent,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w200,
                                              color: Colors.black,
                                              fontFamily: 'Pretendard',
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          GestureDetector(
                                            onTap: () {
                                              Get.toNamed(
                                                  '/post/${verticalPost.id}?from=${Get.currentRoute}');
                                            },
                                            child: Text(
                                              '${verticalPost.commentCount}개의 댓글',
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
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}
