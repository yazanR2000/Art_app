import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../widgets/video.dart';
import '../../screens/loved_items.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
class Gallery extends StatelessWidget {
  final BoxConstraints _constraints;
  final String userId;
  final String userFirstName;
  Gallery(this._constraints, this.userId,this.userFirstName);

  var posts = [];

  Future _user10Posts(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['IP_ADDRESS']}/user/posts/$userId'),
      );
      posts = jsonDecode(response.body);
      print(posts);
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(
        left: _constraints.maxWidth / 15,
        top: _constraints.maxWidth / 60,
        bottom: _constraints.maxWidth / 60,
      ),
      sliver: FutureBuilder(
        future: _user10Posts(userId),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SliverToBoxAdapter(
              child: Container(
                height: _constraints.maxHeight * 0.1,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }
          return SliverList(
            delegate: SliverChildListDelegate(
              [
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(LovedItems.routeName);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Gallery'),
                      Icon(Icons.keyboard_arrow_right),
                    ],
                  ),
                ),
                Container(
                  height: _constraints.maxHeight * 0.11,
                  margin: EdgeInsets.only(top: 10),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: List.generate(
                      posts.length,
                      (index) {
                        bool isVideo =
                        posts[index]['postImages'][0]['img'].toString().contains('mp4');
                        String path =
                        posts[index]['postImages'][0]['img'].toString().replaceAll('\\', '/');
                        return Container(
                          width: 100,
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: isVideo
                                ? Video(path)
                                : Image.network(
                              'http://192.168.1.12:3000/$path',
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
