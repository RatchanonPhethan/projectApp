import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_project_application/Model/report.dart';
import 'package:flutter_project_application/controller/report_controller.dart';

import '../styles/styles.dart';
import '../widgets/BanMemberWidget.dart';
import '../widgets/CustomSearchDelegate.dart';
import '../widgets/MenuFooter.dart';
import '../widgets/MenuWidget.dart';

class ListReportMemberScreen extends StatefulWidget {
  const ListReportMemberScreen({super.key});

  @override
  State<ListReportMemberScreen> createState() => _ListReportMemberScreenState();
}

class _ListReportMemberScreenState extends State<ListReportMemberScreen> {
  bool? isDataLoaded = false;
  ReportController reportController = ReportController();
  List<ReportModel>? reports;

  void fetchPost() async {
    reports = await reportController.listReportMember();

    setState(() {
      isDataLoaded = true;
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
        title: const Text("รายชื่อการรายงานสมาชิก"),
        leading: BackButton(
          color: Colors.black,
          onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) {
            return const MainPage();
          })),
        ),
        centerTitle: true,
        backgroundColor: kPrimary,
      ),
      body: isDataLoaded == false
          ? const CircularProgressIndicator()
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
                            "รายชื่อการรายงานสมาชิก",
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
                        itemCount: reports?.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: ListTile(
                              leading: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [Icon(Icons.account_circle)],
                              ),
                              title: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${reports?[index].member.firstname} ${reports?[index].member.lastname}",
                                    style: const TextStyle(
                                        fontFamily: 'Itim', fontSize: 22),
                                  ),
                                  Text(
                                    "${reports?[index].detail}",
                                    style: const TextStyle(
                                        fontFamily: 'Itim', fontSize: 22),
                                  ),
                                ],
                              ),
                              trailing: BanMemberWidget(
                                  member:
                                      reports?[index].member.login.username),
                              onTap: () {
                                // WidgetsBinding.instance.addPostFrameCallback((_) {
                                //   Navigator.pushReplacement(
                                //       context,
                                //       MaterialPageRoute(
                                //           builder: (_) => PostDetailScreen(
                                //               postId: posts?[index].post_id)));
                                // });
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
