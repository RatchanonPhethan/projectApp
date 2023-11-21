// ignore_for_file: file_names,, use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_project_application/Screens/ListJoinMember.dart';
import 'package:flutter_project_application/Screens/chatScreen.dart';
import 'package:flutter_project_application/controller/review_controller.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:flutter_project_application/Model/review.dart';
import '../Model/joinpost.dart';
import '../constant/constant_value.dart';
import '../controller/joinpost_controller.dart';
import '../controller/report_controller.dart';
import '../styles/styles.dart';
import '../widgets/CustomSearchDelegate.dart';
import '../widgets/MenuFooter.dart';
import '../widgets/MenuWidget.dart';
import '../widgets/ReportPostWidget.dart';
import 'ReviewPostedMemberScreen.dart';

class ListJoinPostScreen extends StatefulWidget {
  const ListJoinPostScreen({super.key});

  @override
  State<ListJoinPostScreen> createState() => _ListJoinPostScreenState();
}

class _ListJoinPostScreenState extends State<ListJoinPostScreen> {
  bool? isDataLoaded = false;
  bool? check = true;
  var sessionManager = SessionManager();
  List<JoinPostModel>? joinposts;
  String? member;
  String? user;
  List<int> reviewCount = [];
  late List<int> memberCount = [];
  late List<double> memberReview = [];
  List<int> countPost = [];
  String? productimg;
  String? replaceString;
  String? subproductimg;
  List<String> imgProductFileName = [];
  // int memberCounts = 0;
  final JoinPostController joinPostController = JoinPostController();
  List<ReviewModel>? reviews;
  double scoreAvg = 0.0;
  final ReviewController reviewController = ReviewController();
  final ReportController reportController = ReportController();

