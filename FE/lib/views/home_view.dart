import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
              if (controller.postListMap.length < 10){
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
                        padding:
                            const EdgeInsets.only(top: 10, left: 10, right: 10),
                        child: Column(
                          children: [
                            Container(
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10)),
                                    border: Border(
                                        right: BorderSide(
                                            color: Colors.black, width: 1),
                                        left: BorderSide(
                                            color: Colors.black, width: 1),
                                        top: BorderSide(
                                            color: Colors.black, width: 1))),
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(children: [
                                        Text(controller.postList1[index].weaveTitle,
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                        Text(controller.postList1[index].weaveId == 1
                                            ? "else weave"
                                            : "Weave")
                                      ]),
                                      IconButton(
                                          onPressed: null,
                                          icon: Icon(Icons.add_circle_outline))
                                    ])),
                            Expanded(
                                child: PageView.builder(
                                    physics: const ClampingScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    onPageChanged: controller.onVerticalScroll,
                                    itemCount:
                                        controller.postListMap[index]?.length,
                                    itemBuilder: (context, index2) {
                                      var verticalPost =
                                          currentPostList[index2];
                                      return Column(children: [
                                        Expanded(
                                            child: Image.network(
                                                verticalPost.mediaUrl,
                                                fit: BoxFit.cover)),
                                        Container(
                                            padding: const EdgeInsets.all(10),
                                            margin: const EdgeInsets.only(
                                                bottom: 10),
                                            decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(10),
                                                    bottomRight:
                                                        Radius.circular(10)),
                                                color: Colors.white,
                                                border: Border(
                                                    left: BorderSide(
                                                        color: Colors.black,
                                                        width: 1),
                                                    right: BorderSide(
                                                        color: Colors.black,
                                                        width: 1),
                                                    bottom: BorderSide(
                                                        color: Colors.black,
                                                        width: 1))),
                                            child: Column(children: [
                                              Text(verticalPost.textContent),
                                              Row(children: [
                                                Text(
                                                    verticalPost.userMediaUrl ??
                                                        ""),
                                                Text(verticalPost.nickname)
                                              ])
                                            ])),
                                      ]);
                                    }))
                          ],
                        ));
                  },
                );}),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}
