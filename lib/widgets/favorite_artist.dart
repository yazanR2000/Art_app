import 'package:artwork_app/providers/oauth/google.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/artist_search_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../providers/oauth/facebook.dart';

class FavoriteArtist extends StatelessWidget {
  final BoxConstraints _constraints;

  FavoriteArtist(this._constraints);

  FirebaseAuth _auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser;

  final googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    final googleProvider = Provider.of<GoogleOAuth>(context, listen: false);
    final facebookProvider = Provider.of<FacebookOAuth>(context, listen: false);
    return SliverAppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Text(
        'ArtWork',
        style: GoogleFonts.getFont(
          'Satisfy',
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(_constraints.maxWidth / 15),
          bottomRight: Radius.circular(_constraints.maxWidth / 15),
        ),
      ),
      elevation: 0,
      expandedHeight: _constraints.maxHeight * 0.30,
      pinned: false,
      flexibleSpace: FlexibleSpaceBar(
        //collapseMode: CollapseMode.pin,
        background: SingleChildScrollView(
          reverse: true,
          child: Padding(
            padding: EdgeInsets.all(_constraints.maxWidth / 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.all(0),
                  ),
                    onPressed: () {
                      user.providerData.forEach((profile) {
                        final oAuthProvider = profile.providerId.toString();
                        if (oAuthProvider.contains('google')) {
                          googleProvider.signOut();
                        } else if (oAuthProvider.contains('facebook')) {
                          facebookProvider.signOut();
                        }
                      });
                    },
                    child: Text('Sign out')),
                Text(
                  'Find Your',
                  style: TextStyle(
                      color: Colors.grey, fontSize: _constraints.maxWidth / 28),
                ),
                SizedBox(
                  height: _constraints.maxWidth / 90,
                ),
                Text(
                  'Favorite Artist',
                  style: TextStyle(fontSize: _constraints.maxWidth / 25),
                ),
                SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () =>
                      Navigator.of(context).pushNamed(ArtistSearchScreen.routeName),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: _constraints.maxWidth / 50,
                      vertical: _constraints.maxWidth / 40,
                    ),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(_constraints.maxWidth / 10),
                      color: Colors.white,
                      border: Border.all(color: Colors.grey[300]),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search),
                        SizedBox(
                          width: _constraints.maxWidth * 0.02,
                        ),
                        Text(
                          'Search',
                          style: GoogleFonts.getFont(
                            'Raleway',
                            color: Colors.grey,
                            fontSize: 15.5,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
