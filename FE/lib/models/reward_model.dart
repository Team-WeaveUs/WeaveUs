class Reward {
  final int id;
  final int userId;
  final int grantedBy;
  final int rewardId;
  final String rewardConditionId;
  late final int weaveId;
  final int postId;
  final DateTime awardedAt;
  final int isUsed;
  final DateTime? usedAt;
  final String title;
  final String grantedByNickname;
  final String description;
  late final String validity;
  final String weaveTitle;

  Reward({
    required this.title,
    required this.description,
    required this.rewardId,
    required this.validity,
    required this.id,
    required this.userId,
    required this.grantedBy,
    required this.rewardConditionId,
    required this.weaveId,
    required this.postId,
    required this.awardedAt,
    required this.isUsed,
    required this.usedAt,
    required this.grantedByNickname,
    required this.weaveTitle,
  });

  factory Reward.fromJson(Map<String, dynamic> json) {
    // 기본값 설정
    final now = DateTime.now();

    return Reward(
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      rewardId: json['reward_id'] ?? 0,
      validity: json['validity']?.toString() ?? '',
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      grantedBy: json['granted_by'] ?? 0,
      rewardConditionId: json['reward_condition_id']?.toString() ?? '0',
      weaveId: json['weave_id'] ?? 0,
      postId: json['post_id'] ?? 0,
      awardedAt:
          json['awarded_at'] != null ? DateTime.parse(json['awarded_at']) : now,
      isUsed: json['is_used'] ?? 0,
      usedAt: json['used_at'] != null ? DateTime.parse(json['used_at']) : null,
      grantedByNickname: json['granted_by_nickname']?.toString() ?? '',
      weaveTitle: json['weave_title']?.toString() ?? '',
    );
  }

  factory Reward.empty() {
    return Reward(
      title: '',
      description: '',
      rewardId: 0,
      validity: '',
      id: 0,
      userId: 0,
      grantedBy: 0,
      rewardConditionId: '',
      weaveId: 0,
      postId: 0,
      awardedAt: DateTime.now(),
      isUsed: 0,
      usedAt: null,
      grantedByNickname: '',
      weaveTitle: '',
    );
  }
}
