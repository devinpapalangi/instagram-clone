import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/app_styles.dart';

class LinearLoader extends StatelessWidget {
  const LinearLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      color: Styles.primaryColor,
    );
  }
}
