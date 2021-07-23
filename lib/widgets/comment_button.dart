import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../screens/comments_screen.dart';

class CommentButton extends StatelessWidget {
  final String _postId;
  final int comments;
  CommentButton(this._postId,this.comments);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: TextButton.styleFrom(
        primary: Colors.blue,
        backgroundColor: Colors.blue.shade50,
        padding: EdgeInsets.symmetric(horizontal: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      icon: Icon(
        Icons.insert_comment_outlined,
        color: Colors.blue,
      ),
      label: Text(
        '$comments',
        style: TextStyle(
          fontSize: 10,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pushNamed(
          CommentsScreen.routeName,
          arguments: _postId,
        );
      },
    );
  }
}
