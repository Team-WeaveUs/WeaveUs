import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../controllers/auth_controller.dart';
import '../../routes/app_routes.dart';

void showOwnerLoginDialog(BuildContext context) {
  final TextEditingController businessNumberController = TextEditingController();
  final authController = Get.find<AuthController>();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 타이틀 텍스트
              const Text(
                "사업자 번호를 입력해주세요.",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Pretendard',
                ),
              ),
              const SizedBox(height: 15),
              // 설명 텍스트
              const Text("사업자등록번호 10자리를 입력해주세요.",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Pretendard',
                ),),
              const SizedBox(height: 14),
              // 입력 필드
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
              const SizedBox(height: 14),
              // 확인 메시지
              const Text("해당 사업자등록번호로 등록하시겠습니까?"
                ,style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Pretendard',
                ),
              ),
              const SizedBox(height: 15),
              // 버튼 영역
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // 예 버튼
                  Expanded(
                    child: ElevatedButton(
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

                        final isValid = await authController.validateBusinessNumber(bn);

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
                        minimumSize: Size.fromHeight(55), // 높이만 설정
                        backgroundColor: Color(0xFF868583),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text("예",
                          style: TextStyle(fontSize: 25,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Pretendard',
                              color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 20),
                  // 취소 버튼
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size.fromHeight(55), // 높이만 설정
                        backgroundColor: Color(0xFFFF8000),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text("취소",
                          style: TextStyle(fontSize: 25,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Pretendard',
                              color: Colors.white)),
                    ),
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