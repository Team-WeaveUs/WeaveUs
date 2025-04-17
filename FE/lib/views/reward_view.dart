import 'package:flutter/material.dart';

import 'components/app_nav_bar.dart';
import 'components/bottom_nav_bar.dart';

class RewardView extends StatelessWidget {
  const RewardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavBar(title: '리워드'),
      body: const Placeholder(),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}
