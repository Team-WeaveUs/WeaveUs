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

  String selectedGender = "비공개";
  int selectedOption = 0; // 0 or 1 for the second dropdown

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
                  'assets/image/weave_us.JPG', // Ensure this path is correct
                  height: 200,
                ),
                SizedBox(height: 10),

                // 가로로 배치된 드롭다운 버튼들
                SizedBox(
                  height: 65,
                  child: Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedGender,
                          decoration: const InputDecoration(
                            labelText: '성별',
                            border: OutlineInputBorder(),
                            filled: true,
                          ),
                          items: const [
                            DropdownMenuItem(value: '비공개', child: Text('비공개')),
                            DropdownMenuItem(value: '남성', child: Text('남성')),
                            DropdownMenuItem(value: '여성', child: Text('여성')),
                          ],
                          onChanged: (value) => setState(() => selectedGender = value!),
                        ),
                      ),
                      SizedBox(width: 20), // Space between dropdowns
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          value: selectedOption,
                          decoration: const InputDecoration(
                            labelText: '오너계정이신가요?',
                            border: OutlineInputBorder(),
                            filled: true,
                          ),
                          items: const [
                            DropdownMenuItem(value: 0, child: Text('아니요')),
                            DropdownMenuItem(value: 1, child: Text('네')),
                          ],
                          onChanged: (value) => setState(() => selectedOption = value!),
                        ),
                      ),
                    ],
                  ),
                ),

                // 닉네임과 이름을 가로로 배치
                SizedBox(
                  height: 65,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
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
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: '이름',
                            prefixIcon: Icon(Icons.person),
                            filled: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),

                // 전화번호 입력 필드
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '전화번호',
                    prefixIcon: Icon(Icons.call),
                    filled: true,
                  ),
                ),
                SizedBox(height: 20),

                // 아이디 입력 필드
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '아이디',
                    prefixIcon: Icon(Icons.email),
                    filled: true,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '아이디를 입력해주세요.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // 패스워드 입력 필드
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

                // 패스워드 확인 입력 필드
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
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // 회원가입 버튼
                ElevatedButton(
                  onPressed: () {
                    final form = _globalKey.currentState;
                    if (form != null && form.validate()) {
                      // Proceed with signup logic
                    } else {
                      setState(() {
                        _autovalidateMode = AutovalidateMode.always;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Text(
                    '회원가입',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 10),

                // 로그인 페이지로 이동 버튼
                TextButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SigninScreen(),
                    ),
                  ),
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
      ),
    );
  }
}
