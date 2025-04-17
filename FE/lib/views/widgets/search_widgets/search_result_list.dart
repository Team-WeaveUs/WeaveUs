import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/search_controller.dart';

class SearchResultList extends StatelessWidget {
  const SearchResultList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WeaveSearchController>();

    return Obx(() {
      final results = controller.searchResults;

      if (controller.isNoResults.value) {
        return const Center(
          child: Text(("검색 결과가 없습니다."),
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF000000),
              fontFamily: 'Pretendard'),
          ),
        );
      }

      return ListView(
        children: [
          if (results.isEmpty) ...[
            const SizedBox(height: 12),
            const Text(
              "@를 붙여서 친구를 검색할 수 있습니다.",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF868583),
                  fontFamily: 'Pretendard'),
            ),
          ],
          if (results.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text(
                "검색 결과",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000000),
                  fontFamily: 'Pretendard'),
            ),
            ...results.map((result) {
              final title = result['title'] ?? result['nickname'] ?? '제목 없음';
              final subtitle = result['description'] ?? result['email'] ?? '';
              return ListTile(
                title: Text(title),
                subtitle: Text(subtitle),
                onTap: () {
                  print("클릭한 항목: $title");
                },
              );
            }).toList(),
            const SizedBox(height: 80),
          ]
        ],
      );
    });
  }
}
