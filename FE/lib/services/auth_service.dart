import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:weave_us/models/lambda_response_model.dart';
import '../models/token_model.dart';
import 'token_service.dart';

class AuthService {
  String? accessToken;
  String? refreshToken;
  late Token token;
  final TokenService tokenController = TokenService();

  Future<bool> login(String email, String password) async {
    final lambdaResponse = await http.post(
      Uri.parse(
          'https://v79h9dyx08.execute-api.ap-northeast-2.amazonaws.com/WeaveAPI/Login'),
      body: jsonEncode({'account_id': email, 'password': password}),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );
    var responseData = jsonDecode(lambdaResponse.body);
    final LambdaResponse response = LambdaResponse.fromJson(responseData);
    try {
      if (response.statusCode == 200) {
        final data = response.body;
        if (data.containsKey('accessToken') &&
            data.containsKey('refreshToken') &&
            data.containsKey('user_id')) {
          token = Token(
              accessToken: data['accessToken'],
              refreshToken: data['refreshToken'],
              userId: data['user_id'].toString());
          await tokenController.saveToken(
              token.accessToken, token.refreshToken, token.userId);
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

  void logout() {
    tokenController.clearToken();
  }

  Future<bool> commonRegistration(String id, String pw, String name, String nickname, String number, String gender) async {
    final lambdaResponse = await http.post(
      Uri.parse(
          'https://v79h9dyx08.execute-api.ap-northeast-2.amazonaws.com/WeaveAPI/SignUp'),
      body: jsonEncode({
        "id": id,
        "pw": pw,
        "name": name,
        "nickname": nickname,
        "number": number,
        "gender": gender,
        "is_owner": "0"
      }),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );
    var responseData = jsonDecode(lambdaResponse.body);
    final LambdaResponse response = LambdaResponse.fromJson(responseData);
    try{
      if(response.statusCode == 200){
        return true;
      }
      else{
        return false;
      }
    } catch (e){
      print("JSON Parsing Error: $e");
      return false;
    }
  }

  Future<bool> ownerRegistration(String id, String pw, String name, String nickname, String number, String gender) async {
    final lambdaResponse = await http.post(
      Uri.parse(
          'https://v79h9dyx08.execute-api.ap-northeast-2.amazonaws.com/WeaveAPI/SignUp'),
      body: jsonEncode({
        "id": id,
        "pw": pw,
        "name": name,
        "nickname": nickname,
        "number": number,
        "gender": gender,
        "is_owner": "1"
      }),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );
    var responseData = jsonDecode(lambdaResponse.body);
    final LambdaResponse response = LambdaResponse.fromJson(responseData);
    try{
      if(response.statusCode == 200){
        return true;
      }
      else{
        return false;
      }
    } catch (e){
      print("JSON Parsing Error: $e");
      return false;
    }
  }
}
