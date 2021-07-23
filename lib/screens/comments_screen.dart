

import 'package:flutter/material.dart';
import '../widgets/comments.dart';

class CommentsScreen extends StatelessWidget {
  static const routeName = 'CommentsScreen';


  @override
  Widget build(BuildContext context) {
    final postId = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Comments'),
        leading: IconButton(
          icon: Icon(Icons.close),
          color: Colors.black,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Comments(postId)
    );
  }
}
