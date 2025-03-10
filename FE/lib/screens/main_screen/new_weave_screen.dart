import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weave_us/Auth/token_storage.dart';

class NewWeaveScreen extends StatefulWidget {
  const NewWeaveScreen({super.key});

  @override
  State<NewWeaveScreen> createState() => _NewWeaveScreenState();
}

class _NewWeaveScreenState extends State<NewWeaveScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String selectedWeaveType = "Local";

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  int _getTypeId(String type) {
    switch (type) {
      case 'Local':
        return 1;
      case 'Global':
        return 2;
      case 'Private':
        return 3;
      default:
        return 1;
    }
  }

  Future<bool> _createWeaveOnServer(String title, String description, int typeId, int privacyId) async {
    String? accessToken = await TokenStorage.getAccessToken();

    final apiUrl = 'https://v79h9dyx08.execute-api.ap-northeast-2.amazonaws.com/WeaveAPI/WeaveUpload';

    final headers = {
      "accesstoken": "$accessToken",
      "Content-Type": "application/json"
    };

    final body = jsonEncode({
      "title": title,
      "description": description,
      "privacy_id": privacyId,
      "type_id": typeId
    });

    try {
      final response = await http.post(Uri.parse(apiUrl), headers: headers, body: body);

      return response.statusCode == 200;
    } catch (e) {
      debugPrint("위브 생성 중 오류: $e");
      return false;
    }
  }

  void _createWeave() async {
    final weaveName = _nameController.text.trim();
    final description = _descriptionController.text.trim();

    if (weaveName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("위브 이름을 입력하세요!")),
      );
      return;
    }

    final success = await _createWeaveOnServer(
      weaveName,
      description,
      _getTypeId(selectedWeaveType),
      3, // privacy_id 고정값 사용 (예시로 3 사용)
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(success ? "위브가 성공적으로 생성되었습니다!" : "위브 생성에 실패했습니다.")),
    );

    if (success) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
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
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '위브 이름',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: selectedWeaveType,
              decoration: const InputDecoration(
                labelText: '위브 종류',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              ),
              items: const [
                DropdownMenuItem(value: 'Local', child: Text('Local')),
                DropdownMenuItem(value: 'Global', child: Text('Global')),
                DropdownMenuItem(value: 'Private', child: Text('Private')),
              ],
              onChanged: (value) => setState(() => selectedWeaveType = value!),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: '소개',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createWeave,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white60,
                padding: const EdgeInsets.all(15),
              ),
              child: const Text(
                '생성하기',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}