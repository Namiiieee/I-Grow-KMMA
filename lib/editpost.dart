import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_group9/mytimeline.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class EditPost extends StatefulWidget {
  final String docID;
  EditPost({Key? key, required this.docID}) : super(key: key);

  @override
  _EditPostState createState() => _EditPostState(docID: this.docID);
}

bool image = false;
String imageUrl = "";
DateTime now = DateTime.now();
CollectionReference sharing = FirebaseFirestore.instance.collection('sharing');

class _EditPostState extends State<EditPost> {
  String docID;
  _EditPostState({required this.docID});
  File? imageFile;
  bool _isLoading = false;
  final myController = TextEditingController();
  late VideoPlayerController _videoPlayerController;
  late VideoPlayerController _cameraVideoPlayerController;
  @override
  Widget build(BuildContext context) {
    Future<void> updatePost() async {
      try {
        if (imageFile != null) {
          setState(() {
            _isLoading = true;
          });
          final ref = FirebaseStorage.instance.ref().child(imageFile!.path);
          await ref.putFile(imageFile!);
          imageUrl = await ref.getDownloadURL();
        }
      } catch (error) {
        Text("Error");
        print('error occured ${error}');
      }
      print(docID);
      return sharing
          .doc(docID)
          .update(
              {'caption': myController.text, 'imageUrl': imageUrl, 'time': now})
          .then((value) => print("User Updated"))
          .catchError((error) => print("Failed to update user: $error"));
    }

    void _openCamImage(BuildContext context) async {
      final pickedFile =
          await ImagePicker().getImage(source: ImageSource.camera);
      final pickedImageFile = File(pickedFile!.path);
      setState(() {
        imageFile = pickedImageFile;
        image = true;
      });
      //Navigator.pop(context);
    }

    // void _openCamVid(BuildContext context) async {
    //   final pickedFile =
    //       await ImagePicker().getVideo(source: ImageSource.camera);
    //   final pickedImageFile = File(pickedFile!.path);
    //   setState(() {
    //     imageFile = pickedImageFile;
    //image = true;
    //   });

    //   _cameraVideoPlayerController = VideoPlayerController.file(imageFile!)
    //     ..initialize().then((_) {
    //       setState(() {});
    //       _cameraVideoPlayerController.play();
    //     });

    //   Navigator.pop(context);
    // }

    void _openLibImage(BuildContext context) async {
      final pickedFile =
          await ImagePicker().getImage(source: ImageSource.gallery);
      final pickedImageFile = File(pickedFile!.path);
      setState(() {
        imageFile = pickedImageFile;
        image = true;
      });
    }

    void _openLibVid(BuildContext context) async {
      final pickedFile =
          await ImagePicker().getVideo(source: ImageSource.gallery);
      final pickedImageFile = File(pickedFile!.path);
      _videoPlayerController = VideoPlayerController.file(pickedImageFile)
        ..initialize().then((_) {
          setState(() {});
          _videoPlayerController.play();
        });
    }

    void _remove(BuildContext context) {
      setState(() {
        imageFile = null;
        image = false;
      });
    }

    return Scaffold(
        backgroundColor: Colors.lightGreen[100],
        appBar: AppBar(
            centerTitle: true,
            // leadingWidth: 75,
            // actionsIconTheme: ,
            title: Text("Edit post",
                style: TextStyle(
                    color: Colors.green.shade700,
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
            elevation: 1,
            backgroundColor: Colors.lightGreen[100],
            automaticallyImplyLeading: true,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.clear),
              color: Colors.green.shade700,
              tooltip: "Post",
            ),
            actions: <Widget>[
              // IconButton(onPressed: (){}, icon: Icon(Icons.post_add_outlined), color: Colors.green.shade700, tooltip: "Post", )
              OutlinedButton(
                style: ButtonStyle(
                  side: MaterialStateProperty.all(
                      BorderSide(color: Colors.transparent)),
                  overlayColor:
                      MaterialStateProperty.all<Color>(Colors.transparent),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.green.shade700),
                ),
                onPressed: () {
                  if (myController.text.isNotEmpty || image) {
                    updatePost();
                    _remove(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyTimeline(),
                        ));
                  } else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Post is Empty",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                                textAlign: TextAlign.center),
                          );
                        });
                  }
                },
                child: Text("Post"),
              ),
            ]),
        body: SingleChildScrollView(
          child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 24,
                  ),
                  PhysicalModel(
                    color: Colors.transparent,
                    shadowColor: Colors.green,
                    elevation: 20,
                    child: Container(
                      width: 360,
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Column(
                        children: <Widget>[
                          TextField(
                            controller: myController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(0),
                              border: InputBorder.none,
                              labelText: "Have something to share?",
                              labelStyle: TextStyle(fontSize: 15),

                              // isDense: true,
                            ),
                          ),
                          SizedBox(
                            height: 60,
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  PhysicalModel(
                    color: Colors.transparent,
                    shadowColor: Colors.green,
                    elevation: 20,
                    child: Container(
                      width: 360,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          //Camera
                          Row(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.camera),
                                color: Colors.purple.shade600,
                                onPressed: () {
                                  _openCamImage(context);
                                  // showDialog(
                                  //     context: context,
                                  //     builder: (BuildContext context) {
                                  //       return AlertDialog(
                                  //         title: Text(
                                  //           "Choose option",
                                  //           style:
                                  //               TextStyle(color: Colors.blue),
                                  //         ),
                                  //         content: SingleChildScrollView(
                                  //           child: ListBody(
                                  //             children: [
                                  //               Divider(
                                  //                 height: 1,
                                  //                 color: Colors.blue,
                                  //               ),
                                  //               ListTile(
                                  //                 onTap: () {
                                  //                   _openCamImage(context);
                                  //                 },
                                  //                 title: Text("Image"),
                                  //               ),
                                  //               Divider(
                                  //                 height: 1,
                                  //                 color: Colors.blue,
                                  //               ),
                                  //               ListTile(
                                  //                 onTap: () {
                                  //                   _openCamVid(context);
                                  //                 },
                                  //                 title: Text("Video"),
                                  //               ),
                                  //             ],
                                  //           ),
                                  //         ),
                                  //       );
                                  //     });
                                },
                              ),
                              Text(
                                "Camera",
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.photo_library),
                                color: Colors.blue.shade600,
                                onPressed: () {
                                  _openLibImage(context);
                                },
                              ),
                              Text("Photo"),
                            ],
                          ),

                          Row(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.videocam),
                                color: Colors.red.shade600,
                                onPressed: () {
                                  _openLibVid(context);
                                },
                              ),
                              Text("Video"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  PhysicalModel(
                      color: Colors.transparent,
                      shadowColor: Colors.green,
                      elevation: 20,
                      child: (imageFile == null)
                          ? (Text(""))
                          : (Container(
                              margin: EdgeInsets.only(bottom: 20.0),
                              width: 360,
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(children: [
                                SizedBox(
                                    width: double.infinity,
                                    height: 200,
                                    child: FittedBox(
                                        fit: BoxFit.fill,
                                        child:
                                            Image.file(File(imageFile!.path)))),
                                IconButton(
                                  icon: Icon(
                                    Icons.clear_rounded,
                                  ),
                                  color: Colors.red,
                                  onPressed: () {
                                    _remove(context);
                                  },
                                )
                              ]))))
                ],
              )),
        ));
  }
}