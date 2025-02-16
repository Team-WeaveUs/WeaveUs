import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:weave_us/screens/main_screen.dart';
import 'package:weave_us/screens/signpassword_screen.dart';
import 'package:weave_us/screens/signup_screen.dart';


class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool get _isEnabled => true;

  // 실시간 검증 상태를 저장할 변수
  String? _idError;
  String? _passwordError;

  // 실시간 검증 함수
  void _validateId(String value) {
    if (value.isEmpty) {
      setState(() {
        _idError = '아이디 또는 이메일을 입력해주세요.';
      });
    } else {
      final isEmail = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value);
      final isUsername = RegExp(r'^[a-zA-Z0-9_.]+$').hasMatch(value);
      if (!isEmail && !isUsername) {
        setState(() {
          _idError = '유효한 아이디 또는 이메일을 입력해주세요.';
        });
      } else {
        setState(() {
          _idError = null; // 오류 없음
        });
      }
    }
  }

  void _validatePassword(String value) {
    if (value.isEmpty) {
      setState(() {
        _passwordError = '비밀번호를 입력해주세요.';
      });
    } else if (value.length < 6) {
      setState(() {
        _passwordError = '비밀번호는 6자 이상이어야 합니다.';
      });
    } else {
      setState(() {
        _passwordError = null; // 오류 없음
      });
    }
  }

  Future<void> _loginUser() async {
    if (_idError != null || _passwordError != null) {
      return; // 입력값이 유효하지 않으면 종료
    }

    const String apiUrl =
        "https://v79h9dyx08.execute-api.ap-northeast-2.amazonaws.com/WeaveAPI/Login";
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "x-api-key": dotenv.env['AWS_API_KEY'] ?? ''
    };

    final Map<String, dynamic> body = {
      "username": _idController.text.trim(),
      "password": _passwordController.text.trim(),
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(body),
      );

      final responseBody = utf8.decode(response.bodyBytes); // UTF-8로 디코딩
      final responseData = jsonDecode(responseBody); // JSON 디코딩

      if (response.statusCode == 200) {
        print("로그인 성공: ${responseData['message']}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("로그인 성공: ${responseData['message']}")),
        );

        // MainScreen으로 이동
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      } else {
        print("로그인 실패: ${responseData['message']}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("로그인 실패: ${responseData['message']}")),
        );
      }
    } catch (e) {
      print("서버 요청 실패: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("서버 요청 실패: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: ListView(
            shrinkWrap: true,
            children: [
              Image.asset(
                "/image/weave_us.JPG",
                height: 200,
              ),
              const SizedBox(height: 20),

              // 아이디 또는 이메일 입력 필드
              TextFormField(
                controller: _idController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '아이디 또는 이메일',
                  prefixIcon: Icon(Icons.person),
                  filled: true,
                  errorText: _idError, // 실시간 오류 메시지
                ),
                onChanged: _validateId, // 입력값 변경 시 검증
              ),
              const SizedBox(height: 20),

              // 비밀번호 입력 필드
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '비밀번호',
                  prefixIcon: Icon(Icons.lock),
                  filled: true,
                  errorText: _passwordError, // 실시간 오류 메시지
                ),
                onChanged: _validatePassword, // 입력값 변경 시 검증
              ),
              SizedBox(height: 5),

              TextButton(
                onPressed: _isEnabled
                    ? () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignpasswordScreen(),
                    ))
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // 버튼 배경색
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  '비밀번호를 잊으셨나요?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange, // 텍스트 색상
                  ),
                ),
              ),
              SizedBox(height: 20),

              // 로그인 버튼
              ElevatedButton(
                onPressed: _loginUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  '로그인',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 10),

              // 회원가입 버튼
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignupScreen(),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  '회원가입',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
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