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
        return ListView.separated(
            itemCount: controller.weaveList.length,
            itemBuilder: (context, index) {
              final weave = controller.weaveList[index];
              return ListTile(
                onTap: () => Get.toNamed('/weave/${weave.weaveId}'),
                  title: Text(weave.title),
                  subtitle: Text(weave.typeId == 1
                      ? 'Global'
                      : weave.typeId == 2
                          ? 'Join'
                          : 'Local'),
                  trailing: IconButton(
                      onPressed: () =>
                          controller.goToNewWeave(weave.weaveId, weave.title),
                      icon: Icon(Icons.add_circle_outline)));
            },
            separatorBuilder: (context, index) => Divider(
          color: Colors.grey[850],
          height: 1,
          thickness: 1
        ),
        );
      },

    );
  }
}
