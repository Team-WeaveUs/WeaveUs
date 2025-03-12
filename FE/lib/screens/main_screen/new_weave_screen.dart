import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weave_us/Auth/api_client.dart';
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

  void _createWeave() {
    Future.delayed(Duration.zero, () {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("게시물 공유 완료!")),
        );
      }
    });
  }

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
    final response = await ApiService.sendRequest(
      "WeaveAPI/WeaveUpload",
      {
        "title": title,
        "description": description,
        "privacy_id": privacyId,
        "type_id": typeId
      },
    );

    if (response != null) {
      debugPrint("위브 생성 성공!");
      return true;
    } else {
      debugPrint("위브 생성 실패!");
      return false;
    }
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