  void fetchJoinPost(String memberId) async {
    setState(() {
      isDataLoaded = false;
    });
    joinposts = await joinPostController.listJoinPostsByMember(memberId);
    if (joinposts?.length != 0) {
      imgProductFileName.clear();
      for (int i = 0; i < joinposts!.length; i++) {
        int count =
            await joinPostController.memberCount(joinposts![i].post.post_id);
        memberCount.add(count);
        int review = await reviewController.reviewCount(
            joinposts![i].payment_id, joinposts![i].member.member_id);
        reviewCount.add(review);
        double num = 0.0;
        reviews = await reviewController.ViewMemberReview(
            joinposts![i].post.member.member_id);
        int countReport =
            await reportController.reportPostCount(joinposts![i].post.post_id);
        countPost.add(countReport);
        String strimg = joinposts![i].post.img_product.first;
        replaceString = strimg.replaceAll("[", "").replaceAll("]", "");
        List<String> listfilepath =
            replaceString!.split(",").map((s) => s.trim()).toList();
        subproductimg = listfilepath
            .elementAt(0)
            .substring(listfilepath.elementAt(0).lastIndexOf("/") + 1);
        imgProductFileName.add(subproductimg!);
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
    getMemberBySession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "โพสต์ที่เข้าร่วม",
          style: TextStyle(color: KFontColor, fontFamily: 'Itim'),
        ),
        backgroundColor: kPrimary,
      ),
      drawer: const MenuWidget(),
      body: isDataLoaded == false
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  check == true
                      ? const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blue),
                          backgroundColor: Colors.grey,
                        )
                      : const Padding(
                          padding: EdgeInsets.only(top: 50, bottom: 15),
                          child: Text(
                            "ท่านยังไม่เข้าร่วมแชร์สินค้าของผู้อื่น",
                            style: TextStyle(fontFamily: 'Itim', fontSize: 18),
                          ),
                        ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return const MainPage();
                        }));
                      },
                      child: const Text(
                        "กลับสู่หน้าหลัก",
                        style: TextStyle(fontFamily: 'Itim'),
                      ))
                ],
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 25, bottom: 40),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(2),
                      child: Column(
                        children: const [
                          Text(
                            "โพสต์ที่เข้าร่วมทั้งหมด",
                            style: TextStyle(fontFamily: 'Itim', fontSize: 20),
                          ),
                          Divider(
                            thickness: 1,
                            indent: 50,
                            endIndent: 50,
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
            width: 380,
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
                              const EdgeInsets.symmetric(horizontal: 1),
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
                                  fontFamily: 'Itim',
                                  height: 1.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 130,
                  top: 58,
                  child: SizedBox(
                    width: 100,
                    height: 18,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          top: 0,
                          child: SizedBox(
                            width: 100,
                            height: 18,
                            child: Text(
                              "ราคา ${joinposts?[index].post.product_price} บาท",
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'Itim',
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
                  left: 230,
                  top: 57.75,
                  child: SizedBox(
                    width: 75,
                    height: 18.25,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          top: 0.25,
                          child: SizedBox(
                            width: 70,
                            height: 18,
                            child: Text(
                              'จำนวน ${joinposts?[index].quantity_product} ชิ้น',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'Itim',
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
                  left: 130,
                  top: 87,
                  child: SizedBox(
                    width: 80,
                    height: 18,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          top: 0,
                          child: SizedBox(
                            width: 80,
                            height: 18,
                            child: Text(
                              'รวม ${joinposts?[index].price} บาท',
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'Itim',
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
                  left: 230,
                  top: 87,
                  child: SizedBox(
                    width: 130,
                    height: 20,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          top: 0,
                          child: SizedBox(
                            width: 130,
                            height: 20,
                            child: Text(
                              joinposts?[index].tacking_number == "-"
                                  ? 'ยังไม่มีการแจ้งเลขพัสดุ'
                                  : '${joinposts?[index].tacking_number}',
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: 'Itim'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 350,
                  top: 10,
                  child: SizedBox(
                    width: 35,
                    height: 25,
                    child: Stack(
                      children: [
                        Positioned(
                            left: -20,
                            top: -8,
                            child: countPost[index] == 0
                                ? ReportPostWidget(
                                    postId: joinposts?[index].post.post_id,
                                    member:
                                        joinposts?[index].member.login.username,
                                  )
                                : const Center()),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 130,
                  top: 149,
                  child: SizedBox(
                    width: 60,
                    height: 25,
                    child: Stack(
                      children: [
                        Positioned(
                            child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (BuildContext context) {
                              return ChatScreen(
                                memberId: joinposts![index].member.member_id,
                                postId:
                                    joinposts![index].post.post_id.toString(),
                              );
                            }));
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.white)),
                          child: const Icon(
                            Icons.chat_outlined,
                            color: Colors.lightBlue,
                            size: 19,
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  // left: 260,
                  // top: 118,
                  left: 130,
                  top: 118,
                  child: SizedBox(
                    width: 200,
                    height: 25,
                    child: Stack(
                      children: [
                        Positioned(
                          // left: 0,
                          // top: 0,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) {
                                return ListJoinMemberScreen(
                                  postId: joinposts![index].post.post_id,
                                );
                              }));
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.white)),
                            label: Text(
                              '${memberCount[index]} คน',
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'Itim',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                            icon: const Icon(
                              Icons.groups_2_sharp,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 200,
                  top: 149,
                  child: SizedBox(
                    width: 70,
                    height: 25,
                    child: Stack(
                      children: [
                        joinposts?[index].post.post_status == "CONFIRM"
                            ? Positioned(
                                child: joinposts?[index].pickup_status == "NO"
                                    ? btnConfirm(context, index)
                                    : reviewCount[index] >= 1
                                        ? Column()
                                        : btnReview(index, context))
                            : Column(
                                children: const [],
                              )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 200,
                  top: 149,
                  child: SizedBox(
                    width: 70,
                    height: 25,
                    child: Stack(
                      children: [
                        joinposts?[index].post.post_status != "CONFIRM"
                            ? Positioned(
                                child: btnLeaveGroup(context, index),
                              )
                            : Column()
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 11,
                  top: 107,
                  child: SizedBox(
                    width: 81,
                    height: 25,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          top: 0.05,
                          child: SizedBox(
                            width: 81,
                            height: 25,
                            child: Text(
                              'ผู้โพสต์ : ${joinposts?[index].post.member.firstname}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                fontFamily: 'Itim',
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
                  top: 0,
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
                            decoration:
                                joinposts?[index].post.post_status == "CONFIRM"
                                    ? const BoxDecoration(
                                        color: Color.fromRGBO(64, 205, 95, 1))
                                    : const BoxDecoration(
                                        color: Color.fromRGBO(255, 61, 61, 1)),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          top: 3,
                          child: SizedBox(
                            width: 47,
                            height: 24.79,
                            child:
                                joinposts?[index].post.post_status == "CONFIRM"
                                    ? const Text(
                                        'ยืนยัน',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 10,
                                          fontFamily: 'Itim',
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
                                          fontFamily: 'Itim',
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
                                fontFamily: 'Itim',
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
                  child: Image.network(
                      '$baseURL/post/${imgProductFileName[index]}',
                      width: 57,
                      height: 57,
                      fit: BoxFit.cover),
                  //
                ),
              ],
            ),
          ),
        ],
      ),
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
      style: ButtonStyle(
          backgroundColor:
              MaterialStateColor.resolveWith((states) => Colors.white)),
      child: const Icon(
        Icons.login_rounded,
        color: Colors.red,
        size: 19,
      ),
    );
  }

  ElevatedButton btnReview(int index, BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return ReviewPostedMemberScroon(
                postId: joinposts![index].payment_id,
              );
            },
          ),
        );
      },
      style: ButtonStyle(
          backgroundColor:
              MaterialStateColor.resolveWith((states) => Colors.white)),
      child: const Icon(
        Icons.rate_review_rounded,
        color: Colors.black,
        size: 19,
      ),
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
      style: ButtonStyle(
          backgroundColor:
              MaterialStateColor.resolveWith((states) => Colors.white)),
      child: const Icon(
        Icons.check_circle,
        color: Colors.green,
      ),
    );
  }
}
