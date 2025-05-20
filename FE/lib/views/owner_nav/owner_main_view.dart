import 'package:flutter/material.dart';

import '../components/app_nav_bar.dart';
import '../components/owner_nav_bar.dart';

class OwnerMainView extends StatelessWidget {
  const OwnerMainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavBar(title: '오너 메인 뷰'),
      body: const Placeholder(),
      bottomNavigationBar: OwnerNavBar(),
    );
  }
}
