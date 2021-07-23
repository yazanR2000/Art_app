import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
class PostComments with ChangeNotifier {

  List<dynamic> _comments = [];

  List<dynamic> get comments{
    return _comments;
  }

  Future fetchComments(String postId) async {
    try {
      final response = await http.get (
        Uri.parse ( '${dotenv.env['IP_ADDRESS']}/post/comments/$postId' ),
      );
      _comments = jsonDecode(response.body);
    }catch(err){
      print(err);
    }
  }

  Future addComment(String postId,String comment,String userId) async {
    try {
      await http.patch(Uri.parse('${dotenv.env['IP_ADDRESS']}/add/comment'), body: {
        "postId":postId,
        "comment": comment,
        "userId": userId
      });
      notifyListeners();
      print('done');
    } catch (err) {
      print(err);
    }
  }

}