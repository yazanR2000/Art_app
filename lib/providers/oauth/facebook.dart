import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
class FacebookOAuth with ChangeNotifier{
  FirebaseAuth _auth = FirebaseAuth.instance;


  Future signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success) {
      // Create a credential from the access token
      final OAuthCredential credential =
      FacebookAuthProvider.credential(result.accessToken.token);

      final userData = await FacebookAuth.instance.getUserData();
      print(userData);

      // Once signed in, return the UserCredential
      await _auth.signInWithCredential(credential);
      await http.post(
          Uri.parse('${dotenv.env['IP_ADDRESS']}/loginWith'),
          body: {
            'full_name' : userData['name'].toString(),
            'id' : FirebaseAuth.instance.currentUser.uid,
            'profileImage' : userData['picture']['data']['url'].toString(),
          }
      );
    }
    return null;
  }

  Future signOut() async {
    await _auth.signOut().then((value){
      FacebookAuth.instance.logOut();
      //googleSignIn.disconnect();
    });
  }
}