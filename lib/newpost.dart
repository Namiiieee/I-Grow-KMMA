import 'package:flutter/material.dart';

class NewPost extends StatelessWidget {
  const NewPost({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.lightGreen.shade100,
        child: const Center(
          child: Text('NewPost'),
        ),
      ),
    );
  }
}