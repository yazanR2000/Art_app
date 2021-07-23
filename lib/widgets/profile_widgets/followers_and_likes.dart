import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FollowersAndLikes extends StatelessWidget {
  final String followers;
  final String likes;
  FollowersAndLikes(this.followers,this.likes);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(2),
              child: Icon(
                Icons.person_outline,
                color: Colors.blue,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                //color: Colors.black45,
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  followers,
                  style: TextStyle(
                      //color: Colors.white,
                      ),
                ),
                Text(
                  'followers',
                  style: GoogleFonts.getFont(
                    'Raleway',
                    //color: Colors.white70,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          width: 50,
        ),
        Row(
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(2),
              child: Icon(
                Icons.favorite_border,
                color: Colors.red,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                //color: Colors.black45,
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  likes,
                  style: TextStyle(
                    //color: Colors.white,
                  ),
                ),
                Text(
                  'likes',
                  style: GoogleFonts.getFont(
                    'Raleway',
                    //color: Colors.white70,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
