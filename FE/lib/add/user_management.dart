import 'package:flutter/material.dart';

class UserManagement extends StatefulWidget {
  const UserManagement({Key? key}) : super(key: key);

  @override
  State<UserManagement> createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
  String selectedWeaveType = "시흥"; // 🔥 상태로 관리해야 Dropdown 변경 가능

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '관리',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
        backgroundColor: Colors.amber[100],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 전화번호 입력 필드
            TextField(
              decoration: const InputDecoration(
                labelText: '전화번호',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 10,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 위브 이름 입력 필드
            TextField(
              decoration: const InputDecoration(
                labelText: '위브 이름',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 10,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 지역 종류 드롭다운
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              child: DropdownButtonFormField<String>(
                value: selectedWeaveType,
                decoration: const InputDecoration(
                  labelText: '지역 종류',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 10,
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: '시흥', child: Text('시흥')),
                  DropdownMenuItem(value: '서울', child: Text('서울')),
                  DropdownMenuItem(value: 'Private', child: Text('Private')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedWeaveType = value; // 🔥 상태 업데이트
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 20),

            // 수정하기 버튼
            ElevatedButton(
              onPressed: () {
                // 버튼 동작 추가
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                padding: const EdgeInsets.all(15),
              ),
              child: const Text(
                '수정하기',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}