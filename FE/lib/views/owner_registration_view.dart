import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weave_us/controllers/auth_controller.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(""),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('오너 회원가입',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900, // 폰트 Black
                    color: Color(0xFF434343),
                    fontFamily: 'Pretendard',
                  )),
              SizedBox(height: 20),
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  controller.ownerRegistration(
                      emailController.text,
                      passwordController.text,
                      nameController.text,
                      nicknameController.text,
                      numberController.text,
                      genderController.text);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(55), // 높이만 설정
                  backgroundColor: Color(0xFF434343),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  "오너 회원가입 하기",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
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
}
