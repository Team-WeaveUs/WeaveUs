import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class LoginView extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: const InputDecoration(labelText: "이메일")),
            TextField(controller: passwordController, decoration: const InputDecoration(labelText: "비밀번호"), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                authController.login(emailController.text, passwordController.text);
              },
              child: Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
