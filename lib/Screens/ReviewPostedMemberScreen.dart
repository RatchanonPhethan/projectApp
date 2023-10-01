// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_project_application/Screens/ListJoinPostScreen.dart';
import 'package:flutter_project_application/widgets/customTextFormField.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

import '../Model/joinpost.dart';
import '../controller/joinpost_controller.dart';
import '../controller/review_controller.dart';
import '../styles/styles.dart';

class ReviewPostedMemberScroon extends StatefulWidget {
  String? postId;
  ReviewPostedMemberScroon({super.key, required this.postId});

  @override
  State<ReviewPostedMemberScroon> createState() =>
      _ReviewPostedMemberScroonState();
}

class _ReviewPostedMemberScroonState extends State<ReviewPostedMemberScroon> {
  JoinPostModel? joinposts;
  bool? isDataLoaded = false;
  final JoinPostController joinPostController = JoinPostController();
  final ReviewController reviewController = ReviewController();
  double? score;
  void fetchJoinPost(String memberId) async {
    joinposts = await joinPostController.getJoinPostById(memberId);
    setState(() {
      isDataLoaded = true;
    });
  }

  GlobalKey<FormState> formkey = GlobalKey();
  TextEditingController commentTextController = TextEditingController();
  var nowDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    fetchJoinPost(widget.postId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("รีวิว"),
        leading: BackButton(
          color: Colors.black,
          onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) {
            return const ListJoinPostScreen();
          })),
        ),
      ),
      body: isDataLoaded == false
          ? const CircularProgressIndicator()
          : Form(
              key: formkey,
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(children: [
                  const Text(
                    "รีวิวผู้โพสต์",
                    style: TextStyle(fontFamily: 'Itim', fontSize: 40),
                  ),
                  Text(
                    "ชื่อผู้โพสต์ : ${joinposts!.member.firstname}",
                    style: const TextStyle(fontFamily: 'Itim', fontSize: 22),
                  ),
                  Text(
                    "โพสต์ : ${joinposts!.post.post_name}",
                    style: const TextStyle(fontFamily: 'Itim', fontSize: 22),
                  ),
                  Text(
                    "วันที่ : $nowDate",
                    style: const TextStyle(fontFamily: 'Itim', fontSize: 22),
                  ),
                  RatingBar.builder(
                    initialRating: 1,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      score = rating;
                    },
                  ),
                  customTextFormField(
                    controller: commentTextController,
                    hintText: "คอมเมนต์",
                    maxLength: 255,
                    validator: (Value) {
                      if (Value!.isNotEmpty) {
                        if (Value.length < 2) {
                          return "กรุณากรอกคอมเมนต์มากกว่า 2 ตัวอักษร";
                        } else {
                          return null;
                        }
                      } else {
                        return "กรุณากรอกคอมเมนต์";
                      }
                    },
                    obscureText: false,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 10, horizontal: kDefaultPaddingH),
                    child: SizedBox(
                      height: 45,
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          if (formkey.currentState!.validate()) {
                            reviewController.addReviewMember(
                                score.toString(),
                                commentTextController.text,
                                joinposts!.payment_id);
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return const ListJoinPostScreen();
                                },
                              ),
                            );
                          }
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateColor.resolveWith(
                                (states) => loginButtonColor),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(15.0)))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text("รีวิว"),
                          ],
                        ),
                      ),
                    ),
                  ),
                ]),
              )),
            ),
    );
  }
}
