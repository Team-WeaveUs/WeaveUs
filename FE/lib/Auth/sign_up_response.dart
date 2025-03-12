class SignUpResponse {
  final String message;
  final int? userId;

  SignUpResponse({
    required this.message,
    this.userId,
  });

  factory SignUpResponse.fromJson(Map<String, dynamic> json) {
    final body = json['body'] ?? {};

    return SignUpResponse(
      message: body['message'] ?? 'Unknown message',
      userId: body['user_id'],
    );
  }
}
