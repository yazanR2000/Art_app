import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
class ProfileData with ChangeNotifier {


  Map _data = {
    'full_name' :'',
    'profileImage' : '',
    'followers' : '',
    'likes' : '',
    'userId' : ''
  };

  Map get data{
    return _data;
  }

  Future profileData(String id) async {
    try {
      final response = await http.post (
          Uri.parse ( '${dotenv.env['IP_ADDRESS']}/profileData' ),
          body: {
            'id': id
          }
      );
      print ( jsonDecode ( response.body ) );

      final userData = jsonDecode ( response.body );
      print(userData);
      _data['userId'] = userData['id'];
      _data['full_name'] = userData['full_name'];
      _data['profileImage'] = userData['profileImage'];
      _data['followers'] = userData['num_followers'].toString();
      _data['likes'] = userData['likes'].toString();
    } catch (err){
      print(err);
    }
  }
}
