import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_project_application/Screens/Home.dart';

import '../Screens/addPostScreen.dart';
import '../styles/styles.dart';
import 'CustomSearchDelegate.dart';
import 'MenuWidget.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  PageController pageController = PageController();
  List<Widget> pages = [HomePage(), addPost(), HomePage()];
  int selectedIndex = 0;
  int _currentIndex = 0;

  void onPageChanged(int index) {
    setState(() {
      selectedIndex = index;
      _currentIndex = index;
    });
  }

  // void onTabTapped(int index) {
  //   setState(() {
  //     _currentIndex = index;
  //   });
  // }

  void onItemTap(int selectedItem) {
    pageController.jumpToPage(selectedItem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kBackgroundColor,
        body: PageView(
          controller: pageController,
          children: pages,
          onPageChanged: onPageChanged,
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: onItemTap,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: selectedIndex == 0 ? Colors.blue[400] : Colors.grey,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.add_circle_rounded,
                color: selectedIndex == 1 ? Colors.blue[400] : Colors.grey,
              ),
              label: 'Add Post',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: selectedIndex == 2 ? Colors.blue[400] : Colors.grey,
              ),
              label: 'Profile',
            ),
          ],
        ));
  }
}
