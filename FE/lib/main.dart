import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weave_us/services/api_service.dart';
import 'package:weave_us/services/token_service.dart';
import 'bindings/auth_binding.dart';
import 'controllers/auth_controller.dart';
import 'routes/app_routes.dart';

void main() {
  Get.put(AuthController(), permanent: true);
  Get.put(TokenService(), permanent: true);
  Get.lazyPut<ApiService>(() => ApiService()); // 필요할 때 생성
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
