import 'package:flutter/cupertino.dart';

class Nav with ChangeNotifier {
  Map _scrolls = {
    'top' : false,
    'bottom' : false
  };

  Map get scrolls{
    return _scrolls;
  }

  void changeScroll(String state){
    if(state == 'top'){
      _scrolls['top'] = true;
      _scrolls['bottom'] = false;
    }else{
      _scrolls['top'] = false;
      _scrolls['bottom'] = true;
    }
    notifyListeners();
  }
}