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