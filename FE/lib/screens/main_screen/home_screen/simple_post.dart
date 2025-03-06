// simple_post.dart
class SimplePost {
  final int id;
  final int userId;
  final int privacyId;
  final int weaveId;
  final int thumbnailMediaId;
  final String textContent;
  final String location;
  final int areaId;
  final int likes;
  final String createdAt;
  final String updatedAt;
  final String weaveTitle;
  final String nickname;
  final String userMediaUrl;
  final bool subValid;
  final int commentCount;
  final String mediaUrl;

  SimplePost({
    required this.id,
    required this.weaveTitle,
    required this.mediaUrl,
    required this.likes,
    required this.textContent,
    required this.nickname,
    required this.subValid,
    required this.weaveId,
    required this.userId,
    required this.privacyId,
    required this.thumbnailMediaId,
    required this.location,
    required this.areaId,
    required this.createdAt,
    required this.updatedAt,
    required this.userMediaUrl,
    required this.commentCount,
  });

  factory SimplePost.fromJson(Map<String, dynamic> json) {
    return SimplePost(
      id: json['id'] ?? 0,
      weaveTitle: json['weave_title'] ?? '',
      mediaUrl: json['media_url'] ?? '',
      likes: json['likes'] ?? 0,
      textContent: json['text_content'] ?? '',
      nickname: json['nickname'] ?? '',
      subValid: json['sub_valid'] == 1, // 1이면 true, 0이면 false
      weaveId: json['weave_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      privacyId: json['privacy_id'] ?? 0,
      thumbnailMediaId: json['thumbnail_media_id'] ?? 0,
      location: json['location'] ?? '',
      areaId: json['area_id'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      userMediaUrl: json['user_media_url'] ?? '',
      commentCount: json['comment_count'] ?? 0,
    );
  }
}
