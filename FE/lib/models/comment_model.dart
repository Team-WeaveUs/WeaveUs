class Comment {
  final int commentId;
  final String content;
  final String nickname;
  final String createdAt;
  final String mediaUrl;
  final String userId;

  Comment({
    required this.commentId,
    required this.content,
    required this.nickname,
    required this.createdAt,
    required this.mediaUrl,
    required this.userId
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentId: json['comment_id'] ?? 0,
      content: json['content'] ?? "",
      nickname: json['nickname'] ?? "",
      createdAt: json['created_at'] ?? "",
      mediaUrl: json['media_url'] ?? "",
      userId: json['user_id'].toString(),
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

