import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../widgets/video.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
class LovedItems extends StatefulWidget {
  static const routeName = 'LovedItems';

  @override
  _LovedItemsState createState() => _LovedItemsState();
}

class _LovedItemsState extends State<LovedItems> {
  final uid = FirebaseAuth.instance.currentUser.uid;
  var posts = [];

  Future _getPosts() async {
    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['IP_ADDRESS']}/user/posts/$uid'),
      );
      posts = jsonDecode(response.body);
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    //final posts = ModalRoute.of(context).settings.arguments as List;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        //title: Text('${posts['name']}\'s Gallery'),
        leading: IconButton(
          icon: Icon(Icons.west_outlined),
          color: Colors.black,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder(
        future: _getPosts(),
        builder: (ctx, snapShot) {
          if(snapShot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }
          return StaggeredGridView.builder(
            padding: EdgeInsets.all(10),
            gridDelegate: SliverStaggeredGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              staggeredTileCount: posts.length,
              crossAxisSpacing: 8,
              staggeredTileBuilder: (i) => StaggeredTile.fit(1),
            ),
            itemBuilder: (ctx, i) {
              //print(posts[i]['postImages']);
              bool isVideo = posts[i]['postImages'][0]['img']
                  .toString()
                  .contains('mp4');
              String path = posts[i]['postImages'][0]['img']
                  .toString()
                  .replaceAll('\\', '/');
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: isVideo
                      ? Video(path)
                      : Image.network(
                          '${dotenv.env['IP_ADDRESS']}/$path',
                          fit: BoxFit.cover,
                        ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
