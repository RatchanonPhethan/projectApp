import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_project_application/controller/ban_controller.dart';
import 'package:flutter_project_application/controller/report_controller.dart';

import '../Screens/ListReportMemberScreen.dart';
import '../styles/styles.dart';
import 'customTextFormField.dart';

class BanMemberWidget extends StatefulWidget {
  String? memberId;
  BanMemberWidget({super.key, required this.memberId});

  @override
  State<BanMemberWidget> createState() => _BanMemberWidgetState();
}

const List<String> list = <String>['1', '3', '5', '7'];

class _BanMemberWidgetState extends State<BanMemberWidget> {
  String dropdownValue = list.first;
  GlobalKey<FormState> formkey = GlobalKey();
  TextEditingController banDetailTextController = TextEditingController();
  BanController banController = BanController();
  ReportController reportController = ReportController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: const Text('แบนสมาชิก!',
                      style: TextStyle(fontFamily: 'Itim')),
                  content: SizedBox(
                    height: 250,
                    child: Form(
                      key: formkey,
                      child: Container(
                        color: Colors.white,
                        width: 250.0,
                        height: 250.0,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 35),
                              child: Row(children: [
                                const Expanded(
                                    child: Text("ต้องการแบนสมาชิกกี่วัน?",
                                        style: TextStyle(fontFamily: 'Itim'))),
                                Expanded(
                                  child: DropdownButton<String>(
                                    value: dropdownValue,
                                    isExpanded: true,
                                    onChanged: (String? value) {
                                      setState(() {
                                        dropdownValue = value!;
                                      });
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
                            customTextFormField(
                              controller: banDetailTextController,
                              hintText: "รายละเอียดการแบน",
                              maxLength: 100,
                              validator: (Value) {
                                if (Value!.isNotEmpty) {
                                  return null;
                                } else {
                                  return "กรุณากรอกรายละเอียดการแบน";
                                }
                              },
                              obscureText: false,
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
                                      banController.addBanMember(
                                          banDetailTextController.text,
                                          dropdownValue,
                                          widget.memberId!);
                                      reportController.removeReportMemberById(
                                          widget.memberId!);
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            return const ListReportMemberScreen();
                                          },
                                        ),
                                      );
                                    }
                                  },
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => loginButtonColor),
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      15.0)))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text("แบน",
                                          style: TextStyle(fontFamily: 'Itim')),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'ปิด'),
                      child: const Text('ปิด',
                          style: TextStyle(fontFamily: 'Itim')),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
      style: ButtonStyle(
          backgroundColor:
              MaterialStateColor.resolveWith((states) => Colors.redAccent)),
      icon: const Icon(Icons.report_problem_rounded),
      label: const Text(
        "แบนสมาชิก",
        style: TextStyle(fontFamily: 'Itim'),
      ),
    );
  }
}
