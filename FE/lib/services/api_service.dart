import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://v79h9dyx08.execute-api.ap-northeast-2.amazonaws.com';
  static const String apiPath = '/WeaveAPI';

  static String getApiUrl(String path) {
    return '$baseUrl$apiPath$path';
  }

  static Future<http.Response> get(String path) async {
    final url = getApiUrl(path);
    final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          //'accesstoken': accessToken, accesstoken 받아오는 tokenservice가 필요함.
        }
    );
    return response;
  }
}
