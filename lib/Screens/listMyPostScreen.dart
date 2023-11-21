import 'dart:async';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../Model/member.dart';
import '../Model/post.dart';
import '../Model/review.dart';
import '../constant/constant_value.dart';
import '../controller/ConfirmPostController.dart';
import '../controller/invite_controller.dart';
import '../controller/joinpost_controller.dart';
import '../controller/listMyPostController.dart';
import '../controller/member_controller.dart';
import '../controller/removePostController.dart';
import '../styles/styles.dart';
import '../widgets/MenuFooter.dart';
import '../widgets/MenuWidget.dart';
import 'InviteMemberScreen.dart';
import 'chatPosterScreen.dart';
import 'editPostScreen.dart';
import 'listJoinMemberScreen.dart';

class ListMyPostPage extends StatefulWidget {
  const ListMyPostPage({super.key});

  // String postId;
  // ListMyPostPage({Key? key, required this.postId}) : super(key: key);

  @override
  State<ListMyPostPage> createState() => _ListMyPostPageState();
}

class _ListMyPostPageState extends State<ListMyPostPage> {
  List<PostModel>? post;
  List<ReviewModel>? review;
  bool? isDataLoaded = false;
  MemberModel? memberid;
  String? user;
  ListMyPostController listMyPostController = ListMyPostController();
  RemovePostController removePostController = RemovePostController();
  MemberController memberController = MemberController();
  JoinPostController joinPostController = JoinPostController();
  ConfirmPostController confirmPostController = ConfirmPostController();
  InviteController inviteController = InviteController();
  int sum = 0;
  bool check = true;
  List<int> memberCounts = [];
  String? productimg;
  String? replaceString;
  String? subproductimg;
  DateTime exppost = DateTime.now();

  var outputFormat = DateFormat("dd/MM/yyyy HH:mm a");

  void FetchListMyPost() async {
    user = await SessionManager().get("username");
    memberid = await memberController.getMemberByUsername(user!);
    review = await inviteController.dolistInvitesByMember(memberid!.member_id);
    post = await listMyPostController.getLisyMyPost(user!);
    if (post!.isNotEmpty) {
      for (int i = 0; i < post!.length; i++) {
        int? summember = await joinPostController.memberCount(post![i].post_id);
        memberCounts.add(summember!);
      }
      setState(() {
        isDataLoaded = true;
      });
    } else {
      timeDuration();
    }
  }

  void membercount(String paymentid) async {
    sum = await joinPostController.memberCount(paymentid);
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

  void haveMemberAlert() {
    QuickAlert.show(
      context: context,
      title: "มีสมาชิกอยู่ในโพสต์นี้",
      text: "ไม่สามารถลบโพสต์นี้ได้",
      type: QuickAlertType.error,
      confirmBtnText: "ตกลง",
      confirmBtnColor: const Color.fromARGB(255, 42, 230, 4),
      onConfirmBtnTap: () {
        Navigator.pop(context);
      },
    );
  }

  void removePostAlert(String postId) {
    QuickAlert.show(
      context: context,
      title: "ต้องการจะลบโพสต์นี้ใช่หรือไม่?",
      type: QuickAlertType.confirm,
      showCancelBtn: true,
      confirmBtnText: "ตกลง",
      cancelBtnText: "ปฏิเสธ",
      cancelBtnTextStyle:
          const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      confirmBtnColor: const Color.fromARGB(255, 42, 230, 4),
      onConfirmBtnTap: () async {
        removePostController.removePost(postId);
        await Future.delayed(const Duration(milliseconds: 1000));
        // ignore: use_build_context_synchronously
        await QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: "ลบโพสต์สำเร็จ",
        );
        Navigator.of(context).pushReplacement(CupertinoPageRoute(
          builder: (BuildContext context) {
            return const ListMyPostPage();
          },
        ));
      },
      onCancelBtnTap: () {
        Navigator.pop(context);
      },
    );
  }

  void confirmPost(String postid) {
    QuickAlert.show(
      context: context,
      title: "ยืนยันโพสต์",
      text: "คุณต้องการจะยืนยันโพสต์แชร์สินค้า?",
      type: QuickAlertType.confirm,
      confirmBtnText: "ตกลง",
      confirmBtnColor: const Color.fromARGB(255, 42, 230, 4),
      cancelBtnText: "ปฏิเสธ",
      onCancelBtnTap: () {
        Navigator.pop(context);
      },
      onConfirmBtnTap: () async {
        confirmPostController.confirmpost(postid);
        Navigator.of(context).pushReplacement(CupertinoPageRoute(
          builder: (BuildContext context) {
            return const ListMyPostPage();
          },
        ));
      },
    );
  }

