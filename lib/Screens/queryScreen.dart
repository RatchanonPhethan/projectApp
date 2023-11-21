import 'dart:io';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

import '../Model/post.dart';
import '../constant/constant_value.dart';
import '../controller/joinpost_controller.dart';
import '../controller/review_controller.dart';
import '../controller/searchPost_controller.dart';
import '../styles/styles.dart';
import '../widgets/MenuFooter.dart';
import 'PostDetailScreen.dart';
import 'ViewMemberReviewScreen.dart';

class QueryPage extends StatefulWidget {
  const QueryPage({super.key});

  @override
  State<QueryPage> createState() => _QueryPageState();
}

class _QueryPageState extends State<QueryPage> {
  SearchPostController searchPostController = SearchPostController();
  TextEditingController queryController = TextEditingController();
  JoinPostController joinPostController = JoinPostController();
  ReviewController reviewController = ReviewController();
  List<PostModel> post = [];
  bool? isDataLoaded = false;
  String? subimg;
  List<int> memberCounts = [];
  File? _imgProfile;
  String? productimg;
  String? subproductimg;
  String? replaceString;
  List<double> starscore = [];
  DateTime exppost = DateTime.now();
  Duration? difference;
  bool istextsearchempty = false;

  var outputFormat = DateFormat("dd/MM/yyyy HH:mm");

  void fetchquery() async {
    setState(() {
      isDataLoaded = false;
    });
    post = await searchPostController.serachpost(queryController.text);
    for (int i = 0; i < post.length; i++) {
      int? sum = await joinPostController.memberCount(post[i].post_id);
      memberCounts.add(sum!);
      starscore.add(await reviewController.getRating(post[i].member.member_id));
    }
    setState(() {
      isDataLoaded = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimary,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
                CupertinoPageRoute(builder: (BuildContext context) {
              return const MainPage();
            }));
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: TextFormField(
          controller: queryController,
          maxLength: 10,
          maxLines: 1,
          style: const TextStyle(fontFamily: 'Itim'),
          keyboardType: TextInputType.text,
          obscureText: false,
          validator: (value) {
            if (value!.isNotEmpty) {
              return null;
            } else {
              return "ไม่พบข้อมูล";
            }
          },
          decoration: const InputDecoration(
            hintText: "ค้นหา..",
            counterText: "",
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                if (queryController.text.isNotEmpty) {
                  setState(() {
                    istextsearchempty = false;
                    fetchquery();
                  });
                } else {
                  setState(() {
                    istextsearchempty = true;
                  });
                }
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: queryController.text.isEmpty ||
              post.isEmpty ||
              istextsearchempty == true
          ? const Center(
              child: Text("ไม่พบข้อมูล"),
            )
          : isDataLoaded == false
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    backgroundColor: Colors.grey,
                  ),
                )
              : Container(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView.builder(
                    itemCount: post.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      String filePath = post[index].member.img_member;
                      subimg = filePath.substring(
                          filePath.lastIndexOf('/') + 1, filePath.length);
                      String strimg = post[index].img_product.toString();
                      replaceString =
                          strimg.replaceAll("[", "").replaceAll("]", "");
                      List<String> listfilepath = replaceString!
                          .split(",")
                          .map((s) => s.trim())
                          .toList();

                      print(listfilepath.length);
                      productimg = listfilepath.elementAt(0);
                      subproductimg = (productimg!.substring(
                        productimg!.lastIndexOf("/") + 1,
                      ));
                      print(starscore[index]);
                      difference = post[index].end_date.difference(exppost);
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
                                  constraints:
                                      const BoxConstraints(maxWidth: 1000),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Text(
                                          post[index].post_name,
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
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                      MaterialPageRoute(builder:
                                                          (BuildContext
                                                              context) {
                                                return ViewMemberReviewScreen(
                                                    memberId: post[index]
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
                                              post[index].member.firstname,
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontFamily: 'Itim'),
                                            ),
                                          ),
                                          Text(
                                            "ราคา ${post[index].product_price} บาท",
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'Itim'),
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
                                                padding: const EdgeInsets.only(
                                                    left: 5),
                                                child: RatingBar.builder(
                                                  ignoreGestures: true,
                                                  initialRating:
                                                      starscore[index],
                                                  minRating: 1,
                                                  direction: Axis.horizontal,
                                                  allowHalfRating: true,
                                                  itemCount: 5,
                                                  itemSize: 10,
                                                  itemPadding: const EdgeInsets
                                                          .symmetric(
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
                                                padding: const EdgeInsets.only(
                                                    left: 5),
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
                                                "${post[index].productshare_qty}",
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
                                                "${memberCounts[index]}/${post[index].member_amount}",
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
                                              '${outputFormat.format(post[index].end_date)} น.',
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontFamily: 'Itim'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () => Navigator.of(context)
                                    .pushReplacement(CupertinoPageRoute(
                                        builder: (BuildContext context) {
                                  return PostDetailScreen(
                                      postId: post[index].post_id);
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
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
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
