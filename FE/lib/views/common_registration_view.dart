import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:weave_us/controllers/auth_controller.dart';

import '../routes/app_routes.dart';

class RegistrationView extends GetView<AuthController> {
  RegistrationView({super.key});

  @override
  Widget build(BuildContext context) {
    final formatter = MaskTextInputFormatter(mask: '###-####-####');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(""),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('회원가입',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900, // 폰트 Black
                    color: Color(0xFFFF8000),
                    fontFamily: 'Pretendard',
                  )),
              SizedBox(height: 20),
              Obx(() => TextField(
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (_) => controller.validateEmail(),
                    decoration: InputDecoration(
                      labelText: '이메일',
                      errorText: controller.emailError.value,
                    ),
                  )),
              TextField(
                  onChanged: (value) {
                    controller.updateFormValidity();
                  },
                  controller: controller.passwordController,
                  decoration: const InputDecoration(labelText: "비밀번호"),
                  obscureText: true),
              TextField(
                onChanged: (value) {
                  controller.updateFormValidity();
                },
                controller: controller.nameController,
                decoration: const InputDecoration(labelText: "이름"),
              ),
              TextField(
                onChanged: (value) {
                  controller.updateFormValidity();
                },
                controller: controller.nicknameController,
                decoration: const InputDecoration(labelText: "닉네임"),
              ),
              TextField(
                onChanged: (value) {
                  controller.updateFormValidity();
                },
                controller: controller.numberController,
                decoration: const InputDecoration(labelText: "전화번호"),
                keyboardType: TextInputType.phone,
                inputFormatters: [formatter],
              ),
              TextField(
                onChanged: (value) {
                  controller.updateFormValidity();
                },
                controller: controller.genderController,
                decoration: const InputDecoration(labelText: "성별"),
              ),
              SizedBox(height: 20),
              Obx(
                () => ElevatedButton(
                  onPressed: () { controller.isFormValid.value ?
                    controller.commonRegistration(
                        controller.emailController.text,
                        controller.passwordController.text,
                        controller.nameController.text,
                        controller.nicknameController.text,
                        controller.numberController.text,
                        controller.genderController.text) : null;
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(55), // 높이만 설정
                    backgroundColor: controller.isFormValid.value ? Color(0xFFFF8000) : Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    "이메일 인증하기",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontFamily: 'Pretendard',
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void clickLogin() {
    Get.offNamed(AppRoutes.LOGIN);
  }
}
