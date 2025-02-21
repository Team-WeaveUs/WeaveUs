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
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: '# 태그 입력',
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: const Icon(Icons.add, color: Colors.deepOrange),
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  onTagAdded(controller.text);
                  controller.clear();
                }
              },
            ),
          ),
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              onTagAdded(value);
              controller.clear();
            }
          },
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
