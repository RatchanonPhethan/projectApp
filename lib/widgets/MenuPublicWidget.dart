import 'package:flutter/material.dart';

import '../Screens/loginScreen.dart';
import '../styles/styles.dart';
import 'MenuFooter.dart';

class MenuPublicWidget extends StatefulWidget {
  const MenuPublicWidget({super.key});

  @override
  State<MenuPublicWidget> createState() => _MenuPublicWidgetState();
}

class _MenuPublicWidgetState extends State<MenuPublicWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(Icons.person, size: 100, color: kIconColor),
        ListTile(
          leading: Icon(
            Icons.home,
            size: 30,
            color: kIconColor,
          ),
          onTap: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) {
              return const MainPage();
            }));
          },
          title: Text(
            "หน้าหลัก",
            style: TextStyle(color: KFontColor),
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.logout_rounded,
            size: 30,
            color: kIconColor,
          ),
          onTap: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) {
              return const LoginApp();
            }));
          },
          title: Text(
            "เข้าสู่ระบบ",
            style: TextStyle(color: KFontColor),
          ),
        ),
      ],
    );
  }
}
