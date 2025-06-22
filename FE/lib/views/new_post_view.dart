import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:weave_us/views/widgets/new_post_widgets/post_content.input.dart';
import 'package:weave_us/views/widgets/new_post_widgets/post_tag.input.dart';
import 'package:weave_us/views/widgets/new_post_widgets/weave_selector_widget.dart';
import '../controllers/new_post_controller.dart';
import '../controllers/weave_dialog_controller.dart';
import '../services/api_service.dart';
import 'widgets/new_post_widgets/weave_select_dialog.dart';

class NewPostView extends GetView<NewPostController> {
  const NewPostView({super.key});

  @override
  Widget build(BuildContext context) {
    final from = Get.parameters['from'] ?? 'home'; // 기본값: home
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "새 게시물",
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w900,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              if (from.isNotEmpty) {
                Get.offAllNamed(from.trim());
              } else {
                Get.offAllNamed('/home');
              }
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(color: Colors.grey[850], thickness: 1),
            Obx(() => WeaveSelector(
                  selectedWeave: controller.selectedWeaveText.value,
                  onWeaveSelected: () {
                    if (!Get.isRegistered<ApiService>()) {
                      Get.put(ApiService());
                    }

                    if (!Get.isRegistered<WeaveDialogController>()) {
                      Get.put(WeaveDialogController(
                          apiService: Get.find<ApiService>()));
                    }

                    Get.dialog(
                      WeaveDialog(
                        onWeaveSelected: (selected) {
                          final parts = selected.split(',');
                          controller.selectWeave(parts[1], parts[0]);
                        },
                      ),
                    );
                  },
                )),
            Divider(color: Colors.grey[850], thickness: 1),

            // 이미지 선택 부분
            Obx(() {
              final hasImage = controller.images.isNotEmpty;
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      if (hasImage) {
                        controller.showDeleteImageDialog();
                      } else {
                        controller.pickImages();
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: hasImage
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.memory(
                                controller.images[0],
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Center(
                              child: Icon(
                                HugeIcons.strokeRoundedImage03,
                                color: Colors.black,
                                size: 100,
                              ),
                            ),
                    ),
                  ),
                ),
              );
            }),

            Divider(color: Colors.grey[850], thickness: 1),

            // 이미지 설명 부분
            PostContentInput(controller: controller.descriptionController),

            Divider(color: Colors.grey[850], thickness: 1),

            // 태그 입력 부분
            PostTagInput(controller: controller.tagController),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Obx(() => SizedBox(
                    width: double.infinity, // 가로 전체 채움
                    child: ElevatedButton(
                      onPressed: controller.images.isNotEmpty &&
                              controller.descriptionText.value.isNotEmpty &&
                              controller.selectedWeaveId.value != null
                          ? controller.sharePost
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF8000),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: const Text(
                          "공유하기",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Pretendard',
                          ),
                        ),
                      ),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
