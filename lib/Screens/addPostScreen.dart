import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';

import '../styles/styles.dart';
import '../widgets/CustomSearchDelegate.dart';
import '../widgets/MenuFooter.dart';
import '../widgets/MenuWidget.dart';
import '../widgets/customTextFormField.dart';

// ignore: camel_case_types
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
  TextEditingController postNameTextController = TextEditingController();
  TextEditingController priceTextController = TextEditingController();
  TextEditingController end_date = TextEditingController();
  TextEditingController postDetailTextController = TextEditingController();
  TextEditingController shippingFeeTextController = TextEditingController();
  var shippingType = ShippingType.pickup;
  // int _groupValue = -1;
  bool enaShipping = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "Add Post",
            style: TextStyle(color: KFontColor),
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
        drawer: MenuWidget(),
        body: SingleChildScrollView(
            child: Form(
          key: formkey,
          child: Column(children: [
            const Padding(
              padding: EdgeInsets.only(top: 15, bottom: 5),
              child: Text("เพิ่มโพสต์",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: Text("กรอกรายละเอียดเพื่อเพิ่มโพสต์",
                  style: TextStyle(fontSize: 15)),
            ),
            const Divider(
              thickness: 3,
              indent: 35,
              endIndent: 35,
            ),
            customTextFormField(
              controller: postNameTextController,
              hintText: "ชื่อโพสต์",
              maxLength: 100,
              validator: (Value) {
                if (Value!.isNotEmpty) {
                  if (Value.length < 10) {
                    return "กรุณากรอกชื่อโพสต์มากกว่า 10 ตัวอักษร";
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
              hintText: "รายละเอียดโพสต์",
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
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 35),
              child: TextFormField(
                controller: priceTextController,
                maxLength: 10,
                maxLines: 1,
                keyboardType: TextInputType.text,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
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
                decoration: const InputDecoration(
                  hintText: "ราคาสินค้า",
                  counterText: "",
                  labelText: "ราคาสินค้า",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 35),
              child: TextFormField(
                controller: end_date,
                validator: (Value) {
                  if (Value!.isNotEmpty) {
                    return null;
                  } else {
                    return "กรุณากรอกวันที่ปิดรับสมาชิก";
                  }
                },
                decoration: const InputDecoration(
                  // icon: Icon(Icons.calendar_today_rounded),
                  prefixIcon: const Icon(Icons.calendar_month_outlined),
                  labelText: "วันที่ปิดรับสมาชิก",
                  hintText: "วันที่ปิดรับสมาชิก",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                ),
                onTap: () async {
                  DateTime? pickeddate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101));
                  if (pickeddate != null) {
                    end_date.text = DateFormat('yyyy-MM-dd').format(pickeddate);
                  }
                },
              ),
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
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 35),
              child: TextFormField(
                controller: shippingFeeTextController,
                maxLength: 10,
                maxLines: 1,
                keyboardType: TextInputType.text,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                obscureText: false,
                validator: (Value) {
                  if (Value!.isNotEmpty) {
                    if (int.parse(Value) <= 0) {
                      return "กรุณากรอกค่าจัดส่งมากกว่า 0 บาท";
                    }
                    return null;
                  } else {
                    return "กรุณากรอกค่าจัดส่ง";
                  }
                },
                decoration: const InputDecoration(
                  hintText: "ค่าจัดส่ง",
                  counterText: "",
                  labelText: "ค่าจัดส่ง",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                ),
                enabled: enaShipping,
              ),
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
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return const MainPage();
                        }));
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

// class AvatarWidget extends StatefulWidget {
//   const AvatarWidget({
//     Key? key,
//     required this.callback,
//     this.defaultImage,
//   }) : super(key: key);

//   final Function(Uint8List) callback;
//   final Image? defaultImage;

//   @override
//   State<AvatarWidget> createState() => _AvatarWidgetState();
// }
// 
// Widget _myRadioButton(
//     { String title,  int value,  required Function onChanged}) {
//   return RadioListTile(
//     value: value,
//     groupValue: _groupValue,
//     onChanged: onChanged,
//     title: Text(title),
//   );
// }


