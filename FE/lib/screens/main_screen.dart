import 'package:flutter/material.dart';
import 'package:weave_us/screens/home_screen.dart';
import 'package:weave_us/screens/profile_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weave Us',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.red,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: MainScreen(), // 앱 실행 시 MainScreen 으로
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    // 탭 컨트롤러 (5개)
    tabController = TabController(length: 5, vsync: this);
  }

  // 하단 네비게이션으로 탭 변경 시 호출되는 메서드
  void bottomNavigationItemOnTab(int index) {
    setState(() {
      tabController.index = index;
    });
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
      onPopInvokedWithResult: (didPop,result) {
        // false를 반환하여 뒤로가기 동작을 차단합니다.
        if(didPop) {
          print('뒤로가기 실행됨, result : $result');
          return;
        }
        print('뒤로가기 시도했으나 실행되지 않음.');
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // 뒤로가기 아이콘 제거
          backgroundColor: Color(0xFFFF9800),
          title: Row(
            children: [
              const SizedBox(width: 8),
              const Text(
                'Weave Us',
                style: TextStyle(
                  fontWeight: FontWeight.bold, // 텍스트를 굵게 설정
                  fontSize: 20.0, // 텍스트 크기 조정 (옵션)
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
                print('$value 선택됨');
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: "프로필 편집", child: Text("프로필 편집")),
                const PopupMenuItem(value: "설정", child: Text("설정")),
                const PopupMenuItem(value: "계정 전환", child: Text("계정 전환")),
              ],
              icon: const Icon(Icons.more_vert), // 세로 점 3개 아이콘 (더보기)
            ),
          ],
        ),
        body: TabBarView(
          controller: tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            HomeScreen(),
            Center(child: Text('돋보기 화면')),
            Center(child: Text('+ 화면')),
            Center(child: Text('크레딧 화면')),
            ProfileScreen(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: tabController.index,
          onTap: bottomNavigationItemOnTab,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const [
          // 추후 로고 디자인 다 변경할 예정
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_circle),
                label: 'Plus'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag),
                label: 'Shopping'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'person'
            ),
          ],
        ),
      ),
    );
  }
}