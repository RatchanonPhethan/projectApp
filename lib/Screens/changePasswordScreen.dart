import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project_application/Screens/viewProfileScreen.dart';
import 'package:flutter_project_application/controller/changepasswordController.dart';
import 'package:flutter_project_application/widgets/MenuFooter.dart';
import 'package:flutter_project_application/widgets/customTextFormField.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../styles/styles.dart';
import '../widgets/CustomSearchDelegate.dart';
import '../widgets/MenuWidget.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  GlobalKey<FormState> formkey = GlobalKey();
  ChangePasswordController changePasswordController =
      ChangePasswordController();
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController newpasswordTextController = TextEditingController();
  TextEditingController newConfirmpasswordTextController =
      TextEditingController();
  String? user;
  void fetchuser() async {
    user = await SessionManager().get("username");
  }

  void changePasswordSussess() {
    QuickAlert.show(
        context: context,
        title: "เปลี่ยนรหัสผ่านสำเร็จ",
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchuser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimary,
        title: Text(
          "เปลี่ยนรหัสผ่าน",
          style: TextStyle(color: KFontColor, fontFamily: 'Itim'),
        ),
        leading: BackButton(
          color: Colors.black,
          onPressed: () => Navigator.of(context).pushReplacement(
              CupertinoPageRoute(builder: (BuildContext context) {
            return const ViewProfilePage();
          })),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 246, 246, 246),
      drawer: const MenuWidget(),
      body: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Column(
              children: <Widget>[
                customTextFormField(
                  controller: passwordTextController,
                  prefixIcon: const Icon(EvaIcons.unlock),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp("[a-z A-Z 0-9 !#_.]"))
                  ],
                  hintText: "รหัสผ่านเก่า",
                  maxLength: 16,
                  validator: (Value) {
                    if (Value!.isNotEmpty) {
                      if (Value.length < 8) {
                        return "กรุณากรอกรหัสผ่านมากกว่า 8 ตัวอักษร";
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
                customTextFormField(
                  controller: newpasswordTextController,
                  prefixIcon: const Icon(EvaIcons.lock),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp("[a-z A-Z 0-9 !#_.]"))
                  ],
                  hintText: "รหัสผ่านใหม่",
                  maxLength: 16,
                  validator: (Value) {
                    if (Value!.isNotEmpty) {
                      if (Value.length < 8) {
                        return "กรุณากรอกรหัสผ่านมากกว่า 8 ตัวอักษร";
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
                customTextFormField(
                  controller: newConfirmpasswordTextController,
                  prefixIcon: const Icon(EvaIcons.lock),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp("[a-z A-Z 0-9 !#_.]"))
                  ],
                  hintText: "ยืนยันรหัสผ่านใหม่",
                  maxLength: 16,
                  validator: (Value) {
                    if (Value!.isNotEmpty) {
                      if (Value.length < 8) {
                        return "กรุณากรอกรหัสผ่านมากกว่า 8 ตัวอักษร";
                      } else if (newpasswordTextController.text !=
                          newConfirmpasswordTextController.text) {
                        return "กรุณากรอกรหัสยืนยันให้ตรงกัน";
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
                            await changePasswordController.changepassword(
                                user!,
                                passwordTextController.text,
                                newpasswordTextController.text);
                            changePasswordSussess();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 5,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "เปลี่ยนรหัสผ่าน",
                              style: TextStyle(
                                  fontFamily: 'Itim', color: Colors.black),
                            ),
                          ],
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
