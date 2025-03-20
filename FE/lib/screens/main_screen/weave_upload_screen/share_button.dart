import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weave_us/screens/main_screen.dart';

class ShareButton extends StatelessWidget {
  final VoidCallback onShare;
  final bool isUploadable;

  const ShareButton({Key? key, required this.onShare, required this.isUploadable}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: isUploadable
              ? () {
            onShare(); // 업로드 실행

            // 업로드 후 스낵바 표시
            Future.delayed(Duration.zero, () {
              if (Get.isSnackbarOpen == false) {
                Get.snackbar(
                  "성공", "게시물 공유 완료!",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.black.withOpacity(0.8),
                  colorText: Colors.white,
                  duration: const Duration(seconds: 2),
                );
              }
            });

            Future.delayed(const Duration(seconds: 1), () {
              Get.offAll(() => MainScreen());
            });
          }
              : null, // 비활성화 시 클릭 불가

          style: ElevatedButton.styleFrom(
            backgroundColor: isUploadable ? Colors.orange : Colors.orangeAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          child: const Text(
            "공유하기",
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}
