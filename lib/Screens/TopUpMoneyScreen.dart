import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../styles/styles.dart';
import '../widgets/CustomSearchDelegate.dart';
import '../widgets/MenuFooter.dart';
import '../widgets/MenuWidget.dart';
import 'loginScreen.dart';

class TopUpMomey extends StatefulWidget {
  const TopUpMomey({super.key});

  @override
  State<TopUpMomey> createState() => _TopUpMomeyState();
}

class _TopUpMomeyState extends State<TopUpMomey> {
  GlobalKey<FormState> formkey = GlobalKey();
  TextEditingController phoneTextController = TextEditingController();
  TextEditingController priceTextController = TextEditingController();

  int _groupValue = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "TopUpMoney",
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
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 15, bottom: 5),
                child: Text(
                  "เติมเงิน",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 15),
                child:
                    Text("เติมเงินเข้าบัญชี", style: TextStyle(fontSize: 15)),
              ),
              const Divider(
                thickness: 3,
                indent: 35,
                endIndent: 35,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 35),
                child: TextFormField(
                  controller: phoneTextController,
                  maxLength: 10,
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  obscureText: false,
                  validator: (Value) {
                    if (Value!.isNotEmpty) {
                      if (Value.length < 10) {
                        return "กรุณากรอกเบอร์โทรศัพท์ 10 ตัว";
                      }
                      return null;
                    } else {
                      return "กรุณากรอกเบอร์โทรศัพท์";
                    }
                  },
                  decoration: const InputDecoration(
                    hintText: "เบอร์โทรศัพท์",
                    counterText: "",
                    labelText: "เบอร์โทรศัพท์",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                  ),
                ),
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
                        return "กรุณากรอกจำนวนเงินมากกว่า 0 บาท";
                      }
                      return null;
                    } else {
                      return "กรุณากรอกจำนวนเงิน";
                    }
                  },
                  decoration: const InputDecoration(
                    hintText: "จำนวนเงิน",
                    counterText: "",
                    labelText: "จำนวนเงิน",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                  ),
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
                              MaterialPageRoute(
                                  builder: (BuildContext context) {
                            return const MainPage();
                          }));
                        }
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateColor.resolveWith(
                              (states) => loginButtonColor),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0)))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text("เติมเงิน"),
                        ],
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget _myRadioButton({required String title,required int value,required Function onChanged}) {
//   return RadioListTile(
//     value: value,
//     groupValue: _groupValue,
//     onChanged: onChanged,
//     title: Text(title),
//   );
// }
