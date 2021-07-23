import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../providers/oauth/facebook.dart';
import '../providers/oauth/google.dart';

import 'dart:convert';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  static const routeName = 'AuthScreen';
  FirebaseAuth _auth = FirebaseAuth.instance;

  User _user;

  bool _isLog = true;

  void _changeState() {
    setState(() {
      _isLog = !_isLog;
    });
  }

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final facebookProvider = Provider.of<FacebookOAuth>(context, listen: false);
    final googleProvider = Provider.of<GoogleOAuth>(context, listen: false);
    return LayoutBuilder(
      builder: (ctx, constraints) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('ArtWork'),
          centerTitle: true,
          elevation: 0,
          leading: !_isLog
              ? IconButton(
                  onPressed: () => _changeState(),
                  icon: Icon(Icons.arrow_back),
                )
              : null,
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Form(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                      vertical: constraints.maxHeight * 0.1,
                      horizontal: constraints.maxWidth * 0.1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Text('Log in to your Account'),
                      SizedBox(
                        height: 20,
                      ),
                      if (!_isLog)
                        Align(
                          alignment: Alignment.center,
                          child: CircleAvatar(
                            radius: 80,
                            //backgroundColor: Colors.black,
                            //backgroundImage: NetworkImage(''),
                          ),
                        ),
                      SizedBox(
                        height: 20,
                      ),
                      if (!_isLog)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          height: constraints.maxHeight * 0.08,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                offset: Offset(1, 3),
                                blurRadius: 5,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Center(
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Full Name',
                                hintStyle: GoogleFonts.getFont('Raleway',
                                    fontSize: 15, color: Colors.grey),
                              ),
                              obscureText: true,
                            ),
                          ),
                        ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: constraints.maxHeight * 0.08,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              offset: Offset(1, 3),
                              blurRadius: 5,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: Center(
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Email',
                              hintStyle: GoogleFonts.getFont('Raleway',
                                  fontSize: 15, color: Colors.grey),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: constraints.maxHeight * 0.08,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              offset: Offset(1, 3),
                              blurRadius: 5,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Center(
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Password',
                              hintStyle: GoogleFonts.getFont('Raleway',
                                  fontSize: 15, color: Colors.grey),
                            ),
                            obscureText: true,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                primary: Color(0xff03256C),
                              ),
                              onPressed: () {},
                              child: Text(_isLog ? 'Sign in' : 'Sign up'),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      Align(
                        alignment: AlignmentDirectional.center,
                        child: Text(
                          _isLog ? 'Or sign in with :' : 'Or sign up with :',
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 15)),
                              onPressed: () async {
                                setState(() {
                                  _isLoading = true;
                                });
                                try {
                                  await googleProvider.signInWithGoogle ( );
                                }catch (err){
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }

                              },
                              child: FaIcon(
                                FontAwesomeIcons.google,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 15)),
                              onPressed: () async {
                                setState(() {
                                  _isLoading = true;
                                });
                                try {
                                  await facebookProvider.signInWithFacebook ( );
                                }catch (err) {
                                  setState ( () {
                                    _isLoading = false;
                                  } );
                                }
                              },
                              child: FaIcon(
                                FontAwesomeIcons.facebook,
                                color: Color(0xff03256C),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 15)),
                              onPressed: () {},
                              child: FaIcon(
                                FontAwesomeIcons.twitter,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (_isLog)
                        SizedBox(
                          height: 50,
                        ),
                      if (_isLog)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Don\'t have an account?'),
                            TextButton(
                              onPressed: _changeState,
                              child: Text('Sing up'),
                            ),
                          ],
                        )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
