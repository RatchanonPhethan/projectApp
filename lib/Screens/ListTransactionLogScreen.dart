// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_project_application/Model/transactionlog.dart';
import 'package:flutter_project_application/controller/transactionlog_controller.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:intl/intl.dart';

import '../styles/styles.dart';
import '../widgets/MenuFooter.dart';
import '../widgets/MenuWidget.dart';

class ListTransactionLogScreen extends StatefulWidget {
  const ListTransactionLogScreen({super.key});

  @override
  State<ListTransactionLogScreen> createState() =>
      _ListTransactionLogScreenState();
}

class _ListTransactionLogScreenState extends State<ListTransactionLogScreen> {
  bool? isDataLoaded = false;
  bool? check = false;
  var sessionManager = SessionManager();
  List<TransactionLogModel>? logs;
  String? member;
  String? user;
  final TransactionLogController transactionLogController =
      TransactionLogController();
  var outputFormat = DateFormat("dd/MM/yyyy HH:mm");
  var outputDate;

  void fetchLog(String memberId) async {
    logs = await transactionLogController.listLogsByMember(memberId);
    setState(() {
      isDataLoaded = true;
    });
  }

  void getMemberBySession() async {
    member = await sessionManager.get("memberId");
    user = await sessionManager.get("username");
    fetchLog(member.toString());
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
    getMemberBySession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "แจ้งเตือน",
          style: TextStyle(color: KFontColor, fontFamily: 'Itim'),
        ),
        backgroundColor: kPrimary,
      ),
      drawer: const MenuWidget(),
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
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: const [
                          Text(
                            "แจ้งเตือนทั้งหมด",
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
                    Column(
                      children: [
                        SizedBox(
                          width: 120,
                          height: 30,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              await transactionLogController
                                  .removeLogByMemberId(member.toString());
                              setState(() {
                                isDataLoaded = false;
                                getMemberBySession();
                              });
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.red)),
                            icon: const Icon(Icons.delete_forever_outlined),
                            label: const Text(
                              'ลบทั้งหมด',
                              style:
                                  TextStyle(fontFamily: 'Itim', fontSize: 14),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: logs?.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: ListTile(
                                  leading: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    // crossAxisAlignment:
                                    //     CrossAxisAlignment.center,
                                    // mainAxisSize: MainAxisSize.max,
                                    children: const [
                                      Icon(
                                        Icons.warning_amber_rounded,
                                        color: Colors.red,
                                      )
                                    ],
                                  ),
                                  title: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${logs?[index].post.post_name}",
                                        style: const TextStyle(
                                            fontFamily: 'Itim', fontSize: 18),
                                      ),
                                      Text(
                                        "${logs?[index].log_detail}",
                                        style: const TextStyle(
                                            fontFamily: 'Itim', fontSize: 18),
                                      ),
                                      Text(
                                        '${outputFormat.format(logs![0].log_date)} น.',
                                        style: const TextStyle(
                                            fontFamily: 'Itim', fontSize: 18),
                                      ),
                                    ],
                                  ),
                                  trailing: SizedBox(
                                    width: 20,
                                    height: 40,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          left: -17,
                                          child: ElevatedButton.icon(
                                            onPressed: () async {
                                              await transactionLogController
                                                  .removeLogById(logs![index]
                                                      .transaction_id);
                                              setState(() {
                                                isDataLoaded = false;
                                                getMemberBySession();
                                              });
                                            },
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateColor
                                                        .resolveWith((states) =>
                                                            Colors.white)),
                                            icon: const Icon(
                                              Icons.delete_forever_outlined,
                                              color: Colors.red,
                                            ),
                                            label: const Text(
                                              '',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
