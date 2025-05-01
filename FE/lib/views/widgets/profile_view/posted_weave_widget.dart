import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../controllers/profile_controller.dart';

class PostedWeaveWidget extends GetView<ProfileController> {
  const PostedWeaveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (controller.profile.value.nickname == '') {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
            itemCount: controller.weaveList.length,
            itemBuilder: (context, index) {
              final weave = controller.weaveList[index];
              return ListTile(
                  title: Text(weave.title),
                  subtitle: Text(weave.typeId == 1
                      ? '내 위브'
                      : weave.typeId == 2
                          ? 'Global'
                          : 'Private'),
                  trailing: IconButton(
                      onPressed: () =>
                          controller.goToNewWeave(weave.weaveId, weave.title),
                      icon: Icon(Icons.add_circle_outline)));
            });
      },
    );
  }
}
