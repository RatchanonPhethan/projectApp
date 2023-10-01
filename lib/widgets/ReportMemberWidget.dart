import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../controller/report_controller.dart';
import '../styles/styles.dart';
import 'customTextFormField.dart';

class ReportMemberWidget extends StatefulWidget {
  String? postId;
  String? member;
  ReportMemberWidget({super.key, required this.postId, required this.member});

  @override
  State<ReportMemberWidget> createState() => _ReportMemberWidgetState();
}

const List<String> list = <String>['1', '2', '3', '4'];

class _ReportMemberWidgetState extends State<ReportMemberWidget> {
  String dropdownValue = list.first;
  GlobalKey<FormState> formkey = GlobalKey();
  TextEditingController reportDetailTextController = TextEditingController();
  ReportController reportController = ReportController();
  TextEditingController reportImgTextController = TextEditingController();
  FilePickerResult? filePickerResult;
  String? fileName;
  PlatformFile? pickedFile;
  File? fileToDisplay;
  bool isLoadingPicture = true;

  void _pickFile() async {
    try {
      setState(() {
        isLoadingPicture = true;
      });
      filePickerResult = await FilePicker.platform
          .pickFiles(allowMultiple: false, type: FileType.image);
      if (filePickerResult != null) {
        fileName = filePickerResult!.files.first.name;
        pickedFile = filePickerResult!.files.first;
        fileToDisplay = File(pickedFile!.bytes.toString());
        reportImgTextController.text = fileName.toString();
        print("File is ${fileName}");
      }
      setState(() {
        isLoadingPicture = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('รายงานโพสต์!'),
            content: SizedBox(
              height: 250,
              child: Form(
                key: formkey,
                child: Container(
                  color: Colors.white,
                  height: 250.0,
                  width: 400.0,
                  child: Column(
                    children: [
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(
                      //       vertical: 10, horizontal: 35),
                      //   child: Row(children: [
                      //     const Expanded(child: Text("หัวข้อการรายงาน")),
                      //     Expanded(
                      //       child: DropdownButton<String>(
                      //         value: dropdownValue,
                      //         // icon: const Icon(Icons.arrow_downward),
                      //         // elevation: 16,
                      //         // style: const TextStyle(
                      //         //   color: Colors.deepPurple,
                      //         // ),
                      //         isExpanded: true,
                      //         // underline: Container(
                      //         //   height: 2,
                      //         //   color: Colors.deepPurpleAccent,
                      //         // ),
                      //         onChanged: (String? value) {
                      //           // This is called when the user selects an item.
                      //           setState(() {
                      //             dropdownValue = value!;
                      //           });
                      //         },
                      //         items: list.map<DropdownMenuItem<String>>(
                      //             (String value) {
                      //           return DropdownMenuItem<String>(
                      //             value: value,
                      //             child: Text(value),
                      //           );
                      //         }).toList(),
                      //       ),
                      //     )
                      //   ]),
                      // ),
                      customTextFormField(
                        controller: reportDetailTextController,
                        hintText: "รายละเอียดการรายงาน",
                        maxLength: 100,
                        validator: (Value) {
                          if (Value!.isNotEmpty) {
                            return null;
                          } else {
                            return "กรุณากรอกรายละเอียดการรายงาน";
                          }
                        },
                        obscureText: false,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextFormField(
                                controller: reportImgTextController,
                                enabled: false,
                                decoration: InputDecoration(
                                    labelText: "แนบรูปภาพ",
                                    counterText: "",
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    prefixIcon: const Icon(Icons.image),
                                    prefixIconColor: Colors.black),
                                style: const TextStyle(
                                    fontFamily: 'Itim', fontSize: 18),
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: SizedBox(
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    _pickFile();
                                  },
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.grey)),
                                  child: const Text("เลือกรูปภาพ"),
                                ),
                              )),
                        ],
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
                                reportController.addReportMember(
                                    fileToDisplay!,
                                    reportDetailTextController.text,
                                    reportImgTextController.text,
                                    widget.member!,
                                    widget.postId!);
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
                                Text("รายงาน"),
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
          backgroundColor: MaterialStateProperty.all(loginButtonColor)),
      child: const Text(
        "รายงาน",
        style: TextStyle(fontFamily: 'Itim', fontSize: 22),
      ),
    );
  }
}
