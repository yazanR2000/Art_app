import 'package:flutter/material.dart';
import '../screens/profile_screen.dart';
import 'package:google_fonts/google_fonts.dart';
class ArtistPicName extends StatelessWidget {
  final BoxConstraints _constraints;
  final String userId;
  final String userImage;
  final String full_name;
  ArtistPicName(this._constraints,this.userId,this.userImage,this.full_name);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: _constraints.maxHeight * 0.08,
          width: _constraints.maxHeight * 0.08,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: GestureDetector(
              onTap: () => Navigator.of(context)
                  .pushNamed(ProfileScreen.routeName,arguments: userId),
              child: Image.network(
                userImage,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              full_name,
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: _constraints.maxWidth / 35),
            ),
            Text(
              'Nature Artist',
              style: GoogleFonts.getFont(
                'Raleway',
                color: Color(0xffFFD460),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
