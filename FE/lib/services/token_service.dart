import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:weave_us/models/lambda_response_model.dart';
import '../models/token_model.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';

class TokenService extends GetxService {
  final _storage = const FlutterSecureStorage();


  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userId = 'user_id';
  static const String _isOwner = 'is_owner';
  // 토큰 저장
  Future<void> saveToken(String accessToken, String refreshToken, String userId, String isOwner) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(_accessTokenKey, accessToken);
      prefs.setString(_refreshTokenKey, refreshToken);
      prefs.setString(_userId, userId);
      prefs.setString(_isOwner, isOwner);

    } else {
      await _storage.write(key: _accessTokenKey, value: accessToken);
      await _storage.write(key: _refreshTokenKey, value: refreshToken);
      await _storage.write(key: _userId, value: userId);
      await _storage.write(key: _isOwner, value: isOwner);
    }
  }

  // 토큰 불러오기
  Future<Token?> loadToken() async {
    String? accessToken;
    String? refreshToken;
    String? userId;
    String? isOwner;

    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      accessToken = prefs.getString(_accessTokenKey);
      refreshToken = prefs.getString(_refreshTokenKey);
      userId = prefs.getString(_userId);
      isOwner = prefs.getString(_isOwner);
    }
    else {
      accessToken = await _storage.read(key: _accessTokenKey);
      refreshToken = await _storage.read(key: _refreshTokenKey);
      userId = await _storage.read(key: _userId);
      isOwner = await _storage.read(key: _isOwner);
    }
    if (accessToken != null && refreshToken != null && userId != null &&
        isOwner != null) {
      return Token(accessToken: accessToken, refreshToken: refreshToken, userId: userId,
        isOwner: int.tryParse(isOwner) ?? 0,);
    }
    return null;
  }

  Future<String> loadUserId() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userId) ?? '';
    }
    else {
      String? userId = await _storage.read(key: _userId);
      return userId ?? '';
    }
  }

  // 토큰 삭제 (로그아웃 시 사용)
  Future<void> clearToken() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      prefs.remove(_accessTokenKey);
      prefs.remove(_refreshTokenKey);
      prefs.remove(_userId);
      prefs.remove(_isOwner);
    }
    else {
      await _storage.delete(key: _accessTokenKey);
      await _storage.delete(key: _refreshTokenKey);
      await _storage.delete(key: _userId);
      await _storage.delete(key: _isOwner);
    }
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
      await saveToken(data['accessToken'], data['refreshToken'], data['user_id'].toString(), data['is_owner'].toString());
      return true; // 갱신 성공
    } else {
      await clearToken();
      return false;
    }
  }
}
