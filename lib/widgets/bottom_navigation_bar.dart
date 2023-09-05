import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/app_styles.dart';

class CustomBottomBar extends StatelessWidget {
  final int currentPage;
  final Function(int) onItemTap;

  const CustomBottomBar({
    required this.currentPage,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoTabBar(
      onTap: onItemTap,
      backgroundColor: Styles.mobileBackgroundColor,
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            color:
                currentPage == 0 ? Styles.primaryColor : Styles.secondaryColor,
          ),
          label: '',
          backgroundColor: Styles.primaryColor,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.search,
            color:
                currentPage == 1 ? Styles.primaryColor : Styles.secondaryColor,
          ),
          label: '',
          backgroundColor: Styles.primaryColor,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.add_circle,
            color:
                currentPage == 2 ? Styles.primaryColor : Styles.secondaryColor,
          ),
          label: '',
          backgroundColor: Styles.primaryColor,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.favorite,
            color:
                currentPage == 3 ? Styles.primaryColor : Styles.secondaryColor,
          ),
          label: '',
          backgroundColor: Styles.primaryColor,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person_2,
            color:
                currentPage == 4 ? Styles.primaryColor : Styles.secondaryColor,
          ),
          label: '',
          backgroundColor: Styles.primaryColor,
        ),
      ],
    );
  }
}
