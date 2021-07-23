import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../providers/server/post_comments.dart';
import 'package:google_fonts/google_fonts.dart';
import './add_comment_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Comments extends StatelessWidget {
  final String _postId;

  Comments(this._postId);

  String _profileImage = '';

  String _fullName = '';

  String _commentUserId = '';
  final _userId = FirebaseAuth.instance.currentUser.uid;

  Future _getUserComment(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['IP_ADDRESS']}/user/comment/$userId'),
      );
      var userInfo = json.decode(response.body);
      print(userInfo);
      _profileImage = userInfo['profileImage'];
      _fullName = userInfo['full_name'];
      _commentUserId = userInfo['userId'];
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: Container(
            //margin: EdgeInsets.only(bottom: constraints.maxHeight * 0.1),
            child: FutureBuilder(
              future: Provider.of<PostComments>(context).fetchComments(_postId),
              builder: (ctx, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final comments =
                    Provider.of<PostComments>(context, listen: false).comments;
                return ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (ctx, index) {
                    return Container(
                      child: Column(
                        children: [
                          FutureBuilder(
                            future: _getUserComment(comments[index]['userId']),
                            builder: (ctx, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return ListTile(
                                  leading: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.grey[200],
                                  ),
                                  title: Container(
                                    color: Colors.grey[100],
                                  ),
                                  subtitle: Text(
                                    comments[index]['comment'],
                                    style: GoogleFonts.getFont(
                                      'Raleway',
                                      color: Colors.black,
                                    ),
                                  ),
                                );
                              }
                              return ListTile(
                                trailing: _commentUserId == _userId
                                    ? Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                      )
                                    : null,
                                leading: CircleAvatar(
                                  radius: 20,
                                  backgroundImage: NetworkImage(_profileImage),
                                ),
                                title: Text(_fullName),
                                subtitle: Text(
                                  comments[index]['comment'],
                                  style: GoogleFonts.getFont(
                                    'Raleway',
                                    color: Colors.black,
                                  ),
                                ),
                              );
                            },
                          ),
                          if (index != comments.length - 1) Divider(),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            left: 8,
            right: 8,
            bottom: 5,
          ),
          //height: constraints.maxHeight * 0.1,
          alignment: Alignment.center,
          child: AddCommentField(_postId),
        )
      ],
    );
  }
}
