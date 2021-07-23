import 'package:flutter/material.dart';
import './like_button.dart';
import './comment_button.dart';
import '../screens/profile_screen.dart';
import './post_images.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import './save_button.dart';
import './comment_button.dart';
import './like_button.dart';
import 'package:provider/provider.dart';
import '../providers/server/profile_data.dart';
import '../providers/state_management/is_post_center.dart';
import '../screens/art_info.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
class Post extends StatefulWidget {
  final BoxConstraints _constraints;
  final String _postId;
  final String _postUserId;
  final String _user_profile_pic;
  final String full_name;
  final List _postImages;
  final int index;
  final int _likes;
  final int _comments;
  final String _caption;

  Post(
    this._constraints,
    this._postId,
    this._postUserId,
    this._user_profile_pic,
    this.full_name,
    this._postImages,
    this.index,
    this._likes,
    this._comments,
    this._caption,
  );

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  bool _isLike = false;
  final userId = FirebaseAuth.instance.currentUser.uid;

  Future _checkLike(String postId) async {
    final response = await http
        .get(Uri.parse('${dotenv.env['IP_ADDRESS']}/islike/$postId/$userId'));
    _isLike = response.body == 'true' ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        right: 15,
        top: 15,
        left: 15,
        bottom: 0,
      ),
      height: widget._constraints.maxHeight * 0.69,
      margin: EdgeInsets.only(bottom: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: LayoutBuilder(
        builder: (ctx, constraints) => Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: constraints.maxHeight * 0.11,
                      width: constraints.maxHeight * 0.11,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pushNamed(
                            ProfileScreen.routeName,
                            arguments: widget._postUserId,
                          ),
                          child: Image.network(
                            widget._user_profile_pic,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: constraints.maxWidth * 0.02,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      width: constraints.maxWidth * 0.7,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          widget.full_name,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  '30min',
                  style: TextStyle(color: Colors.grey[300], fontSize: 10),
                ),
              ],
            ),
            SizedBox(
              height: constraints.maxHeight * 0.02,
            ),
            GestureDetector(
              child: Container(
                height: constraints.maxHeight * 0.6,
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: PostImages(widget._postImages, widget.index,widget._postId),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FutureBuilder(
                  future: _checkLike(widget._postId),
                  builder: (ctx, btnshot) {
                    if (btnshot.connectionState == ConnectionState.waiting) {
                      return Container();
                    }
                    return LikeButton(widget._postId, widget._likes, _isLike);
                  },
                ),
                Container(
                  width: 1,
                  margin: EdgeInsets.symmetric(
                    horizontal: constraints.maxWidth / 20,
                  ),
                  height: widget._constraints.maxHeight / 60,
                  color: Colors.grey,
                ),
                CommentButton(widget._postId,widget._comments),
                Container(
                  width: 1,
                  margin: EdgeInsets.symmetric(
                    horizontal: constraints.maxWidth / 20,
                  ),
                  height: widget._constraints.maxHeight / 60,
                  color: Colors.grey,
                ),
                SaveButton(widget._postId)
              ],
            ),
            Divider(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget._caption.length > 30
                      ? widget._caption.substring(0, 28) + '...'
                      : widget._caption,
                  //style: TextStyle(color: Colors.grey.shade500)
                ),
                TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      backgroundColor: Colors.grey.shade100),
                  onPressed: () async {

                    final profile =
                        Provider.of<ProfileData>(context, listen: false);
                    await profile.profileData(
                      widget._postUserId,
                    );
                    Provider.of<PostCenter>(context, listen: false).pause(true);
                    Navigator.of(context)
                        .pushNamed(ArtInfo.routeName, arguments: {
                      'images': widget._postImages,
                      'postId': widget._postId,
                      'index': widget.index,
                      'caption': widget._caption,
                      'likes_length': widget._likes,
                      'comments_length' : widget._comments,
                      'profileData': profile.data,
                    });
                  },
                  child: Text('More'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
