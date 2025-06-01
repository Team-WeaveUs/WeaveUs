import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weave_us/views/widgets/new_weave_widget/new_name.input.dart';
import 'package:weave_us/views/widgets/new_weave_widget/weave_explanation.dart';
import 'package:weave_us/views/widgets/new_weave_widget/weave_type_selector.dart';
import '../../controllers/new_weave_controller.dart';

class NewWeaveView extends GetView<NewWeaveController> {
  const NewWeaveView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          '새 위브',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 25,
            letterSpacing: 1.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(color: Colors.grey[850], thickness: 1),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, bottom: 2),
              child: Text('위브 종류',style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                fontFamily: 'Pretendard',
              ),),
            ),
            WeaveTypeSelector(
              onChanged: (model) {
                controller.updateSelections(
                  weave: model.weave,
                  range: model.range,
                  invite: model.invite,
                );
              },
            ),
            Divider(color: Colors.grey[850], thickness: 1),
            NewNameInput(
              controller: controller.nameController,
              focusNode: controller.nameFocusNode,
            ),
            Divider(color: Colors.grey[850], thickness: 1),
            WeaveExplanation(
              controller: controller.descriptionController,
              focusNode: controller.descriptionFocusNode,
            ),

            Divider(color: Colors.grey[850], thickness: 1),
            const SizedBox(height: 30),

            Obx(() {
              return Column(
                children: [
                  if (controller.isFormValid.value)
                    Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontFamily: 'Pretendard',
                          ),
                          children: [
                            TextSpan(text: '위브는 '),
                            TextSpan(
                              text: '그 누구의 소유도 아닙니다.  ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: '추가하시겠습니까?'),
                          ],
                        ),
                      ),
                    ),
                  SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20, left: 20),
                      child: ElevatedButton(
                        onPressed: controller.isFormValid.value
                            ? controller.createWeave
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF8000),
                          disabledBackgroundColor: Colors.grey.shade300,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Text(
                            "위브 생성",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Pretendard',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}