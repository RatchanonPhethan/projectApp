import 'dart:io';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';

import '../Model/post.dart';
import '../constant/constant_value.dart';
import '../controller/ViewPostDetails_controller.dart';
import '../controller/editPostController.dart';
import '../styles/styles.dart';
import '../widgets/CustomSearchDelegate.dart';
import '../widgets/MenuWidget.dart';
import '../widgets/customTextFormField.dart';
import 'listMyPostScreen.dart';

class EditPostPage extends StatefulWidget {
  String post_id, memberAmonut;
  EditPostPage({Key? key, required this.post_id, required this.memberAmonut})
      : super(key: key);

  @override
  State<EditPostPage> createState() => _EditPostPageState();
}

enum ShippingType { pickup, delivery }

class _EditPostPageState extends State<EditPostPage> {
  GlobalKey<FormState> formkey = GlobalKey();
  EditPostController editPostController = EditPostController();
  TextEditingController postNameTextController = TextEditingController();
  TextEditingController priceTextController = TextEditingController();
  TextEditingController startdateController = TextEditingController();
  TextEditingController enddateController = TextEditingController();
  TextEditingController postDetailTextController = TextEditingController();
  TextEditingController shippingFeeTextController = TextEditingController();
  TextEditingController productQtyController = TextEditingController();
  TextEditingController productShareQtyController = TextEditingController();
  TextEditingController memberAmountController = TextEditingController();
  PostModel? post;
  String? user;
  String? post_status;
  String? start_date;
  String? member_id;
  var shippingType = ShippingType.pickup;
  // int _groupValue = -1;
  bool enaShipping = false;
  bool? isDataLoaded = false;
  DateTime? editEndDate;
  String? productimg;
  String replaceString = "";
  String? subproductimg;
  List<File> listimg = [];
  List<String> listimgstr = [];
  var outputFormat = DateFormat('dd/MM/yyyy hh:mm:ss');
  final ViewPostDetails viewPostDetails = ViewPostDetails();

  void fetchPost(String postId) async {
    post = await viewPostDetails.getVIewPostDetails(postId);
    String price = post!.product_price.toString();
    String shippingFee = post!.shipping_fee.toString();
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
    print(listimg);
    setState(() {
      isDataLoaded = true;
      postNameTextController.text = post!.post_name;
      postDetailTextController.text = post!.post_detail;
      priceTextController.text = price.substring(0, price.indexOf('.'));
      startdateController.text = outputFormat.format(post!.start_date);
      enddateController.text = outputFormat.format(post!.end_date);
      if (post!.shipping == "PickUp") {
        shippingType = ShippingType.pickup;
      } else {
        shippingType = ShippingType.delivery;
      }
      shippingFeeTextController.text =
          shippingFee.substring(0, shippingFee.indexOf('.'));
      productQtyController.text = post!.product_qty.toString();
      productShareQtyController.text = post!.productshare_qty.toString();
      memberAmountController.text = post!.member_amount.toString();
      post_status = post!.post_status;
      member_id = post!.member.toString();
    });
  }

