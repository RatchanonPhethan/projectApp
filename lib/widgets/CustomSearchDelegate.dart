import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

import '../Model/post.dart';
import '../Screens/PostDetailScreen.dart';
import '../constant/constant_value.dart';
import '../controller/joinpost_controller.dart';
import '../controller/post_controller.dart';
import '../controller/searchPost_controller.dart';

class CustomSearchDelegate extends SearchDelegate {
  SearchPostController searchPostController = SearchPostController();
  JoinPostController joinPostController = JoinPostController();
  PostController postController = PostController();
  List<int> memberCounts = [];
  List<PostModel>? post;
  String? user;
  var outputFormat = DateFormat('dd/MM/yyyy hh:mm a');

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          if (query.isNotEmpty) {
            showResults(context);
          } else {
            showSuggestions(context);
          }
        },
        icon: const Icon(Icons.search),
      ),
    ];
  }

  // second overwrite to pop out of search menu
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  // third overwrite to show query result
  @override
  Widget buildResults(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: FutureBuilder(
          future: searchPostController.searchPost(query: query),
          builder: (context, snapshot) {
            List<PostModel>? post = snapshot.data;
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            if (query.isNotEmpty) {
              return Container(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView.builder(
                    itemCount: post?.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      String filePath = "${post?[index].member.img_member}";
                      var subimg = filePath.substring(
                          filePath.lastIndexOf('/') + 1, filePath.length);
                      return SingleChildScrollView(
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            constraints: const BoxConstraints(maxWidth: 1000),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Text(
                                    "${post?[index].post_name}",
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Expanded(
                                          child: Padding(
                                              padding: EdgeInsets.all(8),
                                              child: Center(
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          180),
                                                  child: Image.network(
                                                    ("$baseURL/member/$subimg"),
                                                    height: 50,
                                                    width: 50,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ))),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: 10, left: 140),
                                      child: Expanded(
                                          child: Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Center(
                                          child: Image.asset(
                                            ("images/img.jpg"),
                                            height: 50,
                                            width: 50,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Expanded(
                                          child: Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Text(
                                            "${post?[index].member.firstname}"),
                                      )),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: 10, left: 140),
                                      child: Expanded(
                                          child: Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Text(
                                            "${post?[index].product_price}"),
                                      )),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    RatingBar.builder(
                                      ignoreGestures: true,
                                      initialRating: 1,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 1,
                                      itemPadding: const EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (rating) {},
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Expanded(
                                          child: Column(
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.all(8),
                                              child: post?[index].post_status ==
                                                      "OPEN"
                                                  ? const Text(
                                                      "เปิดรับถึงวันที่")
                                                  : const Text("ปิดรับ")),
                                          Padding(
                                            padding: EdgeInsets.all(8),
                                            child: Text(outputFormat.format(
                                                post?[index].end_date
                                                    as DateTime)),
                                          ),
                                        ],
                                      )),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 10),
                                            child: SizedBox(
                                              height: 30,
                                              width: 10,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                )),
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                    return PostDetailScreen(
                                                        postId:
                                                            '${post?[index].post_id}');
                                                  }));
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: const [
                                                    Text("ดูรายละเอียด",
                                                        style: TextStyle(
                                                            fontSize: 10)),
                                                  ],
                                                ),
                                              ),
                                            ))),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ));
            } else {
              return const Center(child: Text("ไม่พบสินค้า"));
            }
          }),
    );
  }

  // last overwrite to show the
  // querying process at the runtime
  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(
      child: Text("ค้นหาโพสต์แชร์สินค้า"),
    );
  }
}
