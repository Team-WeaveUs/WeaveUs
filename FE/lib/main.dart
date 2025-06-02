import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:weave_us/services/api_service.dart';
import 'package:weave_us/services/token_service.dart';
import 'bindings/auth_binding.dart';
import 'controllers/auth_controller.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initializeNaverMap();

  Get.put(AuthController(), permanent: true);
  Get.put(TokenService(), permanent: true);
  Get.put(ApiService(), permanent: true);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.SPLASH,
      getPages: AppRoutes.routes,
      initialBinding: AuthBinding(),
      theme: ThemeData(
        fontFamily: 'Pretendard',
      ),
    );
  }
}

Future<void> _initializeNaverMap() async {
  try {
    await FlutterNaverMap().init(
      clientId: '8h5ay3tumv',
      onAuthFailed: (ex) {
        print("네이버 지도 인증 실패: $ex");
        if (ex is NQuotaExceededException) {
          print("사용량 초과 (message: ${ex.message})");
        }
      },
    );
    print("네이버 지도 초기화 성공");
  } catch (e) {
    print("네이버 지도 초기화 실패: $e");
  }
}
