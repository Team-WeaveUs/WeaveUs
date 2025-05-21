class Token {
  final String accessToken;
  final String refreshToken;
  final String userId;
  final int isOwner;

  Token({required this.accessToken, required this.refreshToken, required this.userId, required this.isOwner});

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      userId: json['user_id'],
      isOwner: json['isOwner']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accesstoken': accessToken,
      'refreshtoken': refreshToken,
      'userid': userId,
      'isOwner' : isOwner
    };
  }
}
