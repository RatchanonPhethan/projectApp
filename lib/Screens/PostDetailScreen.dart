import 'dart:io';

import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:intl/intl.dart';

import '../Model/post.dart';
import '../constant/constant_value.dart';
import '../controller/joinpost_controller.dart';
import '../controller/post_controller.dart';
import '../styles/styles.dart';
import '../widgets/MenuFooter.dart';
import '../widgets/MenuWidget.dart';
import 'JoinPostScreen.dart';
import 'loginScreen.dart';

class PostDetailScreen extends StatefulWidget {
  final String? postId;
  const PostDetailScreen({super.key, required this.postId});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final PostController postController = PostController();
  final JoinPostController joinPostController = JoinPostController();
  var outputFormat = DateFormat("dd/MM/yyyy HH:mm");
  PostModel? post;
  List<PostModel>? posts;
  int? sum;
  DateTime now = DateTime.now();
  bool? isDataLoaded = false;
  var sessionManager = SessionManager();
  String? user;
  int? joinCount;
  String? productimg;
  String replaceString = "";
  String? subproductimg;
  List<File> listimg = [];
  List<String> listimgstr = [];
  void fetchPost(String postId) async {
    user = await sessionManager.get("username");
    post = await postController.getPostById(postId);
    posts = await postController.getListAllPost();
    sum = await joinPostController.memberCount(widget.postId!);
    print(sum);
    if (user != null) {
      joinCount =
          await joinPostController.joinCount(user.toString(), post!.post_id);
    }
    String strimg = post!.img_product.toString();
    replaceString = strimg.replaceAll("[", "").replaceAll("]", "");
    List<String> listfilepath =
        replaceString.split(",").map((s) => s.trim()).toList();

    for (int index = 0; index < listfilepath.length; index++) {
      print(listfilepath);
      productimg = listfilepath.elementAt(index);
      subproductimg = (productimg!.substring(
        productimg!.lastIndexOf("/") + 1,
      ));
      print(subproductimg);
      listimgstr.add(subproductimg!);
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
        title: const Text(
          "รายละเอียด",
          style: TextStyle(fontFamily: 'Itim'),
        ),
        leading: BackButton(
          color: Colors.black,
          onPressed: () => Navigator.of(context).pushReplacement(
              CupertinoPageRoute(builder: (BuildContext context) {
            return const MainPage();
          })),
        ),
        centerTitle: true,
        backgroundColor: kPrimary,
      ),
      backgroundColor: Colors.white,
      body: isDataLoaded == false
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                backgroundColor: Colors.grey,
              ),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                          height: 200.0,
                          width: 200.0,
                          decoration: BoxDecoration(
                              border: Border.all(
                            color: const Color.fromARGB(255, 108, 108, 108),
                            width: 0.5,
                          )),
                          child: AnotherCarousel(
                            images: [
                              for (int index = 0;
                                  index < listimgstr.length;
                                  index++)
                                NetworkImage(
                                    "$baseURL/post/${listimgstr[index]}"),
                            ],
                            dotSize: 4.0,
                            dotSpacing: 15.0,
                            dotColor: const Color.fromARGB(255, 0, 25, 253),
                            indicatorBgPadding: 5.0,
                            dotBgColor: const Color.fromARGB(255, 0, 0, 0)
                                .withOpacity(0.5),
                            borderRadius: true,
                            moveIndicatorFromBottom: 180.0,
                            noRadiusForIndicator: true,
                          )),
                    ),
                    const Divider(
                      thickness: 1,
                      indent: 35,
                      endIndent: 35,
                      color: Colors.black,
                    ),
                    Text(
                      "${post?.post_name}",
                      style: const TextStyle(fontFamily: 'Itim', fontSize: 25),
                    ),
                    Text("${post?.post_detail}",
                        style:
                            const TextStyle(fontFamily: 'Itim', fontSize: 15)),
                    const Divider(
                      thickness: 1,
                      indent: 35,
                      endIndent: 35,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "วันที่ปิดรับสมาชิก",
                            style: TextStyle(fontFamily: 'Itim', fontSize: 15),
                          ),
                          Text(
                            '${outputFormat.format(post!.end_date)} น.',
                            style: const TextStyle(
                                fontFamily: 'Itim', fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "จำนวนสินค้าที่เหลือ",
                            style: TextStyle(fontFamily: 'Itim', fontSize: 15),
                          ),
                          Text(
                            "${post?.productshare_qty}",
                            style: const TextStyle(
                                fontFamily: 'Itim', fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "ราคาสินค้าต่อชิ้น",
                            style: TextStyle(fontFamily: 'Itim', fontSize: 15),
                          ),
                          Text(
                            "${post?.product_price}",
                            style: const TextStyle(
                                fontFamily: 'Itim', fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    post!.shipping == "PickUp"
                        ? Padding(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  "สถานะการจัดส่ง",
                                  style: TextStyle(
                                      fontFamily: 'Itim', fontSize: 15),
                                ),
                                Text(
                                  "นัดรับ",
                                  style: TextStyle(
                                      fontFamily: 'Itim', fontSize: 15),
                                ),
                              ],
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  "สถานะการจัดส่ง",
                                  style: TextStyle(
                                      fontFamily: 'Itim', fontSize: 15),
                                ),
                                Text(
                                  "จัดส่ง",
                                  style: TextStyle(
                                      fontFamily: 'Itim', fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "ค่าจัดส่ง",
                            style: TextStyle(fontFamily: 'Itim', fontSize: 15),
                          ),
                          Text(
                            "${post?.shipping_fee}",
                            style: const TextStyle(
                                fontFamily: 'Itim', fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: user == null
                            ? ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (BuildContext context) {
                                    return const LoginApp();
                                  }));
                                },
                                child: const Text("กรุณาเข้าสู่ระบบ"))
                            : post!.post_status == "CONFIRM"
                                ? const Text("โพสต์นี้ทำการยืนยันแล้ว",
                                    style: TextStyle(
                                        fontFamily: 'Itim', fontSize: 20),
                                    textAlign: TextAlign.center)
                                : post!.end_date.microsecondsSinceEpoch <
                                            now.microsecondsSinceEpoch ||
                                        post!.member_amount == sum
                                    ? const Text("ปิดรับสมาชิกแล้ว",
                                        style: TextStyle(
                                            fontFamily: 'Itim', fontSize: 20),
                                        textAlign: TextAlign.center)
                                    : joinCount! >= 1
                                        ? const Text(
                                            "ท่านได้เข้าแล้วโพสต์แชร์นี้แล้ว",
                                            style: TextStyle(
                                                fontFamily: 'Itim',
                                                fontSize: 20),
                                            textAlign: TextAlign.center)
                                        : post!.member.login.username == user
                                            ? null
                                            : btnJoinPost(context)),
                  ],
                ),
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
                builder: (_) => JoinPostScreen(postId: post!.post_id),
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
