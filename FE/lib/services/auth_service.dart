import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:weave_us/models/lambda_response_model.dart';

class AuthService {
  String? accessToken;
  String? refreshToken;

  Future<bool> login(String email, String password) async {
    final lambdaResponse = await http.post(
      Uri.parse('https://v79h9dyx08.execute-api.ap-northeast-2.amazonaws.com/WeaveAPI/Login'),
      body: jsonEncode({'account_id': email, 'password': password}),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );
    var responseData = jsonDecode(lambdaResponse.body);
    final LambdaResponse response = LambdaResponse.fromJson(responseData);

    try {
      if (response.statusCode== 200) {
        final data = response.body;
        if (data.containsKey('accessToken') && data.containsKey('refreshToken')) {
          accessToken = data['accessToken'];
          refreshToken = data['refreshToken'];
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      print("JSON Parsing Error: $e");
      return false;
    }
  }

  Future<void> refreshTokenHandler() async {
    final response = await http.post(
      Uri.parse('https://api.example.com/token/refresh'),
      body: jsonEncode({'refresh_token': refreshToken}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      accessToken = data['access_token'];
      refreshToken = data['refresh_token'];
    } else {
      Get.offNamed('/login');
    }
  }

  Future<http.Response> makeAuthenticatedRequest(String url) async {
    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 401) {
      await refreshTokenHandler();
      return makeAuthenticatedRequest(url);
    }

    return response;
  }

  void logout() {
    accessToken = null;
    refreshToken = null;
  }
}
