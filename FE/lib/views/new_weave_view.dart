import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:weave_us/views/widgets/new_weave_widget/new_name.input.dart';
import 'package:weave_us/views/widgets/new_weave_widget/weave_explanation.dart';
import 'package:weave_us/views/widgets/new_weave_widget/weave_type_selector.dart';
import '../services/api_service.dart';

class NewWeaveView extends StatefulWidget {
  const NewWeaveView({super.key});

  @override
  State<NewWeaveView> createState() => _NewWeaveViewState();
}

class _NewWeaveViewState extends State<NewWeaveView> {
  String selectedWeave = '';
  String selectedOpenRange = '';
  String selectedInviteOption = '';

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

  bool get isFormValid {
    return selectedWeave.isNotEmpty &&
        nameController.text.trim().isNotEmpty &&
        descriptionController.text.trim().isNotEmpty;
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.white),
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
            WeaveTypeSelector(
              onChanged: ({required weave, required range, required invite}) {
                setState(() {
                  selectedWeave = weave ?? '';
                  selectedOpenRange = range ?? '';
                  selectedInviteOption = invite ?? '';
                });
              },
            ),
            Divider(color: Colors.grey[850], thickness: 1),
            NewNameInput(controller: nameController),
            Divider(color: Colors.grey[850], thickness: 1),
            WeaveExplanation(controller: descriptionController),
            Divider(color: Colors.grey[850], thickness: 1),
            const SizedBox(height: 30),
            // 안내 멘트
            if (isFormValid)
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
            // 생성 버튼
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: isFormValid
                      ? () {
                    final title = nameController.text.trim();
                    final desc = descriptionController.text.trim();
                    _createWeave(title, desc, typeId, privacyId);
                  }
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
                    padding: EdgeInsets.only(top:10, bottom: 10),
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
