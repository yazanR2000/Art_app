import 'package:flutter/cupertino.dart';

class PostLike with ChangeNotifier{
  String _id = '';
  String get id{
    return _id;
  }

  void doubleTap(String postId){
    _id = postId;
    notifyListeners();
  }
}