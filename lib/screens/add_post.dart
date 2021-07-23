import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../widgets/post_widgets/main_image.dart';
import '../widgets/post_widgets/more_images.dart';
import '../widgets/post_widgets/post_title.dart';
import '../providers/state_management/post.dart';
import '../widgets/post_widgets/post_caption.dart';
import '../widgets/post_widgets/demo_post_dialog.dart';
import '../providers/server/posts.dart';

class AddPostScreen extends StatefulWidget {
  static const routeName = 'AddPostScreen';

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 0)).then((value) {
      Provider.of<Post>(context, listen: false).resetValues();
    });
    super.initState();
  }

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
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
          actions: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                  backgroundColor: Colors.blue,
                  primary: Colors.white,
                ),
                onPressed: () async {
                  final post = Provider.of<Post>(context, listen: false);
                  if (post.post['main_image'] != null) {
                    final addPostProvider =
                        Provider.of<Posts>(context, listen: false);
                    try {
                      await addPostProvider.addPost (
                        post.post['title'],
                        post.post['caption'],
                        user.uid,
                        post.post['main_image'],
                        post.moreImages,
                      );
                    }catch(err){
                      print(err);
                    }
                    //post.resetValues();
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                     duration: Duration(milliseconds: 1500),
                     backgroundColor: Colors.green,
                     content: Row(
                       mainAxisAlignment: MainAxisAlignment.start,
                       children: [
                         Icon(Icons.done,color: Colors.white,),
                         SizedBox(width: 10,),
                         Text('Post Added Successfully!'),
                       ],
                     ),
                   ));
                  }else{
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      duration: Duration(milliseconds: 2000),
                      backgroundColor: Colors.red,
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.warning_rounded,color: Colors.white,),
                          SizedBox(width: 10,),
                          Text('Please add main Block for post!'),
                        ],
                      ),
                    ));
                  }
                },
                child: Text('Post'),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(constraints.maxWidth / 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MainImage(constraints),
              SizedBox(
                height: 10,
              ),
              Container(
                height: constraints.maxHeight * 0.1,
                child: MoreImages(constraints),
              ),
              SizedBox(
                height: 20,
              ),
              PostTitle(constraints),
              SizedBox(
                height: 20,
              ),
              PostCaption(constraints),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 20),
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (ctx) {
                              final providerCheck =
                                  Provider.of<Post>(context, listen: false)
                                      .post;
                              if (providerCheck['main_image'] != null) {
                                return DemoPostDialog(
                                  constraints,
                                  providerCheck['main_image'],
                                );
                              }
                              return AlertDialog(
                                title: Text('Main Image!'),
                                content: Text(
                                  'Please add main image for the post!',
                                  style: TextStyle(fontSize: 12),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                backgroundColor: Colors.white,
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(ctx).pop();
                                    },
                                    child: Text('OK'),
                                  )
                                ],
                              );
                            });
                      },
                      child: Text('See demo'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
