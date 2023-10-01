import 'package:flutter/material.dart';
import 'package:flutter_project_application/Model/joinpost.dart';
import 'package:flutter_project_application/Model/member.dart';
import 'package:flutter_project_application/Model/post.dart';
import 'package:flutter_project_application/Screens/PostDetailScreen.dart';
import 'package:flutter_project_application/controller/joinpost_controller.dart';
import 'package:flutter_project_application/controller/member_controller.dart';
import 'package:flutter_project_application/controller/post_controller.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:intl/intl.dart';

import '../styles/styles.dart';
import '../widgets/CustomSearchDelegate.dart';
import '../widgets/MenuWidget.dart';
import '../widgets/ReportPostWidget.dart';
import 'ViewMemberReviewScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<PostModel>? posts;
  var sessionManager = SessionManager();
  MemberModel? member;
  bool? isDataLoaded = false;
  String? user;
  List<JoinPostModel>? joinposts;
  var outputFormat = DateFormat('MM/dd/yyyy hh:mm a');
  var outputDate;

  final PostController postController = PostController();
  final JoinPostController joinPostController = JoinPostController();
  final MemberController memberController = MemberController();

  void fetchPost() async {
    posts = await postController.listAllPosts();
    user = await sessionManager.get("username");
    fetchMemberByUser(user.toString());
    setState(() {
      isDataLoaded = true;
    });
  }

  void fetchMemberByUser(String username) async {
    member = await memberController.getMemberByUsername(username);
    await SessionManager().set("memberId", member!.member_id.toString());
  }

  void fetchJoinPost() async {
    joinposts = await joinPostController.listJoinPosts();
    setState(() {
      isDataLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    // fetchJoinPost();
    // fetchMemberByUser(user!);
    fetchPost();
    // print(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Home",
          style: TextStyle(color: KFontColor),
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
          ? const CircularProgressIndicator()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 30),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: const [
                          Text(
                            "โพสต์แชร์ทั้งหมด",
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
                            itemCount: posts?.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: ListTile(
                                      leading: SizedBox(
                                        height: 200,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                        MaterialPageRoute(
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                  return ViewMemberReviewScreen(
                                                      memberId: posts?[index]
                                                          .member
                                                          .member_id);
                                                }));
                                              },
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateColor
                                                          .resolveWith(
                                                              (states) => Colors
                                                                  .greenAccent)),
                                              child: const Icon(
                                                  Icons.account_circle),
                                            )
                                          ],
                                        ),
                                      ),
                                      title: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${posts?[index].post_name}",
                                            style: const TextStyle(
                                                fontFamily: 'Itim',
                                                fontSize: 22),
                                          ),
                                          Text(
                                            outputFormat
                                                .format(posts![index].end_date),
                                            style: const TextStyle(
                                                fontFamily: 'Itim',
                                                fontSize: 18),
                                          ),
                                        ],
                                      ),
                                      trailing: ReportPostWidget(
                                        postId: posts?[index].post_id,
                                        member:
                                            posts?[index].member.login.username,
                                      ),
                                      onTap: () {
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      PostDetailScreen(
                                                          postId: posts?[index]
                                                              .post_id)));
                                        });
                                      }));
                            })),
                  ],
                ),
              ),
            ),
      drawer: const MenuWidget(),
    );
  }
}
