import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_project_application/controller/ban_controller.dart';

import '../styles/styles.dart';
import 'customTextFormField.dart';

class BanMemberWidget extends StatefulWidget {
  String? member;
  BanMemberWidget({super.key, required this.member});

  @override
  State<BanMemberWidget> createState() => _BanMemberWidgetState();
}

const List<String> list = <String>['1', '3', '5', '7'];

class _BanMemberWidgetState extends State<BanMemberWidget> {
  String dropdownValue = list.first;
  GlobalKey<FormState> formkey = GlobalKey();
  TextEditingController banDetailTextController = TextEditingController();
  BanController banController = BanController();
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('แบนสมาชิก!'),
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
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 35),
                        child: Row(children: [
                          const Expanded(
                              child: Text("ต้องการแบนสมาชิกกี่วัน?")),
                          Expanded(
                            child: DropdownButton<String>(
                              value: dropdownValue,
                              // icon: const Icon(Icons.arrow_downward),
                              // elevation: 16,
                              // style: const TextStyle(
                              //   color: Colors.deepPurple,
                              // ),
                              isExpanded: true,
                              // underline: Container(
                              //   height: 2,
                              //   color: Colors.deepPurpleAccent,
                              // ),
                              onChanged: (String? value) {
                                // This is called when the user selects an item.
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
                                    widget.member!);
                                Navigator.pop(context, 'OK');
                              }
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateColor.resolveWith(
                                    (states) => loginButtonColor),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0)))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text("แบน"),
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
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
      style: ButtonStyle(
          backgroundColor:
              MaterialStateColor.resolveWith((states) => Colors.redAccent)),
      child: const Icon(Icons.report_problem_sharp),
    );
  }
}
