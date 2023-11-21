// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:intl/intl.dart';

import '../Model/invite.dart';
import '../constant/constant_value.dart';
import '../controller/invite_controller.dart';
import '../controller/joinpost_controller.dart';
import '../styles/styles.dart';
import '../widgets/CustomSearchDelegate.dart';
import '../widgets/MenuFooter.dart';
import '../widgets/MenuWidget.dart';
import 'ConfirmInviteScreen.dart';

class InviteScreen extends StatefulWidget {
  const InviteScreen({super.key});

  @override
  State<InviteScreen> createState() => _InviteScreenState();
}

class _InviteScreenState extends State<InviteScreen> {
  bool? isDataLoaded = false;
  List<InviteModel>? invites;
  bool? check = true;
  String? member;
  int count = 0;
  String? user;
  List<InviteModel> invite = [];
  var sessionManager = SessionManager();
  final InviteController inviteController = InviteController();
  JoinPostController joinPostController = JoinPostController();
  var outputFormat = DateFormat("dd/MM/yyyy HH:mm");
  List<String> imgMemberFileName = [];
  void fetchInvites(String memberId) async {
    invites = await inviteController.listInvitesByMember(memberId);
    if (invites!.isNotEmpty) {
      for (int i = 0; i < invites!.length; i++) {
        count =
            await joinPostController.joinCount(user!, invites![i].post.post_id);
        if (count == 0) {
          invite.add(invites![i]);
        }
      }
      if (invite != null) {
        invites = invite;
        for (int i = 0; i < invites!.length; i++) {
          String filePath = invites?[i].post.member.img_member ?? "";
          String img = filePath.substring(
              filePath.lastIndexOf('/') + 1, filePath.length - 2);
          imgMemberFileName.add(img.toString());
        }
      }
      setState(() {
        isDataLoaded = true;
      });
    } else {
      TimeDurations();
    }
  }

  void removeInvite(String inviteId) async {
    await inviteController.removeInvite(inviteId);
  }

  void getMemberBySession() async {
    member = await sessionManager.get("memberId");
    user = await sessionManager.get("username");
    fetchInvites(member.toString());
  }

