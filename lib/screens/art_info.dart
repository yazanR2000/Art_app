import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../widgets/artist_pic_name.dart';
import '../widgets/like_button.dart';
import '../widgets/comment_button.dart';
import '../widgets/save_button.dart';
import '../widgets/post_images_info.dart';
import '../widgets/post_images.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/state_management/is_post_center.dart';

class ArtInfo extends StatefulWidget {
  static const routeName = 'ArtInfo';

  @override
  _ArtInfoState createState() => _ArtInfoState();
}

class _ArtInfoState extends State<ArtInfo> {
  final userId = FirebaseAuth.instance.currentUser.uid;


  @override
  Widget build(BuildContext context) {
    final Map postData = ModalRoute.of(context).settings.arguments as Map;
    return LayoutBuilder(
      builder: (ctx, constraints) => Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.west_outlined),
              color: Colors.black,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: constraints.maxWidth / 15,
              left: constraints.maxWidth / 15,
              right: constraints.maxWidth / 15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               Container(
                    height: constraints.maxHeight * 0.4,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(constraints.maxWidth / 20),
                      //color: Colors.black,
                    ),
                    child: PostImages(postData['images'], -1,postData['postId']),
                  ),
                SizedBox(
                  height: constraints.maxHeight * 0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    LikeButton(
                      postData['postId'],
                      postData['likes_length'],
                      true,
                    ),
                    Container(
                      width: 1,
                      height: constraints.maxHeight / 60,
                      color: Colors.grey,
                    ),
                    CommentButton(postData['postId'],postData['comments_length']),
                    Container(
                      width: 1,
                      height: constraints.maxHeight / 60,
                      color: Colors.grey,
                    ),
                    SaveButton(postData['_id'].toString())
                  ],
                ),
                Text(
                  'Astrology Capricorn',
                  style: TextStyle(fontSize: constraints.maxWidth / 20),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'May 06,2019',
                  style: TextStyle(
                      color: Colors.grey, fontSize: constraints.maxWidth / 40),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: constraints.maxWidth / 90,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ArtistPicName(
                        constraints,
                        postData['profileData']['userId'],
                        postData['profileData']['profileImage'],
                        postData['profileData']['full_name'],
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text('Follow'),
                        style: TextButton.styleFrom(
                          primary: Color(0xffFFD460),
                          backgroundColor: Colors.grey[50],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: constraints.maxHeight * 0.05,
                ),
                Text(
                  postData['caption'],
                  style:
                      GoogleFonts.getFont('Raleway', color: Colors.grey[500]),
                ),
                SizedBox(
                  height: constraints.maxHeight * 0.02,
                ),
//                ElevatedButton(
//                  style: ElevatedButton.styleFrom(
//                    primary: Color(0xffFFD460),
//                    elevation: 0,
//                    padding: EdgeInsets.symmetric(
//                      horizontal: constraints.maxWidth / 20,
//                    ),
//                    shape: RoundedRectangleBorder(
//                      borderRadius: BorderRadius.circular(100),
//                    ),
//                  ),
//                  onPressed: () {},
//                  child: Text('Save'),
//                ),
//                SizedBox(
//                  height: constraints.maxHeight * 0.04,
//                ),
                Text('More Work'),
                SizedBox(
                  height: constraints.maxHeight * 0.025,
                ),
                Container(
                  height: constraints.maxHeight * 0.15,
                  child: FutureBuilder(

                    builder: (ctx, snap) {
                      return ListView(
                        scrollDirection: Axis.horizontal,
                        children: List.generate(
                          10,
                          (index) => Container(
                            margin: EdgeInsets.only(
                                right: constraints.maxWidth / 50),
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
                ),
              ],
            ),
          )),
    );
  }
}
