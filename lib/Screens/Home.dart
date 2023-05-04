import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../styles/styles.dart';
import '../widgets/MenuWidget.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: Text(
          "PROJECT APP",
          style: TextStyle(color: KFontColor),
        ),
        backgroundColor: kPrimary,
      ),
      drawer: MenuWidget(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_rounded),
            label: 'Add Post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      // body: SpinKitWave(
      //   color: Colors.redAccent,
      //   size: 200,
      //   duration: Duration(seconds: 3),
      // ),
    );
  }
}
