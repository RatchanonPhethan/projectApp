import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project_application/Screens/loginScreen.dart';
import 'dart:js_util';
import 'dart:ui';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import '../styles/styles.dart';
import '../widgets/MenuFooter.dart';
import '../widgets/customTextFormField.dart';
import 'Home.dart';

class RegisterApp extends StatelessWidget {
  const RegisterApp({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formkey = GlobalKey();
    TextEditingController userNameTextController = TextEditingController();
    TextEditingController passwordTextController = TextEditingController();
    TextEditingController dateinput = TextEditingController();
    TextEditingController phoneTextController = TextEditingController();
    TextEditingController nameTextController = TextEditingController();
    TextEditingController surNameTextController = TextEditingController();
    TextEditingController emailTextController = TextEditingController();
    TextEditingController addressNameTextController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
          onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) {
            return const LoginApp();
          })),
        ),
        centerTitle: true,
        backgroundColor: kPrimary,
      ),
      body: SingleChildScrollView(
          child: Form(
              key: formkey,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 5),
                    child: Text("สมัครสมาชิก",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: Text("สมัครสมาชิกเพื่อใช้งานแอพพลิเคชั่น",
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
                  customTextFormField(
                    controller: nameTextController,
                    hintText: "ชื่อ",
                    maxLength: 50,
                    validator: (Value) {
                      if (Value!.isNotEmpty) {
                        if (Value.length < 2) {
                          return "กรุณากรอกชื่อมากกว่า 2 ตัวอักษร";
                        } else if (Value.length > 50) {
                          return "กรุณากรอกชื่อน้อยกว่า 50 ตัวอักษร";
                        } else
                          return null;
                      } else {
                        return "กรุณากรอกชื่อ";
                      }
                    },
                    obscureText: false,
                  ),
                  customTextFormField(
                    controller: surNameTextController,
                    hintText: "นามสกุล",
                    maxLength: 50,
                    validator: (Value) {
                      if (Value!.isNotEmpty) {
                        if (Value.length < 2) {
                          return "กรุณากรอกนามสกุลมากกว่า 2 ตัวอักษร";
                        } else if (Value.length > 50) {
                          return "กรุณากรอกนามสกุลน้อยกว่า 50 ตัวอักษร";
                        } else
                          return null;
                      } else {
                        return "กรุณากรอกนามสกุล";
                      }
                    },
                    obscureText: false,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 35),
                    child: TextFormField(
                      controller: dateinput,
                      validator: (Value) {
                        if (Value!.isNotEmpty) {
                          return null;
                        } else {
                          return "กรุณากรอกวันเกิด";
                        }
                      },
                      decoration: const InputDecoration(
                        // icon: Icon(Icons.calendar_today_rounded),
                        prefixIcon: const Icon(Icons.calendar_month_outlined),
                        labelText: "วันเกิด",
                        hintText: "วันเกิด",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        ),
                      ),
                      onTap: () async {
                        DateTime? pickeddate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101));
                        if (pickeddate != null) {
                          dateinput.text =
                              DateFormat('yyyy-MM-dd').format(pickeddate);
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 35),
                    child: TextFormField(
                      controller: phoneTextController,
                      maxLength: 10,
                      maxLines: 1,
                      keyboardType: TextInputType.text,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      obscureText: false,
                      validator: (Value) {
                        if (Value!.isNotEmpty) {
                          if (Value.length < 10) {
                            return "กรุณากรอกเบอร์โทรศัพท์ 10 ตัว";
                          }
                          return null;
                        } else {
                          return "กรุณากรอกเบอร์โทรศัพท์";
                        }
                      },
                      decoration: const InputDecoration(
                        hintText: "เบอร์โทรศัพท์",
                        counterText: "",
                        labelText: "เบอร์โทรศัพท์",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        ),
                      ),
                    ),
                  ),
                  customTextFormField(
                    controller: emailTextController,
                    hintText: "อีเมล์",
                    maxLength: 50,
                    validator: (Value) {
                      if (Value!.isNotEmpty) {
                        if (Value.length < 2) {
                          return "กรุณากรอกอีเมล์มากกว่า 2 ตัวอักษร";
                        } else if (Value.length > 50) {
                          return "กรุณากรอกอีเมล์น้อยกว่า 50 ตัวอักษร";
                        } else
                          return null;
                      } else {
                        return "กรุณากรอกอีเมล์";
                      }
                    },
                    obscureText: false,
                  ),
                  customTextFormField(
                    controller: addressNameTextController,
                    hintText: "ที่อยู่",
                    maxLength: 50,
                    validator: (Value) {
                      if (Value!.isNotEmpty) {
                        if (Value.length < 2) {
                          return "กรุณากรอกที่อยู่มากกว่า 2 ตัวอักษร";
                        } else if (Value.length > 100) {
                          return "กรุณากรอกที่อยู่น้อยกว่า 100 ตัวอักษร";
                        } else
                          return null;
                      } else {
                        return "กรุณากรอกที่อยู่";
                      }
                    },
                    obscureText: false,
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
                                  MaterialPageRoute(
                                      builder: (BuildContext context) {
                                return const MainPage();
                              }));
                            }
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => loginButtonColor),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(15.0)))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text("สมัครสมาชิก"),
                            ],
                          )),
                    ),
                  ),
                ],
              ))),
    );
  }
}
