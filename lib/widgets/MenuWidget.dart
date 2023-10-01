import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import '../Model/login.dart';
import '../controller/login_controller.dart';
import '../styles/styles.dart';
import 'MenuAdminWidgets.dart';
import 'MenuMemberWidgets.dart';
import 'MenuPublicWidget.dart';

class MenuWidget extends StatefulWidget {
  const MenuWidget({super.key});

  @override
  State<MenuWidget> createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  final LoginController loginController = LoginController();
  LoginModel? logins;
  String? user;
  bool? isDataLoaded = false;
  var sessionManager = SessionManager();
  void getUser() async {
    user = await sessionManager.get("username");
    fetchLoginByUsername(user.toString());
  }

  void fetchLoginByUsername(String username) async {
    logins = await loginController.LoginByUsername(username);
    setState(() {
      isDataLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: kBackgroundColor,
        width: 300,
        child: isDataLoaded == false
            ? const SizedBox(
                height: 10.0,
                width: 10.0,
                child: Center(child: CircularProgressIndicator()),
              )
            : user == null
                ? const MenuPublicWidget()
                : logins?.isadmin == true
                    ? const MenuAdminWidget()
                    : const MenuMemberWidget());
  }
}
