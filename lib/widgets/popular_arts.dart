import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import './video.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
class PopularArts extends StatelessWidget {
  final BoxConstraints _constraints;

  PopularArts(this._constraints);


  final textColor = const TextStyle(color: Colors.black);

  var _posts = [];

  Future _popularArts() async {
    try {
      final response =
          await http.get(Uri.parse('${dotenv.env['IP_ADDRESS']}/popular/arts'));
      _posts = jsonDecode(response.body);
      print(_posts);
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _popularArts(),
      builder: (ctx, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return SliverToBoxAdapter(
            child: Container(
              height: _constraints.maxHeight * 0.12,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
        return SliverPadding(
          padding: EdgeInsets.only(
            left: _constraints.maxWidth / 15,
            top: _constraints.maxWidth / 15,
            bottom: _constraints.maxWidth / 15,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Text(
                'Popular Art',
                style: textColor,
              ),
              Container(
                height: _constraints.maxHeight * 0.12,
                margin: EdgeInsets.only(top: _constraints.maxWidth / 40),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(
                    _posts.length,
                    (index) => Container(
                      width: _constraints.maxWidth * 0.26,
                      margin: EdgeInsets.only(
                          right:_constraints.maxWidth / 40),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: _posts[index]['postImage']['img']
                                .toString()
                                .contains('.mp4')
                            ? Video(
                                _posts[index]['postImage']['img']
                                    .toString()
                                    .replaceAll('\\', '/'),
                              )
                            : Image.network(
                                '${dotenv.env['IP_ADDRESS']}/${_posts[index]['postImage']['img'].toString().replaceAll('\\', '/')}',
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        );
      },
    );
  }
}


