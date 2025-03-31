// import 'dart:io' show Platform;
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:cookie_jar/cookie_jar.dart';
//
// class TokenService {
//   static const _storage = FlutterSecureStorage();
//   static final cookieJar = PersistCookieJar();
//
//   /// ✅ 토큰 저장 (환경별 처리)
//   Future<void> saveToken(String accessToken, String refreshToken) async {
//     if (Platform.isAndroid || Platform.isIOS) {
//       // 앱 환경: Secure Storage에 저장
//       await _storage.write(key: 'access_token', value: accessToken);
//       await _storage.write(key: 'refresh_token', value: refreshToken);
//     } else {
//       // 웹 환경: HttpOnly 쿠키에 저장
//       final dio = Dio()..interceptors.add(CookieManager(cookieJar));
//       final uri = Uri.parse('https://your-api.com'); // 실제 API 도메인
//       await cookieJar.saveFromResponse(uri, [
//         Cookie('access_token', accessToken)..httpOnly = true,
//         Cookie('refresh_token', refreshToken)..httpOnly = true,
//       ]);
//     }
//   }
//
//   /// ✅ 토큰 가져오기
//   Future<Token?> getToken() async {
//     if (Platform.isWeb) {
//       final uri = Uri.parse('https://your-api.com');
//       final cookies = await cookieJar.loadForRequest(uri);
//       final accessToken = cookies.firstWhere((c) => c.name == 'access_token', orElse: () => Cookie('', '')).value;
//       final refreshToken = cookies.firstWhere((c) => c.name == 'refresh_token', orElse: () => Cookie('', '')).value;
//
//       return (accessToken.isNotEmpty && refreshToken.isNotEmpty)
//           ? Token(accessToken: accessToken, refreshToken: refreshToken)
//           : null;
//     } else {
//       final accessToken = await _storage.read(key: 'access_token');
//       final refreshToken = await _storage.read(key: 'refresh_token');
//
//       return (accessToken != null && refreshToken != null)
//           ? Token(accessToken: accessToken, refreshToken: refreshToken)
//           : null;
//     }
//   }
//
//   /// ✅ 토큰 삭제
//   Future<void> clearToken() async {
//     if (Platform.isWeb) {
//       final uri = Uri.parse('https://your-api.com');
//       await cookieJar.delete(uri);
//     } else {
//       await _storage.deleteAll();
//     }
//   }
// }
