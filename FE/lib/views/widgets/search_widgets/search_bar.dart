import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../controllers/search_controller.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController textController;
  final WeaveSearchController searchController;
  final VoidCallback onSearch;

  const CustomSearchBar({
    super.key,
    required this.textController,
    required this.searchController,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: textController,
            decoration: InputDecoration(
              hintText: "@닉네임 또는 제목으로 검색",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            onSubmitted: (_) => onSearch(),
          ),
        ),
        const SizedBox(width: 8),
        Obx(() => searchController.isLoading.value
            ? const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        )
            : IconButton(
          onPressed: onSearch,
          icon: const Icon(HugeIcons.strokeRoundedSearch02),
        )),
      ],
    );
  }
}