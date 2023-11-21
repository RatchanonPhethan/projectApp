import 'dart:async';

import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_application/Model/post.dart';
import 'package:flutter_project_application/Screens/listMyPostScreen.dart';

import 'package:flutter_project_application/controller/addTrackingNumberController.dart';
import 'package:flutter_project_application/controller/joinpost_controller.dart';
import 'package:flutter_project_application/controller/listJoinMemberController.dart';
import 'package:flutter_project_application/controller/post_controller.dart';
import 'package:flutter_project_application/model/joinpost.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../constant/constant_value.dart';
import '../controller/transactionlog_controller.dart';
import '../styles/styles.dart';
import '../widgets/CustomSearchDelegate.dart';

class ListJoinMemberPage extends StatefulWidget {
  String post_id;
  ListJoinMemberPage({Key? key, required this.post_id}) : super(key: key);

  @override
  State<ListJoinMemberPage> createState() => _ListJoinMemberPageState();
}

class _ListJoinMemberPageState extends State<ListJoinMemberPage> {
  PostModel? post;
  List<PostModel>? posts;
  List<JoinPostModel>? joinposts;
  bool? isDataLoaded = false;
  JoinPostModel? joinpost;
  ListJoinMemberController listJoinMemberController =
      ListJoinMemberController();
  JoinPostController joinPostController = JoinPostController();
  AddTrackingNumberController addTrackingNumberController =
      AddTrackingNumberController();
  TextEditingController addtrackingnumber = TextEditingController();
  TransactionLogController transactionLogController =
      TransactionLogController();
  PostController postController = PostController();
  bool? check = false;
  String? subimg;
  String? productimg;
  String? replaceString;
  String? subproductimg;
  String? user;
  List<String> listimgstr = [];
  int? sum;
  int? joinCount;
  DateTime now = DateTime.now();
  var outputFormat = DateFormat('dd/MM/yyyy hh:mm:ss');