  File? _imgProfile;
  final picker = ImagePicker();
  void getImage() async {
    var imgProfile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      listimg.add(File(imgProfile!.path));
      print(listimg);
    });
  }

  void imageusnullalert() {
    QuickAlert.show(
      context: context,
      title: "กรุณาใส่รูปสินค้า",
      type: QuickAlertType.error,
      confirmBtnText: "ตกลง",
      confirmBtnColor: Color.fromARGB(255, 230, 4, 4),
      onConfirmBtnTap: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchPost(widget.post_id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimary,
          title: Text(
            "แก้ไขโพสต์",
            style: TextStyle(color: KFontColor, fontFamily: 'Itim'),
          ),
          leading: BackButton(
            color: Colors.black,
            onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) {
              return const ListMyPostPage();
            })),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 246, 246, 246),
        drawer: const MenuWidget(),
        body: isDataLoaded == false
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                child: Form(
                key: formkey,
                child: Column(children: [
                  const Divider(
                    thickness: 3,
                    indent: 35,
                    endIndent: 35,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (listimgstr.isNotEmpty)
                          for (int index = 0;
                              index < listimgstr.length;
                              index++)
                            Stack(
                              children: [
                                Center(
                                  child: Image.network(
                                    "$baseURL/post/${listimgstr.elementAt(index)}",
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      listimgstr.removeAt(index);
                                      setState(() {});
                                    },
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.red,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        if (listimg.isNotEmpty)
                          for (int index = 0; index < listimg.length; index++)
                            Stack(
                              children: [
                                Center(
                                  child: Image.file(
                                    listimg.elementAt(index),
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      listimg.removeAt(index);
                                      setState(() {});
                                    },
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.red,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 5,
                      ),
                      onPressed: () {
                        getImage();
                      },
                      icon: const Icon(
                        EvaIcons.image,
                        color: Colors.black,
                      ),
                      label: const Text(
                        "เลือกรูปภาพ",
                        style:
                            TextStyle(fontFamily: 'Itim', color: Colors.black),
                      )),
                  customTextFormField(
                    controller: postNameTextController,
                    keyboardType: TextInputType.text,
                    prefixIcon: Icon(Icons.post_add),
                    hintText: "ชื่อโพสต์",
                    maxLength: 40,
                    enabled: widget.memberAmonut.contains("0") ? true : false,
                    validator: (Value) {
                      if (Value!.isNotEmpty) {
                        if (Value.length < 2) {
                          return "กรุณากรอกชื่อโพสต์มากกว่า 2 ตัวอักษร";
                        } else
                          return null;
                      } else {
                        return "กรุณากรอกชื่อโพสต์";
                      }
                    },
                    obscureText: false,
                  ),
                  customTextFormField(
                    controller: postDetailTextController,
                    keyboardType: TextInputType.text,
                    hintText: "รายละเอียดโพสต์",
                    prefixIcon: Icon(Icons.document_scanner_rounded),
                    maxLength: 100,
                    enabled: widget.memberAmonut.contains("0") ? true : false,
                    validator: (Value) {
                      if (Value!.isNotEmpty) {
                        if (Value.length < 10) {
                          return "กรุณากรอกรายละเอียดโพสต์มากกว่า 10 ตัวอักษร";
                        } else
                          return null;
                      } else {
                        return "กรุณากรอกรายละเอียดโพสต์";
                      }
                    },
                    obscureText: false,
                  ),
                  customTextFormField(
                    hintText: "ราคาสินค้า",
                    controller: priceTextController,
                    maxLength: 10,
                    maxLines: 1,
                    prefixIcon: Icon(Icons.attach_money),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    obscureText: false,
                    enabled: widget.memberAmonut.contains("0") ? true : false,
                    validator: (Value) {
                      if (Value!.isNotEmpty) {
                        if (int.parse(Value) <= 0) {
                          return "กรุณากรอกราคามากกว่า 0 บาท";
                        }
                        return null;
                      } else {
                        return "กรุณากรอกราคาสินค้า";
                      }
                    },
                  ),
                  customTextFormField(
                    controller: startdateController,
                    keyboardType: TextInputType.text,
                    hintText: "วันที่เปิดรับ",
                    prefixIcon: Icon(Icons.document_scanner_rounded),
                    maxLength: 100,
                    validator: (Value) {
                      if (Value!.isNotEmpty) {
                        if (Value.length < 10) {
                          return "กรุณากรอกรายละเอียดโพสต์มากกว่า 10 ตัวอักษร";
                        } else
                          return null;
                      } else {
                        return "กรุณากรอกรายละเอียดโพสต์";
                      }
                    },
                    obscureText: false,
                    enabled: false,
                  ),
                  customTextFormField(
                    controller: enddateController,
                    // icon: Icon(Icons.calendar_today_rounded),
                    prefixIcon: const Icon(Icons.calendar_month_outlined),
                    hintText: "วันที่ปิดรับสมาชิก",
                    onTap: () async {
                      DateTime? pickedDateTime = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2101));

                      if (pickedDateTime != null) {
                        // ignore: use_build_context_synchronously
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          pickedDateTime = DateTime(
                              pickedDateTime.year,
                              pickedDateTime.month,
                              pickedDateTime.day,
                              pickedTime.hour,
                              pickedTime.minute);
                          enddateController.text =
                              DateFormat('dd/MM/yyyy HH:mm:ss')
                                  .format(pickedDateTime);
                        }
                      }
                    },
                    validator: (value) {
                      final now = DateTime.now();
                      if (value!.isNotEmpty) {
                        String InputDate = enddateController.text;
                        DateTime enddate =
                            DateFormat("dd/MM/yyyy HH:mm:ss").parse(InputDate);
                        final bool isExpired = enddate.isBefore(now);
                        if (isExpired == true) {
                          return "กรุณากรอกวันและเวลาไม่ให้เป็นวันในอดีต";
                        } else {
                          return null;
                        }
                      } else {
                        return "กรุณากรอกวันที่ปิดรับสมาชิก";
                      }
                    },
                  ),
                  widget.memberAmonut.contains("0")
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 35),
                          child: Row(
                            children: [
                              Expanded(
                                child: RadioListTile<ShippingType>(
                                    value: ShippingType.pickup,
                                    groupValue: shippingType,
                                    title: const Text("นัดรับ",
                                        style: TextStyle(fontFamily: 'Itim')),
                                    onChanged: (ShippingType? val) {
                                      setState(() {
                                        print("pickup");
                                        shippingType = ShippingType.pickup;
                                        enaShipping = false;
                                        if (widget.memberAmonut.contains("0")) {
                                          shippingFeeTextController.text = "0";
                                        }
                                      });
                                    }),
                              ),
                              Expanded(
                                child: RadioListTile<ShippingType>(
                                    value: ShippingType.delivery,
                                    groupValue: shippingType,
                                    title: const Text("จัดส่ง",
                                        style: TextStyle(fontFamily: 'Itim')),
                                    onChanged: (ShippingType? val) {
                                      setState(() {
                                        print("delivery");
                                        shippingType = ShippingType.delivery;
                                        widget.memberAmonut.contains("0")
                                            ? enaShipping = true
                                            : enaShipping = false;
                                      });
                                    }),
                              )
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 35),
                          child: post!.shipping == "PickUp"
                              ? const Text("นัดรับ",
                                  style: TextStyle(fontFamily: 'Itim'))
                              : const Text("จัดส่ง",
                                  style: TextStyle(fontFamily: 'Itim')),
                        ),
                  customTextFormField(
                    controller: shippingFeeTextController,
                    hintText: "ค่าจัดส่ง",
                    maxLength: 10,
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    obscureText: false,
                    enabled: enaShipping,
                    prefixIcon: Icon(Icons.local_shipping),
                    validator: (value) {
                      if (value!.isNotEmpty) {
                        if (int.parse(value) <= 0) {
                          if (enaShipping == false) {
                            return null;
                          }
                          return "กรุณากรอกค่าจัดส่งมากกว่า 0 บาท";
                        }
                        return null;
                      } else {
                        return "กรุณากรอกค่าจัดส่ง";
                      }
                    },
                  ),
                  customTextFormField(
                    controller: productQtyController,
                    hintText: "จำนวนสินค้าทั้งหมด",
                    obscureText: false,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 10,
                    maxLines: 1,
                    prefixIcon: const Icon(Icons.shopping_bag),
                    validator: (value) {
                      if (value!.isNotEmpty) {
                        if (int.parse(value) <= 0) {
                          return "กรุณากรอกจำนวนสินค้ามากกว่า 0 ชิ้น";
                        }
                        return null;
                      } else {
                        return "กรุณากรอกจำนวนสินค้า";
                      }
                    },
                  ),
                  customTextFormField(
                    controller: productShareQtyController,
                    hintText: "จำนวนสินค้าที่ต้องการแชร์",
                    obscureText: false,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 10,
                    maxLines: 1,
                    prefixIcon: const Icon(Icons.shopping_bag),
                    validator: (value) {
                      if (value!.isNotEmpty) {
                        if (int.parse(value) < 0) {
                          return "กรุณากรอกจำนวนสินค้าที่ต้องการแชร์ให้มากกว่า 0 ชิ้น";
                        } else if (int.parse(productQtyController.text) <=
                            int.parse(value)) {
                          return "สินค้าที่ต้องการแชร์มีมากกว่าสินค้าที่มีอยู่";
                        } else if (!widget.memberAmonut.contains('0')) {
                          if (int.parse(post!.productshare_qty.toString()) >
                              int.parse(value)) {
                            return "ห้ามกรอกสินค้าน้อยลงกว่าจำนวนสินค้าเดิม";
                          } else {
                            return null;
                          }
                        }
                        return null;
                      } else {
                        return "กรุณากรอกจำนวนสินค้าที่ต้องการแชร์";
                      }
                    },
                  ),
                  customTextFormField(
                    controller: memberAmountController,
                    hintText: "จำนวนผู้เข้าร่วม",
                    obscureText: false,
                    maxLength: 10,
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    prefixIcon: const Icon(Icons.people),
                    validator: (value) {
                      if (value!.isNotEmpty) {
                        if (int.parse(value) <= 0) {
                          return "กรุณากรอกจำนวนผู้เข้าร่วมให้มากกว่า 0";
                        } else if (int.parse(productShareQtyController.text) <
                            int.parse(value)) {
                          return "จำนวนผู้เข้าร่วมมากกว่าจำนวนสินค้าที่มีอยู่";
                        }
                        return null;
                      } else {
                        return "กรุณากรอกจำนวนผู้เข้าร่วม";
                      }
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 10, horizontal: kDefaultPaddingH),
                    child: SizedBox(
                      height: 45,
                      width: 200,
                      child: ElevatedButton(
                          onPressed: () async {
                            if (listimg.isEmpty && listimgstr.isEmpty) {
                              imageusnullalert();
                            } else if (formkey.currentState!.validate()) {
                              double price =
                                  double.parse(priceTextController.text);
                              double shippingFee =
                                  double.parse(shippingFeeTextController.text);
                              int memberAmount =
                                  int.parse(memberAmountController.text);
                              int productQty =
                                  int.parse(productQtyController.text);
                              int productShareQty =
                                  int.parse(productShareQtyController.text);
                              String shipping =
                                  enaShipping == false ? "PickUp" : "Delivery";
                              user = await SessionManager().get("username");
                              await editPostController.editMyPost(
                                listimg,
                                listimgstr,
                                widget.post_id,
                                postNameTextController.text,
                                postDetailTextController.text,
                                price,
                                post_status.toString(),
                                startdateController.text,
                                enddateController.text,
                                shipping,
                                shippingFee,
                                memberAmount,
                                productQty,
                                productShareQty,
                              );
                              Navigator.of(context).pushReplacement(
                                CupertinoPageRoute(
                                  builder: (BuildContext context) {
                                    return const ListMyPostPage();
                                  },
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 5,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                "แก้ไข",
                                style: TextStyle(
                                    fontFamily: 'Itim', color: Colors.black),
                              ),
                            ],
                          )),
                    ),
                  ),
                ]),
              )));
  }
}
