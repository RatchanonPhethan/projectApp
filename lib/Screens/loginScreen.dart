// ignore_for_file: use_build_context_synchronously

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project_application/Screens/registerScreen.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';

import '../Model/ban.dart';
import '../Model/login.dart';
import '../Model/member.dart';
import '../controller/ban_controller.dart';
import '../controller/login_controller.dart';
import '../controller/member_controller.dart';
import '../styles/styles.dart';
import '../widgets/MenuFooter.dart';
import '../widgets/MenuWidget.dart';
import '../widgets/customTextFormField.dart';

class LoginApp extends StatefulWidget {
  const LoginApp({super.key});

  @override
  State<LoginApp> createState() => _LoginAppState();
}

class _LoginAppState extends State<LoginApp> {
  GlobalKey<FormState> formkey = GlobalKey();
  TextEditingController userNameTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  BanController banController = BanController();
  final LoginController loginController = LoginController();
  final MemberController memberController = MemberController();
  MemberModel? member;
  LoginModel? logins;
  String? encodepass;
  bool? isDataLoaded = false;
  BanModel? ban;
  var login;
  var outputFormat = DateFormat("dd/MM/yyyy HH:mm");
  DateTime bantime = DateTime.now();
  void fetchMemberByUser() async {
    String user = await SessionManager().get("username");
    member = await memberController.getMemberByUsername(user);

    if (member != null) {
      await SessionManager().set("memberId", member!.member_id);
    }
    setState(() {
      isDataLoaded = true;
    });
  }

  void fetchLoginByUsername(String username) async {
    logins = await loginController.LoginByUsername(username);

    setState(() {
      isDataLoaded = true;
    });
  }

  void loginSussess() {
    QuickAlert.show(
        context: context,
        title: "เข้าสู่ระบบสำเร็จ",
        type: QuickAlertType.success,
        confirmBtnText: "ตกลง",
        onConfirmBtnTap: () {
          Navigator.of(context).pushReplacement(
            CupertinoPageRoute(
              builder: (BuildContext context) {
                return const MainPage();
              },
            ),
          );
        });
  }

  void usernameInvalid() {
    QuickAlert.show(
        context: context,
        title: "username ไม่ถูกต้อง",
        type: QuickAlertType.error,
        confirmBtnText: "ตกลง",
        onConfirmBtnTap: () {
          Navigator.pop(context);
        });
  }

  void passwordInvalid() {
    QuickAlert.show(
        context: context,
        title: "รหัสผ่านไม่ถูกต้อง",
        type: QuickAlertType.error,
        confirmBtnText: "ตกลง",
        onConfirmBtnTap: () {
          Navigator.pop(context);
        });
  }

  void accountisban(BanModel ban) async {
    QuickAlert.show(
        context: context,
        title: "บัญชีผู้ใช้นี้ถูกแบน",
        text:
            "ถึงวันที่ ${outputFormat.format(ban.end_date)} น. \n เนื่องจากทำการ ${ban.ban_detail}",
        type: QuickAlertType.error,
        confirmBtnText: "ตกลง",
        onConfirmBtnTap: () {
          Navigator.pop(context);
        });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimary,
        title: Text(
          "Login",
          style: TextStyle(color: KFontColor),
        ),
      ),
      drawer: const MenuWidget(),
      body: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Expanded(
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Image.asset(
                      "images/user.png",
                      width: 150,
                      height: 150,
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 15, bottom: 5),
              child: Text("เข้าสู่ระบบ",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Itim')),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: Text("แอพพลิเคชั่นสำหรับผู้ที่ต้องหาคนแชร์เวลาซื้อของ",
                  style: TextStyle(fontSize: 15, fontFamily: 'Itim')),
            ),
            const Divider(
              thickness: 3,
              indent: 35,
              endIndent: 35,
            ),
            customTextFormField(
              controller: userNameTextController,
              prefixIcon: Icon(EvaIcons.logIn),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[a-z A-Z 0-9]"))
              ],
              hintText: "ชื่อผู้ใช้",
              maxLength: 16,
              validator: (Value) {
                if (Value!.isNotEmpty) {
                  if (Value.length < 4) {
                    return "กรุณากรอกชื่อผู้ใช้มากกว่า 4-16 ตัวอักษร";
                  } else {
                    return null;
                  }
                } else {
                  return "กรุณากรอกชื่อผู้ใช้";
                }
              },
              obscureText: false,
            ),
            customTextFormField(
              controller: passwordTextController,
              hintText: "รหัสผ่าน",
              prefixIcon: Icon(EvaIcons.lock),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[a-z A-Z 0-9 !#_.]"))
              ],
              maxLength: 16,
              validator: (Value) {
                if (Value!.isNotEmpty) {
                  if (Value.length < 8) {
                    return "กรุณากรอกชื่อผู้ใช้มากกว่า 8-16 ตัวอักษร";
                  } else {
                    return null;
                  }
                } else {
                  return "กรุณากรอกรหัสผ่าน";
                }
              },
              obscureText: true,
              maxLines: 1,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 10, horizontal: kDefaultPaddingH),
              child: SizedBox(
                height: 45,
                width: 200,
                child: ElevatedButton(
                    onPressed: () async {
                      if (formkey.currentState!.validate()) {
                        login = await loginController.Login(
                            userNameTextController.text,
                            passwordTextController.text);
                        if (login["code"] == 200) {
                          await SessionManager()
                              .set("username", userNameTextController.text);
                          fetchMemberByUser();
                          loginSussess();
                        } else if (login["code"] == 501 ||
                            login["code"] == 502) {
                          passwordInvalid();
                        } else if (login["code"] == 503 ||
                            login["code"] == 504) {
                          usernameInvalid();
                        } else if (login["code"] == 505) {
                          member = await memberController
                              .getMemberByUsername(userNameTextController.text);
                          ban = await banController
                              .getBanByMemberId(member!.member_id);
                          if (ban!.end_date.isBefore(bantime)) {
                            await SessionManager()
                                .set("username", userNameTextController.text);
                            await memberController
                                .updatestatusban(member!.member_id);
                            fetchMemberByUser();
                            loginSussess();
                          } else {
                            accountisban(ban!);
                          }
                        }
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => loginButtonColor),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "เข้าสู่ระบบ",
                          style: TextStyle(fontFamily: 'Itim'),
                        ),
                      ],
                    )),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 10, horizontal: kDefaultPaddingH),
              child: SizedBox(
                height: 45,
                width: 200,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return const RegisterApp();
                      }));
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => registerButtonColor),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("สมัครสมาชิก",
                            style: TextStyle(fontFamily: 'Itim')),
                      ],
                    )),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
