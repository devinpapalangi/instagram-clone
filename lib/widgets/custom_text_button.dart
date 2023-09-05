import 'package:flutter/material.dart';

import '../utils/app_layout.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const CustomTextButton(
      {super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        padding: EdgeInsets.symmetric(
          vertical: AppLayout.getHeight(8),
        ),
      ),
    );
  }
}
