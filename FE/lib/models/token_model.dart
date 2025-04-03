class Token {
  final String accessToken;
  final String refreshToken;
  final String userId;

  Token({required this.accessToken, required this.refreshToken, required this.userId});

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accesstoken': accessToken,
      'refreshtoken': refreshToken,
      'userid': userId,
    };
  }
}
