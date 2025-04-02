import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weave_us/services/token_service.dart';
import 'controllers/auth_controller.dart';
import 'routes/app_routes.dart';

void main() {
  Get.put(AuthController(), permanent: true);
  Get.put(TokenService(), permanent: true);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: AppRoutes.SPLASH,
      getPages: AppRoutes.routes,
      theme: ThemeData(
        fontFamily: 'Pretendard',
      ),
    );
  }
}
