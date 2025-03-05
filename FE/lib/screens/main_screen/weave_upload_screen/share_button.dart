import 'package:flutter/material.dart';
import 'package:weave_us/screens/main_screen.dart';

class ShareButton extends StatelessWidget {
  final VoidCallback onShare;
  final bool isUploadable; // 업로드 가능 여부 추가

  const ShareButton({Key? key, required this.onShare, required this.isUploadable}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: isUploadable
            ? () {
          onShare(); // 먼저 업로드 실행     // 게시글과 사진 없으면 넘어가지 않음

          // 업로드 후 1초 뒤 main_screen.dart로 이동 (이전 화면 제거 // 스택 방지)
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainScreen()), // 이전 화면 삭제 후 이동
            );
          });
        }
            : null, // ❌ 사진 & 글 없으면 비활성화
        style: ElevatedButton.styleFrom(
          backgroundColor: isUploadable ? Colors.white60 : Colors.grey[400], // 비활성화 시 색상 변경 (사진 or 게시글없으면)
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          "공유하기",
          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
