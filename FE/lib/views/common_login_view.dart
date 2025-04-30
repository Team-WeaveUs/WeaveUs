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
      appBar: AppBar(
        title: Text("Login"),
        actions: [
          IconButton(
            icon: Icon(Icons.published_with_changes),
            onPressed: () {
              Get.offAllNamed(AppRoutes.AUTH);
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        alignment: Alignment.center,
        child: Column(
          children: [
            TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "이메일")),
            TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: "비밀번호"),
                obscureText: true),
            SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    authController.login(
                        emailController.text, passwordController.text);
                  },
                  child: Text("Login"),
                ),
                TextButton(
                  onPressed: () {
                    Get.offAllNamed(AppRoutes.NEW_USER);
                  },
                  child: Text("New User"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
