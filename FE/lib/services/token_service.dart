import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:weave_us/models/lambda_response_model.dart';
import '../models/token_model.dart';


class TokenService extends GetxService {
  final _storage = const FlutterSecureStorage();


  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  // 토큰 저장
  Future<void> saveToken(String accessToken, String refreshToken) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  // 토큰 불러오기
  Future<Token?> loadToken() async {
    String? accessToken = await _storage.read(key: _accessTokenKey);
    String? refreshToken = await _storage.read(key: _refreshTokenKey);

    if (accessToken != null && refreshToken != null) {
      return Token(accessToken: accessToken, refreshToken: refreshToken);
    }
    return null;
  }

  // 토큰 삭제 (로그아웃 시 사용)
  Future<void> clearToken() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }

  // ✅ 토큰 유효성 검증 (만료 확인)
  Future<bool> isTokenValid() async {
    Token? token = await loadToken();
    if (token == null) return false;

    // access token이 만료되었는지 확인
    return !JwtDecoder.isExpired(token.accessToken);
  }

  // ✅ 401 발생 시 토큰 갱신
  Future<bool> refreshToken() async {
    Token? token = await loadToken();
    if (token == null) return false;

    final lambdaResponse = await http.post(
      Uri.parse('https://v79h9dyx08.execute-api.ap-northeast-2.amazonaws.com/WeaveAPI/Token_Refresh'),
      body: jsonEncode({'refreshtoken': token.refreshToken}),
      headers: {'Content-Type': 'application/json'},
    );
    final LambdaResponse response = LambdaResponse.fromJson(jsonDecode(lambdaResponse.body));

    if (response.statusCode == 200) {
      final data = response.body;
      await saveToken(data['access_token'], data['refresh_token']);
      return true; // 갱신 성공
    }

    // 403 또는 500일 경우 토큰 만료 → 로그아웃 필요
    await clearToken();
    return false;
  }
}