  void TimeDurations() {
    setState(() {
      check = true;
    });
    Timer(const Duration(milliseconds: 2000), () {
      setState(() {
        check = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getMemberBySession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "คำเชิญของฉัน",
          style: TextStyle(color: KFontColor, fontFamily: 'Itim'),
        ),
        backgroundColor: kPrimary,
      ),
      drawer: const MenuWidget(),
      body: isDataLoaded == false
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  check == true
                      ? const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blue),
                          backgroundColor: Colors.grey,
                        )
                      : const Padding(
                          padding: EdgeInsets.only(top: 50, bottom: 15),
                          child: Text(
                            "ไม่มีคำเชิญ",
                            style: TextStyle(fontFamily: 'Itim', fontSize: 18),
                          ),
                        ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return const MainPage();
                        }));
                      },
                      child: const Text(
                        "กลับสู่หน้าหลัก",
                        style: TextStyle(fontFamily: 'Itim'),
                      ))
                ],
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 40),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: const [
                          Text(
                            "คำเชิญทั้งหมด",
                            style: TextStyle(fontFamily: 'Itim', fontSize: 20),
                          ),
                          Divider(
                            thickness: 1,
                            indent: 50,
                            endIndent: 50,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: invites?.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Text(
                                      "${invites![index].post.member.firstname} ${invites![index].post.member.lastname} ได้เชิญคุณเข้าร่วมกลุ่มโพสต์แชร์สินค้า",
                                      style: const TextStyle(
                                          fontFamily: 'Itim', fontSize: 16)),
                                ),
                                Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: ListTile(
                                    leading: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ClipOval(
                                          child: SizedBox.fromSize(
                                            size: const Size.fromRadius(
                                                20), // Image radius
                                            child: Image.network(
                                                '$baseURL/member/${imgMemberFileName[index]}',
                                                width: 10,
                                                height: 10,
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                      ],
                                    ),
                                    title: Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "โพสต์ : ${invites?[index].post.post_name}",
                                            style: const TextStyle(
                                                fontFamily: 'Itim',
                                                fontSize: 18),
                                          ),
                                          Text(
                                            "ราคาชิ้นละ : ${invites?[index].post.product_price} บาท",
                                            style: const TextStyle(
                                                fontFamily: 'Itim',
                                                fontSize: 18),
                                          ),
                                          Text(
                                            "สิ้นสุด : ${outputFormat.format(invites![index].post.end_date)} น.",
                                            style: const TextStyle(
                                                fontFamily: 'Itim',
                                                fontSize: 18),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 5, bottom: 5),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 20),
                                                  child: SizedBox(
                                                    width: 100,
                                                    height: 30,
                                                    child: ElevatedButton.icon(
                                                      onPressed: () {
                                                        Navigator
                                                            .pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (_) =>
                                                                ConfirmInviteScreen(
                                                              postId: invites![
                                                                      index]
                                                                  .post
                                                                  .post_id,
                                                              inviteId: invites![
                                                                      index]
                                                                  .invite_id,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateColor
                                                                  .resolveWith(
                                                                      (states) =>
                                                                          Colors
                                                                              .green)),
                                                      icon: const Icon(
                                                          Icons.check_circle),
                                                      label: const Text(
                                                        'ยอมรับ',
                                                        style: TextStyle(
                                                            fontFamily: 'Itim',
                                                            fontSize: 14),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 100,
                                                  height: 30,
                                                  child: ElevatedButton.icon(
                                                      onPressed: () {
                                                        showDialog<String>(
                                                          context: context,
                                                          builder: (BuildContext
                                                                  context) =>
                                                              AlertDialog(
                                                            title: const Text(
                                                              'ปฏิเสธคำเชิญ',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Itim'),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                            content: const Text(
                                                                'คุณต้องปฏิเสธคำเชิญหรือไม่ ?',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Itim')),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        context,
                                                                        'ยกเลิก'),
                                                                child: const Text(
                                                                    'ยกเลิก',
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'Itim')),
                                                              ),
                                                              TextButton(
                                                                onPressed:
                                                                    () async {
                                                                  removeInvite(invites![
                                                                          index]
                                                                      .invite_id);
                                                                  Navigator.pop(
                                                                      context,
                                                                      'ตกลง');
                                                                  showDialog<
                                                                      String>(
                                                                    context:
                                                                        context,
                                                                    builder: (BuildContext
                                                                            context) =>
                                                                        AlertDialog(
                                                                      title: const Text(
                                                                          'ดำเนินการสำเร็จ!',
                                                                          style:
                                                                              TextStyle(fontFamily: 'Itim')),
                                                                      content: const Text(
                                                                          'ปฏิเสธสำเร็จ!!',
                                                                          style:
                                                                              TextStyle(fontFamily: 'Itim')),
                                                                      actions: <
                                                                          Widget>[
                                                                        TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.pop(context,
                                                                                'ตกลง');

                                                                            setState(() {
                                                                              isDataLoaded = false;
                                                                              getMemberBySession();
                                                                            });
                                                                            // });
                                                                          },
                                                                          child: const Text(
                                                                              'ตกลง',
                                                                              style: TextStyle(fontFamily: 'Itim')),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  );
                                                                },
                                                                child: const Text(
                                                                    'ตกลง',
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'Itim')),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                      style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateColor
                                                                  .resolveWith(
                                                                      (states) =>
                                                                          Colors
                                                                              .red)),
                                                      icon: const Icon(
                                                          Icons.clear_sharp),
                                                      label: const Text(
                                                          'ปฏิเสธ',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Itim',
                                                              fontSize: 14))),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
