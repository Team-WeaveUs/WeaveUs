import 'dart:convert';
import 'package:http/http.dart' as http;
import 'token_storage.dart';

class ApiService {
  static Future<dynamic> sendRequest(String endpoint, Map<String, dynamic> requestBody) async {
    String? accessToken = await TokenStorage.getAccessToken();

    try {
      final response = await http.post(
        Uri.parse(
            "https://v79h9dyx08.execute-api.ap-northeast-2.amazonaws.com/$endpoint"),
        body: jsonEncode(requestBody),
        headers: {
          'Content-Type': 'application/json',
          'accesstoken': '$accessToken',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        // 액세스 토큰 만료 -> 토큰 재발급 시도
        bool refreshed = await _refreshToken();
        if (refreshed) {
          return sendRequest(endpoint, requestBody);
        } else {
          return null;
        }
      } else if (response.statusCode == 403 || response.statusCode == 500) {
        return null;
      }
    } catch(e){
      print('Error fetching profile: $e');
      return null;
    }
  }

  static Future<bool> _refreshToken() async {
    String? refreshToken = await TokenStorage.getRefreshToken();
    int? userID = await TokenStorage.getUserID();
    if (refreshToken == null) return false;

    final response = await http.post(
      Uri.parse("https://v79h9dyx08.execute-api.ap-northeast-2.amazonaws.com/WeaveApi/Token_Refresh"),
      body: jsonEncode({'user_id': userID}),
      headers: {'Content-Type': 'application/json', 'refreshToken': refreshToken},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await TokenStorage.saveTokens(data['accessToken'], data['refreshToken']);
      return true;
    }
    return false;
  }
  static Future<dynamic> sendGetRequest(String endpoint) async {
    String? accessToken = await TokenStorage.getAccessToken();

    try {
      final response = await http.get(
        Uri.parse(
            "https://v79h9dyx08.execute-api.ap-northeast-2.amazonaws.com/$endpoint"),
        headers: {
          'Content-Type': 'application/json',
          'accesstoken': '$accessToken',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        // 액세스 토큰 만료 -> 토큰 재발급 시도
        bool refreshed = await _refreshToken();
        if (refreshed) {
          return sendGetRequest(endpoint);
        } else {
          return null;
        }
      } else if (response.statusCode == 403 || response.statusCode == 500) {
        return null;
      }
    } catch(e){
      print('Error fetching profile: $e');
      return null;
    }
  }
}
