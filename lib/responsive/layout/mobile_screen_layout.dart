import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:instagram_clone/features/feeds/screens/feed_screen.dart';
import 'package:instagram_clone/features/post/screens/add_post_screen.dart';
import 'package:instagram_clone/features/profile/screens/profile_screen.dart';
import 'package:instagram_clone/features/search/screens/search_screen.dart';
import 'package:instagram_clone/widgets/bottom_navigation_bar.dart';

import '../../utils/app_styles.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  void navigationTapped(int page) {
    setState(() {
      _page = page;
    });
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _screen = [
      FeedScreen(),
      SearchScreen(),
      const AddPostScreen(),
      Center(
        child: Text('Favorite'),
      ),
      ProfileScreen(
        uid: FirebaseAuth.instance.currentUser!.uid,
      )
    ];
    return Scaffold(
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          onPageChanged: navigationTapped,
          children: _screen,
        ),
        bottomNavigationBar: CustomBottomBar(
          currentPage: _page,
          onItemTap: navigationTapped,
        ));
  }
}
