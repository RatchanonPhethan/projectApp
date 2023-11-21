// ignore_for_file: unnecessary_null_comparison, prefer_is_empty

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_project_application/Model/member.dart';
import 'package:flutter_project_application/Model/review.dart';
import 'package:flutter_project_application/controller/member_controller.dart';
import 'package:flutter_project_application/controller/review_controller.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../constant/constant_value.dart';
import '../styles/styles.dart';
import '../widgets/CustomSearchDelegate.dart';
import '../widgets/MenuFooter.dart';

class ViewMemberReviewScreen extends StatefulWidget {
  final String? memberId;
  const ViewMemberReviewScreen({super.key, required this.memberId});

  @override
  State<ViewMemberReviewScreen> createState() => _ViewMemberReviewScreenState();
}

class _ViewMemberReviewScreenState extends State<ViewMemberReviewScreen> {
  bool? isDataLoaded = false;
  bool? check = false;
  List<ReviewModel>? reviews;
  double scoreAvg = 0.0;
  final ReviewController reviewController = ReviewController();
  final MemberController memberController = MemberController();
  MemberModel? member;
  String? imgMemberFileName;
  List<String> imgMemberReviewFileName = [];

  void fetchReview(String memberId) async {
    reviews = await reviewController.ViewMemberReview(memberId);
    member = await memberController.getMemberById(memberId);
    String filePath = member?.img_member ?? "";
    String img =
        filePath.substring(filePath.lastIndexOf('/') + 1, filePath.length - 2);
    imgMemberFileName = img;
    for (int i = 0; i < reviews!.length; i++) {
      String filePath = reviews?[i].payment_id.member.img_member ?? "";
      String img = filePath.substring(
          filePath.lastIndexOf('/') + 1, filePath.length - 2);
      imgMemberReviewFileName.add(img.toString());
    }
    calScoreAvg();
    setState(() {
      isDataLoaded = true;
    });
  }

  void calScoreAvg() {
    if (reviews!.length > 0) {
      for (int i = 0; i < reviews!.length; i++) {
        scoreAvg = scoreAvg + reviews![i].score;
      }
      scoreAvg = scoreAvg / reviews!.length;
      scoreAvg.toStringAsFixed(1);
    } else {
      scoreAvg = 0.0;
    }

    setState(() {
      isDataLoaded = true;
    });
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

  @override
  void initState() {
    super.initState();
    timeDuration();
    fetchReview(widget.memberId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "ดูรีวิวทั้งหมด",
          style: TextStyle(color: KFontColor, fontFamily: 'Itim'),
        ),
        leading: BackButton(
          color: Colors.black,
          onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) {
            return const MainPage();
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
                          style: TextStyle(fontFamily: 'Itim'),
                        ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return const MainPage();
                        }));
                      },
                      child: const Text("กลับสู่หน้าหลัก",
                          style: TextStyle(fontFamily: 'Itim')))
                ],
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 25, bottom: 40),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const Text(
                            "ดูรีวิวทั้งหมด",
                            style: TextStyle(fontFamily: 'Itim', fontSize: 20),
                          ),
                          const Divider(
                            thickness: 1,
                            indent: 50,
                            endIndent: 50,
                            color: Colors.black,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipOval(
                                  child: SizedBox.fromSize(
                                    size: const Size.fromRadius(
                                        48), // Image radius
                                    child: Image.network(
                                        '$baseURL/member/${imgMemberFileName!}',
                                        width: 150,
                                        height: 200,
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Column(
                                    children: [
                                      Text(
                                        "username: ${member!.login.username}",
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                            fontFamily: 'Itim', fontSize: 18),
                                      ),
                                      Text(
                                        "ชื่อ: ${member!.firstname} ${member!.lastname}",
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                            fontFamily: 'Itim', fontSize: 18),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RatingBar.builder(
                              ignoreGestures: true,
                              initialRating: scoreAvg,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 30,
                              itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 1.0),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {},
                            ),
                          ),
                          reviews! == null
                              ? const Text(
                                  "คะแนนทั้งหมด 0/5",
                                  style: TextStyle(
                                      fontFamily: 'Itim', fontSize: 18),
                                )
                              : Text(
                                  "คะแนนทั้งหมด ${scoreAvg.toStringAsFixed(1)}/5",
                                  style: const TextStyle(
                                      fontFamily: 'Itim', fontSize: 18),
                                ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(15.0),
                      child: ListView.builder(
                        itemCount: reviews?.length,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
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
                                      '$baseURL/member/${imgMemberReviewFileName[index]}',
                                      width: 10,
                                      height: 10,
                                      fit: BoxFit.cover),
                                ),
                              ),
                              title: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "โพสต์ : ${reviews?[index].payment_id.post.post_name}",
                                    style: const TextStyle(
                                        fontFamily: 'Itim', fontSize: 18),
                                  ),
                                  Text(
                                    "ผู้รีวิว : ${reviews?[index].payment_id.member.firstname} ${reviews?[index].payment_id.member.lastname}",
                                    style: const TextStyle(
                                        fontFamily: 'Itim', fontSize: 18),
                                  ),
                                  Text(
                                    "คอมเมนต์ : ${reviews?[index].comment}",
                                    style: const TextStyle(
                                        fontFamily: 'Itim', fontSize: 18),
                                  ),
                                  Text(
                                    "จำนวนที่ซื้อ : ${reviews?[index].payment_id.quantity_product} ชิ้น",
                                    style: const TextStyle(
                                        fontFamily: 'Itim', fontSize: 18),
                                  ),
                                  RatingBar.builder(
                                    ignoreGestures: true,
                                    initialRating: reviews![index].score,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemSize: 30,
                                    itemPadding: const EdgeInsets.symmetric(
                                        horizontal: 1.0),
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {},
                                  ),
                                ],
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
    );
  }
}
