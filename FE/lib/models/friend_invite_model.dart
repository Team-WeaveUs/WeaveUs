class FriendInviteModel {
  final String nickname;
  final String mediaUrl;
  final int id;

  FriendInviteModel({required this.nickname, required this.mediaUrl, required this.id});

  factory FriendInviteModel.fromJson(Map<String, dynamic> json) {
    return FriendInviteModel(
      id: json['id'],
      nickname: json['nickname'],
      mediaUrl: json['mediaUrl'] ?? '',
    );
  }
}