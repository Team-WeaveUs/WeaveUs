import 'package:flutter/material.dart';

class NewWeaveScreen extends StatelessWidget {
  const NewWeaveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String selectedWeaveType = "Local"; // 드롭다운 기본값

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          '새 위브',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 위브 이름 입력 필드
            const TextField(
              decoration: InputDecoration(
                labelText: '위브 이름',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 10,
                ), // 패딩 추가
              ),
            ),
            const SizedBox(height: 20),

            // 위브 종류 드롭다운
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.85, // 너비 조정
              child: DropdownButtonFormField<String>(
                value: selectedWeaveType,
                decoration: const InputDecoration(
                  labelText: '위브 종류',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 10,
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: 'Local', child: Text('Local')),
                  DropdownMenuItem(value: 'Global', child: Text('Global')),
                  DropdownMenuItem(value: 'Private', child: Text('Private')),
                ],
                onChanged: (value) {
                  // Handle dropdown value change
                  if (value != null) {
                    selectedWeaveType = value;
                  }
                },
              ),
            ),
            const SizedBox(height: 20),

            // 소개 입력 필드
            TextField (
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: '소개',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 10,
                ), // 패딩 추가
              ),
            ),
            const SizedBox(height: 20),

            // 생성하기 버튼
            ElevatedButton(
              onPressed: () {
                // 생성하기 버튼 동작 추가
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300], // 버튼 배경색
                padding: const EdgeInsets.all(15),
              ),
              child: const Text(
                '생성하기',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // 텍스트 색상
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
