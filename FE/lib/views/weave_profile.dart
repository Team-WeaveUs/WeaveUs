import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../controllers/weave_controller.dart';
import 'components/app_nav_bar.dart';

class WeaveProfileView extends StatelessWidget {
  const WeaveProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final weaveId = 17;
    final title = "Local weave";
    final location = "";
    final description = "로컬위브 입니다.";
    final likeCount = 123;
    final contributorCount = 5;
    final participantImages = [
      'https://via.placeholder.com/150',
      'https://via.placeholder.com/150',
      'https://via.placeholder.com/150',
      'https://via.placeholder.com/150',
      'https://via.placeholder.com/150',
      'https://via.placeholder.com/150'
    ];
    final controller = Get.find<WeaveController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppNavBar(title: 'Weave 정보'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'Pretendard')),
            const SizedBox(height: 8),
            Text(description,
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontFamily: 'Pretendard')),
            const SizedBox(height: 12),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 왼쪽: 좋아요 + 참여 인원 (세로 정렬)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.favorite_border, color: Colors.orange),
                          const SizedBox(width: 4),
                          Text(
                            '$likeCount',
                            style: const TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.person_outline, color: Colors.black),
                          const SizedBox(width: 4),
                          Text(
                            '$contributorCount',
                            style: const TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // 오른쪽: + 버튼
                  Container(
                    width: 36,
                    height: 36,
                    child: IconButton(
                      onPressed: () {
                        controller.goToNewWeave(weaveId, title);
                      },
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            const Text(
              "쌓일 위브들",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: participantImages.length,
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(participantImages[index], fit: BoxFit.cover),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}