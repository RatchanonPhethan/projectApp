import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_project_application/Screens/registerScreen.dart';

import '../styles/styles.dart';
import '../widgets/customTextFormField.dart';
import 'Home.dart';

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formkey = GlobalKey();
    TextEditingController userNameTextController = TextEditingController();
    TextEditingController passwordTextController = TextEditingController();
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Column(children: [
            Padding(
              padding: EdgeInsets.all(20.0),
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
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: Text("แอพพลิเคชั่นสำหรับผู้ที่ต้องหาคนแชร์เวลาซื้อของ",
                  style: TextStyle(fontSize: 15)),
            ),
            const Divider(
              thickness: 3,
              indent: 35,
              endIndent: 35,
            ),
            customTextFormField(
              controller: userNameTextController,
              hintText: "ชื่อผู้ใช้",
              maxLength: 50,
              validator: (Value) {
                if (Value!.isNotEmpty) {
                  if (Value.length < 10) {
                    return "กรุณากรอกชื่อผู้ใช้มากกว่า 10 ตัวอักษร";
                  } else
                    return null;
                } else {
                  return "กรุณากรอกชื่อผู้ใช้";
                }
              },
              obscureText: false,
            ),
            customTextFormField(
              controller: passwordTextController,
              hintText: "รหัสผ่าน",
              maxLength: 50,
              validator: (Value) {
                if (Value!.isNotEmpty) {
                  return null;
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
                    onPressed: () {
                      if (formkey.currentState!.validate()) {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return const HomePage();
                        }));
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
                        Text("เข้าสู่ระบบ"),
                      ],
                    )),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 10, horizontal: kDefaultPaddingH),
              child: SizedBox(
                height: 40,
                width: 150,
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
                        Text("สมัครสมาชิก"),
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
