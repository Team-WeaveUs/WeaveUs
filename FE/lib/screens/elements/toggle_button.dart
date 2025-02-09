import 'package:flutter/material.dart';

class ToggleButton extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onToggle;

  const ToggleButton({required this.selectedIndex, required this.onToggle, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (selectedIndex != 0) _buildButton("구독", 0),
        if (selectedIndex != 1) _buildButton("프로필", 1),
      ],
    );
  }

  Widget _buildButton(String text, int index) {
    return GestureDetector(
      onTap: () => onToggle(index),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all()
        ),
        child: Text(
          text,
          style: TextStyle(
          ),
        ),
      ),
    );
  }
}