import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/search_controller.dart';

class RecentSearch extends StatelessWidget {
  const RecentSearch({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WeaveSearchController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("최근 검색", style: TextStyle(fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: controller.clearRecentSearches,
              child: const Text("전체 삭제", style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
        Obx(() => controller.recentSearches.isEmpty
            ? const Text("최근 검색 기록이 없습니다.")
            : Wrap(
          spacing: 8,
          children: controller.recentSearches.map((term) {
            return ActionChip(
              label: Text(term),
              onPressed: () {
                controller.textController.text = term;
                controller.search(term);
                controller.foldMap(); // 지도 접기
              },
            );
          }).toList(),
        )),
      ],
    );
  }
}
