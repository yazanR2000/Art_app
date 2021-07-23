import 'package:flutter/material.dart';
import '../../widgets/like_button.dart';
import '../../widgets/artist_pic_name.dart';
import '../../widgets/comment_button.dart';
import '../../widgets/save_button.dart';
import 'package:provider/provider.dart';
import '../../providers/state_management/post.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
class DemoPostDialog extends StatefulWidget {
  final BoxConstraints constraints;
  final File image;
  DemoPostDialog(this.constraints,this.image);

  @override
  _DemoPostDialogState createState() => _DemoPostDialogState();
}

class _DemoPostDialogState extends State<DemoPostDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        height: widget.constraints.maxHeight * 0.8,
        child: LayoutBuilder(
          builder: (ctx, cons) =>
              SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: cons.maxHeight * 0.3,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius:
                        BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius:
                        BorderRadius.circular(20),
                        child: Image.file(
                          widget.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceAround,
                      children: [
                        //LikeButton(),
                        Container(
                          width: 1,
                          height:
                          widget.constraints.maxHeight /
                              60,
                          color: Colors.grey,
                        ),
                        CommentButton('dsa',0),
                        Container(
                          width: 1,
                          height:
                          widget.constraints.maxHeight /
                              60,
                          color: Colors.grey,
                        ),
                        //SaveButton()
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Astrology Capricorn',
                      style: TextStyle(
                          fontSize: cons.maxWidth / 20),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    //ArtistPicName(cons),
                    SizedBox(
                      height: cons.maxHeight * 0.05,
                    ),
                    Text(
                      'The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from "de Finibus Bonorum et Malorum" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham',
                      style: GoogleFonts.getFont(
                          'Raleway',
                          color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
        ),
      ),
    );
  }
}
