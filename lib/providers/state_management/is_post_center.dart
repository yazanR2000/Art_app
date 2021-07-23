import 'package:flutter/cupertino.dart';

class PostCenter with ChangeNotifier{
  bool _isPlaying = false;
  int _index = -1;
  bool _isPause = false;
  bool get isPause{
    return _isPause;
  }
  bool get isPlaying {
    return _isPlaying;
  }
  int get index {
    return _index;
  }
  void onClick(bool play,int index){
    this._isPlaying = play;
    this._index = index;
    notifyListeners();
  }
  void pause(bool pause){
    this._isPause = pause;
  }
}