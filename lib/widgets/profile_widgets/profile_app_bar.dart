import 'package:flutter/material.dart';
import './followers_and_likes.dart';
import './message_and_follow.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileAppBar extends StatelessWidget {
  final BoxConstraints _constraints;
  final Map _userData;
  final String userId;

  ProfileAppBar(this._constraints, this._userData, this.userId);

  final id = FirebaseAuth.instance.currentUser.uid;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      pinned: false,
      floating: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(_constraints.maxWidth / 15),
          bottomRight: Radius.circular(_constraints.maxWidth / 15),
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.west_outlined),
        color: Colors.black,
        onPressed: () => Navigator.of(context).pop(),
      ),
      expandedHeight: _constraints.maxHeight * 0.6,
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: _constraints.maxHeight * 0.2,
                width: _constraints.maxHeight * 0.2,
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10000)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10000),
                  child: Image.network(
                    _userData['profileImage'],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Text(
                _userData['full_name'],
                style: GoogleFonts.getFont(
                  'Raleway',
                  //color: Colors.white,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              FollowersAndLikes(_userData['followers'], _userData['likes']),
              SizedBox(
                height: 25,
              ),
              if (userId != id) MessageAndFollow(userId),
            ],
          ),
        ),
      ),
    );
  }
}
