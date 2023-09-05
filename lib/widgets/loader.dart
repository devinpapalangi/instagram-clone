import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/app_styles.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      color: Styles.primaryColor,
    );
  }
}
