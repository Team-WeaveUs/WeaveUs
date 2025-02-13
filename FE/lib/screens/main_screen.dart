import 'package:flutter/material.dart';
import 'package:weave_us/screens/main_screen/bottom_navigation.dart';
import 'package:weave_us/screens/main_screen/new_weave_screen.dart';
import 'package:weave_us/screens/main_screen/weave_upload_screen.dart';
import 'package:weave_us/screens/main_screen/home_screen.dart';
import 'package:weave_us/screens/main_screen/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  void onItemTapped(int index) {
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const WeaveUploadScreen()),
      );
    } else {
      setState(() {
        _tabController.index = index;
      });
    }
  }

  void _onMiddleLongPress() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NewWeaveScreen()),
    );
  }

  // 상단에 있는 Alarm
  void _openAlarm() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alarm'),
        content: const Text('알람 페이지로 들어갈 예정'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        // false를 반환하여 뒤로가기 동작을 차단합니다.
        if (didPop) {
          //print('뒤로가기 실행됨, result : $result');
          return;
        }
        //print('뒤로가기 시도했으나 실행되지 않음.');
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Row(
            children: [
              SizedBox(width: 8),
              Text(
                '',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: _openAlarm,
              tooltip: 'Alarm',
            ),
            PopupMenuButton<String>(
              position: PopupMenuPosition.under,
              onSelected: (value) {
                //print('$value 선택됨');
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: "프로필 편집", child: Text("프로필 편집")),
                const PopupMenuItem(value: "설정", child: Text("설정")),
                const PopupMenuItem(value: "계정 전환", child: Text("계정 전환")),
              ],
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),
        body: TabBarView(
          controller: _tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            HomeScreen(), //home_screen.dart
            Center(child: Text('돋보기 화면')),
            WeaveUploadScreen(),
            Center(child: Text('리워드 화면')),
            ProfileScreen(), //profile_screen.dart
          ],
        ),
        bottomNavigationBar: BottomNavigation(
          currentIndex: _tabController.index,
          onTap: onItemTapped,
          onMiddleLongPress: _onMiddleLongPress,
        ),
      ),
    );
  }
}
