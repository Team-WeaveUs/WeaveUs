import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weave_us/views/widgets/owner_login_dialog.dart';
import '../controllers/auth_controller.dart';
import '../routes/app_routes.dart';

class OwnerLoginView extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: Text("OwnerLogin"),
      //   actions: [
      //     IconButton(
      //       icon: Icon(Icons.published_with_changes),
      //       onPressed: () {
      //         Get.offAllNamed(AppRoutes.AUTH);
      //       },
      //     ),
      //   ],
      // ),
      body: Center(
        child: Padding(
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
                    decoration: const InputDecoration(labelText: "이메일")
                    ),
                SizedBox(height: 20),
                TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(labelText: "비밀번호"),
                    obscureText: true),
                SizedBox(height: 20),

                // 로그인 버튼
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
                  child: Text(
                    "로그인하기",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Pretendard',
                    ),
                  ),
                ),

                SizedBox(height: 20),
                //
                //    TextButton(
                //     onPressed: () {
                //       showOwnerLoginDialog(context); // 다이얼로그 호출
                //     },
                //     child: Text("New Owner"),
                //   )
                // ],
                // 오너 회원가입 버튼
                ElevatedButton(
                  onPressed: () {
                    showOwnerLoginDialog(context); // 다이얼로그 호출
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(55), // 높이만 설정
                    backgroundColor: Color(0xFF434343),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    "오너 회원가입",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Pretendard',
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
