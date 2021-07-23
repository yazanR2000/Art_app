import 'dart:convert';

import 'package:artwork_app/screens/art_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import '../../widgets/video.dart';
import 'package:provider/provider.dart';
import '../../providers/server/profile_data.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
class RecentWork extends StatelessWidget {
  final BoxConstraints _constraints;
  final String _userId;

  RecentWork(this._constraints, this._userId);

  List _posts;

  Future getPosts() async {
    final response = await http
        .get(Uri.parse('${dotenv.env['IP_ADDRESS']}/recent/work/$_userId'));
    _posts = jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getPosts(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SliverToBoxAdapter(
            child: Container(
              height: _constraints.maxHeight * 0.3,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
        return SliverPadding(
          padding: EdgeInsets.only(
            left: _constraints.maxWidth / 15,
            right: _constraints.maxWidth / 30,
          ),
          sliver: SliverStaggeredGrid(
            delegate: SliverChildBuilderDelegate(
              (ctx, i) {
                bool isVideo =
                    _posts[i]['postImage'].toString().contains('mp4');
                String path =
                    _posts[i]['postImage'].toString().replaceAll('\\', '/');
                return GestureDetector(
                  onTap: () async {
                    try {
                      final response = await http.get(
                        Uri.parse(
                            '${dotenv.env['IP_ADDRESS']}/post/${_posts[i]['postId']}'),
                      );
                      final post = json.decode(response.body);
                      print(post);
                      final profile =
                      Provider.of<ProfileData>(context, listen: false);
                      await profile.profileData(
                        post['userId'],
                      );
                      Navigator.of(context).pushNamed(ArtInfo.routeName,arguments: {
                        'images': post['postImages'],
                        'postId': post['_id'],
                        'index': 0,
                        'caption': post['caption'],
                        'likes_length': post['likes'].length,
                        'comments_length' : post['comments'].length,
                        'profileData': profile.data,
                      });
                    } catch (err) {
                      print(err);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
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
                  ),
                );
              },
              childCount: _posts.length,
            ),
            gridDelegate: SliverStaggeredGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              staggeredTileCount: _posts.length,
              crossAxisSpacing: 8,
              staggeredTileBuilder: (i) => StaggeredTile.fit(1),
            ),
          ),
        );
      },
    );
  }
}
