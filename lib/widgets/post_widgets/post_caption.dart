import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/state_management/post.dart';
import 'package:google_fonts/google_fonts.dart';
class PostCaption extends StatefulWidget {
  final BoxConstraints _constraints;
  PostCaption(this._constraints);
  @override
  _PostCaptionState createState() => _PostCaptionState();
}

class _PostCaptionState extends State<PostCaption> {
  @override
  Widget build(BuildContext context) {
    final caption = Provider.of<Post>(context,listen: false);
    return Container (
      height: widget._constraints.maxHeight * 0.3,
      padding: EdgeInsets.all ( 10 ),
      decoration: BoxDecoration (
          borderRadius: BorderRadius.circular ( 10 ),
          color: Colors.grey.shade50 ),
      child: TextField (
        onChanged: (value) => caption.changeCaption(value),
        maxLines: 8,
        decoration: InputDecoration.collapsed (
          hintText: 'Enter your text here',
          hintStyle:
          GoogleFonts.getFont (
              'Raleway', color: Colors.grey[500] ),
        ),
        style:
        GoogleFonts.getFont (
            'Raleway', color: Colors.grey[500] ),
      ),
    );
  }
}
