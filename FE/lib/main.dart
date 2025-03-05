import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weave_us/screens/signin_screen.dart';
import 'package:weave_us/screens/main_screen.dart';
import 'package:weave_us/screens/owner_screen.dart';
import "config.dart";
// fe/dev(아무개) Branch 생성
// fe/dev 에서 작업 및 커밋
// fe/dev 를 fe/main 으로 pr
// fe/main 를 main 으로 pr

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {await dotenv.load();}
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, // 배너 제거
      home: SigninScreen(), // SigninScreen 먼저 보여주기,
      //home: MainScreen(), //Sign in api 안돼서 main먼저 보여주기
    );
  }
}
