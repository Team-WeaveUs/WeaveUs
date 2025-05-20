class CreateRewardRequest {
  final String userId;
  final String title;
  final String description;
  final String validity;

  CreateRewardRequest({
    required this.userId,
    required this.title,
    required this.description,
    required this.validity,
  });

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "title": title,
    "description": description,
    "validity": validity,
  };
}