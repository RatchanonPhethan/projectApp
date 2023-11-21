// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'dart:io';

import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project_application/Screens/ListJoinPostScreen.dart';
import 'package:flutter_project_application/Screens/PostDetailScreen.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

import '../Model/member.dart';
import '../Model/post.dart';
import '../constant/constant_value.dart';
import '../controller/joinpost_controller.dart';
import '../controller/member_controller.dart';
import '../controller/post_controller.dart';
import '../styles/styles.dart';
import '../widgets/CustomSearchDelegate.dart';

class JoinPostScreen extends StatefulWidget {
  String postId;
  JoinPostScreen({super.key, required this.postId});

  @override
  State<JoinPostScreen> createState() => _JoinPostScreenState();
}

List<String> list = <String>[];

class _JoinPostScreenState extends State<JoinPostScreen> {
  final PostController postController = PostController();
  GlobalKey<FormState> formkey = GlobalKey();
  // TextEditingController quantityTextController = TextEditingController();
  MemberModel? member;
  PostModel? post;
  String? user;
  String? postId;
  double? price = 0;
  int? qty = 0;
  var sessionManager = SessionManager();
  bool? isDataLoaded = false;
  late String dropdownValue;
  String? productimg;
  String replaceString = "";
  String? subproductimg;
  List<File> listimg = [];
  List<String> listimgstr = [];
  final MemberController memberController = MemberController();

  void fetchPost(String postId) async {
    user = await sessionManager.get("username");
    post = await postController.getPostById(postId);
    fetchMemberByUser(user.toString());
    this.postId = post?.post_id;
    price = post!.shipping_fee;
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
    list.clear();
    for (int i = 0; i < post!.productshare_qty; i++) {
      String num = (i + 1).toString();
      list.add(num);
    }
    dropdownValue = list.first;
    upDatePrice();
  }

  void fetchMemberByUser(String username) async {
    member = await memberController.getMemberByUsername(username);
    setState(() {
      isDataLoaded = true;
    });
  }

  void upDatePrice() {
    setState(() {
      qty = int.tryParse(dropdownValue);
      qty ??= 0;
      price = qty! * post!.product_price + post!.shipping_fee;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchPost(widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "เข้าร่วมโพสต์",
          style: TextStyle(color: KFontColor, fontFamily: 'Itim'),
        ),
        leading: BackButton(
          color: Colors.black,
          onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) {
            return PostDetailScreen(
              postId: post?.post_id,
            );
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
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                backgroundColor: Colors.grey,
              ),
            )
          : SingleChildScrollView(
              child: Form(
                key: formkey,
                child: Padding(
                  padding: const EdgeInsets.only(top: 40, bottom: 15),
                  child: Column(
                    children: [
                      const Text(
                        "เข้าร่วมโพสต์",
                        style: TextStyle(fontFamily: 'Itim', fontSize: 32),
                      ),
                      const Divider(
                        thickness: 1,
                        indent: 70,
                        endIndent: 70,
                        color: Color.fromARGB(255, 121, 121, 121),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15, top: 10),
                        child: SizedBox(
                            height: 150.0,
                            width: 150.0,
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
                      Text(
                        "${post?.post_name}",
                        style:
                            const TextStyle(fontFamily: 'Itim', fontSize: 26),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("รายละเอียด : ${post?.post_detail}",
                                style: const TextStyle(
                                    fontFamily: 'Itim', fontSize: 18)),
                            Text(
                                "จำนวนสินค้าที่เหลือ : ${post?.productshare_qty}",
                                style: const TextStyle(
                                    fontFamily: 'Itim', fontSize: 18),
                                textAlign: TextAlign.center),
                            Text("ราคาสินค้าต่อชิ้น : ${post?.product_price}",
                                style: const TextStyle(
                                    fontFamily: 'Itim', fontSize: 18),
                                textAlign: TextAlign.center),
                            post?.shipping == "delivery"
                                ? Text("ค่าจัดส่ง : ${post?.shipping_fee}",
                                    style: const TextStyle(
                                        fontFamily: 'Itim', fontSize: 18),
                                    textAlign: TextAlign.center)
                                : Text("ค่าจัดส่ง : ${post?.shipping_fee}",
                                    style: const TextStyle(
                                        fontFamily: 'Itim', fontSize: 18),
                                    textAlign: TextAlign.center),
                            Text("จำนวนเงินคงเหลือ : ${member?.amount_money}",
                                style: const TextStyle(
                                    fontFamily: 'Itim', fontSize: 18),
                                textAlign: TextAlign.center),
                            Text("รวมราคาทั้งหมด : $price",
                                style: const TextStyle(
                                    fontFamily: 'Itim', fontSize: 18),
                                textAlign: TextAlign.center),
                          ],
                        ),
                      ),

                      //
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 35),
                        child: Row(children: [
                          const Expanded(
                              child: Text(
                            "เลือกจำนวนสินค้า",
                            style: TextStyle(fontFamily: 'Itim', fontSize: 16),
                          )),
                          Expanded(
                            child: DropdownButton<String>(
                              value: dropdownValue,
                              isExpanded: true,
                              onChanged: (String? value) {
                                setState(() {
                                  dropdownValue = value!;
                                });
                                upDatePrice();
                              },
                              items: list.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          )
                        ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: SizedBox(
                          height: 45,
                          width: 200,
                          child: ElevatedButton(
                              onPressed: () async {
                                if (formkey.currentState!.validate()) {
                                  if (price! > member!.amount_money) {
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title: const Text(
                                            'ยอดเงินของคุณไม่เพียงพอ!'),
                                        content: const Text('กรุณาเติมเงิน!!'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, 'OK'),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    await JoinPostController().addJoinPost(
                                        dropdownValue,
                                        user.toString(),
                                        postId.toString(),
                                        price.toString());
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) {
                                          return const ListJoinPostScreen();
                                        },
                                      ),
                                    );
                                  }
                                }
                              },
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateColor.resolveWith(
                                          (states) => joinButtonColor),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0)))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    "ชำระเงิน",
                                    style: TextStyle(fontFamily: 'Itim'),
                                  ),
                                ],
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
