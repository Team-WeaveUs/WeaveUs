import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
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

                  return Container(
                    padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                            border: Border(
                              right: BorderSide(color: Colors.black, width: 1),
                              left: BorderSide(color: Colors.black, width: 1),
                              top: BorderSide(color: Colors.black, width: 1),
                            ),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    controller.postList1[index].weaveTitle,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                      fontFamily: 'Pretendard',
                                    ),
                                  ),
                                  Text(
                                    controller.postList1[index].weaveId == 1 ? "else weave" : "Weave",
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
                              )
                            ],
                          ),
                        ),
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
                                    child: Image.network(
                                      verticalPost.mediaUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.only(bottom: 10),
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                      color: Colors.white,
                                      border: Border(
                                        left: BorderSide(color: Colors.black, width: 1),
                                        right: BorderSide(color: Colors.black, width: 1),
                                        bottom: BorderSide(color: Colors.black, width: 1),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(verticalPost.userMediaUrl ?? ""),
                                            const SizedBox(width: 6),
                                            Text(verticalPost.nickname),
                                            const SizedBox(width: 6),
                                            IconButton(
                                              icon: Icon(
                                                verticalPost.isLiked
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: verticalPost.isLiked
                                                    ? const Color(0xFFFF8000)
                                                    : Colors.grey,
                                              ),
                                              onPressed: () => controller.toggleLike(verticalPost),
                                            ),
                                            Text('${verticalPost.likes}'),
                                            const SizedBox(width: 6),
                                            GestureDetector(
                                              onTap: () => controller.toggleSubscribe(verticalPost),
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: Text( "구독",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          verticalPost.textContent,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w200,
                                            color: Colors.black,
                                            fontFamily: 'Pretendard',
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Get.toNamed('/post/${verticalPost.id}',
                                              arguments: {'postUserId': verticalPost.userId},
                                            );
                                          },
                                          child: Text(
                                            '${verticalPost.commentCount.toString()}개의 댓글',
                                            style: const TextStyle(
                                              fontSize: 10,
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