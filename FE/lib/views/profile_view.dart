import 'package:flutter/material.dart';

import 'components/app_nav_bar.dart';
import 'components/bottom_nav_bar.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavBar(title: '내 프로필'),
      body: const Placeholder(),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}
