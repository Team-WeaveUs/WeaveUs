import './profile_post_list_model.dart';

class Profile {
  final String message;
  final int userId;
  final String nickname;
  final String img;
  final int likes;
  final int subscribes;
  final List<ProfilePostList> postList;
  final int isOwner;

  Profile({
    required this.message,
    required this.userId,
    required this.nickname,
    required this.img,
    required this.likes,
    required this.subscribes,
    required this.postList,
    required this.isOwner,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      message: json['message'],
      userId: json['user_id'],
      nickname: json['nickname'],
      img: json['img'] ?? "",
      likes: json['likes'],
      subscribes: json['subscribes'],
      isOwner: json['is_owner'] ?? 0,
      postList: List<ProfilePostList>.from(
        json['post_list'].map((x) => ProfilePostList.fromJson(x)),
      ),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'user_id': userId,
      'nickname': nickname,
      'img': img,
      'likes': likes,
      'subscribes': subscribes,
      'post_list': postList.map((x) => x.toJson()).toList(),
    };
  }
}


