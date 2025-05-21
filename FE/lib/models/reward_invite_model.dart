class RewardInviteModel {
  final String reward;
  final String mediaUrl;

  RewardInviteModel({
    required this.reward,
    required this.mediaUrl,
  });

  factory RewardInviteModel.fromJson(Map<String, dynamic> json) {
    return RewardInviteModel(
      reward: json['title']?.toString() ?? '',
      mediaUrl: json['mediaUrl']?.toString() ?? '',
    );
  }
}
