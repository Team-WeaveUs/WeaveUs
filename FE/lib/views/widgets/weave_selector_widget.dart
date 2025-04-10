import 'package:flutter/material.dart';

class WeaveSelector extends StatelessWidget {
  final String? selectedWeave;
  final VoidCallback onWeaveSelected;

  const WeaveSelector({
    super.key,
    required this.selectedWeave,
    required this.onWeaveSelected,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEmpty = selectedWeave == null || selectedWeave!.trim().isEmpty;

    return Padding(
      padding: const EdgeInsets.only(top: 10,bottom: 10,left: 20, right: 20),
      child: GestureDetector(
        onTap: onWeaveSelected,
        child: Row(
          children: [
            Expanded(
              child: Text(
                isEmpty ? '위브를 선택해주세요.' : selectedWeave!,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Pretendard',
                  color: isEmpty ? Colors.grey : Colors.black,
                ),
              ),
            ),
            const Icon(Icons.add_circle_outline, color: Colors.black),
          ],
        ),
      ),
    );
  }
}