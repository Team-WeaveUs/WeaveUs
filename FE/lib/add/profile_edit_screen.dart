import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({Key? key}) : super(key: key);

  @override
  State<ProfileEditScreen> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEditScreen> {
  Uint8List? _image;
  bool _isEnabled = true;
  String selectedWeaveType = "남자";

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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '프로필 편집',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
        backgroundColor: Colors.amber[100],
        centerTitle: true,
      ),
      body: Center( // 🔥 모든 위젯을 중앙 정렬
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // 세로 방향 중앙 정렬
            crossAxisAlignment: CrossAxisAlignment.center, // 가로 방향 중앙 정렬
            children: [
              // 프로필 사진
              Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 80, // 크기 증가
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _image != null ? MemoryImage(_image!) : null,
                    child: _image == null
                        ? const Icon(
                      Icons.person,
                      size: 80, // 아이콘 크기 증가
                      color: Colors.white,
                    )
                        : null,
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: IconButton(
                      onPressed: _isEnabled ? selectImage : null,
                      icon: const Icon(Icons.add_a_photo, size: 30),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20), // 🔥 간격 조정

              // 이름 입력 필드
              SizedBox(
                width: 300, // 🔥 너비 고정
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: '이름',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // 닉네임 입력 필드
              SizedBox(
                width: 300,
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: '닉네임',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // 위브 종류 드롭다운
              SizedBox(
                width: 300,
                child: DropdownButtonFormField<String>(
                  value: selectedWeaveType,
                  decoration: const InputDecoration(
                    labelText: '위브 종류',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: '남자', child: Text('남자')),
                    DropdownMenuItem(value: '여자', child: Text('여자')),
                    DropdownMenuItem(value: '???', child: Text('???')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedWeaveType = value;
                      });
                    }
                  },
                ),
              ),

              const SizedBox(height: 15),

              // 프로필 링크 입력 필드
              SizedBox(
                width: 300,
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: '프로필 링크',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // 소개 입력 필드
              SizedBox(
                width: 300,
                child: TextField(
                  maxLines: 3, // 🔥 높이 줄임
                  decoration: const InputDecoration(
                    labelText: '소개',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 프로필 편집하기 버튼
              SizedBox(
                width: 300, // 🔥 버튼도 동일한 너비 설정
                child: ElevatedButton(
                  onPressed: () {
                    // 프로필 편집하기 버튼 동작 추가
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                  ),
                  child: const Text(
                    '프로필 편집하기',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10), // 🔥 버튼 아래 간격 추가
            ],
          ),
        ),
      ),
    );
  }
}
