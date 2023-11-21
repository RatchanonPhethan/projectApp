import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project_application/Screens/viewProfileScreen.dart';
import 'package:flutter_project_application/controller/member_controller.dart';
import 'package:flutter_project_application/controller/topupmoney_controller.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:quickalert/quickalert.dart';

import '../Model/member.dart';
import '../styles/styles.dart';
import '../widgets/CustomSearchDelegate.dart';
import '../widgets/MenuFooter.dart';
import '../widgets/MenuWidget.dart';

class TopUpMomey extends StatefulWidget {
  const TopUpMomey({super.key});

  @override
  State<TopUpMomey> createState() => _TopUpMomeyState();
}

enum Topup { trueWallet, promtpay }

class _TopUpMomeyState extends State<TopUpMomey> {
  GlobalKey<FormState> formkey = GlobalKey();
  TextEditingController phoneTextController = TextEditingController();
  TextEditingController priceTextController = TextEditingController();
  TopUpMoneyController topUpMoneyController = TopUpMoneyController();
  MemberController memberController = MemberController();
  MemberModel? memberid;
  TopUpMomey? topUpMomey;
  String? user;
  bool? isdataLoaded = false;
  var topup = Topup.trueWallet;
  void fetchtopup() async {
    user = await SessionManager().get("username");
    memberid = await memberController.getMemberByUsername(user!);
    print(memberid!.member_id);
    phoneTextController.text = memberid!.tel;
    setState(() {
      isdataLoaded = true;
    });
  }

  void topupsuccess() {
    QuickAlert.show(
      context: context,
      title: "เติมเงินสำเร็จ",
      type: QuickAlertType.success,
      confirmBtnText: "ตกลง",
      confirmBtnColor: Color.fromARGB(255, 45, 230, 4),
      onConfirmBtnTap: () {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
          return const ViewProfilePage();
        }));
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchtopup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "เติมเงิน",
          style: TextStyle(color: KFontColor, fontFamily: 'Itim'),
        ),
        backgroundColor: kPrimary,
      ),
      backgroundColor: Color.fromARGB(255, 246, 246, 246),
      drawer: const MenuWidget(),
      body: isdataLoaded == false
          ? CircularProgressIndicator()
          : SingleChildScrollView(
              child: Form(
                key: formkey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: Color.fromARGB(255, 254, 254, 255),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          blurRadius: 10,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Image.asset(
                                      'images/icontruewallet.png',
                                      width: 50,
                                      height: 50,
                                    ),
                                  ),
                                ),
                                RadioListTile<Topup>(
                                    value: Topup.trueWallet,
                                    groupValue: topup,
                                    title: const Text("TrueWallet",
                                        style: TextStyle(fontFamily: 'Itim')),
                                    onChanged: (Topup? val) {
                                      setState(() {
                                        topup = Topup.trueWallet;
                                      });
                                    }),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 20),
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: Color.fromARGB(255, 254, 254, 255),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          blurRadius: 10,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Image.asset(
                                      'images/iconpromtpay.png',
                                      width: 50,
                                      height: 50,
                                    ),
                                  ),
                                ),
                                RadioListTile<Topup>(
                                    value: Topup.promtpay,
                                    groupValue: topup,
                                    title: const Text("Promtpay",
                                        style: TextStyle(fontFamily: 'Itim')),
                                    onChanged: (Topup? val) {
                                      setState(() {
                                        topup = Topup.promtpay;
                                      });
                                    }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 3,
                      indent: 35,
                      endIndent: 35,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 10,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                "ยอดเงินคงเหลือ ${memberid?.amount_money}",
                                style:
                                    TextStyle(fontFamily: 'Itim', fontSize: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 35),
                      child: TextFormField(
                        controller: phoneTextController,
                        maxLength: 10,
                        maxLines: 1,
                        style: TextStyle(fontFamily: 'Itim'),
                        keyboardType: TextInputType.text,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        obscureText: false,
                        enabled: false,
                        decoration: const InputDecoration(
                          hintText: "เบอร์โทรศัพท์",
                          counterText: "",
                          prefixIcon: Icon(EvaIcons.phone),
                          labelText: "เบอร์โทรศัพท์",
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 35),
                      child: TextFormField(
                        controller: priceTextController,
                        maxLength: 10,
                        maxLines: 1,
                        style: const TextStyle(fontFamily: 'Itim'),
                        keyboardType: TextInputType.text,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[0-9].?"))
                        ],
                        obscureText: false,
                        validator: (value) {
                          if (value!.isNotEmpty) {
                            final double price = double.tryParse(value) ?? 0.0;
                            if (price < 1.00 || price > 50000.00) {
                              return "กรุณากรอกจำนวนเงินระหว่าง 1.00 ถึง 50000.00";
                            } else if (!RegExp("0-9").hasMatch(value)) {
                              return null;
                            } else if (!RegExp("[0-9]{1,5}([.][0-9]{1,2})")
                                .hasMatch(value)) {
                              return "กรุณากรอกจำนวนเงินให้อยู่ในรูปแบบ 1.00";
                            }
                            return null;
                          } else {
                            return "กรุณากรอกจำนวนเงิน";
                          }
                        },
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.attach_money),
                          hintText: "จำนวนเงิน",
                          counterText: "",
                          labelText: "จำนวนเงิน",
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
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
                            onPressed: () async {
                              if (formkey.currentState!.validate()) {
                                var topup =
                                    await topUpMoneyController.topUpMoney(
                                        memberid!.member_id,
                                        double.parse(priceTextController.text));
                                topupsuccess();
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
                                  "เติมเงิน",
                                  style: TextStyle(
                                      fontFamily: 'Itim', color: Colors.black),
                                ),
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
