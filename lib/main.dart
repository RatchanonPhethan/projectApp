import 'package:flutter/material.dart';
import 'package:flutter_project_application/styles/styles.dart';
import 'package:flutter_project_application/widgets/MenuFooter.dart';
import 'package:flutter_project_application/widgets/MenuWidget.dart';

import 'Screens/Home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
dddd
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PROJECT APP',
      home: MainPage(),
    );
  }
}
