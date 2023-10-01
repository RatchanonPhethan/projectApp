// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_project_application/Screens/ListJoinPostScreen.dart';

import '../Model/joinpost.dart';
import '../controller/joinpost_controller.dart';
import '../styles/styles.dart';
import '../widgets/CustomSearchDelegate.dart';
import '../widgets/MenuWidget.dart';
import '../widgets/ReportMemberWidget.dart';

class ListJoinMemberScreen extends StatefulWidget {
  String PostId;
  ListJoinMemberScreen({super.key, required this.PostId});

  @override
  State<ListJoinMemberScreen> createState() => _ListJoinMemberScreenState();
}

class _ListJoinMemberScreenState extends State<ListJoinMemberScreen> {
  bool? isDataLoaded = false;
  bool? check = false;
  List<JoinPostModel>? joinposts;
  final JoinPostController joinPostController = JoinPostController();

  void fetchJoinPost(String memberId) async {
    joinposts = await joinPostController.listJoinMember(memberId);
    print(joinposts![0].payment_id);
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
    fetchJoinPost(widget.PostId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "รายชื่อสมาชิกทั้งหมด",
          style: TextStyle(color: KFontColor),
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
                      ? CircularProgressIndicator()
                      : const Text("ไม่พบข้อมูล"),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return const ListJoinPostScreen();
                        }));
                      },
                      child: Text("กลับสู่หน้าหลัก"))
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
                            "สมาชิกทั้งหมด",
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
                            itemCount: joinposts?.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: ListTile(
                                      leading: const Icon(Icons.account_circle),
                                      title: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "${joinposts?[index].member.login.username}",
                                                style: const TextStyle(
                                                    fontFamily: 'Itim',
                                                    fontSize: 22),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      trailing: ReportMemberWidget(
                                        postId: joinposts?[index].post.post_id,
                                        member: joinposts?[index]
                                            .member
                                            .login
                                            .username,
                                      ),
                                      onTap: () {}));
                            })),
                  ],
                ),
              ),
            ),
      drawer: const MenuWidget(),
    );
  }
}
