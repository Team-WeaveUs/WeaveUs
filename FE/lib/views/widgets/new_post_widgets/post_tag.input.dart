import 'package:flutter/material.dart';
import 'package:textfield_tags/textfield_tags.dart';

class PostTagInput extends StatelessWidget {
  final TextfieldTagsController<String> controller;

  const PostTagInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFieldTags<String>(
            textfieldTagsController: controller,
            textSeparators: const [' ', ','], // 스페이스나 ,로 분리
            inputFieldBuilder: (context, inputFieldValues) {
              return TextField(
                controller: inputFieldValues.textEditingController,
                style: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'Pretendard',
                  color: Colors.black,
                  letterSpacing: 0.5,
                ),
                decoration: InputDecoration(
                  hintText: '#태그를 입력하세요',
                  hintStyle: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Pretendard',
                    color: Colors.grey,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                  prefixIconConstraints: BoxConstraints(maxWidth: screenWidth * 0.8),
                  prefixIcon: inputFieldValues.tags.isNotEmpty
                      ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: inputFieldValues.tagScrollController,
                    child: Row(
                      children: inputFieldValues.tags.map((tag) {
                        return Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFBBBBBB),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Text('#$tag', style: const TextStyle(color: const Color(0xFFFFFFFF)),
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: () => inputFieldValues.onTagRemoved(tag),
                                child: const Icon(Icons.cancel, size: 14, color: const Color(0xFF868583)),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  )
                      : null,
                ),
                onChanged: inputFieldValues.onTagChanged,
                onSubmitted: inputFieldValues.onTagSubmitted,
              );
            },
          ),
        ],
      ),
    );
  }
}