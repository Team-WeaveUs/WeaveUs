import 'dart:convert';

class LambdaResponse {
  final int statusCode;
  final Map<String, dynamic> body;

  LambdaResponse({required this.statusCode, required this.body});

  // JSON 파싱을 위한 factory 생성자
  factory LambdaResponse.fromJson(Map<String, dynamic> json) {
    // body가 문자열일 경우, jsonDecode로 Map으로 변환
    var body = json['body'] is String
        ? jsonDecode(json['body']) // 문자열인 경우 JSON 디코드
        : json['body']; // 이미 Map인 경우 그대로 사용

    return LambdaResponse(
      statusCode: json['statusCode'] ?? 200, // 기본값 200
      body: body is Map<String, dynamic> ? body : {},
    );
  }

  // JSON 직렬화
  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'body': body,
    };
  }
}