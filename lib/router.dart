import 'package:flutter/material.dart';
import 'package:instagram_clone/features/auth/screens/login_screen.dart';
import 'package:instagram_clone/features/auth/screens/signup_screen.dart';
import 'package:instagram_clone/features/profile/screens/profile_screen.dart';
import 'package:instagram_clone/responsive/app_responsive.dart';
import 'package:instagram_clone/responsive/layout/mobile_screen_layout.dart';

import 'features/comments/screens/comment_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const LoginScreen(),
      );
    case SignUpScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SignUpScreen(),
      );
    case ResponsiveLayout.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ResponsiveLayout(
          webScreenLayout: MobileScreenLayout(),
          mobileScreenLayout: MobileScreenLayout(),
        ),
      );
    case CommentScreen.routeName:
      var snap = routeSettings.arguments;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => CommentScreen(
          snap: snap,
        ),
      );
    case ProfileScreen.routeName:
      var uid = routeSettings.arguments;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ProfileScreen(uid: uid as String),
      );
    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
            body: Center(
          child: Text('Route does not exist or not created yet!'),
        )),
      );
  }
}
