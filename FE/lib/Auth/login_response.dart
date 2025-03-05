class LoginResponse {
  final String message;
  final String? accessToken;
  final String? refreshToken;
  final int? userId;
  final String? nickname;

  LoginResponse({
    required this.message,
    this.accessToken,
    this.refreshToken,
    this.userId,
    this.nickname,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    // 'body' 안에 있는 데이터에 접근하여 파싱
    final body = json['body'] ?? {};

    return LoginResponse(
      message: body['message'] ?? 'Unknown message',
      accessToken: body['accessToken'],
      refreshToken: body['refreshToken'],
      userId: body['user_id'],
      nickname: body['nickname'],
    );
  }
}
