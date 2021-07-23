import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
class SearchUsers with ChangeNotifier {
  List _users = [];
  bool _isLoading = false;
  List get users {
    return _users;
  }
  bool get isLoading{
    return _isLoading;
  }
  Future fetchUsers(String name) async {

    try {
      _isLoading = true;
      notifyListeners();
      final response = await http.get(
        Uri.parse('${dotenv.env['IP_ADDRESS']}/search/${name}'),
      );
      _users = jsonDecode(response.body);
      _isLoading = false;
    } catch (err) {
      _isLoading = false;
      print(err);
    }
    notifyListeners();
  }
}
