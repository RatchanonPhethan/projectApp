import 'package:flutter/material.dart';
import 'package:flutter_project_application/Screens/Home.dart';
import 'package:flutter_project_application/Screens/InviteScreen.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

import '../Screens/ListJoinPostScreen.dart';
import '../Screens/ListMyReviewScreen.dart';
import '../Screens/ListTransactionLogScreen.dart';
import '../Screens/TopUpMoneyScreen.dart';
import '../Screens/listMyPostScreen.dart';
import '../Screens/loginScreen.dart';
import '../styles/styles.dart';
import 'MenuFooter.dart';

class MenuMemberWidget extends StatefulWidget {
  const MenuMemberWidget({super.key});

  @override
  State<MenuMemberWidget> createState() => _MenuMemberWidgetState();
}

class _MenuMemberWidgetState extends State<MenuMemberWidget> {
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
            style: TextStyle(color: KFontColor, fontFamily: 'Itim'),
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.description_outlined,
            size: 30,
            color: kIconColor,
          ),
          onTap: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) {
              return const ListMyPostPage();
            }));
          },
          title: Text(
            "โพสต์แชร์ของฉัน",
            style: TextStyle(color: KFontColor, fontFamily: 'Itim'),
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.person_add_alt_1,
            size: 30,
            color: kIconColor,
          ),
          onTap: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) {
              return const ListJoinPostScreen();
            }));
          },
          title: Text(
            "โพสต์แชร์ที่เข้าร่วม",
            style: TextStyle(color: KFontColor, fontFamily: 'Itim'),
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.star_border_purple500_rounded,
            size: 30,
            color: kIconColor,
          ),
          onTap: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) {
              return const ListMyReviewPage();
            }));
          },
          title: Text(
            "ประวัติการรีวิว",
            style: TextStyle(color: KFontColor, fontFamily: 'Itim'),
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.email_outlined,
            size: 30,
            color: kIconColor,
          ),
          onTap: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) {
              return const InviteScreen();
            }));
          },
          title: Text(
            "คำเชิญของฉัน",
            style: TextStyle(color: KFontColor, fontFamily: 'Itim'),
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.add_alert_rounded,
            size: 30,
            color: kIconColor,
          ),
          onTap: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) {
              return const ListTransactionLogScreen();
            }));
          },
          title: Text(
            "แจ้งเตือนของฉัน",
            style: TextStyle(color: KFontColor, fontFamily: 'Itim'),
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.monetization_on_outlined,
            size: 30,
            color: kIconColor,
          ),
          onTap: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) {
              return const TopUpMomey();
            }));
          },
          title: Text(
            "เติมเงิน",
            style: TextStyle(color: KFontColor, fontFamily: 'Itim'),
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.logout_rounded,
            size: 30,
            color: kIconColor,
          ),
          onTap: () async {
            await SessionManager().remove("username");
            await SessionManager().remove("memberId");
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) {
              return const LoginApp();
            }));
          },
          title: Text(
            "ออกจากระบบ",
            style: TextStyle(color: KFontColor, fontFamily: 'Itim'),
          ),
        ),
      ],
    );
  }
}
