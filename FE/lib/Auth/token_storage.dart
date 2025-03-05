import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html; // Web 용 LocalStorage 사용

class TokenStorage {
  static final _secureStorage = FlutterSecureStorage();

  // Web 용 localStorage 사용
  static Future<void> saveUserID(int userId) async {
    if (kIsWeb) {
      html.window.localStorage['user_id'] = userId.toString();
    } else {
      await _secureStorage.write(key: "user_id", value: userId.toString());
    }
  }

  static Future<void> saveTokens(String accessToken, String refreshToken) async {
    if (kIsWeb) {
      html.window.localStorage['access_token'] = accessToken;
      html.window.localStorage['refresh_token'] = refreshToken;
    } else {
      await _secureStorage.write(key: "access_token", value: accessToken);
      await _secureStorage.write(key: "refresh_token", value: refreshToken);
    }
  }

  static Future<String?> getAccessToken() async {
    if (kIsWeb) {
      return html.window.localStorage['access_token'];
    } else {
      return await _secureStorage.read(key: "access_token");
    }
  }

  static Future<String?> getRefreshToken() async {
    if (kIsWeb) {
      return html.window.localStorage['refresh_token'];
    } else {
      return await _secureStorage.read(key: "refresh_token");
    }
  }

  static Future<int?> getUserID() async {
    if (kIsWeb) {
      final userId = html.window.localStorage['user_id'];
      return userId != null ? int.tryParse(userId) : null;
    } else {
      return int.tryParse(await _secureStorage.read(key: "user_id") ?? "");
    }
  }

  static Future<void> clearTokens() async {
    if (kIsWeb) {
      html.window.localStorage.remove('access_token');
      html.window.localStorage.remove('refresh_token');
      html.window.localStorage.remove('user_id');
    } else {
      await _secureStorage.deleteAll();
    }
  }
}
