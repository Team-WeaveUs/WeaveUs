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


class ProfilePostList {
  final int postId;
  final String img;
  final String loc;
  ProfilePostList({
    required this.postId,
    required this.img,
    required this.loc,
  });
  factory ProfilePostList.fromJson(Map<String, dynamic> json) {
    return ProfilePostList(
      postId: json['post_id'],
      img: json['img'],
      loc: json['loc']??"",
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'post_id': postId,
      'img': img,
      'loc': loc,
    };
  }
}