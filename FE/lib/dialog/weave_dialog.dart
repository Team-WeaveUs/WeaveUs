import 'package:flutter/material.dart';
import 'package:weave_us/dialog/map_dialog.dart';

class WeaveDialog extends StatelessWidget {
  final Function(String) onWeaveSelected;

  const WeaveDialog({super.key, required this.onWeaveSelected});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Dialog 박스
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Dialog 테두리 둥글게
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dialog Header
                const Center(
                  child: Text(
                    "위브를 검색하세요",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // 검색 입력 필드
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "검색어를 입력하세요...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        // 검색 로직 추가
                      },
                      icon: const Icon(Icons.search, color: Colors.blue),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 근처의 join 위브 안내
                const Center(
                  child: Text(
                    "근처의 join 위브 입니다.",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // 리스트 아이템
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: 2, // 예제 아이템 개수
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          // CircleAvatar로 배경 추가
                          const CircleAvatar(
                            backgroundColor: Colors.blue, // 배경색
                            radius: 20, // 크기
                            child: Icon(
                              Icons.person, // 아이콘
                              size: 24, // 아이콘 크기
                              color: Colors.white, // 아이콘 색상
                            ),
                          ),
                          const SizedBox(width: 12),

                          // 텍스트
                          Expanded(
                            child: Text(
                              index == 0
                                  ? "2F이프카페 - 방문" // 샘플 텍스트
                                  : "2F이프카페 - 2F",
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),

                          // 추가 버튼
                          IconButton(
                            onPressed: () {
                              onWeaveSelected(
                                  index == 0 ? "2F이프카페 - 방문" : "2F이프카페 - 2F");
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.add_circle_outline),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),

        // 박스 밖 왼쪽 아래 지도 버튼
        Positioned(
          bottom: 30,
          right: 30,
          child: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return MapDialog(
                    onLocationSelected: (location) {
                      // 선택된 위치 데이터를 처리
                      //print("선택된 위치: $location");
                    },
                  );
                },
              );
            },
            backgroundColor: Colors.white, // 배경색
            child: const Icon(
              Icons.location_on_outlined, // 지도 아이콘
              color: Colors.black, // 아이콘 색상
              size: 28, // 아이콘 크기
            ),
          ),
        ),
      ],
    );
  }
}

// 지도 화면
class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("지도 화면"),
      ),
      body: const Center(
        child: Text(
          "여기에 지도를 표시합니다.",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
