import 'package:get/get.dart';
import 'package:weave_us/controllers/profile_controller.dart';
import 'package:flutter/material.dart';

class MyWeaveWidget extends GetView<ProfileController> {
  MyWeaveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
          () {
        if (controller.profile.value.nickname == '') {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
            itemCount: controller.myWeaveList.length,
            itemBuilder: (context, index) {
              final weave = controller.myWeaveList[index];
              return ListTile(
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
            });
      },
    );
  }
}