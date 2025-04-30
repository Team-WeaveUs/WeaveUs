class Comment {
  final int commentId;
  final String content;
  final String nickname;

  Comment({
    required this.commentId,
    required this.content,
    required this.nickname,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentId: json['comment_id'],
      content: json['content'],
      nickname: json['nickname'],
    );
  }
}

class CommentInput {
  final String userId;
  final int postId;
  final String content;

  CommentInput({
    required this.userId,
    required this.postId,
    required this.content,
  });

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'post_id': postId,
    'content': content,
  };
}

