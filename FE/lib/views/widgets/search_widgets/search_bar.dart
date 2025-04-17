import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../controllers/search_controller.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;

  const CustomSearchBar({
    super.key,
    required this.controller,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
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
        IconButton(
          onPressed: onSearch,
          icon: const Icon(HugeIcons.strokeRoundedSearch02),
        ),
      ],
    );
  }
}
