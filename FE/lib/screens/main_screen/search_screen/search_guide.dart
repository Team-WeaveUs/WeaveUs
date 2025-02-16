import 'package:flutter/material.dart';

class SearchGuide extends StatelessWidget {
  const SearchGuide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        "\n검색 방법 안내: \n\n"
            "• 위브 → 브랜드 또는 일반 키워드 검색 (예: asd)\n"
            "• @사용자이름 → 특정 계정 찾기 (예: @weave)\n"
            "• #키워드 → 해당 키워드가 포함된 위브 검색 (예: #방문)",
        style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
      ),
    );
  }
}
