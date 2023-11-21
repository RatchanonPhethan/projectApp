import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_project_application/Model/report.dart';
import 'package:flutter_project_application/Screens/ListReportPostScreen.dart';
import 'package:flutter_project_application/controller/report_controller.dart';

import '../Model/joinpost.dart';
import '../constant/constant_value.dart';
import '../controller/joinpost_controller.dart';
import '../controller/post_controller.dart';
import '../styles/styles.dart';
import '../widgets/CustomSearchDelegate.dart';
import '../widgets/MenuWidget.dart';

class DeletePostScreen extends StatefulWidget {
  String postId;
  DeletePostScreen({super.key, required this.postId});

  @override
  State<DeletePostScreen> createState() => _DeletePostScreenState();
}

class _DeletePostScreenState extends State<DeletePostScreen> {
  bool? isDataLoaded = false;
  bool? check = false;
  final ReportController reportController = ReportController();
  final JoinPostController joinPostController = JoinPostController();
  final PostController postController = PostController();
  List<JoinPostModel>? joinposts;
  List<ReportModel>? reports;
  List<String> imgReporeFileName = [];
  List<String> imgMemberFileName = [];

  void timeDuration() {
    setState(() {
      check = true;
    });
    Timer(const Duration(milliseconds: 3000), () {
      setState(() {
        check = false;
      });
    });
  }

  void removePost(String postId) async {
    joinposts = await joinPostController.getJoinPostByPostId(postId);
    if (joinposts!.isNotEmpty) {
      for (int i = 0; i < joinposts!.length; i++) {
        if (joinposts![i].post.post_status != 'CONFIRM') {
          await joinPostController.leaveGroup(joinposts![i].payment_id);
        }
      }
    }
    await postController.removePost(postId);
  }

  void removeRepost(String postId) async {
    await reportController.removeReportPostById(postId);
  }

  void fetchReportPost(String postId) async {
    reports = await reportController.getListReportPostById(postId);
    for (int i = 0; i < reports!.length; i++) {
      String filePath = reports?[i].img_report ?? "";
      String img = filePath.substring(
          filePath.lastIndexOf('/') + 1, filePath.length - 2);
      print(img);
      imgReporeFileName.add(img.toString());
      filePath = reports?[i].member.img_member ?? "";
      img = filePath.substring(
          filePath.lastIndexOf('/') + 1, filePath.length - 2);
      imgMemberFileName.add(img.toString());
    }

    setState(() {
      isDataLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    timeDuration();
    fetchReportPost(widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "รายละเอียดทั้งหมด",
          style: TextStyle(
            color: KFontColor,
            fontFamily: 'Itim',
          ),
        ),
        leading: BackButton(
          color: Colors.black,
          onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) {
            return const ListReportPostScreen();
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
                          style: TextStyle(
                            fontFamily: 'Itim',
                          ),
                        ),
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
                        children: const [
                          Text(
                            "รายละเอียดการรายงานทั้งหมด",
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
                        itemCount: reports?.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: ListTile(
                                  leading: ClipOval(
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
                                  title: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "ผู้รายงาน : ${reports?[index].member.firstname} ${reports?[index].member.lastname}",
                                        style: const TextStyle(
                                            fontFamily: 'Itim', fontSize: 18),
                                      ),
                                      Text(
                                        "รายละเอียด : ${reports?[index].detail}",
                                        style: const TextStyle(
                                            fontFamily: 'Itim', fontSize: 18),
                                      ),
                                      Image.network(
                                        '$baseURL/report/${imgReporeFileName[index]}',
                                        height: 460,
                                      ),
                                    ],
                                  ),
                                  trailing: null,
                                  onTap: () {}));
                        },
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('ลบโพสต์',
                                    style: TextStyle(fontFamily: 'Itim')),
                                content: const Text(
                                    'คุณต้องการลบโพสต์นี้หรือไม่ ?',
                                    style: TextStyle(fontFamily: 'Itim')),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'ยกเลิก'),
                                    child: const Text('ยกเลิก'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.pop(context, 'ตกลง');
                                      removePost(widget.postId);
                                      showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          title: const Text('ดำเนินการสำเร็จ!',
                                              style: TextStyle(
                                                  fontFamily: 'Itim')),
                                          content: const Text(
                                              'คุณได้ลบโพสต์นี้แล้ว!!',
                                              style: TextStyle(
                                                  fontFamily: 'Itim')),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                // Navigator.pop(context, 'OK');
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                  MaterialPageRoute(
                                                    builder:
                                                        (BuildContext context) {
                                                      return const ListReportPostScreen();
                                                    },
                                                  ),
                                                );
                                              },
                                              child: const Text('ตกลง',
                                                  style: TextStyle(
                                                      fontFamily: 'Itim')),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    child: const Text('ตกลง',
                                        style: TextStyle(fontFamily: 'Itim')),
                                  ),
                                ],
                              ),
                            );
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.redAccent)),
                          label: const Text(
                            "ลบโพสต์",
                            style: TextStyle(
                              fontFamily: 'Itim',
                            ),
                          ),
                          icon: const Icon(
                            Icons.delete_forever_outlined,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('ลบคำร้อง',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontFamily: 'Itim')),
                                  content: const Text(
                                      'คุณต้องการลบคำร้องหรือไม่ ?',
                                      style: TextStyle(fontFamily: 'Itim')),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'ยกเลิก'),
                                      child: const Text('ยกเลิก',
                                          style: TextStyle(fontFamily: 'Itim')),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        removeRepost(widget.postId);
                                        Navigator.pop(context, 'OK');
                                        showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                            title: const Text(
                                                'ดำเนินการสำเร็จ!',
                                                style: TextStyle(
                                                    fontFamily: 'Itim')),
                                            content: const Text('ลบสำเร็จ!!',
                                                style: TextStyle(
                                                    fontFamily: 'Itim')),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  // Navigator.pop(context, 'OK');
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                    MaterialPageRoute(
                                                      builder: (BuildContext
                                                          context) {
                                                        return const ListReportPostScreen();
                                                      },
                                                    ),
                                                  );
                                                },
                                                child: const Text('ตกลง',
                                                    style: TextStyle(
                                                        fontFamily: 'Itim')),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      child: const Text('ตกลง',
                                          style: TextStyle(fontFamily: 'Itim')),
                                    ),
                                  ],
                                ),
                              );
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.white)),
                            icon: const Icon(
                              Icons.delete_forever_outlined,
                              color: Colors.red,
                              size: 25,
                            ),
                            label: const Text(
                              "ลบคำร้อง",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Itim',
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
      drawer: const MenuWidget(),
    );
  }
}
