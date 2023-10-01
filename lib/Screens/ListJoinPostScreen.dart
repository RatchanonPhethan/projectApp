// ignore_for_file: file_names,, use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_project_application/Screens/ListJoinMember.dart';
import 'package:flutter_project_application/controller/review_controller.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:flutter_project_application/Model/review.dart';
import '../Model/joinpost.dart';
import '../controller/joinpost_controller.dart';
import '../styles/styles.dart';
import '../widgets/CustomSearchDelegate.dart';
import '../widgets/MenuFooter.dart';
import '../widgets/MenuWidget.dart';
import 'ReviewPostedMemberScreen.dart';

class ListJoinPostScreen extends StatefulWidget {
  const ListJoinPostScreen({super.key});

  @override
  State<ListJoinPostScreen> createState() => _ListJoinPostScreenState();
}

class _ListJoinPostScreenState extends State<ListJoinPostScreen> {
  bool? isDataLoaded = false;
  bool? check = false;
  var sessionManager = SessionManager();
  List<JoinPostModel>? joinposts;
  String? member;
  String? user;
  int? review;
  late List<int> memberCount = [];
  late List<double> memberReview = [];
  // int memberCounts = 0;
  final JoinPostController joinPostController = JoinPostController();
  List<ReviewModel>? reviews;
  double scoreAvg = 0.0;
  final ReviewController reviewController = ReviewController();

  void fetchJoinPost(String memberId) async {
    joinposts = await joinPostController.listJoinPostsByMember(memberId);
    if (joinposts?.length != 0) {
      for (int i = 0; i < joinposts!.length; i++) {
        int count =
            await joinPostController.memberCount(joinposts![i].post.post_id);
        memberCount.add(count);
        double num = 0.0;
        reviews = await reviewController.ViewMemberReview(
            joinposts![i].post.member.member_id);
        if (reviews!.length > 0) {
          for (int i = 0; i < reviews!.length; i++) {
            num += reviews![i].score;
          }
          num = num / reviews!.length;
        } else {
          num = 0.0;
        }
        memberReview.add(num);
        // print(memberCount[i]);
      }
      setState(() {
        isDataLoaded = true;
      });
    } else {
      timeDuration();
    }
  }

  // void fetchReview(String memberId) async {
  //   setState(() {
  //     isDataLoaded = false;
  //   });

  //   print(num);
  //   setState(() {
  //     isDataLoaded = true;
  //   });
  // }

  // void calScoreAvg() {
  //   if (reviews!.length > 0) {
  //     for (int i = 0; i < reviews!.length; i++) {
  //       scoreAvg = scoreAvg + reviews![i].score;
  //     }
  //     scoreAvg = scoreAvg / reviews!.length;
  //     scoreAvg.toStringAsFixed(1);
  //   } else {
  //     scoreAvg = 0.0;
  //   }
  //   setState(() {
  //     isDataLoaded = true;
  //   });
  // }

  // void memberCount(String postId) async {}

  void leaveGroup(String paymentId) async {
    await joinPostController.leaveGroup(paymentId);
    setState(() {
      isDataLoaded = false;
    });
    fetchJoinPost(member.toString());
    setState(() {
      isDataLoaded = true;
    });
  }

  void confirmProduct(String paymentId) async {
    await joinPostController.confirmReceiveProduct(paymentId);
    setState(() {
      isDataLoaded = false;
    });
    fetchJoinPost(member.toString());
    setState(() {
      isDataLoaded = true;
    });
  }

