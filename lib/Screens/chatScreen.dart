import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_project_application/Model/chat.dart';
import 'package:flutter_project_application/Screens/ListJoinPostScreen.dart';
import 'package:flutter_project_application/widgets/customTextFormField.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../Model/member.dart';
import '../Model/post.dart';
import '../constant/constant_value.dart';
import '../controller/member_controller.dart';
import '../controller/post_controller.dart';
import '../styles/styles.dart';

class ChatScreen extends StatefulWidget {
  String postId;
  String memberId;
  ChatScreen({super.key, required this.memberId, required this.postId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController text = TextEditingController();
  DateTime now = new DateTime.now();
  final MemberController memberController = MemberController();
  final PostController postController = PostController();
  List<ChatModel>? chat;
  PostModel? post;
  MemberModel? member;
  bool? isDataLoaded = false;
  List<String> imgMemberFileName = [];

  void fetchMember(memberId) async {
    member = await memberController.getMemberById(memberId);

    // setState(() {
    //   isDataLoaded = true;
    // });
  }

  void fetchPost(String postId) async {
    post = await postController.getPostById(postId);

    setState(() {
      isDataLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchMember(widget.memberId);

    _loadCustomers();
  }

  void _saveMessageToFirebase() async {
    String date = DateFormat('yyyy-MM-d, HH:mm:ss').format(now);
    // print(date);
    // String datetime = DateTime.now().toString();
    if (_formKey.currentState!.validate()) {
      String time = date.toString();
      _formKey.currentState!.save();
      final url = Uri.https(
          'flutter-project-sharehub-default-rtdb.asia-southeast1.firebasedatabase.app',
          'chat/${widget.postId}.json');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            //'id': _cid,
            'time': time.toString(),
            'text': text.text,
            'member': {
              'member_id': member!.member_id,
              'firstname': member!.firstname,
              'lastname': member!.lastname,
              'tel': member!.tel,
              'email': member!.email,
              'birthday': DateFormat('MMM d, yyyy, HH:mm:ss aaa')
                  .format(member!.birthday)
                  .toString(),
              'amount_money': member!.amount_money,
              'gender': member!.gender,
              'address': member!.address,
              'img_member': member!.img_member,
              'member_status': member!.member_status,
              'username': {
                'username': member!.login.username,
                'password': member!.login.password,
                'isadmin': member!.login.isadmin,
              },
            },
          },
        ),
      );
      text.clear();
    }
    setState(() {
      now = new DateTime.now();
      _loadCustomers();
    });
  }

  void _loadCustomers() async {
    setState(() {
      isDataLoaded = false;
    });
    final url = Uri.https(
        'flutter-project-sharehub-default-rtdb.asia-southeast1.firebasedatabase.app',
        'chat/${widget.postId}.json');
    final response = await http.get(url);

    final Map<String, dynamic>? listData;
    listData = json.decode(response.body);
    final List<ChatModel> loadedChat = [];
    if (listData != null) {
      for (final item in listData.entries) {
        loadedChat.add(
          ChatModel(
            chat_id: item.key,
            text: item.value['text'],
            time: DateFormat('yyyy-MM-d, HH:mm:ss').parse(item.value['time']),
            member: MemberModel.fromMemberToJson(item.value['member']),
          ),
        );
      }
      imgMemberFileName.clear();
      for (int i = 0; i < loadedChat.length; i++) {
        String filePath = loadedChat?[i].member.img_member ?? "";
        String img = filePath.substring(
            filePath.lastIndexOf('/') + 1, filePath.length - 2);
        imgMemberFileName.add(img.toString());
      }

      setState(() {
        chat = loadedChat;
      });
    }
    setState(() {
      isDataLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "แชท",
          style: TextStyle(color: KFontColor, fontFamily: 'Itim'),
        ),
        leading: BackButton(
          color: Colors.black,
          onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) {
            return const ListJoinPostScreen();
          })),
        ),
        backgroundColor: kPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 600,
              child: chat != null
                  ? SingleChildScrollView(
                      child: isDataLoaded == false
                          ? const CircularProgressIndicator()
                          : Container(
                              padding: const EdgeInsets.all(10.0),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: chat?.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      // Padding(
                                      //   padding: const EdgeInsets.all(8.0),
                                      //   child: Text("${chat?[index].time}",
                                      //       style: const TextStyle(
                                      //           fontFamily: 'Itim',
                                      //           fontSize: 16)),
                                      // ),
                                      SizedBox(
                                        child: ListTile(
                                          leading: member?.member_id ==
                                                  chat?[index].member.member_id
                                              ? null
                                              : ClipOval(
                                                  child: SizedBox.fromSize(
                                                    size: const Size.fromRadius(
                                                        20), // Image radius
                                                    child: Image.network(
                                                        '$baseURL/member/${imgMemberFileName[index]}',
                                                        width: 10,
                                                        height: 10,
                                                        fit: BoxFit.cover),
                                                  ),
                                                ),
                                          title: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                member?.member_id ==
                                                        chat?[index]
                                                            .member
                                                            .member_id
                                                    ? CrossAxisAlignment.end
                                                    : CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                "${chat?[index].member.firstname} ${chat?[index].member.lastname}",
                                                style: const TextStyle(
                                                    fontFamily: 'Itim',
                                                    fontSize: 14),
                                              ),
                                              Container(
                                                width: 150,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: member?.member_id ==
                                                          chat?[index]
                                                              .member
                                                              .member_id
                                                      ? const Color.fromARGB(
                                                          255, 56, 129, 255)
                                                      : const Color.fromARGB(
                                                          255, 222, 222, 222),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10, right: 10),
                                                  child: Text(
                                                    "${chat?[index].text}",
                                                    textAlign:
                                                        member?.member_id ==
                                                                chat?[index]
                                                                    .member
                                                                    .member_id
                                                            ? TextAlign.right
                                                            : TextAlign.left,
                                                    style: TextStyle(
                                                        fontFamily: 'Itim',
                                                        fontSize: 18,
                                                        color:
                                                            member?.member_id ==
                                                                    chat?[index]
                                                                        .member
                                                                        .member_id
                                                                ? Colors.white
                                                                : Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          trailing: member?.member_id ==
                                                  chat?[index].member.member_id
                                              ? ClipOval(
                                                  child: SizedBox.fromSize(
                                                    size: const Size.fromRadius(
                                                        20), // Image radius
                                                    child: Image.network(
                                                        '$baseURL/member/${imgMemberFileName[index]}',
                                                        width: 10,
                                                        height: 10,
                                                        fit: BoxFit.cover),
                                                  ),
                                                )
                                              : null,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                    )
                  : Column(),
            ),
            Form(
              key: _formKey,
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        // height: 30,
                        width: 300,
                        child: TextFormField(
                          style: const TextStyle(
                            fontFamily: 'Itim',
                          ),
                          decoration: const InputDecoration(
                            labelText: "กรอกข้อความ",
                            hintText: "กรอกข้อความ",
                            counterText: "",
                          ),
                          controller: text,
                          validator: (Value) {
                            if (Value!.isNotEmpty) {
                              null;
                            } else {
                              return "กรุณากรอกข้อความ";
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, left: 10),
                        child: ElevatedButton(
                          onPressed: () {
                            _saveMessageToFirebase();
                          },
                          child: const Text(
                            "ส่งข้อความ",
                            style: TextStyle(
                              fontFamily: 'Itim',
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
