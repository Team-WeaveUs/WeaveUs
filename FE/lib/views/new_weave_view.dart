import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:weave_us/views/components/app_nav_bar.dart';
import 'package:weave_us/views/widgets/new_weave_widget/new_name.input.dart';
import 'package:weave_us/views/widgets/new_weave_widget/weave_explanation.dart';

import '../services/api_service.dart';

class NewWeaveView extends StatefulWidget {
  const NewWeaveView({super.key});

  @override
  State<NewWeaveView> createState() => _NewWeaveViewState();
}

class _NewWeaveViewState extends State<NewWeaveView> {
  final weaveTypes = ['Weave', '내 Weave', 'Global', 'Private'];
  final openRanges = ['모두 공개', '초대한 사용자', '나만 보기'];
  final inviteOptions = ['1명 업로드 가능', '3명 업로드 가능', '5명 업로드 가능'];

  String selectedWeave = 'Weave';
  String selectedOpenRange = '모두 공개';
  String selectedInviteOption = '3명 업로드 가능';

  bool isOpenRangeExpanded = false;
  bool isInviteExpanded = false;

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  int get typeId {
    switch (selectedWeave) {
      case '내 Weave':
        return 1;
      case 'Global':
        return 2;
      case 'Private':
        return 3;
      default:
        return 1;
    }
  }

  int get privacyId {
    switch (selectedOpenRange) {
      case '모두 공개':
        return 1;
      case '초대한 사용자':
        return 2;
      case '나만 보기':
        return 3;
      default:
        return 1;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _createWeave(String title, String description, int typeId, int privacyId) async {
    try {
      final response = await ApiService().postRequest("WeaveUpload", {
        "title": title,
        "description": description,
        "privacy_id": privacyId,
        "type_id": typeId
      });

      if (response != null && response['message'] == '위브 생성 성공') {
        debugPrint("위브 생성 성공!");
        Get.snackbar("성공", "위브가 성공적으로 생성되었습니다");
        Get.back();
      } else {
        debugPrint("위브 생성 실패: \${response.toString()}");
        Get.snackbar("실패", "위브 생성에 실패했습니다");
      }
    } catch (e) {
      debugPrint("오류 발생: \$e");
      Get.snackbar("에러", "서버 오류가 발생했습니다");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavBar(
        title: "새 게시물",
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('위브 종류', style: TextStyle(fontSize: 15, color: Colors.black)),
            DropdownButton<String>(
              value: selectedWeave,
              isExpanded: true,
              items: weaveTypes.map((type) {
                return DropdownMenuItem(value: type, child: Text(type));
              }).toList(),
              onChanged: (value) {
                setState(() => selectedWeave = value!);
              },
            ),
            if (selectedWeave == '내 Weave') ...[
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => setState(() => isOpenRangeExpanded = !isOpenRangeExpanded),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      const Icon(Icons.public, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        selectedOpenRange,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ]),
                    Icon(isOpenRangeExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                  ],
                ),
              ),
              if (isOpenRangeExpanded)
                Padding(
                  padding: const EdgeInsets.only(left: 36, bottom: 8),
                  child: Column(
                    children: openRanges.map((option) {
                      return GestureDetector(
                        onTap: () => setState(() {
                          selectedOpenRange = option;
                          isOpenRangeExpanded = false;
                        }),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(option),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => setState(() => isInviteExpanded = !isInviteExpanded),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      const Icon(Icons.group, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        selectedInviteOption,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ]),
                    Icon(isInviteExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                  ],
                ),
              ),
              if (isInviteExpanded)
                Padding(
                  padding: const EdgeInsets.only(left: 36, bottom: 8),
                  child: Column(
                    children: inviteOptions.map((option) {
                      return GestureDetector(
                        onTap: () => setState(() {
                          selectedInviteOption = option;
                          isInviteExpanded = false;
                        }),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(option),
                        ),
                      );
                    }).toList(),
                  ),
                ),
            ],
            Divider(color: Colors.grey[850], thickness: 1),
            NewNameInput(controller: nameController),
            Divider(color: Colors.grey[850], thickness: 1),
            WeaveExplanation(controller: descriptionController),
            Divider(color: Colors.grey[850], thickness: 1),
            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final title = nameController.text.trim();
                    final desc = descriptionController.text.trim();

                    if (title.isNotEmpty && desc.isNotEmpty) {
                      _createWeave(title, desc, typeId, privacyId);
                    } else {
                      Get.snackbar("입력 오류", "제목과 소개를 모두 입력해주세요");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF8000),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
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
        ),
      ),
    );
  }
}
