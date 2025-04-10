import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/api_service.dart';

class WeaveDialog extends StatefulWidget {
  final Function(String) onWeaveSelected;

  const WeaveDialog({super.key, required this.onWeaveSelected});

  @override
  _WeaveDialogState createState() => _WeaveDialogState();
}

class _WeaveDialogState extends State<WeaveDialog> {
  final TextEditingController _searchController = TextEditingController();
  final ApiService _apiService = Get.find<ApiService>();
  List<Map<String, dynamic>> _searchResults = [];

  // API 호출
  Future<void> _searchWeave() async {
    final String query = _searchController.text.trim();

    if (query.isEmpty) {
      print("검색어를 입력하세요!");
      return;
    }

    print("API 호출 시작: $query");

    try {
      final response = await _apiService.postRequest('search/weave', {
        'title': query,
      });

      if (response != null && response['weaves'] is List) {
        setState(() {
          _searchResults = List<Map<String, dynamic>>.from(response['weaves']);
        });
        print("검색 성공: ${_searchResults}");
      } else {
        print("검색 결과가 리스트가 아님");
        setState(() => _searchResults = []);
      }
    } catch (e) {
      print("검색 실패: $e");
      setState(() => _searchResults = []);
    }
  }

  // 자동입력
  void _selectWeave(String title) {
    widget.onWeaveSelected(title);
    Navigator.pop(context); // 선택 후 다이얼로그 닫기
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 200,
          maxHeight: MediaQuery.of(context).size.height * 0.7, // 최대 높이 설정
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Dialog Header
              const Center(
                child: Text(
                  "위브를 검색하세요",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // 검색 입력 필드
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "검색어를 입력하세요...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _searchWeave, // 🔥 버튼 클릭 시 검색 실행
                    icon: const Icon(Icons.search, color: Colors.blue),
                  ),
                ],
              ),

              AnimatedContainer(
                duration: const Duration(milliseconds: 300), // 부드럽게 변경
                height: _searchResults.isNotEmpty ? 10 : 0, // 검색 결과가 있을 때만 공간 추가
              ),

              /// 🔥 **검색 결과 리스트 (title만 표시)**
              _searchResults.isEmpty
                  ? const Padding(
                padding: EdgeInsets.all(8.0),
              )
                  : Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final weave = _searchResults[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        title: Text(
                          weave['title'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        trailing: IconButton(
                          icon: const Icon(Icons.add, color: Colors.green),
                          onPressed: () => _selectWeave(weave['title'] + "," + weave['weave_id'].toString()),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 10),

              // 닫기버튼
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                ),
                child: const Text("닫기", style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}