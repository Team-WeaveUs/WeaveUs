import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:weave_us/models/lambda_response_model.dart';
import 'package:weave_us/services/token_service.dart';
import '../controllers/auth_controller.dart';

class ApiService {
  final AuthController _authController = Get.find<AuthController>();
  final TokenService _tokenService = Get.find<TokenService>();
  var count = 0;

  Future<Map<String, dynamic>> getRequest(String endpoint) async {
    var token = await _tokenService.loadToken();
    if (token == null) throw Exception("No token found");
    final url = "https://v79h9dyx08.execute-api.ap-northeast-2.amazonaws.com/WeaveAPI/$endpoint";

    final lambdaResponse = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json; charset=utf-8",
        'accesstoken': token.accessToken
      },
    );

    final LambdaResponse response = LambdaResponse.fromJson(jsonDecode(utf8.decode(lambdaResponse.bodyBytes)));

    if (response.statusCode == 401) {
      bool refreshed = await _authController.handle401();
      if (refreshed) {
        return getRequest(endpoint); // 다시 요청
      }
    }
    return response.body;
  }

  Future<Map<String, dynamic>> postRequest(String endpoint, Map<String, dynamic> body) async {
    var token = await _tokenService.loadToken();
    if (token == null) throw Exception("No token found");
    final url = "https://v79h9dyx08.execute-api.ap-northeast-2.amazonaws.com/WeaveAPI/$endpoint";

    final lambdaResponse = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json; charset=utf-8",
        'accesstoken': token.accessToken
      },
      body: jsonEncode(body),
    );

    final LambdaResponse response = LambdaResponse.fromJson(jsonDecode(utf8.decode(lambdaResponse.bodyBytes)));

    if (response.statusCode == 401) {
      bool refreshed = await _authController.handle401();
      if (refreshed) {
        return postRequest(endpoint, body); // 다시 요청
      }
    }
    return response.body;
  }
}