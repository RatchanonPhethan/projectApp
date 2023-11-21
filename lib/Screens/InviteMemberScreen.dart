import 'dart:async';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_project_application/Screens/listMyPostScreen.dart';
import 'package:flutter_project_application/controller/invite_controller.dart';
import 'package:flutter_project_application/controller/member_controller.dart';
import 'package:flutter_project_application/styles/styles.dart';
import 'package:flutter_project_application/widgets/CustomSearchDelegate.dart';
import 'package:flutter_project_application/widgets/MenuFooter.dart';
import 'package:flutter_project_application/widgets/MenuWidget.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

import '../Model/member.dart';
import '../Model/review.dart';
import '../constant/constant_value.dart';

class InviteMemberPage extends StatefulWidget {
  String post_id;
  InviteMemberPage({Key? key, required this.post_id}) : super(key: key);

  @override
  State<InviteMemberPage> createState() => _InviteMemberPageState();
}

class _InviteMemberPageState extends State<InviteMemberPage> {
  bool isDataLoaded = false;
  String? user;
  List<ReviewModel>? review;
  bool check = true;
  MemberModel? member;
  InviteController inviteController = InviteController();
  MemberController memberController = MemberController();
  List<int> checkinvite = [];
  List<String> imgMemberFileName = [];
  void fetchinvite() async {
    user = await SessionManager().get("username");
    member = await memberController.getMemberByUsername(user!);
    review = await inviteController.dolistInvitesByMember(member!.member_id);
    if (review!.isNotEmpty) {
      for (int index = 0; index < review!.length; index++) {
        checkinvite.add(await inviteController.checkInvite(
            review![index].payment_id.member.member_id, widget.post_id));
        String filePath = review?[index].payment_id.member.img_member ?? "";
        String img = filePath.substring(
            filePath.lastIndexOf('/') + 1, filePath.length - 2);
        imgMemberFileName.add(img.toString());
      }
      setState(() {
        isDataLoaded = true;
      });
    } else {
      timeDuration();
    }
  }

  void timeDuration() {
    setState(() {
      check = true;
    });
    Timer(const Duration(milliseconds: 1000), () {
      setState(() {
        check = false;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchinvite();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimary,
        title: Text(
          "เชิญเพื่อน",
          style: TextStyle(color: KFontColor, fontFamily: 'Itim'),
        ),
        leading: BackButton(
          color: Colors.black,
          onPressed: () => Navigator.of(context).pushReplacement(
              CupertinoPageRoute(builder: (BuildContext context) {
            return const ListMyPostPage();
          })),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: CustomSearchDelegate());
              },
              icon: const Icon(Icons.search))
        ],
      ),
      backgroundColor: Color.fromARGB(255, 224, 226, 226),
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
                            "ไม่พบสมาชิกที่เคยเข้าร่วมโพสต์แชร์",
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
          : ListView.builder(
              itemCount: review!.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return SingleChildScrollView(
                  child: Column(children: [
                    Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                            leading: ClipOval(
                              child: SizedBox.fromSize(
                                size: const Size.fromRadius(20), // Image radius
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${review?[index].payment_id.member.firstname}",
                                      style: const TextStyle(
                                          fontFamily: 'Itim', fontSize: 16),
                                    ),
                                    // ignore: unrelated_type_equality_checks
                                    checkinvite[index] == 1
                                        ? const Text(
                                            "เชิญสำเร็จ",
                                            style: TextStyle(
                                                fontFamily: 'Itim',
                                                fontSize: 12,
                                                color: Colors.green),
                                          )
                                        : IconButton(
                                            alignment: Alignment.centerRight,
                                            onPressed: () async {
                                              inviteController.addInvite(
                                                  widget.post_id,
                                                  review![index]
                                                      .payment_id
                                                      .member
                                                      .member_id);
                                              await Future.delayed(
                                                  const Duration(
                                                      milliseconds: 1000));
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                      CupertinoPageRoute(
                                                          builder: (BuildContext
                                                              context) {
                                                return InviteMemberPage(
                                                    post_id: widget.post_id);
                                              }));
                                            },
                                            icon:
                                                const Icon(EvaIcons.personAdd),
                                            color: Colors.green,
                                          )
                                  ],
                                ),
                              ],
                            ),
                            onTap: () {}))
                  ]),
                );
              }),
    );
  }
}
