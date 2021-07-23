import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
class EmailPass with ChangeNotifier {

  Future createUserWithEmailAndPassword(String email,String pass)async{
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: pass);
    }catch (err){
      print(err);
    }
  }

  Future signInWithEmailAndPass(String email,String pass)async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: pass);
    }catch(err){
      print(err);
    }
  }
}
