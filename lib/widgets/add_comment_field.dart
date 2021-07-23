import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../providers/server/post_comments.dart';

class AddCommentField extends StatefulWidget {

  final String _postId;

  AddCommentField(this._postId);

  static GlobalKey _formKey = GlobalKey<FormState>();

  @override
  _AddCommentFieldState createState() => _AddCommentFieldState();
}

class _AddCommentFieldState extends State<AddCommentField> {
  bool _isEmpty = true;
  String _text = '';
  //TextEditingController _controller;


  final userId = FirebaseAuth.instance.currentUser.uid;
  static final _formKey = GlobalKey<FormState>();

//  @override
//  void initState() {
//    _controller = TextEditingController();
//    super.initState();
//  }
//
//  @override
//  void dispose() {
//    _controller.dispose();
//    super.dispose();
//  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Container(
            constraints: BoxConstraints(
              //maxHeight: widget._constraints.maxHeight * 0.2,
            ),
            //height: height,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(100),
              color: Colors.white,
              border: Border.all(color: Colors.grey[300]),
            ),
            child: Form(
              key: _formKey,
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                //controller: _controller,
                //expands: true,
                maxLines: null,
                minLines: null,
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintText: 'Add comment',
                  hintStyle: GoogleFonts.getFont(
                    'Raleway',
                    color: Colors.grey,
                    fontSize: 15.5,
                  ),
                ),
                onChanged: (value) {
                  //print(value.contains(new RegExp(r'[aA-zZ]')));
                  setState(() {
                    if (!value.contains(new RegExp(r'[aA-zZ]'))) {
                      _isEmpty = true;
                    } else if (value.isEmpty) {
                      _isEmpty = true;
                    } else {
                      _isEmpty = false;
                    }
                    _text = value;
                  });
                },
                style: GoogleFonts.getFont(
                  'Raleway',
                  color: Colors.black,
                  fontSize: 15.5,
                ),
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: _isEmpty
              ? null
              : () async {
                  FocusScope.of(context).unfocus();
                  await Provider.of<PostComments>(context, listen: false)
                      .addComment(
                    widget._postId,
                    _text,
                    userId,
                  );
                },
          icon: Icon(Icons.send),
          color: _isEmpty ? Colors.grey : Colors.blue,
        )
      ],
    );
  }
}
