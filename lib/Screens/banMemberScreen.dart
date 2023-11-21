import 'dart:async';

import 'package:flutter/material.dart';

import '../Model/report.dart';
import '../constant/constant_value.dart';
import '../controller/ban_controller.dart';
import '../controller/report_controller.dart';
import '../styles/styles.dart';
import '../widgets/BanMemberWidget.dart';
import '../widgets/CustomSearchDelegate.dart';
import '../widgets/MenuWidget.dart';
import 'ListReportMemberScreen.dart';

class BanMemberScreen extends StatefulWidget {
  String memberId;
  BanMemberScreen({super.key, required this.memberId});

  @override
  State<BanMemberScreen> createState() => _BanMemberScreenState();
}

class _BanMemberScreenState extends State<BanMemberScreen> {
  bool? isDataLoaded = false;
  bool? check = false;
  final ReportController reportController = ReportController();
  List<ReportModel>? reports;
  List<String> imgReporeFileName = [];
  List<String> imgMemberFileName = [];

  void removeRepost(String memberId) async {
    await reportController.removeReportMemberById(memberId);
  }

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

  void fetchReportMember(String memberId) async {
    reports = await reportController.getListReportMemberById(memberId);
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
    fetchReportMember(widget.memberId);
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
            return const ListReportMemberScreen();
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
                                    "โพสต์ : ${reports?[index].post.post_name}",
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
                              // onTap: () {}
                            ),
                          );
                        },
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BanMemberWidget(memberId: widget.memberId),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text(
                                    'ลบคำร้อง',
                                    style: TextStyle(fontFamily: 'Itim'),
                                    textAlign: TextAlign.center,
                                  ),
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
                                        removeRepost(widget.memberId);
                                        Navigator.pop(context, 'ตกลง');
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
                                                        return const ListReportMemberScreen();
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
