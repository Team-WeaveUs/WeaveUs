import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:weave_us/services/api_service.dart';
import 'package:weave_us/services/token_service.dart';
import 'bindings/auth_binding.dart';
import 'controllers/auth_controller.dart';
import 'routes/app_routes.dart';

void main() {
  Get.put(AuthController(), permanent: true);
  Get.put(TokenService(), permanent: true);
  Get.put(ApiService(), permanent: true);
  WidgetsFlutterBinding.ensureInitialized();
  _initialize();
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

Future<void> _initialize() async{
  await FlutterNaverMap().init(
      clientId: '8h5ay3tumv',
      onAuthFailed: (ex) =>
      switch (ex) {
        NQuotaExceededException(:final message) =>
            print("사용량 초과 (message: $message)"),
        NUnauthorizedClientException() ||
        NClientUnspecifiedException() ||
        NAnotherAuthFailedException() =>
            print("인증 실패: $ex"),
      });
}
