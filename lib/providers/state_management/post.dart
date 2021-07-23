import 'package:flutter/cupertino.dart';
import 'dart:io';
class Post with ChangeNotifier{

  List<File> _moreImages = List.filled(3, null);

  Map<String,Object> _post = {
    'main_image' : null,
    'title' : String,
    'caption' : String
  };

  Map<String,Object> get post {
    return _post;
  }


  List<File> get moreImages{
    return _moreImages;
  }


  void changeMainImage(File file){
    _post['main_image'] = file;
    notifyListeners();
  }
  void changeTitle(String title){
    _post['title'] = title;
  }
  void changeCaption(String caption){
    _post['caption'] = caption;
  }
  void changeMoreImages(File file,int index){
    _moreImages[index] = file;
    notifyListeners();
  }


  void resetValues(){
    _post['main_image'] = null;
    _post['title'] = '';
    _post['caption'] = '';
    _moreImages[0] = _moreImages[1] = _moreImages[2] = null;
    notifyListeners();
  }

}