import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../routes/app_routes.dart';

class OwnerLoginView extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OwnerLogin"),
        actions: [
          IconButton(
            icon: Icon(Icons.published_with_changes),
            onPressed: () {
              Get.offAllNamed(AppRoutes.AUTH);
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
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
                SizedBox(width: 10,),
                TextButton(
                  onPressed: () {
                    Get.offAllNamed(AppRoutes.NEW_OWNER);
                  },
                  child: Text("New Owner"),
                )
              ],
            )

          ],
        ),
      ),
    );
  }
}
