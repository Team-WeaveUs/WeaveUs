import 'package:flutter/material.dart';

import 'components/app_nav_bar.dart';
import 'components/bottom_nav_bar.dart';

class RewardView extends StatelessWidget {
  const RewardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavBar(title: '리워드'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 검색창
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: '',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const Icon(Icons.cancel, color: Colors.grey),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 리워드 리스트
            _buildRewardItem(
              title: '논산 유기농 딸기 1박스',
              subtitle: '딸기코아저씨농장',
            ),
            const SizedBox(height: 12),
            _buildRewardItem(
              title: '홀케이크',
              subtitle: '2F 이프커피',
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }

  Widget _buildRewardItem({required String title, required String subtitle}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.card_giftcard_outlined, color: Colors.black54),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(subtitle, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: Colors.orange),
              ),
            ),
            child: const Text("사용"),
          ),
        ],
      ),
    );
  }
}