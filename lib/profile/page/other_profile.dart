import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_group9/chats/chatbox.dart';

import 'package:flutter_group9/profile/widget/appbar_widget.dart';
import 'package:flutter_group9/profile/widget/button_widget.dart';
import 'package:flutter_group9/profile/widget/profile_widget.dart';

class ProfilePage2 extends StatefulWidget {
  final String userid;
  const ProfilePage2({Key? key, required this.userid}) : super(key: key);

  @override
  _ProfilePageState2 createState() => _ProfilePageState2(userid: this.userid);
}

String? documentId;

class _ProfilePageState2 extends State<ProfilePage2> {
  String userid;
  _ProfilePageState2({required this.userid});
  String? userID;
  String name = "";
  String email = "";
  String phone = "";
  String location = "";
  String about = "";
  String status = "";
  String dpUrl = "";

  @override
  Widget build(BuildContext context) {
    userID = userid;
    Stream prof() async* {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userID)
          .get()
          .then((value) {
        email = value.data()!["email"];
        name = value.data()!["username"];
        location = value.data()!["location"];
        phone = value.data()!["phone"].toString();
        status = value.data()!["status"];
        dpUrl = value.data()!["dpUrl"];
        about = value.data()!["about"];
      });
    }

    return Scaffold(
      backgroundColor: Colors.lightGreen.shade100,
      appBar: buildAppBar(context),
      body: StreamBuilder(
          stream: prof(),
          builder: (context, snapshot) {
            return ListView(
              physics: BouncingScrollPhysics(),
              children: [
                ProfileWidget(
                  imagePath: dpUrl,
                  onClicked: () async {},
                ),
                const SizedBox(height: 24),
                buildName(),

                const SizedBox(height: 24),
                buildNumber(), //buildlocationbaru

                // const SizedBox(height: 24),
                // buildLocation(),
                const SizedBox(height: 24),
                buildStatus(),

                const SizedBox(height: 48),
                buildAbout(),

                const SizedBox(height: 148),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: floatingActionButton(),
                  ),
                ),
              ],
            );
          }),
    );
  }

  Widget buildName() => Column(
        children: [
          Text(
            name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            email,
            style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black),
          )
        ],
      );

  Widget buildAbout() => Container(
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              about,
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 16,
                  height: 1.4,
                  color: Colors.black),
            ),
          ],
        ),
      );

  // Widget buildLocation() => Container(
  //       padding: EdgeInsets.symmetric(horizontal: 48),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             'Location',
  //             style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  //           ),
  //           const SizedBox(height: 16),
  //           Text(
  //             location,
  //             style: TextStyle(fontSize: 16, height: 1.4),
  //           ),
  //         ],
  //       ),
  //     );

  Widget buildStatus() => Container(
        padding: EdgeInsets.symmetric(horizontal: 48, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              status,
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 16,
                  height: 1.4,
                  color: Colors.black),
            ),
          ],
        ),
      );

  Widget buildNumber() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          buildButton(context, Icons.location_pin, location),
        ],
      );
  Widget buildDivider() => Container(
        height: 24,
        child: VerticalDivider(),
      );

  Widget buildButton(BuildContext context, IconData icon, String value) =>
      MaterialButton(
        padding: const EdgeInsets.symmetric(vertical: 4),
        onPressed: () {},
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 5),
            Icon(
              Icons.location_pin,
              color: Colors.black,
              size: 30.0,
              semanticLabel: 'Text to announce in accessibility modes',
            ),
            Text(
              value,
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 20),
            ),
          ],
        ),
      );
  // Widget buildUpgradeButton() => ButtonWidget(
  //       text: 'Chatroom',
  //       onClicked: () {
  //         Navigator.of(context).push(MaterialPageRoute(
  //             builder: (BuildContext context) => ChatScreen()));
  //       },
  //     );

  Widget floatingActionButton() => FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => ChatScreen()));
        },
        child: const Icon(Icons.chat_bubble),
        backgroundColor: Colors.green[700],
        tooltip: "Chatroom",
      );
}
