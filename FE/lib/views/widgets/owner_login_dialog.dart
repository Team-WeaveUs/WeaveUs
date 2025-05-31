import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../routes/app_routes.dart';

void showOwnerLoginDialog(BuildContext context) {
  final TextEditingController businessNumberController = TextEditingController();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "사업자 번호를 입력해주세요.",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Pretendard',
                ),
              ),
              const SizedBox(height: 12),
              const Text("사업자등록번호 10자리를 입력해주세요."),
              const SizedBox(height: 12),
              TextField(
                controller: businessNumberController,
                keyboardType: TextInputType.number,
                maxLength: 10,
                decoration: InputDecoration(
                  hintText: "ex) 0123456789",
                  counterText: "",
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 12),
              const Text("해당 사업자등록번호로 등록하시겠습니까?"),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // 예 버튼
                  ElevatedButton(
                    onPressed: () async {
                      final bn = businessNumberController.text.trim();

                      if (bn.length != 10) {
                        Get.snackbar(
                          "입력 오류", "사업자번호는 정확히 10자리여야 합니다.",
                          backgroundColor: Colors.redAccent,
                          colorText: Colors.white,
                        );
                        return;
                      }

                      // 🔄 로딩 표시
                      Get.dialog(const Center(child: CircularProgressIndicator()),
                          barrierDismissible: false);

                      final isValid = await validateBusinessNumber(bn);

                      Get.back(); // 로딩 닫기

                      if (isValid) {
                        Navigator.of(context).pop();
                        Get.offAllNamed(AppRoutes.NEW_OWNER, arguments: {"b_no": bn});
                      } else {
                        Get.snackbar(
                          "인증 실패", "유효하지 않은 사업자번호입니다.",
                          backgroundColor: Colors.redAccent,
                          colorText: Colors.white,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[700],
                      minimumSize: const Size(100, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("예",
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),

                  // 취소 버튼
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      minimumSize: const Size(100, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("취소",
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}

Future<bool> validateBusinessNumber(String bno) async {
  const url = "https://api.odcloud.kr/api/nts-businessman/v1/status?serviceKey=RK1Tb5xIod4LWDuarSN6uUOZpHG%2BZgpTmbySBU8n2yiBcpZWwrYoUY6h80Chcv0EGXCRKTszOFCDpItZ4ZO%2FMA%3D%3D";

  final response = await http.post(
    Uri.parse(url),
    headers: {
      "Content-Type": "application/json",
    },
    body: jsonEncode({
      "b_no": [bno]
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final statusList = data['data'] as List<dynamic>;
    if (statusList.isNotEmpty) {
      final status = statusList[0];
      return status['b_stt_cd'] != null && status['b_stt_cd'].toString().isNotEmpty;
    }
  }

  return false;
}