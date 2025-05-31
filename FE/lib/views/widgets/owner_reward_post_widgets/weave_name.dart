import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../controllers/weave_controller.dart';

class WeaveNameWidget extends GetView<WeaveController> {
  const WeaveNameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.weaveList.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      } else {
        return ListView.builder(
          itemCount: controller.weaveList.length,
          itemBuilder: (context, index) {
            final weave = controller.weaveList[index];
            return ListTile(
              title: Text(
                weave.title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                weave.description,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
              onTap: () {
                // 위브 상세보기 이동 (추후 연결 가능)
              },
            );
          },
        );
      }
    });
  }
}
