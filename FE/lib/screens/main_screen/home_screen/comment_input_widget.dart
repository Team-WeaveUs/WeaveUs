import 'package:flutter/material.dart';

class CommentInputWidget extends StatelessWidget {
  final String username;
  final String profileImageUrl;
  final ValueChanged<String> onCommentSubmit;

  const CommentInputWidget({
    Key? key,
    required this.username,
    required this.profileImageUrl,
    required this.onCommentSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(profileImageUrl),
            backgroundColor: Colors.grey,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "$username님의 생각을 적어주세요",
                  border: InputBorder.none,
                ),
                style: const TextStyle(fontSize: 16),
                textInputAction: TextInputAction.send,
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    onCommentSubmit(value);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
