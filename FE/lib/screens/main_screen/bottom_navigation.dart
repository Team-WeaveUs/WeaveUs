import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final VoidCallback onMiddleLongPress;

  const BottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onMiddleLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // 기본 네비게이션 바
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.orange, blurRadius: 2, spreadRadius: 0),
            ],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            currentIndex: currentIndex,
            onTap: onTap,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedItemColor: Colors.orange,
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
              BottomNavigationBarItem(
                icon: SizedBox.shrink(), // 가운데 버튼 대신 빈 공간
                label: '',
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_bag), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
            ],
          ),
        ),
        // 가운데 버튼 (위로 띄우기)
        Positioned(
          bottom: 20, // 바텀 네비게이션보다 위로 띄우기
          left: MediaQuery.of(context).size.width / 2 - 30,
          child: GestureDetector(
            onTap: () => onTap(2), // 가운데 버튼 클릭 시 두 번째 탭으로 이동
            onLongPress: onMiddleLongPress, // 롱클릭 시 특정 화면 이동
            child: Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 30),
            ),
          ),
        ),
      ],
    );
  }
}
