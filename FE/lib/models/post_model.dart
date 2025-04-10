class Post {
  final int id;
  final int userId;
  final int privacyId;
  final int weaveId;
  final int thumbnailMediaId;
  final String textContent;
  final String? location;
  final int? areaId;
  final int likes;
  final String createdAt;
  final String updatedAt;
  final String weaveTitle;
  final String nickname;
  final String? userMediaUrl;
  final int subValid;
  final int commentCount;
  final String mediaUrl;
  final int weaveType;

  Post({
    required this.id,
    required this.userId,
    required this.privacyId,
    required this.weaveId,
    required this.thumbnailMediaId,
    required this.textContent,
    this.location,
    this.areaId,
    required this.likes,
    required this.createdAt,
    required this.updatedAt,
    required this.weaveTitle,
    required this.nickname,
    this.userMediaUrl,
    required this.subValid,
    required this.commentCount,
    required this.mediaUrl,
    required this.weaveType,
  });

  // JSON 변환을 위한 factory constructor
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      userId: json['user_id'],
      privacyId: json['privacy_id'],
      weaveId: json['weave_id'],
      thumbnailMediaId: json['thumbnail_media_id'],
      textContent: json['text_content'],
      location: json['location'],
      areaId: json['area_id'],
      likes: json['likes'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      weaveTitle: json['weave_title'],
      nickname: json['nickname'],
      userMediaUrl: json['user_media_url'],
      subValid: json['sub_valid'],
      commentCount: json['comment_count'],
      mediaUrl: json['media_url'],
      weaveType: json['weave_type'],
    );
  }

  // JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'privacy_id': privacyId,
      'weave_id': weaveId,
      'thumbnail_media_id': thumbnailMediaId,
      'text_content': textContent,
      'location': location,
      'area_id': areaId,
      'likes': likes,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'weave_title': weaveTitle,
      'nickname': nickname,
      'user_media_url': userMediaUrl,
      'sub_valid': subValid,
      'comment_count': commentCount,
      'media_url': mediaUrl,
      'weave_type': weaveType,
    };
  }
}

class PostList {
  final List<Post> posts;

  PostList({required this.posts});

  factory PostList.fromJson(List<dynamic> json) {
    return PostList(
      posts: json.map((e) => Post.fromJson(e)).toList(),
    );
  }

  List<Map<String, dynamic>> toJson() {
    return posts.map((post) => post.toJson()).toList();
  }
}
