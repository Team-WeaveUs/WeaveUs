class Reward {
  final int id;
  final int userId;
  final int grantedBy;
  final int rewardId;
  final String rewardConditionId;
  final int weaveId;
  final int postId;
  final DateTime awardedAt;
  final int isUsed;
  final DateTime? usedAt;
  final String title;
  final String grantedByNickname;
  final String description;
  final String validity;


  //        "id": 10,
  //         "user_id": 1,
  //         "granted_by": 16,
  //         "reward_id": 2,
  //         "reward_condition_id": 1,
  //         "weave_id": 40,
  //         "post_id": 80,
  //         "awarded_at": "2025-05-28T22:20:41.000Z",
  //         "is_used": 0,
  //         "used_at": null,
  //         "title": "포카리스웨트 쿠폰",
  //         "granted_by_nickname": "JEKKY",
  //         "description": "포카리 전용 쿠폰입니다.",
  //         "validity": "12d"

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
  });

  factory Reward.fromJson(Map<String, dynamic> json) {
    return Reward(
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      rewardId: json['reward_id'] ?? 0,
      validity: json['validity']?.toString() ?? '',
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      grantedBy: json['granted_by'] ?? 0,
      rewardConditionId: json['reward_condition_id']?.toString() ?? '',
      weaveId: json['weave_id'] ?? 0,
      postId: json['post_id'] ?? 0,
      awardedAt: DateTime.parse(json['awarded_at']),
      isUsed: json['is_used'] ?? 0,
      usedAt: json['used_at'] != null ? DateTime.parse(json['used_at']) : null,
      grantedByNickname: json['granted_by_nickname']?.toString() ?? '',
    );
  }
}
