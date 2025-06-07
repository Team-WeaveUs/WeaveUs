import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

import '../controllers/profile_controller.dart';
import '../routes/app_routes.dart';

class OtherProfileView extends GetView<ProfileController> {
  const OtherProfileView({super.key});

  get icon => null;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Obx(() => controller.profile.value.nickname == ''
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Text("${controller.profile.value.nickname} 님의 프로필")),
          ),
          body: Column(
            children: [
              Obx(() => controller.profile.value.nickname == ''
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          controller.profile.value.img == ''
                              ? const CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  radius: 50,
                                  child: Icon(
                                    HugeIcons.strokeRoundedUser,
                                    color: Colors.white,
                                    size: 50,
                                  ))
                              : CircleAvatar(
                                  radius: 50,
                                  backgroundImage: NetworkImage(
                                      controller.profile.value.img),
                                ),
                          const SizedBox(width: 10),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(controller.profile.value.nickname,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              Row(
                                children: [
                                  const Icon(HugeIcons.strokeRoundedUser),
                                  Text(controller.profile.value.subscribes
                                      .toString()),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.favorite,
                                      color: Colors.orange),
                                  Text(controller.profile.value.likes
                                      .toString()),
                                ],
                              ),
                            ],
                          )),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF868583),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                            child: Text("구독",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold)),
                          )
                        ],
                      ))),
              const TabBar(
                tabs: [
                  Tab(text: '게시물'),
                  Tab(text: '만든 위브'),
                  Tab(text: '기여한 위브'),
                ],
              ),
              Expanded(
                  child: TabBarView(children: [
                Obx(
                  () => controller.profile.value.nickname == ''
                      ? const Center(child: CircularProgressIndicator())
                      : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3, childAspectRatio: 1),
                          itemCount: controller.otherPostList.length,
                          itemBuilder: (context, index) {
                            final post = controller.otherPostList[index];
                            return GestureDetector(
                                onTap: () {
                                  Get.toNamed(
                                    '/post/${post.postId}',
                                    arguments: {
                                      'postUserId':
                                          controller.profile.value.userId
                                    },
                                  );
                                },
                                child: Image.network(post.img));
                          },
                        ),
                ),
                Obx(
                  () => controller.otherWeaveData.value.message != "성공"
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.separated(
                          itemCount:
                              controller.otherWeaveList.length,
                          itemBuilder: (context, index) {
                            final weave =
                                controller.otherWeaveList[index];
                            return ListTile(
                              onTap: () =>
                                  Get.toNamed('/weave/${weave.weaveId}'),
                              title: Text(weave.title),
                              subtitle: Text(weave.typeId == 1
                                  ? 'Global'
                                  : weave.typeId == 2
                                  ? 'Join'
                                  : 'Local'),
                              trailing: IconButton(
                                  onPressed: () =>
                                      controller.goToNewWeave(weave.weaveId, weave.title),
                                  icon: Icon(Icons.add_circle_outline))
                            );
                          },
                          separatorBuilder: (context, index) => Divider(
                              color: Colors.grey[850], height: 1, thickness: 1),
                        ),
                ),
                    Obx(() => controller.otherContributedWeaveData.value.message != "성공"
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.separated(
                      itemCount: controller.otherContributedWeaveList.length,
                      itemBuilder: (context, index) {
                        final weave = controller.otherContributedWeaveList[index];
                        return ListTile(
                          onTap: () => Get.toNamed('/weave/${weave.weaveId}'),
                          title: Text(weave.title),
                          subtitle: Text(weave.typeId == 1
                              ? 'Global'
                              : weave.typeId == 2
                              ? 'Join'
                              : 'Local'),
                          trailing: IconButton(
                              onPressed: () => controller.goToNewWeave(weave.weaveId, weave.title),
                              icon: Icon(Icons.add_circle_outline)
                          )
                        );},
                      separatorBuilder: (context, index) => Divider(
    color: Colors.grey[850], height: 1, thickness: 1),
                      ),
                    )
              ])),
            ],
          ),
        ));
  }
}
