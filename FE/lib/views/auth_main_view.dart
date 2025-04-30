import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

import '../routes/app_routes.dart';

class AuthMainView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text("Welcome to Weave Us"),
        ),
        body: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              Icon(HugeIcons.strokeRoundedGift, size: 100,color: Colors.orange,),
              TextButton(onPressed: onPressedWeave, child: Text("위브로 계속하기")),
              TextButton(onPressed: onPressedOwner, child: Text("오너로 계속하기")),
            ],
          ),
        ));
  }

  onPressedWeave() {
    Get.offAllNamed(AppRoutes.LOGIN);
  }

  onPressedOwner() {
    Get.offAllNamed(AppRoutes.OWNERS);
  }
}
