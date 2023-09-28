// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project_application/Screens/ListJoinPostScreen.dart';
import 'package:flutter_project_application/Screens/PostDetailScreen.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

import '../Model/member.dart';
import '../Model/post.dart';
import '../controller/joinpost_controller.dart';
import '../controller/member_controller.dart';
import '../controller/post_controller.dart';
import '../styles/styles.dart';
import '../widgets/CustomSearchDelegate.dart';

class JoinPostScreen extends StatefulWidget {
  final String? postId;
  const JoinPostScreen({super.key, required this.postId});

  @override
  State<JoinPostScreen> createState() => _JoinPostScreenState();
}

class _JoinPostScreenState extends State<JoinPostScreen> {
  final PostController postController = PostController();
  GlobalKey<FormState> formkey = GlobalKey();
  TextEditingController quantityTextController = TextEditingController();
  MemberModel? member;
  PostModel? post;
  String? user;
  String? postId;
  double? price = 0;
  int? qty = 0;
  var sessionManager = SessionManager();
  bool? isDataLoaded = false;

  final MemberController memberController = MemberController();

  void fetchTodo(String postId) async {
    user = await sessionManager.get("username");
    post = await postController.getPostById(postId);
    fetchMemberByUser(user.toString());
    this.postId = post?.post_id;
    // qty = int.tryParse(quantityTextController.text);
    price = post!.shipping_fee;
    // price = (price! * qty!);
    // setState(() {
    //   isDataLoaded = true;
    // });
  }

  void fetchMemberByUser(String username) async {
    member = await memberController.getMemberByUsername(username);
    setState(() {
      isDataLoaded = true;
    });
  }

  void upDatePrice() {
    setState(() {
      qty = int.tryParse(quantityTextController.text);

      qty ??= 0;
      price = qty! * post!.product_price + post!.shipping_fee;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchTodo(widget.postId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "เข้าร่วมโพสต์",
          style: TextStyle(color: KFontColor),
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
          ? const CircularProgressIndicator()
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
                        thickness: 3,
                        indent: 35,
                        endIndent: 35,
                        color: Colors.black,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Image.asset(
                              "images/img.jpg",
                              width: 150,
                              height: 150,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "${post?.post_name}",
                        style:
                            const TextStyle(fontFamily: 'Itim', fontSize: 28),
                      ),
                      Text("${post?.post_detail}",
                          style: const TextStyle(
                              fontFamily: 'Itim', fontSize: 22)),
                      Text("จำนวนสินค้าที่เหลือ : ${post?.productshare_qty}",
                          style:
                              const TextStyle(fontFamily: 'Itim', fontSize: 20),
                          textAlign: TextAlign.center),
                      Text("ราคาสินค้าต่อชิ้น : ${post?.product_price}",
                          style:
                              const TextStyle(fontFamily: 'Itim', fontSize: 20),
                          textAlign: TextAlign.center),
                      post?.shipping == "delivery"
                          ? Text("ค่าจัดส่ง : ${post?.shipping_fee}",
                              style: const TextStyle(
                                  fontFamily: 'Itim', fontSize: 20),
                              textAlign: TextAlign.center)
                          : Text("ค่าจัดส่ง : ${post?.shipping_fee}",
                              style: const TextStyle(
                                  fontFamily: 'Itim', fontSize: 20),
                              textAlign: TextAlign.center),
                      Text("จำนวนเงินคงเหลือ : ${member?.amount_money}",
                          style:
                              const TextStyle(fontFamily: 'Itim', fontSize: 20),
                          textAlign: TextAlign.center),
                      Text("รวมราคาทั้งหมด : $price",
                          style:
                              const TextStyle(fontFamily: 'Itim', fontSize: 20),
                          textAlign: TextAlign.center),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 35),
                        child: TextFormField(
                          controller: quantityTextController,
                          maxLength: 2,
                          maxLines: 1,
                          keyboardType: TextInputType.text,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          obscureText: false,
                          validator: (Value) {
                            if (Value!.isNotEmpty) {
                              if (int.parse(Value) <= 0) {
                                return "กรุณากรอกจำนวนสินค้ามากกว่า 0 ชิ้น";
                              } else if (int.parse(Value) >
                                  post!.productshare_qty) {
                                return "จำนวนสินค้าไม่เพียงพอ";
                              }
                              return null;
                            } else {
                              return "กรุณากรอกจำนวนสินค้า";
                            }
                          },
                          decoration: const InputDecoration(
                            hintText: "จำนวนสินค้า",
                            counterText: "",
                            labelText: "จำนวนสินค้า",
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                            ),
                            prefixIcon: Icon(Icons.post_add),
                          ),
                          onChanged: (value) => upDatePrice(),
                        ),
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
                                        quantityTextController.text,
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
                                  Text("ชำระเงิน"),
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
