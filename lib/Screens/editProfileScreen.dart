import 'dart:io';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project_application/Screens/viewProfileScreen.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';

import '../Model/login.dart';
import '../Model/member.dart';
import '../constant/constant_value.dart';
import '../controller/editProfileController.dart';
import '../controller/login_controller.dart';
import '../controller/viewProfileController.dart';
import '../styles/styles.dart';
import '../widgets/MenuFooter.dart';
import '../widgets/MenuWidget.dart';
import '../widgets/customTextFormField.dart';

enum Gender { male, female }

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  GlobalKey<FormState> formkey = GlobalKey();
  String? user;
  MemberModel? member;
  LoginModel? login;
  ViewProfileController viewProfileController = ViewProfileController();
  LoginController loginController = LoginController();
  EditProfileController editProfileController = EditProfileController();
  String? subimg;
  bool? isDataLoaded = false;
  var outputFormat = DateFormat('MM/dd/yyyy');
  String? memberid;
  String? password;
  bool? isadmin;
  double? amountmoney;
  TextEditingController birthdaycontroller = TextEditingController();
  TextEditingController phoneTextController = TextEditingController();
  TextEditingController firstnameTextController = TextEditingController();
  TextEditingController lastNameTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController addressNameTextController = TextEditingController();
  var gender = Gender.male;
  String? filePath;

  void fetchPost() async {
    user = await SessionManager().get("username");
    member = await viewProfileController.getViewProfile(user!);
    login = await loginController.LoginByUsername(user!);
    filePath = "${member?.img_member}";

    print(user);
    subimg =
        filePath!.substring(filePath!.lastIndexOf('/') + 1, filePath!.length);
    print(subimg);
    memberid = member!.member_id;
    password = login!.password;
    isadmin = login!.isadmin;
    amountmoney = member!.amount_money;
    birthdaycontroller.text = outputFormat.format(member!.birthday);
    phoneTextController.text = member!.tel;
    firstnameTextController.text = member!.firstname;
    lastNameTextController.text = member!.lastname;
    emailTextController.text = member!.email;
    addressNameTextController.text = member!.address;
    if (member!.gender == "male") {
      gender = Gender.male;
    } else {
      gender = Gender.female;
    }
    setState(() {
      isDataLoaded = true;
    });
  }

  File? _imgProfile;
  final picker = ImagePicker();

  void getImage() async {
    var imgProfile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imgProfile = File(imgProfile!.path);
      print(_imgProfile);
    });
  }

  void editProfileAlert() {
    QuickAlert.show(
        context: context,
        title: "แก้ไขข้อมูลส่วนตัวสำเร็จ",
        type: QuickAlertType.success,
        confirmBtnText: "ตกลง",
        onConfirmBtnTap: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) {
            return const ViewProfilePage();
          }));
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
          onPressed: () => Navigator.of(context).pushReplacement(
              CupertinoPageRoute(builder: (BuildContext context) {
            return const ViewProfilePage();
          })),
        ),
        centerTitle: true,
        backgroundColor: kPrimary,
      ),
      drawer: const MenuWidget(),
      body: isDataLoaded == false
          ? CircularProgressIndicator()
          : SingleChildScrollView(
              child: Form(
                  key: formkey,
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 15, bottom: 5),
                        child: Text("แก้ไขโปรไฟล์",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Itim')),
                      ),
                      Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(255, 255, 255, 255),
                          border: Border.all(
                            color: Colors.black,
                            width: 2,
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            getImage();
                          },
                          child: Stack(
                            children: <Widget>[
                              subimg == "-" && _imgProfile == null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(180),
                                      child: const Icon(
                                        EvaIcons.person,
                                        size: 150,
                                      ),
                                    )
                                  : _imgProfile == null
                                      ? Center(
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(180),
                                            child: Image.network(
                                              ("$baseURL/member/$subimg"),
                                              height: 150,
                                              width: 150,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )
                                      : Center(
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(180),
                                            child: Image.file(
                                              _imgProfile!,
                                              height: 150,
                                              width: 150,
                                              fit: BoxFit.cover,
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
                      ),
                      const Text(
                        "ข้อมูลส่วนตัว",
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
                        controller: firstnameTextController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp("[ก-์ a-z A-Z]"))
                        ],
                        prefixIcon: Icon(Icons.card_membership),
                        hintText: "ชื่อ",
                        maxLength: 50,
                        validator: (Value) {
                          if (Value!.isNotEmpty) {
                            if (Value.length < 1) {
                              return "กรุณากรอกชื่อมากกว่า 1 ตัวอักษร";
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
                        controller: lastNameTextController,
                        prefixIcon: Icon(Icons.card_membership),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp("[ก-์ a-z A-Z]"))
                        ],
                        hintText: "นามสกุล",
                        maxLength: 50,
                        validator: (Value) {
                          if (Value!.isNotEmpty) {
                            if (Value.length < 1) {
                              return "กรุณากรอกนามสกุลมากกว่า 1 ตัวอักษร";
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
                            prefixIcon:
                                const Icon(Icons.calendar_month_outlined),
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
                        controller: phoneTextController,
                        maxLength: 10,
                        prefixIcon: Icon(EvaIcons.phone),
                        maxLines: 1,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
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
                            } else if (!RegExp(
                                    "[A-Z a-z 0-9]{5}[@gmail.com]{10}")
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
                        maxLength: 200,
                        prefixIcon: Icon(Icons.maps_home_work),
                        validator: (Value) {
                          if (Value!.isNotEmpty) {
                            if (Value.length < 2) {
                              return "กรุณากรอกที่อยู่มากกว่า 2 ตัวอักษร";
                            } else if (Value.length > 200) {
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
                                  title: const Text(
                                    "หญิง",
                                    style: TextStyle(fontFamily: 'Itim'),
                                  ),
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
                                  editProfileController.editMyProfile(
                                      memberid!,
                                      user!,
                                      isadmin!,
                                      firstnameTextController.text,
                                      lastNameTextController.text,
                                      phoneTextController.text,
                                      emailTextController.text,
                                      birthdaycontroller.text,
                                      amountmoney!,
                                      gender,
                                      password!,
                                      addressNameTextController.text,
                                      _imgProfile,
                                      filePath!);
                                  editProfileAlert();
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
                                    "แก้ไข",
                                    style: TextStyle(
                                        fontFamily: 'Itim',
                                        color: Colors.black),
                                  ),
                                ],
                              )),
                        ),
                      ),
                    ],
                  ))),
    );
  }
}
