class Post {
  final String name;
  final String content;
  final int postLikes;
  final String weaveTitle;
  final String userProfile;
  final int userLikePost;
  final List<String> types;
  final List<String> urls;

  Post({
    required this.name,
    required this.content,
    required this.postLikes,
    required this.weaveTitle,
    required this.userProfile,
    required this.userLikePost,
    required this.types,
    required this.urls,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      name: json['name'],
      content: json['content'],
      postLikes: json['post_likes'],
      weaveTitle: json['weave_title'],
      userProfile: json['user_profile'],
      userLikePost: json['user_like_post'],
      types: json['types'].split(','),
      urls: json['urls'].split(','),
    );
  }
}