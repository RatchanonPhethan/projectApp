import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_project_application/Screens/loginScreen.dart';
import 'package:flutter_project_application/Screens/viewPostDetailScreen.dart';
import 'package:flutter_project_application/Screens/viewProfileScreen.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

class CheckUser extends StatefulWidget {
  const CheckUser({super.key});

  @override
  State<CheckUser> createState() => _CheckUserState();
}

class _CheckUserState extends State<CheckUser> {
  String? user;
  bool checkUser = false;

  void FetchUser() async {
    user = await SessionManager().get("username");
    if (user == null) {
      setState(() {
        checkUser == false;
      });
    } else {
      setState(() {
        checkUser == true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FetchUser();
  }

  @override
  Widget build(BuildContext context) {
    _navigateToPage(BuildContext context) {
      if (checkUser == false) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) {
            return LoginApp();
          }),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) {
            return ViewProfilePage();
          }),
        );
      }
    }

    return Scaffold(
      body: Container(
        child: FutureBuilder(
          future: Future.delayed(
              Duration(seconds: 1)), // Simulating some async operation
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Show a loading indicator while checking user status.
            } else {
              _navigateToPage(
                  context); // Call the navigation function based on user status.
              return Container(); // You can return an empty container here since the navigation happens elsewhere.
            }
          },
        ),
      ),
    );
  }
}
