// import 'package:firebase/firebase.dart';
// import 'package:flutter_group9/chats/user.dart';

// import 'package:flutter/material.dart';

// class ChatsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) => Scaffold(
//         backgroundColor: Colors.blue,
//         body: SafeArea(
//           child: StreamBuilder<List<User>>(
//             stream: FirebaseApi.getUsers(),
//             builder: (context, snapshot) {
//               switch (snapshot.connectionState) {
//                 case ConnectionState.waiting:
//                   return Center(child: CircularProgressIndicator());
//                 default:
//                   if (snapshot.hasError) {
//                     print(snapshot.error);
//                     return buildText('Something Went Wrong Try later');
//                   } else {
//                     final users = snapshot.data;

//                     if (users.isEmpty) {
//                       return buildText('No Users Found');
//                     } else
//                       return Column(
//                         children: [
//                           ChatHeaderWidget(users: users),
//                           ChatBodyWidget(users: users)
//                         ],
//                       );
//                   }
//               }
//             },
//           ),
//         ),
//       );

//   Widget buildText(String text) => Center(
//         child: Text(
//           text,
//           style: TextStyle(fontSize: 24, color: Colors.white),
//         ),
//       );
// }