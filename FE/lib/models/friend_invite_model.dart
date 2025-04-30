class FriendInviteModel {
  final String nickname;
  final String mediaUrl;

  FriendInviteModel({required this.nickname, required this.mediaUrl});

  factory FriendInviteModel.fromJson(Map<String, dynamic> json) {
    return FriendInviteModel(
      nickname: json['nickname'],
      mediaUrl: json['mediaUrl'] ?? '',
    );
  }
}