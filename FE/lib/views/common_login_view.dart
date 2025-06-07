import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../routes/app_routes.dart';

class LoginView extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    ever(authController.isLoading, (bool loading) {
      if (!loading && Get.isDialogOpen!) {
        Get.back(); // 다이얼로그 닫기
      }
    });
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(""),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Weave Us',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900, // 폰트 Black
                  color: Colors.orange,
                  fontFamily: 'Pretendard',
                )),
            SizedBox(height: 20),
            TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "이메일")),
            TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: "비밀번호"),
                obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                authController.login(
                    emailController.text, passwordController.text);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(55), // 높이만 설정
                backgroundColor: Color(0xFFFF8000),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                "로그인하기",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Pretendard',
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () => Get.toNamed(AppRoutes.NEW_USER),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF434343),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        "유저 회원가입",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: SizedBox(
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () => Get.toNamed(AppRoutes.NEW_OWNER),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF434343),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        "오너 회원가입",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
