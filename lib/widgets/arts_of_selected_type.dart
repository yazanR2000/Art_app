import 'package:artwork_app/providers/state_management/is_post_center.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../screens/art_info.dart';
import '../widgets/like_button.dart';
import './comment_button.dart';
import '../screens/profile_screen.dart';
import './post.dart';
import './save_button.dart';
import '../screens/art_info.dart';
import '../screens/profile_screen.dart';
import '../providers/server/posts.dart';
import './post_images.dart';
import '../providers/server/profile_data.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import './post.dart';

class ArtsOfSelectedType extends StatelessWidget {
  final BoxConstraints _constraints;

  ArtsOfSelectedType(this._constraints);

  final userId = FirebaseAuth.instance.currentUser.uid;

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  bool _isLike = false;

  Future _checkLike(String postId) async {
    final response = await http
        .get(Uri.parse('${dotenv.env['IP_ADDRESS']}/islike/$postId/$userId'));
    _isLike = response.body == 'true' ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<Posts>(context).getPosts(userId),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SliverToBoxAdapter(
            child: Container(
              height: 100,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
        final posts = Provider.of<Posts>(context, listen: false).posts;
        return SliverPadding(
          padding: EdgeInsets.all(_constraints.maxWidth / 25),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, index) {
                return Post(
                        _constraints,
                        posts[index]['_id'],
                        posts[index]['userId'],
                        posts[index]['profile_pic'],
                        posts[index]['full_name'],
                        posts[index]['postImages'],
                        index,
                        posts[index]['likes'].length,
                        posts[index]['comments'].length,
                        posts[index]['caption'],
                      );
//                    : Container(
//                        padding: EdgeInsets.only(
//                          right: 15,
//                          top: 15,
//                          left: 15,
//                          bottom: 0,
//                        ),
//                        height: _constraints.maxHeight * 0.69,
//                        margin: EdgeInsets.only(bottom: 30),
//                        decoration: BoxDecoration(
//                          color: Colors.white,
//                          borderRadius: BorderRadius.only(
//                            topLeft: Radius.circular(20),
//                            bottomLeft: Radius.circular(20),
//                            bottomRight: Radius.circular(20),
//                            topRight: Radius.circular(20),
//                          ),
//                        ),
//                        child: LayoutBuilder(
//                          builder: (ctx, constraints) => Column(
//                            children: [
//                              Row(
//                                mainAxisAlignment:
//                                    MainAxisAlignment.spaceBetween,
//                                children: [
//                                  Row(
//                                    mainAxisAlignment: MainAxisAlignment.start,
//                                    children: [
//                                      Container(
//                                        height: constraints.maxHeight * 0.11,
//                                        width: constraints.maxHeight * 0.11,
//                                        decoration: BoxDecoration(
//                                          color: Colors.blueAccent,
//                                          borderRadius:
//                                              BorderRadius.circular(100),
//                                        ),
//                                        child: ClipRRect(
//                                          borderRadius:
//                                              BorderRadius.circular(100),
//                                          child: GestureDetector(
//                                            onTap: () => Navigator.of(context)
//                                                .pushNamed(
//                                                    ProfileScreen.routeName,
//                                                    arguments: posts[index]
//                                                        ['userId']),
//                                            child: Image.network(
//                                              posts[index]['profile_pic'],
//                                              fit: BoxFit.cover,
//                                            ),
//                                          ),
//                                        ),
//                                      ),
//                                      SizedBox(
//                                        width: constraints.maxWidth * 0.02,
//                                      ),
//                                      Container(
//                                        alignment: Alignment.centerLeft,
//                                        width: constraints.maxWidth * 0.7,
//                                        child: FittedBox(
//                                          fit: BoxFit.scaleDown,
//                                          child: Text(
//                                            posts[index]['full_name'],
//                                          ),
//                                        ),
//                                      ),
//                                    ],
//                                  ),
//                                  Text(
//                                    '30min',
//                                    style: TextStyle(
//                                        color: Colors.grey[300], fontSize: 10),
//                                  ),
//                                ],
//                              ),
//                              SizedBox(
//                                height: constraints.maxHeight * 0.02,
//                              ),
//                              GestureDetector(
//                                child: Container(
//                                  height: constraints.maxHeight * 0.6,
//                                  margin: EdgeInsets.only(bottom: 20),
//                                  decoration: BoxDecoration(
//                                    borderRadius: BorderRadius.only(
//                                      topLeft: Radius.circular(20),
//                                      bottomLeft: Radius.circular(20),
//                                      bottomRight: Radius.circular(20),
//                                      topRight: Radius.circular(20),
//                                    ),
//                                  ),
//                                  child: PostImages(
//                                      posts[index]['postImages'], index),
//                                ),
//                              ),
//                              Row(
//                                mainAxisAlignment: MainAxisAlignment.center,
//                                children: [
//                                  FutureBuilder(
//                                    future: _checkLike(posts[index]['_id']),
//                                    builder: (ctx, btnshot) {
//                                      if (btnshot.connectionState ==
//                                          ConnectionState.waiting) {
//                                        return Container();
//                                      }
//                                      return LikeButton(
//                                          posts[index]['_id'],
//                                          posts[index]['likes'].length,
//                                          _isLike);
//                                    },
//                                  ),
//                                  Container(
//                                    width: 1,
//                                    margin: EdgeInsets.symmetric(
//                                      horizontal: constraints.maxWidth / 20,
//                                    ),
//                                    height: _constraints.maxHeight / 60,
//                                    color: Colors.grey,
//                                  ),
//                                  CommentButton(),
//                                  Container(
//                                    width: 1,
//                                    margin: EdgeInsets.symmetric(
//                                      horizontal: constraints.maxWidth / 20,
//                                    ),
//                                    height: _constraints.maxHeight / 60,
//                                    color: Colors.grey,
//                                  ),
//                                  SaveButton(posts[index]['_id'])
//                                ],
//                              ),
//                              Divider(),
//                              Row(
//                                crossAxisAlignment: CrossAxisAlignment.center,
//                                mainAxisAlignment:
//                                    MainAxisAlignment.spaceBetween,
//                                children: [
//                                  Text(
//                                    posts[index]['caption'].toString().length >
//                                            30
//                                        ? posts[index]['caption']
//                                                .toString()
//                                                .substring(0, 28) +
//                                            '...'
//                                        : posts[index]['caption'].toString(),
//                                    //style: TextStyle(color: Colors.grey.shade500)
//                                  ),
//                                  TextButton(
//                                    style: TextButton.styleFrom(
//                                        primary: Colors.black,
//                                        shape: RoundedRectangleBorder(
//                                          borderRadius:
//                                              BorderRadius.circular(100),
//                                        ),
//                                        backgroundColor: Colors.grey.shade100),
//                                    onPressed: () async {
//                                      final profile = Provider.of<ProfileData>(
//                                          context,
//                                          listen: false);
//                                      await profile.profileData(
//                                        posts[index]['userId'],
//                                      );
//                                      Provider.of<PostCenter>(context,
//                                              listen: false)
//                                          .pause(true);
//                                      Navigator.of(context).pushNamed(
//                                          ArtInfo.routeName,
//                                          arguments: {
//                                            'images': posts[index]
//                                                ['postImages'],
//                                            'postId': posts[index]['_id'],
//                                            'index': index,
//                                            'caption': posts[index]['caption'],
//                                            'likes_length':
//                                                posts[index]['likes'].length,
//                                            'profileData': profile.data,
//                                          });
//                                    },
//                                    child: Text('More'),
//                                  ),
//                                ],
//                              ),
//                            ],
//                          ),
//                        ),
//                      );
              },
              childCount: posts.length,
            ),
          ),
        );
      },
    );
  }
}
