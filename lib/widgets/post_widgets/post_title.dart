import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/state_management/post.dart';
class PostTitle extends StatefulWidget {
  final BoxConstraints _constraints;
  PostTitle(this._constraints);
  @override
  _TitleState createState() => _TitleState();
}

class _TitleState extends State<PostTitle> {

  TextEditingController _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final title = Provider.of<Post>(context,listen: false);
    return Container (
      //height: constraints.maxHeight * 0.07,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.all ( 10 ),
      decoration: BoxDecoration (
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular ( 10 ),
      ),
      child: TextField (
        //maxLength: 25,
        onChanged: (value){
          title.changeTitle(value);
        },
        maxLines: 1,
        decoration: InputDecoration.collapsed (
          hintText: 'Title',
          hintStyle:
          GoogleFonts.getFont (
              'Raleway', color: Colors.grey[500] ),
        ),
        style: TextStyle ( fontSize: widget._constraints.maxWidth / 20 ),
      ),
    );
  }
}
