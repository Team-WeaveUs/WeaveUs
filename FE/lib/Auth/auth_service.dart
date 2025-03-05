import 'dart:convert';
import 'package:http/http.dart' as http;

import 'login_response.dart';

class AuthService {
  static const String apiUrl =
      "https://v79h9dyx08.execute-api.ap-northeast-2.amazonaws.com/WeaveAPI/Login";

  Future<LoginResponse> loginUser(String accountId, String password) async {
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json"
    };
    final Map<String, dynamic> body = {
      "account_id": accountId.trim(),
      "password": password.trim(),
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(body),
      );

      final responseBody = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(responseBody);
        return LoginResponse.fromJson(jsonData); // 'body' 처리
      } else {
        final errorData = jsonDecode(responseBody);
        throw Exception("로그인 실패: ${errorData['message']}");
      }
    } catch (e) {
      throw Exception("서버 요청 실패: $e");
    }
  }
}
