// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_project_application/Screens/ListJoinPostScreen.dart';
import 'package:flutter_project_application/controller/member_controller.dart';
import 'package:flutter_project_application/controller/post_controller.dart';
import 'package:flutter_project_application/controller/report_controller.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

import '../Model/joinpost.dart';
import '../Model/member.dart';
import '../constant/constant_value.dart';
import '../controller/joinpost_controller.dart';
import '../styles/styles.dart';
import '../widgets/CustomSearchDelegate.dart';
import '../widgets/MenuWidget.dart';
import '../widgets/ReportMemberWidget.dart';

class ListJoinMemberScreen extends StatefulWidget {
  String postId;
  ListJoinMemberScreen({super.key, required this.postId});

  @override
  State<ListJoinMemberScreen> createState() => _ListJoinMemberScreenState();
}

class _ListJoinMemberScreenState extends State<ListJoinMemberScreen> {
  bool? isDataLoaded = false;
  bool? check = false;
  List<JoinPostModel>? joinposts;
  final JoinPostController joinPostController = JoinPostController();
  final ReportController reportController = ReportController();
  final MemberController memberController = MemberController();
  late List<int> reportMemberCount = [];
  List<String> imgMemberFileName = [];
  MemberModel? member;
  String? imgPostMemberFileName;
  int reportCount = 0;

  var sessionManager = SessionManager();
  String? user;
  void fetchJoinPost(String postId) async {
    user = await sessionManager.get("username");
    joinposts = await joinPostController.listJoinMember(postId);

    if (joinposts != null) {
      for (int i = 0; i < joinposts!.length; i++) {
        int count = await reportController.reportMemberCount(
            joinposts![i].member.member_id, postId);
        reportMemberCount.add(count);
        String filePath = joinposts?[i].member.img_member ?? "";
        String img = filePath.substring(
            filePath.lastIndexOf('/') + 1, filePath.length - 2);
        imgMemberFileName.add(img.toString());
      }
      member = await memberController
          .getMemberById(joinposts![0].post.member.member_id);
      int count =
          await reportController.reportMemberCount(member!.member_id, postId);
      reportCount = count;
      String filePath = member!.img_member;
      String img = filePath.substring(
          filePath.lastIndexOf('/') + 1, filePath.length - 2);
      imgPostMemberFileName = img.toString();
    }
    setState(() {
      isDataLoaded = true;
    });
  }

  void TimeDuration() {
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
    TimeDuration();
    fetchJoinPost(widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "รายชื่อสมาชิกทั้งหมด",
          style: TextStyle(color: KFontColor, fontFamily: 'Itim'),
        ),
        leading: BackButton(
          color: Colors.black,
          onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) {
            return const ListJoinPostScreen();
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
                      : const Text(
                          "ไม่พบข้อมูล",
                          style: TextStyle(fontFamily: 'Itim'),
                        ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return const ListJoinPostScreen();
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
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          const Text(
                            "ผู้โพสต์",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontFamily: 'Itim', fontSize: 20),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: GestureDetector(
                              child: ClipOval(
                                child: SizedBox.fromSize(
                                  size:
                                      const Size.fromRadius(48), // Image radius
                                  child: Image.network(
                                      '$baseURL/member/${imgPostMemberFileName!}',
                                      width: 150,
                                      height: 200,
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ),
                          ),
                          Stack(children: [
                            SizedBox(
                              child: Positioned(
                                child: Container(
                                  child: member!.login.username == user
                                      ? null
                                      : reportCount == 0
                                          ? ReportMemberWidget(
                                              postId: widget.postId,
                                              member: member!.login.username,
                                            )
                                          : null,
                                ),
                              ),
                            ),
                          ]),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 30, top: 10),
                            child: Text(
                              "ชื่อ: ${member!.firstname} ${member!.lastname}",
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                  fontFamily: 'Itim', fontSize: 18),
                            ),
                          ),
                          const Text(
                            "สมาชิกทั้งหมด",
                            style: TextStyle(fontFamily: 'Itim', fontSize: 20),
                          ),
                          const Divider(
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
                        itemCount: joinposts?.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: ListTile(
                              leading: ClipOval(
                                child: SizedBox.fromSize(
                                  size:
                                      const Size.fromRadius(20), // Image radius
                                  child: Image.network(
                                      '$baseURL/member/${imgMemberFileName[index]}',
                                      width: 10,
                                      height: 10,
                                      fit: BoxFit.cover),
                                ),
                              ),
                              title: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${joinposts?[index].member.firstname} ${joinposts?[index].member.lastname}",
                                    style: const TextStyle(
                                        fontFamily: 'Itim', fontSize: 18),
                                  ),
                                  Text(
                                    "จำนวนสินค้าที่ซื้อ ${joinposts?[index].quantity_product} ชิ้น",
                                    style: const TextStyle(
                                        fontFamily: 'Itim', fontSize: 16),
                                  ),
                                ],
                              ),
                              trailing: joinposts?[index]
                                          .member
                                          .login
                                          .username ==
                                      user
                                  ? null
                                  : reportMemberCount[index] == 0
                                      ? ReportMemberWidget(
                                          postId:
                                              joinposts![index].post.post_id,
                                          member: joinposts![index]
                                              .member
                                              .login
                                              .username,
                                        )
                                      : null,
                              // onTap: () {},
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
      drawer: const MenuWidget(),
    );
  }
}
