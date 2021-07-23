import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
class SavedItems with ChangeNotifier {
  List _savedItems = [];

  List get savedItems {
    return _savedItems;
  }

  Future getItems(String id) async {
    try {
      final response = await http.get (
        Uri.parse ( '${dotenv.env['IP_ADDRESS']}/savedItems/$id' ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        _savedItems = json.decode(response.body)['saves'];
      }
    }catch (err){
      print(err);
    }
  }
}
