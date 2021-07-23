import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../providers/state_management/post_like.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
class LikeButton extends StatefulWidget {
  final String _postId;
  int _likes;
  bool _isLike;

  LikeButton(this._postId, this._likes, this._isLike);

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  final userId = FirebaseAuth.instance.currentUser.uid;

  Future _toggleLike() async {
    setState(() {
      widget._isLike = !widget._isLike;
      if (widget._isLike) {
        widget._likes++;
      } else {
        widget._likes--;
      }
    });
    await http.patch(
        Uri.parse('${dotenv.env['IP_ADDRESS']}/post/${widget._postId}/$userId'));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PostLike>(
      builder: (ctx, post, _) {
        if(post.id == widget._postId){
          _toggleLike();
        }
        return TextButton.icon(
          style: TextButton.styleFrom(
            primary: widget._isLike ? Colors.white : Colors.red,
            backgroundColor: widget._isLike ? Colors.red : Colors.red.shade50,
            padding: EdgeInsets.symmetric(horizontal: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          icon: Icon(
            Icons.favorite,
            color: widget._isLike ? Colors.white : Colors.red,
          ),
          label: Text(
            '${widget._likes}',
            style: TextStyle(
              fontSize: 10,
            ),
          ),
          onPressed: _toggleLike,
        );
      },
    );
  }
}
