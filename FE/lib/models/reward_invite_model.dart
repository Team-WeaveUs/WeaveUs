class RewardInviteModel {
  final String reward;
  final String description;
  final int rewardId;
  final String validity;

  RewardInviteModel({
    required this.reward,
    required this.description,
    required this.rewardId,
    required this.validity,
  });

  factory RewardInviteModel.fromJson(Map<String, dynamic> json) {
    return RewardInviteModel(
      reward: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      rewardId: json['reward_id'] ?? 0,
      validity: json['validity']?.toString() ?? '',
    );
  }
}
