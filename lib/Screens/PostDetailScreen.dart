// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_project_application/Model/post.dart';
import 'package:flutter_project_application/Screens/JoinPostScreen.dart';
import 'package:flutter_project_application/controller/joinpost_controller.dart';
import 'package:flutter_project_application/controller/post_controller.dart';
import 'package:flutter_project_application/widgets/MenuFooter.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

import '../styles/styles.dart';
import '../widgets/MenuWidget.dart';

class PostDetailScreen extends StatefulWidget {
  final String? postId;
  const PostDetailScreen({super.key, required this.postId});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final PostController postController = PostController();
  final JoinPostController joinPostController = JoinPostController();

  PostModel? post;
  DateTime now = DateTime.now();
  bool? isDataLoaded = false;
  var sessionManager = SessionManager();
  String? user;
  int? joinCount;
  void fetchPost(String postId) async {
    user = await sessionManager.get("username");
    post = await postController.getPostById(postId);
    if (user != null) {
      joinCount =
          await joinPostController.joinCount(user.toString(), post!.post_id);
    }

    setState(() {
      isDataLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchPost(widget.postId!);
    // print(memberModel.member_id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("รายละเอียด"),
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
      backgroundColor: Colors.white,
      body: isDataLoaded == false
          ? CircularProgressIndicator()
          : Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Column(
                children: [
                  const Text(
                    "เข้าร่วมโพสต์",
                    style: TextStyle(fontFamily: 'Itim', fontSize: 32),
                  ),
                  const Divider(
                    thickness: 3,
                    indent: 35,
                    endIndent: 35,
                    color: Colors.black,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Image.asset(
                          "images/img.jpg",
                          width: 150,
                          height: 150,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "${post?.post_name}",
                    style: const TextStyle(fontFamily: 'Itim', fontSize: 28),
                  ),
                  Text("${post?.post_detail}",
                      style: const TextStyle(fontFamily: 'Itim', fontSize: 22)),
                  Text("จำนวนสินค้าที่เหลือ : ${post?.productshare_qty}",
                      style: const TextStyle(fontFamily: 'Itim', fontSize: 20),
                      textAlign: TextAlign.center),
                  Text("ราคาสินค้าต่อชิ้น : ${post?.product_price}",
                      style: const TextStyle(fontFamily: 'Itim', fontSize: 20),
                      textAlign: TextAlign.center),
                  post?.shipping == "delivery"
                      ? Text("ค่าจัดส่ง : ${post?.shipping_fee}",
                          style:
                              const TextStyle(fontFamily: 'Itim', fontSize: 20),
                          textAlign: TextAlign.center)
                      : Text("ค่าจัดส่ง : ${post?.shipping_fee}",
                          style:
                              const TextStyle(fontFamily: 'Itim', fontSize: 20),
                          textAlign: TextAlign.center),
                  Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: user == null
                          ? const Text("กรุณาเข้าสู่ระบบ",
                              style:
                                  TextStyle(fontFamily: 'Itim', fontSize: 20),
                              textAlign: TextAlign.center)
                          : post!.post_status == "CONFIRM"
                              ? const Text("โพสต์นี้ทำการยืนยันแล้ว",
                                  style: TextStyle(
                                      fontFamily: 'Itim', fontSize: 20),
                                  textAlign: TextAlign.center)
                              : post!.end_date.microsecondsSinceEpoch <
                                      now.microsecondsSinceEpoch
                                  ? const Text("ปิดรับสมาชิกแล้ว",
                                      style: TextStyle(
                                          fontFamily: 'Itim', fontSize: 20),
                                      textAlign: TextAlign.center)
                                  : joinCount! >= 1
                                      ? const Text(
                                          "ท่านได้เข้าแล้วโพสต๋แชร์นี้แล้ว",
                                          style: TextStyle(
                                              fontFamily: 'Itim', fontSize: 20),
                                          textAlign: TextAlign.center)
                                      : post!.member.login.username == user
                                          ? const Text(
                                              "ท่านได้เข้าแล้วโพสต์แชร์นี้แล้ว",
                                              style: TextStyle(
                                                  fontFamily: 'Itim',
                                                  fontSize: 20),
                                              textAlign: TextAlign.center)
                                          : btnJoinPost(context)),
                ],
              ),
            ),
      drawer: const MenuWidget(),
    );
  }

  SizedBox btnJoinPost(BuildContext context) {
    return SizedBox(
      height: 45,
      width: 200,
      child: ElevatedButton(
        onPressed: () {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => JoinPostScreen(postId: post?.post_id),
              ),
            );
          });
        },
        style: ButtonStyle(
            backgroundColor:
                MaterialStateColor.resolveWith((states) => joinButtonColor),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("เข้าร่วม"),
          ],
        ),
      ),
    );
  }
}
