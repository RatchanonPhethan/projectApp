import 'dart:io';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../Model/member.dart';
import '../constant/constant_value.dart';
import '../controller/viewProfileController.dart';
import '../styles/styles.dart';
import '../widgets/CustomSearchDelegate.dart';
import '../widgets/MenuFooter.dart';
import '../widgets/MenuWidget.dart';
import 'changePasswordScreen.dart';
import 'editProfileScreen.dart';
import 'loginScreen.dart';

class ViewProfilePage extends StatefulWidget {
  const ViewProfilePage({super.key});

  @override
  State<ViewProfilePage> createState() => _ViewProfilePageState();
}

class _ViewProfilePageState extends State<ViewProfilePage> {
  MemberModel? member;
  bool? isDataLoaded = false;
  String? user;
  String? subimg;
  String filePath = "";

  ViewProfileController viewProfileController = ViewProfileController();

  var outputFormat = DateFormat('dd/MM/yyyy');
  void fetchPost() async {
    user = await SessionManager().get("username");

    member = await viewProfileController.getViewProfile(user!);
    filePath = "${member?.img_member}";
    print(user);
    subimg = filePath.substring(filePath.lastIndexOf('/') + 1, filePath.length);
    print(subimg);
    setState(() {
      isDataLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchPost();
  }

  File? _imgProfile;
  final picker = ImagePicker();

  void getImage() async {
    var imgProfile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imgProfile = File(imgProfile!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimary,
          title: Text(
            "โปรไฟล์",
            style: TextStyle(color: KFontColor, fontFamily: 'Itim'),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 246, 246, 246),
        drawer: const MenuWidget(),
        body: isDataLoaded == false
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(children: [
                    filePath != "-"
                        ? Center(
                            child: Container(
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
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(180),
                                child: Image.network(
                                  "$baseURL/member/$subimg",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                        : Center(
                            child: Container(
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
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(180),
                                child: const Icon(
                                  EvaIcons.person,
                                  size: 150,
                                ),
                              ),
                            ),
                          ),
                    const Divider(
                      thickness: 1,
                      color: Colors.black,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "ข้อมูลส่วนตัว",
                          style: TextStyle(fontFamily: 'Itim', fontSize: 15),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: ((BuildContext context) {
                                return const EditProfilePage();
                              })));
                            },
                            child: const Text(
                              "แก้ไข",
                              style:
                                  TextStyle(fontFamily: 'Itim', fontSize: 15),
                            ))
                      ],
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "จำนวนเงิน",
                          style: TextStyle(fontFamily: 'Itim', fontSize: 15),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(
                            "${member?.amount_money}",
                            style: const TextStyle(
                                fontFamily: 'Itim', fontSize: 15),
                          ),
                        )
                      ],
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "ชื่อบัญชีผู้ใช้ ",
                          style: TextStyle(fontFamily: 'Itim', fontSize: 15),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(
                            user!,
                            style: const TextStyle(
                                fontFamily: 'Itim', fontSize: 15),
                          ),
                        )
                      ],
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "เพศ",
                          style: TextStyle(fontFamily: 'Itim', fontSize: 15),
                        ),
                        member?.gender == "male"
                            ? const Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Text(
                                  "ชาย",
                                  style: TextStyle(
                                      fontFamily: 'Itim', fontSize: 15),
                                ),
                              )
                            : const Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Text(
                                  "หญิง",
                                  style: TextStyle(
                                      fontFamily: 'Itim', fontSize: 15),
                                ),
                              )
                      ],
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "ชื่อ-นามสกุล",
                          style: TextStyle(fontFamily: 'Itim', fontSize: 15),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(
                            "${member?.firstname} ${member?.lastname}",
                            style: const TextStyle(
                                fontFamily: 'Itim', fontSize: 15),
                          ),
                        )
                      ],
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "เบอร์โทรศัพท์",
                          style: TextStyle(fontFamily: 'Itim', fontSize: 15),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(
                            "${member?.tel}",
                            style: const TextStyle(
                                fontFamily: 'Itim', fontSize: 15),
                          ),
                        )
                      ],
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "อีเมลล์",
                          style: TextStyle(fontFamily: 'Itim', fontSize: 15),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(
                            "${member?.email}",
                            style: const TextStyle(
                                fontFamily: 'Itim', fontSize: 15),
                          ),
                        )
                      ],
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "วัน/เดือน/ปีเกิด",
                          style: TextStyle(fontFamily: 'Itim', fontSize: 15),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(
                            outputFormat.format(member!.birthday),
                            style: const TextStyle(
                                fontFamily: 'Itim', fontSize: 15),
                          ),
                        )
                      ],
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "ที่อยู่",
                          style: TextStyle(fontFamily: 'Itim', fontSize: 15),
                        ),
                        const SizedBox(width: 100),
                        Flexible(
                          child: Text(
                            "${member?.address}",
                            style: const TextStyle(
                                fontFamily: 'Itim', fontSize: 15),
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    ListTile(
                      tileColor: Color.fromARGB(255, 246, 246, 246),
                      title: const Text(
                        "เปลี่ยนรหัสผ่าน",
                        style: TextStyle(
                            fontFamily: 'Itim',
                            color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                      trailing: Icon(EvaIcons.arrowForward),
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return const ChangePasswordPage();
                        }));
                      },
                    ),
                    ListTile(
                      tileColor: Color.fromARGB(255, 233, 233, 233),
                      title: const Text(
                        "ออกจากระบบ",
                        style: TextStyle(fontFamily: 'Itim', color: Colors.red),
                      ),
                      onTap: () {
                        SessionManager().remove("username");
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return const LoginApp();
                        }));
                      },
                    ),
                  ]),
                ),
              ));
  }
}
