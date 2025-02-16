import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:weave_us/add/user_management.dart';
import 'package:weave_us/screens/main_screen.dart';

import 'user_management.dart'; // ✅ 메인 화면 import 추가

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  Uint8List? _image;
  bool _isEnabled = true;

  Future<void> selectImage() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      Uint8List imageBytes = await image.readAsBytes();
      setState(() {
        _image = imageBytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope( // ✅ 뒤로가기 동작을 감지
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()), // ✅ 메인 화면으로 이동
              (Route<dynamic> route) => false, // ✅ 모든 기존 화면을 제거
        );
        return false; // 기본 뒤로가기 동작 방지
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton( // ✅ 앱바에서도 뒤로가기 버튼을 메인화면으로 이동
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const MainScreen()), // ✅ MainScreen으로 이동
                    (Route<dynamic> route) => false,
              );
            },
          ),
          title: const Text(
            '설정',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
            ),
          ),
          backgroundColor: Colors.amber[100],
          centerTitle: true,
        ),
        body: Column(
          children: [
            const SizedBox(height: 10),

            // 🔥 프로필 정보 (사진, 이름, 닉네임, 관리 버튼)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                leading: Stack(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: _image != null ? MemoryImage(_image!) : null,
                      child: _image == null
                          ? const Icon(Icons.person, size: 40, color: Colors.white)
                          : null,
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: GestureDetector(
                        onTap: _isEnabled ? selectImage : null,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[200],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                title: const Text(
                  '김제원',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  'stellive',
                  style: TextStyle(color: Colors.grey),
                ),
                trailing: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const UserManagement()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.grey[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    '관리',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // 🔥 설정 목록
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView(
                  children: [
                    const Divider(thickness: 1, color: Colors.grey, height: 1),
                    buildSettingItem(Icons.notifications, "알림 설정"),
                    const Divider(thickness: 1, color: Colors.grey, height: 1),

                    buildSettingItem(Icons.lock, "계정 공개 범위"),
                    const Divider(thickness: 1, color: Colors.grey, height: 1),

                    buildSettingItem(Icons.headset_mic, "고객 센터"),
                    const Divider(thickness: 1, color: Colors.grey, height: 1),

                    buildSettingItem(Icons.star, "오너 되기"),
                    const Divider(thickness: 1, color: Colors.grey, height: 1),

                    buildSettingItem(Icons.privacy_tip, "개인정보 처리방침"),
                    const Divider(thickness: 1, color: Colors.grey, height: 1),

                    buildSettingItem(Icons.info, "버전 정보"),
                    const Divider(thickness: 1, color: Colors.grey, height: 1),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 설정 항목 UI 빌드 함수 (우측 화살표 아이콘 추가)
  Widget buildSettingItem(IconData icon, String title) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      leading: Icon(icon, size: 24, color: Colors.black),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.orange),
      onTap: () {
        // 해당 설정 페이지로 이동하는 로직 추가 가능
      },
    );
  }
}
