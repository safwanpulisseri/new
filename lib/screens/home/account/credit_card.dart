// import 'package:flutter/material.dart';
// import 'package:rupee_app/screens/home/account/account.dart';

// class ScreenCreditCard extends StatelessWidget {
//   const ScreenCreditCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
//       body: SingleChildScrollView(
//         child: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(colors: [Colors.red, Colors.orange]),
//           ),
//           child: Column(
//             children: [
//               SizedBox(
//                 height: 100,
//                 child: Column(
//                   children: [
//                     SizedBox(
//                       height: 50,
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => ScreenAccount()));
//                       },
//                       child: Row(
//                         children: [
//                           SizedBox(
//                             width: 30,
//                           ),
//                           Icon(
//                             Icons.arrow_back_ios,
//                             color: Colors.white,
//                           ),
//                           Text(
//                             'My Cards',
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 25,
//                                 fontWeight: FontWeight.w600),
//                           )
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 height: 640,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(30),
//                         topRight: Radius.circular(30))),
//                 child: Column(
//                   children: [
//                     FloatingActionButton(
//                       onPressed: () {},
//                       backgroundColor: Colors.transparent,
//                       child: Container(
//                         decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                               colors: [Colors.red, Colors.orange],
//                             ),
//                             borderRadius: BorderRadius.circular(20)),
//                         child: Icon(Icons.add),
//                         padding: EdgeInsets.all(16),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
