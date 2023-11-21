// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
// import 'package:flutter_project_application/widgets/MenuFooter.dart';

// import '../styles/styles.dart';
// import '../widgets/CustomSearchDelegate.dart';
// import '../widgets/MenuWidget.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Text(
//           "Home",
//           style: TextStyle(color: KFontColor),
//         ),
//         actions: [
//           IconButton(
//             onPressed: () {
//               // method to show the search bar
//               showSearch(
//                   context: context,
//                   // delegate to customize the search bar
//                   delegate: CustomSearchDelegate());
//             },
//             icon: const Icon(
//               Icons.search,
//               color: Colors.black,
//             ),
//           )
//         ],
//         backgroundColor: kPrimary,
//       ),
//       drawer: const MenuWidget(),
//     );
//   }
// }
