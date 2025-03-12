import 'dart:convert';
import 'package:http/http.dart' as http;

import 'sign_up_response.dart';

class AuthSignup {
  static const String apiUrl =
      "https://v79h9dyx08.execute-api.ap-northeast-2.amazonaws.com/WeaveAPI/SignUp";

  Future<SignUpResponse> signUpUser(String id, String password, String name, String nickname, String number, String gender, String isOwner) async {
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json"
    };

    final Map<String, dynamic> body = {
      "id": id.trim(),
      "pw": password.trim(),
      "name": name.trim(),
      "nickname": nickname.trim(),
      "number": number.trim(),
      "gender": gender.trim(),
      "is_owner": isOwner.trim(),
    };

    print("회원가입 요청 보냄...");
    print("요청 데이터: $body");

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(body),
      );

      final responseBody = utf8.decode(response.bodyBytes);

      print("서버 응답: $responseBody");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(responseBody);
        print("회원가입 성공: ${jsonData['body']['message']}");
        return SignUpResponse.fromJson(jsonData);
      } else {
        final errorData = jsonDecode(responseBody);
        print("회원가입 실패: ${errorData['body']['message']}");
        throw Exception("로그인 실패: ${errorData['message']}");
      }
    } catch (e) {
      print("서버 요청 중 오류 발생: $e");
      throw Exception("서버 요청 실패: $e");
    }
  }
}
