import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weave_us/services/token_service.dart';
import 'controllers/auth_controller.dart';
import 'routes/app_routes.dart';
import 'bindings/auth_binding.dart';

void main() {
  Get.put(AuthController(), permanent: true);
  Get.put(TokenService(), permanent: true);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: AppRoutes.LOGIN,
      getPages: AppRoutes.routes,
      initialBinding: AuthBinding(),
      theme: ThemeData(
        fontFamily: 'Pretendard',
      ),
    );
  }
}
