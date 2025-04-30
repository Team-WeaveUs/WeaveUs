import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weave_us/controllers/auth_controller.dart';

import '../routes/app_routes.dart';

class OwnerRegistrationView extends GetView<AuthController> {
  OwnerRegistrationView({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("오너 회원가입"),
        actions: [
          IconButton(
            icon: Icon(Icons.login),
            onPressed: () {
              Get.offAllNamed(AppRoutes.OWNERS);
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        alignment: Alignment.center,
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "이메일"),
            ),
            TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: "비밀번호"),
                obscureText: true),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "이름"),
            ),
            TextField(
              controller: nicknameController,
              decoration: const InputDecoration(labelText: "닉네임"),
            ),
            TextField(
              controller: numberController,
              decoration: const InputDecoration(labelText: "전화번호"),
            ),
            TextField(
              controller: genderController,
              decoration: const InputDecoration(labelText: "성별"),
            ),
            TextButton(
                onPressed: () {
                  controller.ownerRegistration(
                      emailController.text,
                      passwordController.text,
                      nameController.text,
                      nicknameController.text,
                      numberController.text,
                      genderController.text);
                },
                child: Text("회원가입"))
          ],
        ),
      ),
    );
  }
}
