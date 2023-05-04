import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../styles/styles.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: kBackgroundColor,
        width: 300,
        child: Column(children: [
          Icon(Icons.person, size: 100, color: kIconColor),
          ListTile(
            leading: Icon(
              Icons.home,
              size: 30,
              color: kIconColor,
            ),
            // onTap: () {
            //   Navigator.of(context).pushReplacement(
            //       MaterialPageRoute(builder: (BuildContext context) {
            //     return const HomeScreen();
            //   }));
            // },
            title: Text(
              "หน้าหลัก",
              style: TextStyle(color: KFontColor),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.description_outlined,
              size: 30,
              color: kIconColor,
            ),
            // onTap: () {
            //   Navigator.of(context).pushReplacement(
            //       MaterialPageRoute(builder: (BuildContext context) {
            //     return const HomeScreen();
            //   }));
            // },
            title: Text(
              "โพสต์แชร์ของฉัน",
              style: TextStyle(color: KFontColor),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.person_add_alt_1,
              size: 30,
              color: kIconColor,
            ),
            // onTap: () {
            //   Navigator.of(context).pushReplacement(
            //       MaterialPageRoute(builder: (BuildContext context) {
            //     return const HomeScreen();
            //   }));
            // },
            title: Text(
              "โพสต์แชร์ที่เข้าร่วม",
              style: TextStyle(color: KFontColor),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.star_border_purple500_rounded,
              size: 30,
              color: kIconColor,
            ),
            // onTap: () {
            //   Navigator.of(context).pushReplacement(
            //       MaterialPageRoute(builder: (BuildContext context) {
            //     return const HomeScreen();
            //   }));
            // },
            title: Text(
              "ประวัติการรีวิว",
              style: TextStyle(color: KFontColor),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.email_outlined,
              size: 30,
              color: kIconColor,
            ),
            // onTap: () {
            //   Navigator.of(context).pushReplacement(
            //       MaterialPageRoute(builder: (BuildContext context) {
            //     return const HomeScreen();
            //   }));
            // },
            title: Text(
              "คำเชิญของฉัน",
              style: TextStyle(color: KFontColor),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.add_alert_rounded,
              size: 30,
              color: kIconColor,
            ),
            // onTap: () {
            //   Navigator.of(context).pushReplacement(
            //       MaterialPageRoute(builder: (BuildContext context) {
            //     return const HomeScreen();
            //   }));
            // },
            title: Text(
              "แจ้งเตือนของฉัน",
              style: TextStyle(color: KFontColor),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.monetization_on_outlined,
              size: 30,
              color: kIconColor,
            ),
            // onTap: () {
            //   Navigator.of(context).pushReplacement(
            //       MaterialPageRoute(builder: (BuildContext context) {
            //     return const HomeScreen();
            //   }));
            // },
            title: Text(
              "เติมเงิน",
              style: TextStyle(color: KFontColor),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.logout_rounded,
              size: 30,
              color: kIconColor,
            ),
            // onTap: () {
            //   Navigator.of(context).pushReplacement(
            //       MaterialPageRoute(builder: (BuildContext context) {
            //     return const HomeScreen();
            //   }));
            // },
            title: Text(
              "ออกจากระบบ",
              style: TextStyle(color: KFontColor),
            ),
          ),
        ]));
  }
}
