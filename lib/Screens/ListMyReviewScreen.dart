import 'dart:async';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_project_application/controller/listMyReviewController.dart';
import 'package:flutter_project_application/controller/member_controller.dart';
import 'package:flutter_project_application/model/review.dart';
import 'package:flutter_project_application/styles/styles.dart';
import 'package:flutter_project_application/widgets/MenuFooter.dart';
import 'package:flutter_project_application/widgets/MenuWidget.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:intl/intl.dart';

import '../Model/member.dart';
import '../constant/constant_value.dart';
import 'PostDetailScreen.dart';

class ListMyReviewPage extends StatefulWidget {
  const ListMyReviewPage({super.key});

  @override
  State<ListMyReviewPage> createState() => _ListMyReviewPageState();
}

class _ListMyReviewPageState extends State<ListMyReviewPage> {
  List<ReviewModel>? review;
  String? user;
  ListMyReviewController listMyReviewController = ListMyReviewController();
  final MemberController memberController = MemberController();
  MemberModel? member;
  bool? isDataLoaded = false;
  bool? check = false;
  String? productimg;
  String? subproductimg;
  String? replaceString;
  var outputformat = DateFormat("dd/MM/yyyy");
  void fetchListMyReview() async {
    user = await SessionManager().get("username");
    member = await memberController.getMemberByUsername(user!);
    print(member!.member_id);
    review = await listMyReviewController.ListMyReview(member!.member_id);
    setState(() {
      isDataLoaded = true;
    });
  }

  void timeDuration() {
    setState(() {
      check = true;
    });
    Timer(const Duration(milliseconds: 1000), () {
      setState(() {
        check = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    fetchListMyReview();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "ดูรีวิวของฉันทั้งหมด",
          style: TextStyle(color: KFontColor, fontFamily: 'Itim'),
        ),
        leading: BackButton(
          color: Colors.black,
          onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) {
            return const MainPage();
          })),
        ),
        backgroundColor: kPrimary,
      ),
      body: isDataLoaded == false
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                backgroundColor: Colors.grey,
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 40),
                child: Column(
                  children: [
                    Container(
                        padding: const EdgeInsets.all(10.0),
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: review?.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              String strimg = review![index]
                                  .payment_id
                                  .post
                                  .img_product
                                  .toString();
                              replaceString = strimg
                                  .replaceAll("[", "")
                                  .replaceAll("]", "");
                              List<String> listfilepath = replaceString!
                                  .split(",")
                                  .map((s) => s.trim())
                                  .toList();

                              print(listfilepath.length);
                              productimg = listfilepath.elementAt(0);
                              subproductimg = (productimg!.substring(
                                productimg!.lastIndexOf("/") + 1,
                              ));
                              return Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: ListTile(
                                      leading: Image.network(
                                        ("$baseURL/post/$subproductimg"),
                                        height: 50,
                                        width: 50,
                                        fit: BoxFit.cover,
                                      ),
                                      trailing:
                                          const Icon(EvaIcons.arrowForward),
                                      title: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Column(
                                                children: [
                                                  Text(
                                                    "${review?[index].payment_id.post.post_name} | ${outputformat.format(review![index].review_date)}",
                                                    style: const TextStyle(
                                                        fontFamily: 'Itim',
                                                        fontSize: 15),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 91),
                                                    child: Text(
                                                      "${review?[index].comment}",
                                                      style: const TextStyle(
                                                          fontFamily: 'Itim',
                                                          fontSize: 15),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        Navigator.of(context).pushReplacement(
                                            CupertinoPageRoute(builder:
                                                (BuildContext context) {
                                          return PostDetailScreen(
                                              postId: review![index]
                                                  .payment_id
                                                  .post
                                                  .post_id);
                                        }));
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
