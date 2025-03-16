import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weave_us/screens/signin_screen.dart';

class SignpasswordScreen extends StatefulWidget {
  const SignpasswordScreen({super.key});

  @override
  State<SignpasswordScreen> createState() => _SignpasswordScreenState();
}

class _SignpasswordScreenState extends State<SignpasswordScreen> {
  bool get _isEnabled => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            child: ListView(
              shrinkWrap: true,
              children: [
                // 해당 로고
                Image.asset(
                  '/image/weave_us.JPG',
                  height: 200,
                ),
                SizedBox(height: 50),

                // 구분선
                Divider(
                  height: 20,
                  color: Colors.grey[850],
                  thickness: 2,
                ),
                SizedBox(height: 50),

                // 추후 변경할 예정
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '이메일 인증 ???',
                    prefixIcon: Icon(Icons.email),
                    filled: true,
                  ),
                ),
                SizedBox(height: 20),

                // 추후 변경할 예정
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '보안 질문 ???',
                    prefixIcon: Icon(Icons.lock),
                    filled: true,
                  ),
                ),
                SizedBox(height: 50),

                // 구분선
                Divider(
                  height: 20,
                  color: Colors.grey[850],
                  thickness: 2,
                ),
                SizedBox(height: 20),

                // 변경하지 않고 나가기 버튼
                TextButton(
                  onPressed:()
                  {
                    Get.offAll(() => SigninScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // 버튼 배경색
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Text(
                    '변경하지 않고 나가기',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange, // 텍스트 색상
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // 비밀번호 변경하기 버튼
                TextButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent, // 버튼 배경색
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Text(
                    '비밀번호 변경하기',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // 텍스트 색상
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}