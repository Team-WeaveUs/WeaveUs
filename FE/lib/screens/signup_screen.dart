import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weave_us/Auth/api_client.dart';
import 'package:weave_us/Auth/auth_signup.dart';
import 'package:weave_us/Auth/sign_up_response.dart';
import 'package:weave_us/screens/signin_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool get _isEnabled => true;

  String? selectedGender = '비공개';
  String? selectedOwnerStatus = '일반회원';

  String? _nickError;
  String? _nameError;
  String? _numberError;
  String? _idError;
  String? _passwordError;
  String? _confirmPasswordError;


  final List<String> genderItems = ['비공개', '남성', '여성'];
  final List<String> ownerOptions = ['일반회원', '오너회원']; // 0: 일반 유저, 1: 오너 계정

  void _validateNick(String value) {
    if (value.isEmpty) {
      setState(() {
        _nickError = '닉네임을 입력해주세요.';
      });
    } else {
      setState(() {
        _nickError = null; // 오류 없음
      });
    }
  }
  void _validateName(String value) {
    setState(() {
      if (value.isEmpty) {
          _nameError = '이름를 입력해주세요.';
      } else {
        _nameError = null; // 오류 없음
      }
    });
  }
  void _validateNumber(String value) {
    setState(() {
      if (value.isEmpty) {
        _numberError = '전화번호를 입력해주세요.';
      } else if (value.length < 11) {
        _numberError = '전화번호는 정확히 11자여야 합니다.';
      } else if (value.length > 11) {
        _numberError = '전화번호는 정확히 11자여야 합니다.';
      } else {
        _numberError = null; // 오류 없음
      }
    });
  }
  void _validateId(String value) {
    if (value.isEmpty) {
      setState(() {
        _idError = '아이디를 입력해주세요.';
      });
    } else {
      setState(() {
        _idError = null; // 오류 없음
      });
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
    // 비밀번호가 변경되면 다시 비밀번호 확인 검증
    _validateConfirmPassword(_confirmPasswordController.text);
  }
  void _validateConfirmPassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _confirmPasswordError = "비밀번호 확인을 입력해주세요!";
      } else if (value != _passwordController.text) {
        _confirmPasswordError = "비밀번호가 일치하지 않습니다!";
      } else {
        _confirmPasswordError = null;
      }
    });
  }

  final _authSignup = AuthSignup();

  Future<void> _signUpUser() async {
    // 모든 입력 필드 검증 실행
    _validateNick(_nicknameController.text);
    _validateName(_nameController.text);
    _validateNumber(_numberController.text);
    _validateId(_idController.text);
    _validatePassword(_passwordController.text);
    _validateConfirmPassword(_confirmPasswordController.text);

    // 오류 메시지가 하나라도 있으면 진행하지 않음
    if (_nickError != null || _nameError != null || _numberError != null || _idError != null || _passwordError != null || _confirmPasswordError != null) {
      setState(() {}); // 오류 메시지를 UI에 반영
      return;
    }

    try {
      final signUpResponse = await _authSignup.signUpUser(
          _idController.text.trim(),
          _passwordController.text.trim(),
          _nicknameController.text.trim(),
          _nameController.text.trim(),
          _numberController.text.trim(),
          selectedGender ?? "비공개",
          selectedOwnerStatus ?? "일반회원"
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("회원가입 성공! 로그인하세요: ${signUpResponse.message}")),
      );

      // 회원가입 성공 후 0초 후 로그인 화면으로 이동
      Future.delayed(const Duration(seconds: 0), () {
        if (mounted) {
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (context) => SigninScreen()),
          // );
          Get.offAll(SigninScreen());
        }
      });

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("회원가입 실패: ${e.toString()}")),
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
              Image.asset('assets/image/weave_us.JPG', height: 200),
              const SizedBox(height: 10),

              // 성별 & 오너 여부 선택
              SizedBox(
                height: 65,
                child: Row(
                  children: [
                    Expanded(
                      child: _buildDropdown(
                          "성별", genderItems, selectedGender, (value) {
                        setState(() => selectedGender = value);
                      }),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _buildDropdown(
                          "오너 가입여부", ownerOptions, selectedOwnerStatus, (
                          value) {
                        setState(() => selectedOwnerStatus = value);
                      }),
                    ),
                  ],
                ),
              ),

              // 닉네임 필드
              SizedBox(height: 5),
              TextFormField(
                controller: _nicknameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "닉네임",
                  prefixIcon: Icon(Icons.person_2),
                  filled: true,
                  errorText: _nickError,
                ),
                onChanged: _validateNick,
              ),

              // 이름 필드
              SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "이름",
                  prefixIcon: Icon(Icons.person),
                  filled: true,
                  errorText: _nameError,
                ),
                onChanged: _validateName,
              ),

              // 전화번호 필드
              SizedBox(height: 20),
              TextFormField(
                controller: _numberController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "전화번호",
                  prefixIcon: Icon(Icons.call),
                  filled: true,
                  errorText: _numberError,
                ),
                onChanged: _validateNumber,
              ),

              // 아이디 필드
              SizedBox(height: 20),
              TextFormField(
                controller: _idController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "아이디",
                  prefixIcon: Icon(Icons.email),
                  filled: true,
                  errorText: _idError,
                ),
                onChanged: _validateId,
              ),

              // 비밀번호 입력
              SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "비밀번호",
                  prefixIcon: Icon(Icons.lock),
                  filled: true,
                  errorText: _passwordError, // 실시간 오류 메시지
                ),
                onChanged: _validatePassword,
              ),

              // 비밀번호 확인
              SizedBox(height: 20),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "비밀번호 확인",
                  prefixIcon: Icon(Icons.lock),
                  filled: true,
                  errorText: _confirmPasswordError, // 실시간 오류 메시지
                ),
                onChanged: _validateConfirmPassword, // 실시간 검증
              ),

              SizedBox(height: 20),

              // 회원가입 버튼
              ElevatedButton(
                onPressed: _signUpUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  '회원가입',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Login 화면 돌아가기
              ElevatedButton(
                onPressed: (){
                  // Get.offAll(SigninScreen());
                  Get.offAll(() => SigninScreen());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  '이미 회원이신가요? 로그인하기',
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

  Widget _buildDropdown(String label, List<String> items, String? value, ValueChanged<String?> onChanged) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        items: items.map((item) => DropdownMenuItem(
          value: item,
          child: Text(
            item,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        )).toList(),
        value: value,
        onChanged: onChanged,
        buttonStyleData: ButtonStyleData(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black54),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14),
        ),
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(Icons.arrow_drop_down, color: Colors.black54),
          iconSize: 24,
        ),
      ),
    );
  }


  Widget _buildTextField(TextEditingController controller, String label, IconData icon,
      [TextInputType keyboardType = TextInputType.text, bool obscureText = false, String? Function(String?)? validator]) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        prefixIcon: Icon(icon, color: Colors.black54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black54),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.orange, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      ),
      validator: validator ?? (value) => (value == null || value.trim().isEmpty) ? "$label을 입력해주세요." : null,
    );
  }
}
