import 'package:flutter/material.dart';
import 'package:weave_us/dialog/weave_dialog.dart';

class WeaveSelector extends StatelessWidget {
  final String? selectedWeave;
  final Function() onWeaveSelected;

  const WeaveSelector({
    super.key,
    required this.selectedWeave,
    required this.onWeaveSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20,right: 20),
      child: SizedBox(
        width: double.infinity,
        child: TextField(
          readOnly: true,
          onTap: onWeaveSelected,
          style: TextStyle(
            fontSize: 20,
            color: selectedWeave != null ? Colors.black : Colors.grey,
            letterSpacing: 1.0,
          ),
          decoration: InputDecoration(
            hintText: selectedWeave ?? '위브를 선택해주세요.',
            hintStyle: TextStyle(
              fontSize: 20,
              color: selectedWeave != null ? Colors.black : Colors.grey,
            ),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.add_circle_outline, color: Colors.black,),
              onPressed: onWeaveSelected,
            ),
          ),
        ),
      ),
    );
  }
}