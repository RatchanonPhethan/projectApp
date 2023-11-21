import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

import '../Screens/addPostScreen.dart';
import '../Screens/loginScreen.dart';
import '../Screens/searchPostSscreen.dart';
import '../Screens/viewProfileScreen.dart';
import '../styles/styles.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  PageController pageController = PageController();
  String? user;
  bool checkUser = false;
  // ignore: non_constant_identifier_names

  List<Widget> pages = [
    const SearchPostPage(),
    const addPost(),
    const ViewProfilePage()
  ];
  int selectedIndex = 0;
  int _currentIndex = 0;

  void onPageChanged(int index) async {
    user = await SessionManager().get("username");
    setState(() {
      selectedIndex = index;
      _currentIndex = index;
    });
  }

  void fetchUser() async {
    user = await SessionManager().get("username");
    if (user == null) {
      setState(() {
        checkUser = false;
        pages = [const SearchPostPage(), const LoginApp()];
      });
    } else {
      setState(() {
        checkUser = true;
        pages = [
          const SearchPostPage(),
          const addPost(),
          const ViewProfilePage()
        ];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  void onItemTap(int selectedItem) {
    pageController.jumpToPage(selectedItem);
  }

  @override
  Widget build(BuildContext context) {
    return checkUser == true
        ? Scaffold(
            backgroundColor: kBackgroundColor,
            body: PageView(
              controller: pageController,
              onPageChanged: onPageChanged,
              children: pages,
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
            ))
        : Scaffold(
            backgroundColor: kBackgroundColor,
            body: PageView(
              controller: pageController,
              onPageChanged: onPageChanged,
              children: pages,
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
                    Icons.login_outlined,
                    color: selectedIndex == 1 ? Colors.blue[400] : Colors.grey,
                  ),
                  label: 'Login',
                ),
              ],
            ));
  }
}
