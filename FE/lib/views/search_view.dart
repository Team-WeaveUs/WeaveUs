import 'package:flutter/material.dart';

import 'components/app_nav_bar.dart';
import 'components/bottom_nav_bar.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavBar(title: '검색'),
      body: const Placeholder(),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}
