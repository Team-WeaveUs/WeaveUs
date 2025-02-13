import 'package:flutter/material.dart';
import 'package:weave_us/screens/signin_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  TextEditingController _passwordEditingController = TextEditingController();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  bool get _isEnabled => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: _globalKey,
            autovalidateMode: _autovalidateMode,
            child: ListView(
              shrinkWrap: true,
              children: [
                // 팀 로고
                Image.asset(
                  '/image/weave_us.JPG',
                  height: 200,
                ),
                SizedBox(height: 20),

                // 이메일
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '이메일',
                    prefixIcon: Icon(Icons.email),
                    filled: true,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '이메일을 입력해주세요.';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return '유효한 이메일을 입력해주세요.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // 닉네임
                TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '닉네임',
                    prefixIcon: Icon(Icons.person_2),
                    filled: true,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '닉네임을 입력해주세요.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // 이름
                TextFormField(
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '이름',
                    prefixIcon: Icon(Icons.person),
                    filled: true,
                  ),
                ),
                SizedBox(height: 20),

                // 생년월일
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '생년월일',
                    prefixIcon: Icon(Icons.calendar_month),
                    filled: true,
                  ),
                ),
                SizedBox(height: 20),

                // 패스워드
                TextFormField(
                  controller: _passwordEditingController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    filled: true,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '패스워드를 입력해주세요.';
                    }
                    if (value.length < 8) {
                      return '패스워드는 8글자 이상 입력해주세요.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // 패스워드 확인
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Confirm Password',
                    prefixIcon: Icon(Icons.lock),
                    filled: true,
                  ),
                  validator: (value) {
                    if (_passwordEditingController.text != value) {
                      return '패스워드가 일치하지 않습니다.';
                    }
                    // 추가 비밀번호 확인 로직을 여기에 작성
                    return null;
                  },
                ),
                SizedBox(height: 40),

                // 회원가입 버튼
                ElevatedButton(
                  onPressed: () {
                    final form = _globalKey.currentState;

                    // 실시간 검증 ex) 이메일, 닉네임, 패스워드 똑바로 입력했는지
                    setState(() {
                      _autovalidateMode = AutovalidateMode.always;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent, // 버튼 배경색
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Text(
                    '회원가입',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // 텍스트 색상
                    ),
                  ),
                ),
                SizedBox(height: 10),

                // 다시 Signin 화면으로 복귀
                TextButton(
                  onPressed: _isEnabled
                      ? () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SigninScreen(),
                      ))
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent, // 버튼 배경색
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Text(
                    '이미 회원이신가요? 로그인하기',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // 텍스트 색상
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}