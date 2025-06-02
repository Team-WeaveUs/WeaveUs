import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

import '../routes/app_routes.dart';

class AuthMainView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // 앱 바 삭제
      // appBar: AppBar(
      //   centerTitle: true,
      //   backgroundColor: Colors.white,
      //   title: Text("Weave Us"),
      // ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(HugeIcons.strokeRoundedGift, size: 200, color: Colors.orange),
              Text('Weave Us',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900, // 폰트 Black
                    color: Colors.orange,
                    fontFamily: 'Pretendard',
                  )),
              SizedBox(height: 50),

              // 위브 버튼
              ElevatedButton(
                onPressed: onPressedWeave,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(55), // 높이만 설정
                  backgroundColor: Color(0xFFFF8000),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  "위브로 계속하기",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontFamily: 'Pretendard',
                  ),
                ),
              ),

              SizedBox(height: 20),

              // 오너 버튼
              ElevatedButton(
                onPressed: onPressedOwner,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(55), // 높이만 설정
                  backgroundColor: Color(0xFF434343),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  "오너로 계속하기",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontFamily: 'Pretendard',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  onPressedWeave() {
    Get.offAllNamed(AppRoutes.LOGIN);
  }

  onPressedOwner() {
    Get.offAllNamed(AppRoutes.OWNERS);
  }
}