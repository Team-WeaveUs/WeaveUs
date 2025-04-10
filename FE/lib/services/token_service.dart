import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:weave_us/models/lambda_response_model.dart';
import '../models/token_model.dart';


class TokenService extends GetxService {
  final _storage = const FlutterSecureStorage();

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userId = 'user_id';

  // 토큰 저장
  Future<void> saveToken(String accessToken, String refreshToken, String userId) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
    await _storage.write(key: _userId, value: userId);
  }

  // 토큰 불러오기
  Future<Token?> loadToken() async {
    String? accessToken = await _storage.read(key: _accessTokenKey);
    String? refreshToken = await _storage.read(key: _refreshTokenKey);
    String? userId = await _storage.read(key: _userId);

    if (accessToken != null && refreshToken != null && userId != null) {
      return Token(accessToken: accessToken, refreshToken: refreshToken, userId: userId);
    }
    return null;
  }

  Future<String> loadUserId() async {
    String? userId = await _storage.read(key: _userId);
    return userId ?? '';
  }

  // 토큰 삭제 (로그아웃 시 사용)
  Future<void> clearToken() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _userId);
  }

  // ✅ 401 발생 시 토큰 갱신
  Future<bool> refreshToken() async {
    Token? token = await loadToken();
    if (token == null) return false;
    final lambdaResponse = await http.post(
      Uri.parse('https://v79h9dyx08.execute-api.ap-northeast-2.amazonaws.com/WeaveAPI/Token_Refresh'),
      body: jsonEncode({'user_id': token.userId}),
      headers: {
        'Content-Type': 'application/json',
        'refreshtoken': token.refreshToken
      },
    );
    final LambdaResponse response = LambdaResponse.fromJson(jsonDecode(lambdaResponse.body));
    if (response.statusCode == 200) {
      final data = response.body;
      await saveToken(data['accessToken'], data['refreshToken'], data['user_id'].toString());
      return true; // 갱신 성공
    } else {
      await clearToken();
      return false;
    }

  }
}