  void alertconfirmPost() {
    QuickAlert.show(
      context: context,
      title: "คำเตือน",
      text: "ไม่สามารถยืนยันโพสต์ได้",
      type: QuickAlertType.error,
      confirmBtnText: "ตกลง",
      confirmBtnColor: const Color.fromARGB(255, 42, 230, 4),
      onConfirmBtnTap: () async {
        Navigator.pop(context);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    FetchListMyPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimary,
        title: Text(
          "โพสต์ทั้งหมดของฉัน",
          style: TextStyle(color: KFontColor, fontFamily: 'Itim'),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 224, 226, 226),
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
                            "ท่านยังไม่สร้างแชร์สินค้า",
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
          : Container(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                  itemCount: post?.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    String strimg = post![index].img_product.toString();
                    replaceString =
                        strimg.replaceAll("[", "").replaceAll("]", "");
                    List<String> listfilepath =
                        replaceString!.split(",").map((s) => s.trim()).toList();

                    subproductimg = listfilepath.elementAt(0).substring(
                        listfilepath.elementAt(0).lastIndexOf("/") + 1);

                    return SingleChildScrollView(
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        child: Container(
                            padding: const EdgeInsets.all(10),
                            constraints: const BoxConstraints(maxWidth: 1000),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Text(
                                    "${post?[index].post_name}",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Itim',
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Image.network(
                                        "$baseURL/post/$subproductimg",
                                        width: 80,
                                        height: 80,
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: post![index]
                                                        .end_date
                                                        .isBefore(exppost) &&
                                                    post?[index].post_status ==
                                                        "OPEN"
                                                ? const Text(
                                                    "ปิดรับ",
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15,
                                                        fontFamily: 'Itim'),
                                                  )
                                                : post?[index].post_status ==
                                                        "CONFIRM"
                                                    ? const Text(
                                                        "ยืนยันโพสต์สำเร็จ",
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    0,
                                                                    255,
                                                                    85),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15,
                                                            fontFamily: 'Itim'),
                                                      )
                                                    : post?[index]
                                                                .post_status ==
                                                            "OPEN"
                                                        ? const Text(
                                                            "เปิดรับถึงวันที่",
                                                            style: TextStyle(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        13,
                                                                        0,
                                                                        255),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 15,
                                                                fontFamily:
                                                                    'Itim'))
                                                        : Container()),
                                        Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Text(
                                            outputFormat.format(post?[index]
                                                .end_date as DateTime),
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'Itim'),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Text(
                                            "สมาชิกทั้งหมด ${memberCounts[index]}/${post![index].member_amount}",
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'Itim'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                //ดูสมาชิกกลุ่ม
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: IconButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pushReplacement(
                                              CupertinoPageRoute(
                                                builder:
                                                    (BuildContext context) {
                                                  return ListJoinMemberPage(
                                                    post_id:
                                                        post![index].post_id,
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                          icon: const Icon(EvaIcons.people),
                                          color: const Color.fromARGB(
                                              255, 0, 0, 0),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: IconButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pushReplacement(
                                              CupertinoPageRoute(
                                                builder:
                                                    (BuildContext context) {
                                                  return ChatPosterScreen(
                                                    memberId:
                                                        memberid!.member_id,
                                                    postId:
                                                        post![index].post_id,
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                          icon: const Icon(Icons.chat_outlined),
                                          color: Colors.lightBlue,
                                        ),
                                      ),
                                    ),
                                    //แก้ไข
                                    post?[index].post_status == "OPEN"
                                        ? Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: IconButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                          CupertinoPageRoute(
                                                    builder:
                                                        (BuildContext context) {
                                                      return EditPostPage(
                                                        post_id:
                                                            '${post?[index].post_id}',
                                                        memberAmonut:
                                                            '${memberCounts[index]}',
                                                      );
                                                    },
                                                  ));
                                                },
                                                icon: const Icon(EvaIcons.edit),
                                                color: const Color.fromARGB(
                                                    255, 0, 0, 0),
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    //ลบโพสต์
                                    post?[index].post_status == "OPEN" &&
                                            memberCounts[index] == 0
                                        ? Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: IconButton(
                                                onPressed: () {
                                                  if (memberCounts[index] ==
                                                      0) {
                                                    removePostAlert(
                                                        post![index].post_id);
                                                  }
                                                },
                                                icon: const Icon(Icons.delete),
                                                color: Colors.red,
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    //เชิญเพื่อน
                                    post![index].end_date.isBefore(exppost) &&
                                            post?[index].post_status == "OPEN"
                                        ? Container()
                                        : post?[index].post_status == "OPEN"
                                            ? Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10),
                                                  child: IconButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pushReplacement(
                                                              CupertinoPageRoute(
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                        return InviteMemberPage(
                                                            post_id:
                                                                post![index]
                                                                    .post_id);
                                                      }));
                                                    },
                                                    icon: const Icon(
                                                        EvaIcons.personAdd),
                                                    color: const Color.fromARGB(
                                                        255, 5, 7, 6),
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                    //ยืนยันโพสต์
                                    post![index].end_date.isBefore(exppost) &&
                                            post?[index].post_status == "OPEN"
                                        ? Container()
                                        : post?[index].post_status == "OPEN"
                                            ? Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10),
                                                  child: IconButton(
                                                      onPressed: () {
                                                        if (memberCounts[
                                                                index] ==
                                                            0) {
                                                          alertconfirmPost();
                                                        } else {
                                                          confirmPost(
                                                              post![index]
                                                                  .post_id);
                                                        }
                                                      },
                                                      icon: const Icon(
                                                          Icons.approval),
                                                      color: kPrimary),
                                                ),
                                              )
                                            : Container(),
                                  ],
                                ),
                              ],
                            )),
                      ),
                    );
                  }),
            ),
      drawer: const MenuWidget(),
    );
  }
}
