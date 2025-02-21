import 'package:flutter/material.dart';

class ShareButton extends StatelessWidget {
  final VoidCallback onShare;

  const ShareButton({Key? key, required this.onShare}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: onShare,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white60,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          "공유하기",
          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}