import 'package:flutter/cupertino.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
class GoogleOAuth with ChangeNotifier {
  final googleSignIn = GoogleSignIn();

  Future signInWithGoogle() async {
    final _user = await googleSignIn.signIn();
    final googleAuth = await _user.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    await FirebaseAuth.instance.signInWithCredential(credential);

    final user = FirebaseAuth.instance.currentUser;

    user.providerData.forEach((profile) async {
      return await http.post(
        Uri.parse('${dotenv.env['IP_ADDRESS']}/loginWith'),
        body: {
          'id': FirebaseAuth.instance.currentUser.uid,
          'full_name' : profile.displayName.toString(),
          'profileImage' : profile.photoURL.toString(),
        }
      );
    });
  }

  Future signOut() async {
    await FirebaseAuth.instance.signOut().then((value) {
      googleSignIn.disconnect();
    });
  }
}
