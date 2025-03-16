import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weave_us/screens/main_screen/home_screen.dart';
import 'package:weave_us/screens/main_screen/router.dart';
import 'package:weave_us/screens/signin_screen.dart';
import 'package:weave_us/screens/main_screen.dart';

import 'Auth/token_storage.dart';


// fe/dev(아무개) Branch 생성
// fe/dev 에서 작업 및 커밋
// fe/dev 를 fe/main 으로 pr
// fe/main 를 main 으로 pr
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  Future<bool> _checkLogin() async {
    String? token = await TokenStorage.getAccessToken();
    return token != null && token.isNotEmpty;
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false, // 배너 제거
      home: FutureBuilder<bool>(
        future: _checkLogin(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (snapshot.hasData && snapshot.data == true) {
                Get.offAll(SigninScreen());
              } else {
                Get.offAll(SigninScreen());
              }
            });
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
      // home: MainScreen(), //Sign in api 안돼서 main먼저 보여주기
      getPages: Routes.pages,
    );
  }
}