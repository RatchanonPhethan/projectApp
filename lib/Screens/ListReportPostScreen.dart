// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_project_application/Model/joinpost.dart';
import 'package:flutter_project_application/controller/joinpost_controller.dart';
import 'package:flutter_project_application/controller/post_controller.dart';

import '../Model/report.dart';
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
  final ReportController reportController = ReportController();
  final JoinPostController joinPostController = JoinPostController();
  final PostController postController = PostController();
  List<JoinPostModel>? joinposts;
  List<ReportModel>? reports;
  int? countMember;

  void fetchReportPost() async {
    reports = await reportController.listReportPost();
    setState(() {
      isDataLoaded = true;
    });
  }

  void removePost(String postId) async {
    if (joinposts!.isNotEmpty) {
      for (int i = 0; i < joinposts!.length; i++) {
        print(joinposts![i].payment_id);
        await joinPostController.leaveGroup(joinposts![i].payment_id);
      }
    }
    await postController.removePost(postId);
    setState(() {
      isDataLoaded = false;
    });
    fetchReportPost();
    setState(() {
      isDataLoaded = true;
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
        title: const Text("รายชื่อการรายงานโพสต์"),
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
                            "รายชื่อการรายงานโพสต์",
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
                                    "${reports?[index].post.post_name}",
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
                              trailing: ElevatedButton(
                                onPressed: () {
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: const Text('ลบโพสต์'),
                                      content: const Text(
                                          'คุณต้องการลบโพสต์นี้หรือไม่ ?'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'Cancel'),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            joinposts = await joinPostController
                                                .getJoinPostByPostId(
                                                    reports![index]
                                                        .post
                                                        .post_id);

                                            Navigator.pop(context, 'OK');
                                            showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                title: const Text(
                                                    'ดำเนินการสำเร็จ!'),
                                                content: const Text(
                                                    'คุณได้ลบโพสต์นี้แล้ว!!'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context, 'OK');
                                                      removePost(reports![index]
                                                          .post
                                                          .post_id);
                                                    },
                                                    child: const Text('OK'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateColor.resolveWith(
                                            (states) => Colors.redAccent)),
                                child: const Text("ลบโพสต์"),
                              ),
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
