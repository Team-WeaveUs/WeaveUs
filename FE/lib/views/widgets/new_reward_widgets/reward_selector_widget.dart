import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class RewardSelector extends StatelessWidget {
  final String? selectedReward;
  final VoidCallback onRewardSelected;

  const RewardSelector({
    super.key,
    required this.selectedReward,
    required this.onRewardSelected,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEmpty = selectedReward == null || selectedReward!.trim().isEmpty;

    return Padding(
      padding: const EdgeInsets.only(top: 10,bottom: 10,left: 20, right: 20),
      child: GestureDetector(
        onTap: onRewardSelected,
        child: Row(
          children: [
            Expanded(
              child: Text(
                isEmpty ? '리워드를 선택해주세요.' : selectedReward!,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Pretendard',
                  color: isEmpty ? Colors.grey : Colors.black,
                ),
              ),
            ),
            const Icon(HugeIcons.strokeRoundedGift, color: Colors.black),
          ],
        ),
      ),
    );
  }
}