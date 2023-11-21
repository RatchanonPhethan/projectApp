import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_project_application/Model/report.dart';
import 'package:flutter_project_application/Screens/banMemberScreen.dart';
import 'package:flutter_project_application/controller/report_controller.dart';

import '../constant/constant_value.dart';
import '../styles/styles.dart';
import '../widgets/MenuFooter.dart';
import '../widgets/MenuWidget.dart';

class ListReportMemberScreen extends StatefulWidget {
  const ListReportMemberScreen({super.key});

  @override
  State<ListReportMemberScreen> createState() => _ListReportMemberScreenState();
}

class _ListReportMemberScreenState extends State<ListReportMemberScreen> {
  bool? isDataLoaded = false;
  bool check = true;
  ReportController reportController = ReportController();
  List<ReportModel>? reports;
  List<int> countMember = [];
  List<String> imgMemberFileName = [];

  void fetchPost() async {
    reports = await reportController.listReportMember();
    if (reports!.isNotEmpty) {
      for (int i = 0; i < reports!.length; i++) {
        int count = await reportController.reportMemberCount(
            reports![i].member.member_id, reports![i].post.post_id);
        print(count);
        countMember.add(count);
        String filePath = reports?[i].member.img_member ?? "";
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
    Timer(const Duration(milliseconds: 2000), () {
      setState(() {
        check = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("รายชื่อการรายงานสมาชิก",
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
                          "ไม่พบการรายงานสมาชิก",
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
                            "รายชื่อการรายงานสมาชิก",
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
                                    "ชื่อผู้ใช้ : ${reports?[index].member.firstname} ${reports?[index].member.lastname}",
                                    style: const TextStyle(
                                        fontFamily: 'Itim', fontSize: 18),
                                  ),
                                  Text(
                                    "ชื่อบัญชี : ${reports?[index].member.login.username}",
                                    style: const TextStyle(
                                        fontFamily: 'Itim', fontSize: 18),
                                  ),
                                  Text(
                                    "จำนวนรายงาน : ${countMember[index]} รายงาน",
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
                                      return BanMemberScreen(
                                          memberId:
                                              reports![index].member.member_id);
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
