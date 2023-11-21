// ignore: camel_case_types
import 'dart:io';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../controller/addpost_controller.dart';
import '../styles/styles.dart';
import '../widgets/CustomSearchDelegate.dart';
import '../widgets/MenuFooter.dart';
import '../widgets/MenuWidget.dart';
import '../widgets/customTextFormField.dart';

class addPost extends StatefulWidget {
  const addPost({super.key});

  @override
  State<addPost> createState() => _addPostState();
}

enum ShippingType { pickup, delivery }
// ignore: unused_element
// int _groupValue = -1;

// ignore: camel_case_types
class _addPostState extends State<addPost> {
  GlobalKey<FormState> formkey = GlobalKey();
  addPostController addpostController = addPostController();
  TextEditingController postNameTextController = TextEditingController();
  TextEditingController priceTextController = TextEditingController();
  TextEditingController enddateController = TextEditingController();
  TextEditingController postDetailTextController = TextEditingController();
  TextEditingController shippingFeeTextController = TextEditingController();
  TextEditingController productQtyController = TextEditingController();
  TextEditingController productShareQtyController = TextEditingController();
  TextEditingController memberAmountController = TextEditingController();
  List<File> listimg = [];
  String? user;
  var shippingType = ShippingType.pickup;
  // int _groupValue = -1;
  bool enaShipping = false;

  @override
  void initState() {
    super.initState();
    shippingFeeTextController.text = "0";
  }

  var sessionManager = SessionManager();
  void getMemberBySession() async {
    user = await sessionManager.get("username");
  }

  File? _imgProfile;
  final picker = ImagePicker();
  void getImage() async {
    var imgProfile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      listimg.add(File(imgProfile!.path));
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

  void addPostSuccess() {
    QuickAlert.show(
      context: context,
      title: "สร้างโพสต์สำเร็จ",
      type: QuickAlertType.success,
      confirmBtnText: "ตกลง",
      confirmBtnColor: Color.fromARGB(255, 4, 230, 45),
      onConfirmBtnTap: () {
        Navigator.of(context).pushReplacement(
          CupertinoPageRoute(
            builder: (BuildContext context) {
              return const MainPage();
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "เพิ่มโพสต์",
            style: TextStyle(color: KFontColor, fontFamily: 'Itim'),
          ),
          backgroundColor: kPrimary,
        ),
        backgroundColor: Color.fromARGB(255, 246, 246, 246),
        drawer: const MenuWidget(),
        body: SingleChildScrollView(
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
                  if (listimg.isNotEmpty)
                    for (int index = 0; index < listimg.length; index++)
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(180),
                            child: Center(
                              child: Image.file(
                                listimg.elementAt(index),
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
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
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateColor.resolveWith((states) => Colors.blue),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)))),
                onPressed: () {
                  getImage();
                },
                icon: const Icon(EvaIcons.image),
                label: const Text("เลือกรูปภาพ")),
            customTextFormField(
              controller: postNameTextController,
              keyboardType: TextInputType.text,
              prefixIcon: Icon(Icons.post_add),
              hintText: "ชื่อโพสต์",
              maxLength: 40,
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
              maxLength: 150,
              validator: (Value) {
                if (Value!.isNotEmpty) {
                  if (Value.length < 2) {
                    return "กรุณากรอกรายละเอียดโพสต์มากกว่า 2 ตัวอักษร";
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
                    enddateController.text = DateFormat('dd/MM/yyyy HH:mm:ss')
                        .format(pickedDateTime);
                  }
                }
              },
              validator: (value) {
                final now = DateTime.now();
                if (value!.isNotEmpty) {
                  String InputEnddate = enddateController.text;
                  DateTime enddate =
                      DateFormat("dd/MM/yyyy HH:mm:ss").parse(InputEnddate);
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 35),
              child: Row(
                children: [
                  Expanded(
                    child: RadioListTile<ShippingType>(
                        value: ShippingType.pickup,
                        groupValue: shippingType,
                        title: const Text("นัดรับ"),
                        onChanged: (ShippingType? val) {
                          setState(() {
                            print("pickup");
                            shippingType = ShippingType.pickup;
                            enaShipping = false;
                            shippingFeeTextController.text = "0";
                          });
                        }),
                  ),
                  Expanded(
                    child: RadioListTile<ShippingType>(
                        value: ShippingType.delivery,
                        groupValue: shippingType,
                        title: const Text("จัดส่ง"),
                        onChanged: (ShippingType? val) {
                          setState(() {
                            print("delivery");
                            shippingType = ShippingType.delivery;
                            enaShipping = true;
                          });
                        }),
                  )
                ],
              ),
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
                  if (int.parse(value) <= 0) {
                    return "กรุณากรอกจำนวนสินค้าที่ต้องการแชร์ให้มากกว่า 0 ชิ้น";
                  } else if (int.parse(productQtyController.text) <=
                      int.parse(value)) {
                    return "สินค้าที่ต้องการแชร์มีมากกว่าสินค้าที่มีอยู่";
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
                      if (formkey.currentState!.validate()) {
                        double price = double.parse(priceTextController.text);
                        double shippingFee =
                            double.parse(shippingFeeTextController.text);
                        int memberAmount =
                            int.parse(memberAmountController.text);
                        int productQty = int.parse(productQtyController.text);
                        int productShareQty =
                            int.parse(productShareQtyController.text);
                        String shipping =
                            enaShipping == false ? "PickUp" : "Delivery";
                        await addpostController.addPost(
                            listimg,
                            postNameTextController.text,
                            postDetailTextController.text,
                            price,
                            enddateController.text,
                            shipping,
                            shippingFee,
                            memberAmount,
                            productQty,
                            productShareQty);
                        addPostSuccess();
                      } else if (listimg.isEmpty) {
                        imageusnullalert();
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => loginButtonColor),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("เพิ่มโพสต์"),
                      ],
                    )),
              ),
            ),
          ]),
        )));
  }
}
