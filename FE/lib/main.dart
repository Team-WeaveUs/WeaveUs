import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}
// fe/dev 에서 작업 및 커밋
// fe/dev 를 fe/main 으로 pr
// fe/main 를 main 으로 pr
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo'
    );
  }
}
