class MiniPost {
  final int postId;
  final String? img;
  final String? loc;

  MiniPost({required this.postId, this.img, this.loc});

  factory MiniPost.fromJson(Map<String, dynamic> json) {
    return MiniPost(
      postId: json['post_id'],
      img: json['img'],
      loc: json['loc'],
    );
  }
}

class Profile {
  final int userId;
  final String nickname;
  final String? img;
  final int likes;
  final int subscribes;
  final List<MiniPost> postList;

  Profile({
    required this.userId,
    required this.nickname,
    this.img,
    required this.likes,
    required this.subscribes,
    required this.postList,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      userId: json['user_id'],
      nickname: json['nickname'],
      img: json['img'],
      likes: json['likes'],
      subscribes: json['subscribes'],
      postList: (json['post_list'] as List)
          .map((post) => MiniPost.fromJson(post))
          .toList(),
    );
  }
}
