// ignore_for_file: unnecessary_null_comparison, prefer_is_empty

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_project_application/Model/review.dart';
import 'package:flutter_project_application/controller/review_controller.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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

  void fetchReview(String memberId) async {
    reviews = await reviewController.ViewMemberReview(memberId);
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
          style: TextStyle(color: KFontColor),
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
                padding: const EdgeInsets.only(top: 25, bottom: 40),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const Text(
                            "ดูรีวิวทั้งหมด",
                            style: TextStyle(fontFamily: 'Itim', fontSize: 32),
                          ),
                          const Divider(
                            thickness: 3,
                            indent: 35,
                            endIndent: 35,
                            color: Colors.black,
                          ),
                          RatingBar.builder(
                            ignoreGestures: true,
                            initialRating: scoreAvg,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {},
                          ),
                          reviews! == null
                              ? const Text(
                                  "คะแนนทั้งหมด 0/5",
                                  style: TextStyle(
                                      fontFamily: 'Itim', fontSize: 28),
                                )
                              : Text(
                                  "คะแนนทั้งหมด ${scoreAvg.toStringAsFixed(1)}/5",
                                  style: const TextStyle(
                                      fontFamily: 'Itim', fontSize: 28),
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
                              leading: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: const [Icon(Icons.account_circle)],
                              ),
                              title: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${reviews?[index].payment_id.post.post_name}",
                                    style: const TextStyle(
                                        fontFamily: 'Itim', fontSize: 22),
                                  ),
                                  Text(
                                    "${reviews?[index].comment}",
                                    style: const TextStyle(
                                        fontFamily: 'Itim', fontSize: 22),
                                  ),
                                  RatingBar.builder(
                                    ignoreGestures: true,
                                    initialRating: reviews![index].score,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemPadding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
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