  void fetchListJoinMember(String postid) async {
    user = await SessionManager().get("username");
    post = await postController.getPostById(postid);
    posts = await postController.getListAllPost();
    joinposts = await listJoinMemberController.getListJoinMember(postid);
    sum = await joinPostController.memberCount(postid);
    print(sum);
    if (user != null) {
      joinCount =
          await joinPostController.joinCount(user.toString(), post!.post_id);
    }
    String strimg = post!.img_product.toString();
    replaceString = strimg.replaceAll("[", "").replaceAll("]", "");
    List<String> listfilepath =
        replaceString!.split(",").map((s) => s.trim()).toList();

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

  void textAddTrackingNumber(String paymentid) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.custom,
      barrierDismissible: true,
      confirmBtnText: 'ยืนยัน',
      customAsset: 'images/icontruck.jpg',
      widget: TextFormField(
        decoration: const InputDecoration(
          alignLabelWithHint: true,
          hintText: 'กรุณากรอกเลขพัสดุ',
          prefixIcon: Icon(
            Icons.add_location,
          ),
        ),
        controller: addtrackingnumber,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
        onChanged: (value) {},
      ),
      onConfirmBtnTap: () async {
        if (addtrackingnumber.text.isNotEmpty) {
          await QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: "เลขพัสดุ${addtrackingnumber.text}",
          );
          addTrackingNumberController.addTrackingNumber(
              paymentid, addtrackingnumber.text);
          await Future.delayed(const Duration(milliseconds: 1000));
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) {
              return ListJoinMemberPage(
                post_id: widget.post_id,
              );
            },
          ));
        } else if (addtrackingnumber.text.isEmpty) {
          await QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: "แจ้งเตือน",
            text: 'โปรดกรอกเลขพัสดุ!',
          );
        } else if (addtrackingnumber.text.length > 50) {
          await QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: "แจ้งเตือน",
            text: 'โปรดกรอกเลขพัสดุน้อยกว่า 50 ตัว!',
          );
        }
      },
    );
  }

  void removeMemberAlert(
      String paymentid, double amount, String memberid, String postid) {
    QuickAlert.show(
      context: context,
      title: "ต้องการจะลบสมาชิกนี้ใช่หรือไม่?",
      type: QuickAlertType.confirm,
      showCancelBtn: true,
      confirmBtnText: "ตกลง",
      cancelBtnText: "ปฏิเสธ",
      cancelBtnTextStyle:
          TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      confirmBtnColor: Color.fromARGB(255, 42, 230, 4),
      onConfirmBtnTap: () async {
        joinPostController.leaveGroup(paymentid);
        await Future.delayed(const Duration(milliseconds: 1000));
        // ignore: use_build_context_synchronously
        await transactionLogController.addLog(
            amount, "คุณถูกเชิญออกจากกลุ่ม", postid, memberid);
        // ignore: use_build_context_synchronously
        await QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: "ลบสมาชิกสำเร็จ",
        );
        Navigator.of(context).pushReplacement(CupertinoPageRoute(
          builder: (BuildContext context) {
            return ListJoinMemberPage(post_id: widget.post_id);
          },
        ));
      },
      onCancelBtnTap: () {
        Navigator.pop(context);
      },
    );
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
    fetchListJoinMember(widget.post_id);
    timeDuration();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimary,
        title: Text(
          "ดูรายละเอียดโพสต์",
          style: TextStyle(color: KFontColor, fontFamily: 'Itim'),
        ),
        leading: BackButton(
          color: Colors.black,
          onPressed: () => Navigator.of(context).pushReplacement(
              CupertinoPageRoute(builder: (BuildContext context) {
            return const ListMyPostPage();
          })),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: CustomSearchDelegate());
              },
              icon: const Icon(Icons.search))
        ],
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
                            CupertinoPageRoute(builder: (BuildContext context) {
                          return const ListMyPostPage();
                        }));
                      },
                      child: const Text("กลับสู่หน้าหลัก"))
                ],
              ),
            )
          : Column(children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                    height: 150.0,
                    width: 150.0,
                    decoration: BoxDecoration(
                        border: Border.all(
                      color: const Color.fromARGB(255, 108, 108, 108),
                      width: 0.5,
                    )),
                    child: AnotherCarousel(
                      images: [
                        for (int index = 0; index < listimgstr.length; index++)
                          NetworkImage("$baseURL/post/${listimgstr[index]}"),
                      ],
                      dotSize: 4.0,
                      dotSpacing: 15.0,
                      dotColor: const Color.fromARGB(255, 0, 25, 253),
                      indicatorBgPadding: 5.0,
                      dotBgColor:
                          const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
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
                  style: const TextStyle(fontFamily: 'Itim', fontSize: 15)),
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
                      outputFormat.format(post!.end_date),
                      style: const TextStyle(fontFamily: 'Itim', fontSize: 15),
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
                      style: const TextStyle(fontFamily: 'Itim', fontSize: 15),
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
                      style: const TextStyle(fontFamily: 'Itim', fontSize: 15),
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
                            style: TextStyle(fontFamily: 'Itim', fontSize: 15),
                          ),
                          Text(
                            "นัดรับ",
                            style: TextStyle(fontFamily: 'Itim', fontSize: 15),
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
                            style: TextStyle(fontFamily: 'Itim', fontSize: 15),
                          ),
                          Text(
                            "จัดส่ง",
                            style: TextStyle(fontFamily: 'Itim', fontSize: 15),
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
                      style: const TextStyle(fontFamily: 'Itim', fontSize: 15),
                    ),
                  ],
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 10)),
              sum! != 0
                  ? const Text(
                      "รายชื่อสมาชิกในกลุ่ม",
                      style: TextStyle(fontFamily: 'Itim', fontSize: 25),
                    )
                  : Container(),
              Expanded(
                child: ListView.builder(
                  itemCount: joinposts!.length,
                  itemBuilder: (context, index) {
                    String filePath = "${joinposts?[index].member.img_member}";
                    subimg = filePath.substring(
                        filePath.lastIndexOf('/') + 1, filePath.length);
                    return SingleChildScrollView(
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(180)),
                                  child: Image.network(
                                    "$baseURL/member/$subimg",
                                    width: 40,
                                    height: 40,
                                  ),
                                ),
                                Text(
                                  "${joinposts?[index].member.firstname}",
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Itim'),
                                ),
                                post!.post_status != 'CONFIRM'
                                    ? IconButton(
                                        onPressed: () {
                                          removeMemberAlert(
                                              joinposts![index].payment_id,
                                              joinposts![index].price,
                                              joinposts![index]
                                                  .member
                                                  .member_id,
                                              joinposts![index].post.post_id);
                                        },
                                        icon: const Icon(EvaIcons.personDelete),
                                        color: const Color.fromARGB(
                                            255, 234, 0, 0),
                                      )
                                    : Center(),
                                joinposts![index].tacking_number != "-" &&
                                        joinposts![index].post.post_status ==
                                            "CONFIRM"
                                    ? Text(joinposts![index].tacking_number,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ))
                                    : joinposts![index].post.post_status ==
                                            "CONFIRM"
                                        ? IconButton(
                                            onPressed: () {
                                              textAddTrackingNumber(
                                                  joinposts![index].payment_id);
                                            },
                                            icon: const Icon(EvaIcons.car),
                                            color: Color.fromARGB(255, 0, 0, 0),
                                          )
                                        : Container(),
                              ]),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ]),
    );
  }
}
