// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_project_application/Model/invite.dart';
import 'package:flutter_project_application/Screens/ConfirmInviteScreen.dart';
import 'package:flutter_project_application/controller/invite_controller.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:intl/intl.dart';

import '../styles/styles.dart';
import '../widgets/CustomSearchDelegate.dart';
import '../widgets/MenuFooter.dart';
import '../widgets/MenuWidget.dart';

class InviteScreen extends StatefulWidget {
  const InviteScreen({super.key});

  @override
  State<InviteScreen> createState() => _InviteScreenState();
}

class _InviteScreenState extends State<InviteScreen> {
  bool? isDataLoaded = false;
  List<InviteModel>? invites;
  bool? check = false;
  String? member;
  String? user;
  var sessionManager = SessionManager();
  final InviteController inviteController = InviteController();
  var outputFormat = DateFormat('dd/MM/yyyy hh:mm a');
  var outputDate;
  void fetchInvites(String memberId) async {
    invites = await inviteController.listInvitesByMember(memberId);
    setState(() {
      isDataLoaded = true;
    });
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
    Timer(const Duration(milliseconds: 3000), () {
      setState(() {
        check = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    TimeDurations();
    getMemberBySession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "คำเชิญของฉัน",
          style: TextStyle(color: KFontColor),
        ),
        leading: BackButton(
          color: Colors.black,
          onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) {
            return const MainPage();
          })),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // method to show the search bar
              showSearch(
                  context: context,
                  // delegate to customize the search bar
                  delegate: CustomSearchDelegate());
            },
            icon: const Icon(
              Icons.search,
              color: Colors.black,
            ),
          )
        ],
        backgroundColor: kPrimary,
      ),
      body: isDataLoaded == false
          ? Center(
              child: Column(
                children: [
                  check == true
                      ? const CircularProgressIndicator()
                      : const Text("ไม่พบข้อมูล"),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return const MainPage();
                        }));
                      },
                      child: const Text("กลับสู่หน้าหลัก"))
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
                            style: TextStyle(fontFamily: 'Itim', fontSize: 32),
                          ),
                          Divider(
                            thickness: 3,
                            indent: 35,
                            endIndent: 35,
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
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      "${invites![index].post.member.firstname} ได้เชิญคุณเข้าร่วมกลุ่มโพสต์แชร์สินค้า",
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
                                      children: const [
                                        Icon(Icons.account_circle)
                                      ],
                                    ),
                                    title: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${invites?[index].post.post_name}",
                                          style: const TextStyle(
                                              fontFamily: 'Itim', fontSize: 22),
                                        ),
                                        Text(
                                          "สิ้นสุด : ${outputFormat.format(invites![index].post.end_date)}",
                                          style: const TextStyle(
                                              fontFamily: 'Itim', fontSize: 18),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback(
                                        (_) {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  ConfirmInviteScreen(
                                                postId: invites?[index]
                                                    .post
                                                    .post_id,
                                                inviteId:
                                                    invites?[index].invite_id,
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
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
