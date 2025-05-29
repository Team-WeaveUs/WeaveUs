class CreateRewardRequest {
  final String userId;
  final String title;
  final String description;
  final String validity;
  final String password;

  CreateRewardRequest({
    required this.userId,
    required this.title,
    required this.description,
    required this.validity,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "title": title,
    "description": description,
    "validity": validity,
    "password": password,
  };
}