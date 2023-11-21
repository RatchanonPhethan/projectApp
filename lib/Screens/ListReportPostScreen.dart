// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_project_application/Model/joinpost.dart';
import 'package:flutter_project_application/Screens/deletePostScreen.dart';
import 'package:flutter_project_application/controller/joinpost_controller.dart';
import 'package:flutter_project_application/controller/post_controller.dart';

import '../Model/report.dart';
import '../constant/constant_value.dart';
import '../controller/report_controller.dart';
import '../styles/styles.dart';
import '../widgets/MenuFooter.dart';
import '../widgets/MenuWidget.dart';

class ListReportPostScreen extends StatefulWidget {
  const ListReportPostScreen({super.key});

  @override
  State<ListReportPostScreen> createState() => _ListReportPostScreenState();
}

class _ListReportPostScreenState extends State<ListReportPostScreen> {
  bool? isDataLoaded = false;
  bool? check = true;
  final ReportController reportController = ReportController();
  final JoinPostController joinPostController = JoinPostController();
  final PostController postController = PostController();
  List<JoinPostModel>? joinposts;
  List<ReportModel>? reports;
  List<int> countPost = [];
  String? productimg;
  String? replaceString;
  String? subproductimg;
  List<String> imgReportFileName = [];
  void fetchReportPost() async {
    reports = await reportController.listReportPost();
    if (reports!.isNotEmpty) {
      for (int i = 0; i < reports!.length; i++) {
        int count =
            await reportController.reportPostCount(reports![i].post.post_id);

        countPost.add(count);
        String strimg = reports![i].post.img_product.first;
        replaceString = strimg.replaceAll("[", "").replaceAll("]", "");
        List<String> listfilepath =
            replaceString!.split(",").map((s) => s.trim()).toList();
        subproductimg = listfilepath
            .elementAt(0)
            .substring(listfilepath.elementAt(0).lastIndexOf("/") + 1);
        imgReportFileName.add(subproductimg!);
      }
      setState(() {
        isDataLoaded = true;
      });
    } else {
      timeDuration();
    }
  }

  void fetchCountPost() async {
    setState(() {
      isDataLoaded = true;
    });
  }

  void timeDuration() {
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
    fetchReportPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("รายชื่อการรายงานโพสต์",
            style: TextStyle(fontFamily: 'Itim', color: KFontColor)),
        leading: BackButton(
          color: Colors.black,
          onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) {
            return const MainPage();
          })),
        ),
        backgroundColor: kPrimary,
      ),
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
                      : const Text(
                          "ไม่พบการรายงานโพสต์",
                          style: TextStyle(fontFamily: 'Itim', fontSize: 18),
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
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: const [
                          Text(
                            "รายชื่อการรายงานโพสต์",
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
                              leading: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.network(
                                        '$baseURL/post/${imgReportFileName[index]}',
                                        width: 40,
                                        height: 45,
                                        fit: BoxFit.cover),
                                  ]),
                              title: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "โพสต์ : ${reports?[index].post.post_name}",
                                    style: const TextStyle(
                                        fontFamily: 'Itim', fontSize: 18),
                                  ),
                                  Text(
                                    "ผู้โพสต์ : ${reports?[index].post.member.login.username}",
                                    style: const TextStyle(
                                        fontFamily: 'Itim', fontSize: 18),
                                  ),
                                  Text(
                                    "จำนวนรายงาน : ${countPost[index]} รายงาน",
                                    style: const TextStyle(
                                        fontFamily: 'Itim', fontSize: 18),
                                  ),
                                ],
                              ),
                              trailing: null,
                              onTap: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return DeletePostScreen(
                                          postId: reports![index].post.post_id);
                                    },
                                  ),
                                );
                              },
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
