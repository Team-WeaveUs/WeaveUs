import 'package:flutter/material.dart';

class TagInput extends StatelessWidget {
  final TextEditingController controller;
  final List<String> tags;
  final Function(String) onTagAdded;
  final Function(String) onTagRemoved;

  const TagInput({
    super.key,
    required this.controller,
    required this.tags,
    required this.onTagAdded,
    required this.onTagRemoved,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: '# 태그를 추가해주세요',
              hintStyle: TextStyle(
                fontSize: 20,
                color: Colors.grey,
              ),
              border: InputBorder.none,
            ),
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                onTagAdded(value);
                controller.clear();
              }
            },
          ),
        ),

        const SizedBox(height: 10),
        Wrap(
          spacing: 6,
          children: tags
              .map((tag) => Chip(
            label: Text(tag),
            deleteIcon: const Icon(Icons.close),
            onDeleted: () => onTagRemoved(tag),
          ))
              .toList(),
        ),
      ],
    );
  }
}
