import 'dart:async';
import 'dart:io';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_application/Screens/queryScreen.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:intl/intl.dart';

import '../Model/post.dart';
import '../constant/constant_value.dart';
import '../controller/addpost_controller.dart';
import '../controller/joinpost_controller.dart';
import '../controller/member_controller.dart';
import '../controller/review_controller.dart';
import '../controller/viewProfileController.dart';
import '../styles/styles.dart';
import '../widgets/MenuWidget.dart';
import 'PostDetailScreen.dart';
import 'ViewMemberReviewScreen.dart';

class SearchPostPage extends StatefulWidget {
  const SearchPostPage({super.key});

  @override
  State<SearchPostPage> createState() => _SearchPostPageState();
}

class _SearchPostPageState extends State<SearchPostPage> {
  List<PostModel>? post;
  bool? isDataLoaded = false;
  bool? checkUser = false;
  String? user;
  String? subimg;
  List<int> memberCounts = [];
  File? _imgProfile;
  bool? check = false;
  String? productimg;
  String? subproductimg;
  String? replaceString;
  List<double> starscore = [];
  String? memberid;
  DateTime exppost = DateTime.now();
  Duration? difference;

  var outputFormat = DateFormat("dd/MM/yyyy HH:mm");

  final addPostController postController = addPostController();
  final ViewProfileController viewProfileController = ViewProfileController();
  final JoinPostController joinPostController = JoinPostController();
  final ReviewController reviewController = ReviewController();
  final MemberController memberController = MemberController();

  void fetchPost() async {
    user = await SessionManager().get("username");
    post = await postController.getListAllPost();
    for (int i = 0; i < post!.length; i++) {
      int? sum = await joinPostController.memberCount(post![i].post_id);
      memberCounts.add(sum!);
      starscore
          .add(await reviewController.getRating(post![i].member.member_id));
    }
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
    fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimary,
        title: Text(
          "หน้าหลัก",
          style: TextStyle(color: KFontColor, fontFamily: 'Itim'),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    CupertinoPageRoute(builder: (BuildContext context) {
                  return const QueryPage();
                }));
              },
              icon: const Icon(Icons.search))
        ],
      ),
      drawer: const MenuWidget(),
      // ignore: prefer_const_constructors
      body: isDataLoaded == false
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                backgroundColor: Colors.grey,
              ),
            )
          : Container(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                itemCount: post?.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  String filePath = "${post?[index].member.img_member}";
                  subimg = filePath.substring(
                      filePath.lastIndexOf('/') + 1, filePath.length);
                  String strimg = post![index].img_product.toString();
                  replaceString =
                      strimg.replaceAll("[", "").replaceAll("]", "");
                  List<String> listfilepath =
                      replaceString!.split(",").map((s) => s.trim()).toList();

                  print(listfilepath.length);
                  productimg = listfilepath.elementAt(0);
                  subproductimg = (productimg!.substring(
                    productimg!.lastIndexOf("/") + 1,
                  ));
                  print(starscore[index]);
                  difference = post?[index].end_date.difference(exppost);
                  return SingleChildScrollView(
                    child: Stack(
                      children: [
                        Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          child: ListTile(
                            title: Container(
                              padding: const EdgeInsets.all(10),
                              constraints: const BoxConstraints(maxWidth: 1000),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Text(
                                      "${post?[index].post_name}",
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Itim'),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(builder:
                                                  (BuildContext context) {
                                            return ViewMemberReviewScreen(
                                                memberId: post?[index]
                                                    .member
                                                    .member_id);
                                          }));
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(180),
                                          child: Image.network(
                                            ("$baseURL/member/$subimg"),
                                            height: 80,
                                            width: 80,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Image.network(
                                        ("$baseURL/post/$subproductimg"),
                                        height: 80,
                                        width: 80,
                                        fit: BoxFit.cover,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15),
                                        child: Text(
                                          "${post?[index].member.firstname}",
                                          style: const TextStyle(
                                              fontSize: 15, fontFamily: 'Itim'),
                                        ),
                                      ),
                                      Text(
                                        "ราคา ${post?[index].product_price} บาท",
                                        style: const TextStyle(
                                            fontSize: 15, fontFamily: 'Itim'),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            child: RatingBar.builder(
                                              ignoreGestures: true,
                                              initialRating: starscore[index],
                                              minRating: 1,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              itemSize: 10,
                                              itemPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 1.0),
                                              itemBuilder: (context, _) =>
                                                  const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              onRatingUpdate: (rating) {},
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            child: Text(
                                              "${starscore[index]}",
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontFamily: 'Itim'),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          const Text(
                                            "จำนวนสินค้าทั้งหมด",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'Itim'),
                                          ),
                                          Text(
                                            "${post?[index].productshare_qty}",
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'Itim'),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          const Text(
                                            "สมาชิกทั้งหมด",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'Itim'),
                                          ),
                                          Text(
                                            "${memberCounts[index]}/${post?[index].member_amount}",
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'Itim'),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Padding(
                                            padding: EdgeInsets.all(8),
                                            child: Text(
                                              "เปิดรับถึงวันที่",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily: 'Itim'),
                                            )),
                                        Text(
                                          '${outputFormat.format(post?[index].end_date as DateTime)} น.',
                                          style: const TextStyle(
                                              fontSize: 15, fontFamily: 'Itim'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () => Navigator.of(context).pushReplacement(
                                CupertinoPageRoute(
                                    builder: (BuildContext context) {
                              return PostDetailScreen(
                                  postId: '${post?[index].post_id}');
                            })),
                          ),
                        ),
                        difference!.inDays <= 1
                            ? Positioned(
                                top: 5,
                                right: 30,
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 255, 0, 0),
                                    shape: BoxShape.rectangle,
                                  ),
                                  child: const Icon(
                                    EvaIcons.clock,
                                    size: 24,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  );
                },
              )),
    );
  }
}
