import 'package:flutter/material.dart';

class FloatingMapButton extends StatelessWidget {
  final VoidCallback onPressed;

  const FloatingMapButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, bottom: 20), // 오른쪽 20px, 아래쪽 20px 여백
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: Colors.orange,
        elevation: 2,
        child: Icon(
          Icons.location_on_outlined,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}