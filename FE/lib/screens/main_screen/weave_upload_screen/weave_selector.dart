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
    return SizedBox(
      width: double.infinity,
      child: TextField(
        readOnly: true,
        onTap: onWeaveSelected,
        decoration: InputDecoration(
          hintText: selectedWeave ?? '위브 선택',
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: const Icon(Icons.add, color: Colors.deepOrange),
            onPressed: onWeaveSelected,
          ),
        ),
      ),
    );
  }
}