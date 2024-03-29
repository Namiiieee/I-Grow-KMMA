import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_group9/login.dart';
import 'package:flutter_group9/mytimeline.dart';
import 'package:flutter_group9/profile.dart';
import 'package:flutter_group9/searchfriends.dart';
import 'package:flutter_group9/widget/custom_page_route.dart';
import 'package:flutter_group9/friend_info.dart';

class Friend extends StatefulWidget {
  @override
  FriendState createState() => FriendState();
}

class FriendState extends State<Friend> {
  @override
  Widget build(BuildContext context) {
    String? user = FirebaseAuth.instance.currentUser?.uid;
    final Stream<QuerySnapshot> friend = FirebaseFirestore.instance
        .collection('member')
        .where('userid', isEqualTo: user)
        // .orderBy('id')
        .snapshots();

    final Stream<QuerySnapshot> alluser =
        FirebaseFirestore.instance.collection('member').snapshots();

    return Scaffold(
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: alluser,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: const CircularProgressIndicator(),
              );
            } else {
              // return Text("Testing ...");
              var data = snapshot.requireData;

              return ListView.builder(
                itemCount: data.size,
                itemBuilder: (BuildContext context, int index) {
                  return StreamBuilder(
                    stream: friend,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot2) {
                      if (snapshot2.hasError) {
                        return Text("something is wrong");
                      }
                      if (snapshot2.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (data.docs[index]['userid'] == user) {
                        return SizedBox.shrink();
                      }

                      var added =
                          snapshot2.data!.docChanges[0].doc['friend_uid'];
                      // snapshot2.data!.docChanges[0].doc['pending_uid'];
                      bool check = added.contains(data.docs[index]['userid']);

                      if (!check) {
                        return SizedBox.shrink();
                      } else {
                        return Card(
                          elevation: 6,
                          margin: EdgeInsets.all(10),
                          child: ListTile(
                            leading: Icon(
                              Icons.group,
                              size: 30,
                            ),
                            title: Text("${data.docs[index]['username']}"),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FriendInfo(
                                        docid: snapshot.data!.docs[index]),
                                  ));
                            },
                            trailing: Wrap(
                              spacing: 12, // space between two icons
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(right: 0.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      //reject friend pending
                                      snapshot.data!.docs[index].reference
                                          .update({
                                        'friend_uid':
                                            FieldValue.arrayRemove([user]),
                                      }).whenComplete(() {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => Friend()));
                                        // Navigator.pop(context);
                                      });
                                      snapshot2.data!.docs[0].reference.update({
                                        'friend_uid': FieldValue.arrayRemove([
                                          snapshot.data!.docs[index]['userid']
                                        ]),
                                      }).whenComplete(() {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => Friend()));
                                        // Navigator.pop(context);
                                      });
                                    },
                                    child: Icon(
                                      Icons.cancel,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
