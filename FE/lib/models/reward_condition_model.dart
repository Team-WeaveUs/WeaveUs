class RewardCondition {
  final int id;
  final String name;
  final String description;
  final String type;
  final int rewardCount;
  final int likeThreshold;
  final String parameters;
  final int isActive;

  RewardCondition({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.rewardCount,
    required this.likeThreshold,
    required this.parameters,
    required this.isActive,
});
  factory RewardCondition.fromJson(Map<String, dynamic> json) {
    return RewardCondition(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: json['type'],
      rewardCount: json['reward_count'],
      likeThreshold: json['like_threshold'] ?? 0,
      parameters: json['parameters'] ?? '',
      isActive: json['is_active'],
    );
  }
  factory RewardCondition.empty() {
    return RewardCondition(
      id: 0,
      name: '',
      description: '',
      type: '',
      rewardCount: 0,
      likeThreshold: 0,
      parameters: '',
      isActive: 0,
    );
  }

}

//"id": 2,
//       "name": "직접지급",
//       "description": "내가 직접 지급",
//       "type": "INSERT",
//       "reward_count": 0,
//       "like_threshold": null,
//       "parameters": null,
//       "is_active": 1