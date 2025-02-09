import 'package:flutter/material.dart';
import 'package:weave_us/screens/new_weave_screen.dart';
import 'package:weave_us/screens/weave_upload_screen.dart';

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
    return WillPopScope(
      onWillPop: () async {
        return false; // 뒤로가기 버튼 비활성화
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFFF9800),
          title: Row(
            children: [
              const SizedBox(width: 8),
              const Text(
                'Weave Us',
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
                print('$value 선택됨');
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
          controller: tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            const Center(child: Text('홈 화면')),
            const Center(child: Text('돋보기 화면')),

            // WeaveUploadScreen을 길게 누르면 NewWeaveScreen으로 이동 (긴 터치 이벤트 사용)
            GestureDetector(
              onLongPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewWeaveScreen()),
                );
              },
              child: WeaveUploadScreen(),
            ),

            const Center(child: Text('크레딧 화면')),
            const Center(child: Text('내 정보 화면')),
          ],
        ),

        // + 버튼: 짧게 누르면 WeaveUploadScreen, 길게 누르면 NewWeaveScreen으로 이동
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: tabController.index,
          onTap: (index) {
            if (index == 2) {
              // + 버튼을 짧게 누르면 NewWeaveScreen으로 이동
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WeaveUploadScreen()),
              );
            } else {
              bottomNavigationItemOnTab(index);
            }
          },
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            const BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),

            // GestureDetector로 감싸서 + 버튼을 길게 눌렀을 때 이벤트 추가
            BottomNavigationBarItem(
              icon: GestureDetector(
                onLongPress: () {
                  // + 버튼을 길게 누르면 WeaveUploadScreen으로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewWeaveScreen()),
                  );
                },
                child: const Icon(Icons.add_circle),
              ),
              label: 'Plus',
            ),

            const BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Shopping'),
            const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Person'),
          ],
        ),
      ),
    );
  }
}
