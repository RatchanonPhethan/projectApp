import 'dart:io';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project_application/Model/member.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../controller/member_controller.dart';
import '../styles/styles.dart';
import '../widgets/MenuFooter.dart';
import '../widgets/customTextFormField.dart';
import 'loginScreen.dart';

enum Gender { male, female }

class RegisterApp extends StatefulWidget {
  const RegisterApp({super.key});

  @override
  State<RegisterApp> createState() => _RegisterAppState();
}

class _RegisterAppState extends State<RegisterApp> {
  GlobalKey<FormState> formkey = GlobalKey();
  MemberController memberController = MemberController();
  TextEditingController userNameTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController birthdaycontroller = TextEditingController();
  TextEditingController phoneTextController = TextEditingController();
  TextEditingController nameTextController = TextEditingController();
  TextEditingController surNameTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController addressNameTextController = TextEditingController();
  MemberModel? member;
  var gender = Gender.male;

  File? _imgProfile;
  final picker = ImagePicker();

  void getImage() async {
    var imgProfile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imgProfile = File(imgProfile!.path);
      print(_imgProfile);
    });
  }

  void showCompleteRegisterAlert() {
    QuickAlert.show(
        context: context,
        title: "สมัครสมาชิกสำเร็จ",
        type: QuickAlertType.success,
        confirmBtnText: "ตกลง",
        onConfirmBtnTap: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) {
            return const MainPage();
          }));
        });
  }

  void imgProfileAlert() {
    QuickAlert.show(
        context: context,
        title: "กรุณาใส่รูป Profile",
        type: QuickAlertType.error,
        confirmBtnText: "ตกลง",
        onConfirmBtnTap: () {
          Navigator.pop(context);
        });
  }

  void fetchMemberByUser() async {
    String user = await SessionManager().get("username");
    member = await memberController.getMemberByUsername(user);

    if (member != null) {
      await SessionManager().set("memberId", member!.member_id);
    }
  }

  @override
  Widget build(BuildContext context) {
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
      backgroundColor: Color.fromARGB(255, 246, 246, 246),
      body: SingleChildScrollView(
          child: Form(
              key: formkey,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 5),
                    child: Text("สมัครสมาชิก",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Itim')),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: Text("สมัครสมาชิกเพื่อใช้งานแอพพลิเคชั่น",
                        style: TextStyle(fontSize: 15, fontFamily: 'Itim')),
                  ),
                  GestureDetector(
                    onTap: () {
                      getImage();
                    },
                    child: Stack(
                      children: <Widget>[
                        Container(
                          child: _imgProfile == null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(180),
                                  child: const Icon(
                                    EvaIcons.person,
                                    size: 150,
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(180),
                                  child: Center(
                                    child: Image.file(
                                      _imgProfile!,
                                      height: 150,
                                      width: 150,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 0, 0, 0),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 24,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    "ข้อมูลการสมัคร",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Itim'),
                  ),
                  const Divider(
                    thickness: 3,
                    indent: 35,
                    endIndent: 35,
                  ),
                  customTextFormField(
                    controller: userNameTextController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[a-z A-Z 0-9]"))
                    ],
                    hintText: "ชื่อผู้ใช้",
                    prefixIcon: Icon(EvaIcons.person),
                    maxLength: 16,
                    validator: (Value) {
                      if (Value!.isNotEmpty) {
                        if (Value.length < 4) {
                          return "กรุณากรอกชื่อผู้ใช้มากกว่า 4 ตัวอักษร";
                        }
                        return null;
                      } else {
                        return "กรุณากรอกชื่อผู้ใช้";
                      }
                    },
                    obscureText: false,
                  ),
                  customTextFormField(
                    controller: passwordTextController,
                    prefixIcon: Icon(EvaIcons.lock),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp("[a-z A-Z 0-9 !#_.]"))
                    ],
                    hintText: "รหัสผ่าน",
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
                    controller: nameTextController,
                    prefixIcon: Icon(Icons.card_membership),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[ก-์ a-z A-Z]"))
                    ],
                    hintText: "ชื่อ",
                    maxLength: 50,
                    validator: (Value) {
                      if (Value!.isNotEmpty) {
                        if (Value.length < 4) {
                          return "กรุณากรอกชื่อมากกว่า 4 ตัวอักษร";
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
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[ก-์ a-z A-Z]"))
                    ],
                    hintText: "นามสกุล",
                    prefixIcon: Icon(Icons.card_membership),
                    maxLength: 50,
                    validator: (Value) {
                      if (Value!.isNotEmpty) {
                        if (Value.length < 4) {
                          return "กรุณากรอกนามสกุลมากกว่า 4 ตัวอักษร";
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
                      controller: birthdaycontroller,
                      style: TextStyle(fontFamily: 'Itim'),
                      validator: (Value) {
                        if (Value!.isNotEmpty) {
                          return null;
                        } else {
                          return "กรุณากรอกวันเกิด";
                        }
                      },
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.calendar_month_outlined),
                        labelText: "วันเกิด",
                        hintText: "วันเกิด",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                            borderSide: BorderSide(color: Colors.blue)),
                        labelStyle: TextStyle(color: Colors.blue),
                      ),
                      onTap: () async {
                        DateTime? pickeddate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now()
                                .subtract(const Duration(days: 365 * 13)),
                            firstDate: DateTime.now()
                                .subtract(const Duration(days: 365 * 100)),
                            lastDate: DateTime.now()
                                .subtract(const Duration(days: 365 * 13)));
                        if (pickeddate != null) {
                          birthdaycontroller.text =
                              DateFormat('dd/MM/yyyy').format(pickeddate);
                        }
                      },
                    ),
                  ),
                  customTextFormField(
                    hintText: "เบอร์โทรศัพท์",
                    prefixIcon: Icon(EvaIcons.phone),
                    controller: phoneTextController,
                    maxLength: 10,
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    obscureText: false,
                    validator: (value) {
                      if (value!.isNotEmpty) {
                        if (value.length < 10) {
                          return "กรุณากรอกเบอร์โทรศัพท์ 10 ตัว";
                        } else if (!RegExp("[0]{1}[6,8,9]{1}[0-9]{8}")
                            .hasMatch(value)) {
                          return "กรุณากรอกเบอร์โทรศัพท์ให้อยู่ในรูปแบบ 06 08 09";
                        }
                        return null;
                      } else {
                        return "กรุณากรอกเบอร์โทรศัพท์";
                      }
                    },
                  ),
                  customTextFormField(
                    controller: emailTextController,
                    hintText: "อีเมล์",
                    prefixIcon: Icon(EvaIcons.email),
                    maxLength: 60,
                    validator: (value) {
                      if (value!.isNotEmpty) {
                        if (value.length < 5) {
                          return "กรุณากรอกอีเมล์มากกว่า 5 ตัวอักษร";
                        } else if (!RegExp("[A-Z a-z 0-9]{5}[@gmail.com]{10}")
                            .hasMatch(value)) {
                          return "กรุณากรอกรูปแบบอีเมลให้ถูกต้อง";
                        } else {
                          return null;
                        }
                      } else {
                        return "กรุณากรอกอีเมล์";
                      }
                    },
                    obscureText: false,
                  ),
                  customTextFormField(
                    controller: addressNameTextController,
                    hintText: "ที่อยู่",
                    prefixIcon: Icon(Icons.maps_home_work),
                    maxLength: 200,
                    validator: (Value) {
                      if (Value!.isNotEmpty) {
                        if (Value.length < 2) {
                          return "กรุณากรอกที่อยู่มากกว่า 1 ตัวอักษร";
                        } else if (Value.length > 200) {
                          return "กรุณากรอกที่อยู่น้อยกว่า 200 ตัวอักษร";
                        } else {
                          return null;
                        }
                      } else {
                        return "กรุณากรอกที่อยู่";
                      }
                    },
                    obscureText: false,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 35),
                    child: Row(
                      children: [
                        Expanded(
                          child: RadioListTile<Gender>(
                              value: Gender.male,
                              groupValue: gender,
                              title: const Text(
                                "ชาย",
                                style: TextStyle(fontFamily: 'Itim'),
                              ),
                              onChanged: (Gender? val) {
                                setState(() {
                                  gender = Gender.male;
                                });
                              }),
                        ),
                        Expanded(
                          child: RadioListTile<Gender>(
                              value: Gender.female,
                              groupValue: gender,
                              title: const Text("หญิง",
                                  style: TextStyle(fontFamily: 'Itim')),
                              onChanged: (Gender? val) {
                                setState(() {
                                  gender = Gender.female;
                                });
                              }),
                        )
                      ],
                    ),
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
                              String gender =
                                  Gender.male == true ? "FeMale" : "male";
                              memberController.addMember(
                                  userNameTextController.text,
                                  nameTextController.text,
                                  surNameTextController.text,
                                  phoneTextController.text,
                                  emailTextController.text,
                                  birthdaycontroller.text,
                                  0,
                                  gender,
                                  passwordTextController.text,
                                  addressNameTextController.text,
                                  _imgProfile!);
                              await SessionManager()
                                  .set("username", userNameTextController.text);
                              fetchMemberByUser();
                              showCompleteRegisterAlert();
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
                              Text("สมัครสมาชิก",
                                  style: TextStyle(
                                      fontFamily: 'Itim', color: Colors.black)),
                            ],
                          )),
                    ),
                  ),
                ],
              ))),
    );
  }
}