  void getMemberBySession() async {
    member = await sessionManager.get("memberId");
    user = await sessionManager.get("username");
    fetchJoinPost(member.toString());
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
    getMemberBySession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "โพสต์ที่เข้าร่วม",
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
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: const [
                          Text(
                            "โพสต์ที่เข้าร่วมทั้งหมด",
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
                      padding: const EdgeInsets.all(15.0),
                      child: ListView.builder(
                        itemCount: joinposts?.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: listPost(index, context),
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

  Card listPost(int index, BuildContext context) {
    return btnViewCountMember(index);
  }

  Card btnViewCountMember(int index) {
    return btnViewMember(index);
  }

  Card btnViewMember(int index) {
    return Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 330,
              height: 194,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      width: 330,
                      height: 194,
                    ),
                  ),
                  Positioned(
                    left: 18,
                    top: 137,
                    child: Column(
                      children: [
                        SizedBox(
                          width: 80,
                          height: 15,
                          child: RatingBar.builder(
                            ignoreGestures: true,
                            initialRating: memberReview[index],
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 10,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {},
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 101,
                    top: 14,
                    child: Transform(
                      transform: Matrix4.identity()
                        ..translate(0.0, 0.0)
                        ..rotateZ(1.57),
                      child: Container(
                        width: 170,
                        decoration: const ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              strokeAlign: BorderSide.strokeAlignCenter,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 119,
                    top: 14,
                    child: SizedBox(
                      width: 199,
                      height: 33.03,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0.62,
                            top: 0.03,
                            child: Container(
                              width: 198,
                              height: 33,
                              decoration:
                                  const BoxDecoration(color: Color(0xFFD9D9D9)),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            top: 0,
                            child: SizedBox(
                              width: 199,
                              height: 33,
                              child: Text(
                                "${joinposts?[index].post.post_name}",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontFamily: 'Inter',
                                    height: 1.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 120,
                    top: 58,
                    child: SizedBox(
                      width: 62,
                      height: 18,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Container(
                              width: 62,
                              height: 18,
                              decoration:
                                  const BoxDecoration(color: Color(0xFFD9D9D9)),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            top: 0,
                            child: SizedBox(
                              width: 62,
                              height: 18,
                              child: Text(
                                "ราคา ${joinposts?[index].post.product_price} บาท",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 192,
                    top: 57.75,
                    child: SizedBox(
                      width: 54.45,
                      height: 18.25,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Container(
                              width: 54.45,
                              height: 18.15,
                              decoration:
                                  const BoxDecoration(color: Color(0xFFD9D9D9)),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            top: 0.25,
                            child: SizedBox(
                              width: 54,
                              height: 18,
                              child: Text(
                                'จำนวน ${joinposts?[index].quantity_product} ชิ้น',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 259,
                    top: 58,
                    child: SizedBox(
                      width: 59,
                      height: 18,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Container(
                              width: 59,
                              height: 18,
                              decoration:
                                  const BoxDecoration(color: Color(0xFFD9D9D9)),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            top: 0,
                            child: SizedBox(
                              width: 59,
                              height: 18,
                              child: Text(
                                'รวม ${joinposts?[index].price} บาท',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 120,
                    top: 87,
                    child: SizedBox(
                      width: 126.22,
                      height: 20,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Container(
                              width: 126.22,
                              height: 20,
                              decoration:
                                  const BoxDecoration(color: Color(0xFFD9D9D9)),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            top: 0,
                            child: SizedBox(
                              width: 126,
                              height: 20,
                              child: Text(
                                joinposts?[index].tacking_number == "-"
                                    ? 'ยังไม่มีการแจ้งเลขพัสดุ'
                                    : '${joinposts?[index].tacking_number}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 259,
                    top: 87,
                    child: SizedBox(
                      width: 59,
                      height: 20,
                      child: Stack(
                        children: [
                          // Positioned(
                          //   left: 0,
                          //   top: 0,
                          //   child: Container(
                          //     width: 59,
                          //     height: 20,
                          //     decoration:
                          //         const BoxDecoration(color: Color(0xFFD9D9D9)),
                          //   ),
                          // ),
                          Positioned(
                              // left: 0,
                              // top: 0,
                              child: ElevatedButton(
                            onPressed: () {},
                            child: const Text(
                              'แชท',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                // fontSize: 10,
                                // fontFamily: 'Inter',
                                // fontWeight: FontWeight.w400,
                                // height: 0,
                              ),
                            ),
                          )
                              // SizedBox(
                              //   width: 59,
                              //   height: 20,
                              //   child: Text(
                              //     'แชท',
                              //     textAlign: TextAlign.center,
                              //     style: TextStyle(
                              //       color: Colors.black,
                              //       fontSize: 10,
                              //       fontFamily: 'Inter',
                              //       fontWeight: FontWeight.w400,
                              //       height: 0,
                              //     ),
                              //   ),
                              // ),
                              ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 120,
                    top: 118,
                    child: SizedBox(
                      width: 126,
                      height: 20,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Container(
                              width: 126,
                              height: 20,
                              decoration:
                                  const BoxDecoration(color: Color(0xFFD9D9D9)),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            top: 0,
                            child: SizedBox(
                              width: 126,
                              height: 20,
                              child: Text(
                                'สมาชิกทั้งหมด ${memberCount[index]} คน',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 120,
                    top: 149,
                    child: SizedBox(
                      width: 126,
                      height: 25,
                      child: Stack(
                        children: [
                          // Positioned(
                          //   left: 0,
                          //   top: 0,
                          //   child: Container(
                          //     width: 126,
                          //     height: 20,
                          //     decoration:
                          //         const BoxDecoration(color: Color(0xFFD9D9D9)),
                          //   ),
                          // ),
                          Positioned(
                            // left: 0,
                            // top: 0,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) {
                                  return ListJoinMemberScreen(
                                    PostId: joinposts![index].post.post_id,
                                  );
                                }));
                              },
                              child: const Text("ดูสมาชิกทั้งหมด",
                                  textAlign: TextAlign.center),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 259,
                    top: 118,
                    child: SizedBox(
                      width: 60,
                      height: 20,
                      child: Stack(
                        children: [
                          // Positioned(
                          //   left: 0,
                          //   top: 0,
                          //   child: Container(
                          //     width: 59,
                          //     height: 20,
                          //     decoration:
                          //         const BoxDecoration(color: Color(0xFFD9D9D9)),
                          //   ),
                          // ),
                          Positioned(
                            child: joinposts?[index].pickup_status == "NO"
                                ? btnConfirm(context, index)
                                : btnReview(index, context),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 259,
                    top: 149,
                    child: SizedBox(
                      width: 60,
                      height: 25,
                      child: Stack(
                        children: [
                          // Positioned(
                          //   left: 0,
                          //   top: 0,
                          //   child: Container(
                          //     width: 59,
                          //     height: 20,
                          //     decoration:
                          //         const BoxDecoration(color: Color(0xFFD9D9D9)),
                          //   ),
                          // ),
                          Positioned(child: btnLeaveGroup(context, index)),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 11,
                    top: 107,
                    child: SizedBox(
                      width: 81,
                      height: 20.05,
                      child: Stack(
                        children: [
                          // Positioned(
                          //   left: 0,
                          //   top: 0,
                          //   child: Container(
                          //     width: 81,
                          //     height: 20,
                          //     decoration:
                          //         const BoxDecoration(color: Color(0xFFD9D9D9)),
                          //   ),
                          // ),
                          Positioned(
                            left: 0,
                            top: 0.05,
                            child: SizedBox(
                              width: 81,
                              height: 20,
                              child: Text(
                                'ผู้โพสต์ : ${joinposts?[index].post.member.firstname}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 4,
                    top: 1,
                    child: SizedBox(
                      width: 47.02,
                      height: 25,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Container(
                              width: 47.02,
                              height: 25,
                              decoration: joinposts?[index].post.post_status ==
                                      "CONFIRM"
                                  ? const BoxDecoration(
                                      color: Color.fromRGBO(64, 205, 95, 1))
                                  : const BoxDecoration(
                                      color: Color.fromRGBO(255, 61, 61, 1)),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            top: 0,
                            child: SizedBox(
                              width: 47,
                              height: 24.79,
                              child: joinposts?[index].post.post_status ==
                                      "CONFIRM"
                                  ? const Text(
                                      'ยืนยัน',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 10,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 0,
                                      ),
                                    )
                                  : const Text(
                                      'ไม่ยืนยัน',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 10,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 0,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 36,
                    top: 160,
                    child: SizedBox(
                      width: 30,
                      height: 10,
                      child: Stack(
                        children: [
                          // Positioned(
                          //   left: 0,
                          //   top: 0,
                          //   child:
                          // ),
                          Positioned(
                            left: 0,
                            top: 0,
                            child: SizedBox(
                              width: 30,
                              height: 10,
                              child: Text(
                                '${memberReview[index].toStringAsFixed(1)}/5',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 21,
                    top: 40,
                    child: Image.asset(
                      "images/img.jpg",
                      width: 57,
                      height: 57,
                    ),
                    // Container(
                    //   width: 57,
                    //   height: 57,
                    //   decoration: const ShapeDecoration(
                    //     color: Color(0xFFD9D9D9),
                    //     shape:
                    //         RoundedRectangleBorder(side: BorderSide(width: 1)),
                    //   ),
                    // ),
                  ),
                ],
              ),
            ),
          ],
        )
        // ListTile(

        //   leading: Column(
        //     mainAxisSize: MainAxisSize.max,
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: const [Icon(Icons.account_circle)],
        //   ),
        //   title: Column(
        //     mainAxisSize: MainAxisSize.max,
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Text(
        //         "${joinposts?[index].post.post_name}",
        //         style: const TextStyle(fontFamily: 'Itim', fontSize: 22),
        //       ),
        //       Text(
        //         "${joinposts?[index].post.post_status}",
        //         style: const TextStyle(fontFamily: 'Itim', fontSize: 22),
        //       ),

        // joinposts?[index].pickup_status == "NO"
        //     ? btnConfirm(context, index)
        //     : btnReview(index, context),
        // btnLeaveGroup(context, index),
        //     ],
        // ),
        // ),
        );
  }

  ElevatedButton btnLeaveGroup(BuildContext context, int index) {
    return ElevatedButton(
      onPressed: () {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('ออกกลุ่ม'),
            content: const Text('ท่านออกจากกลุ่มหรือไม่ ?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (joinposts![index].post.post_status == "CONFIRM") {
                    Navigator.pop(context, 'OK');
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('ออกกลุ่มไม่สำเร็จ!'),
                        content: const Text(
                            'กลุ่มนี้ถูกยืนยันการสั่งสินค้าแล้ว ไม่สามารถออกจากกลุ่มได้!!'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, 'OK');
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  } else if (joinposts![index].pickup_status == "CONFIRM") {
                    Navigator.pop(context, 'OK');
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('ออกกลุ่มไม่สำเร็จ!'),
                        content: const Text(
                            'ท่านได้ยืนยันการสั่งสินค้าแล้ว ไม่สามารถออกจากกลุ่มได้!!'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, 'OK');
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    Navigator.pop(context, 'OK');
                    leaveGroup(joinposts![index].payment_id);
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('ออกกลุ่มสำเร็จ!'),
                        content: const Text('ท่านออกกลุ่มแล้ว!!'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, 'OK');
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
      child: const Text("ออก", textAlign: TextAlign.center),
    );
  }

  ElevatedButton btnReview(int index, BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        review = await reviewController.reviewCount(
            joinposts![index].payment_id, joinposts![index].member.member_id);
        review! >= 1
            ? showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('รีวิวสำเร็จ!'),
                  content:
                      const Text('ท่านได้ทำการรีวิวการเข้าร่วมกลุ่มนี้แล้ว!!'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, 'OK');
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              )
            : Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return ReviewPostedMemberScroon(
                      postId: joinposts![index].payment_id,
                    );
                  },
                ),
              );
      },
      child: const Text("รีวิว", textAlign: TextAlign.center),
    );
  }

  ElevatedButton btnConfirm(BuildContext context, int index) {
    return ElevatedButton(
      onPressed: () {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('ยืนยันการรับของ'),
            content: const Text('ท่านยืนยันการรับของหรือไม่ ?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, 'OK');
                  confirmProduct(joinposts![index].payment_id);
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('ยืนยันสำเร็จ!'),
                      content: const Text('ยืนยันการรับของสำเร็จ!!'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, 'OK');
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
      child: const Text(
        "ยืนยัน",
        style: TextStyle(fontSize: 11),
      ),
    );
  }
}
