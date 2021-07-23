import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
class MoreWorks extends StatelessWidget {
  final BoxConstraints constraints;
  final String userId;

  MoreWorks(this.constraints, this.userId);

  var works = [];

  Future _getMoreWorks() async {
    try {
      final response = await http
          .get(Uri.parse('${dotenv.env['IP_ADDRESS']}/more/works/$userId'));
      works = jsonDecode(response.body);
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: constraints.maxHeight * 0.15,
      child: FutureBuilder(
        future: _getMoreWorks(),
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            scrollDirection: Axis.horizontal,
            children: List.generate(
              works.length,
              (index) => Container(
                margin: EdgeInsets.only(
                  right: constraints.maxWidth / 50,
                ),
                width: constraints.maxHeight * 0.15,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
