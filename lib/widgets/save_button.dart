import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
class SaveButton extends StatefulWidget {
  final String _postId;
  SaveButton(this._postId);
  @override
  _SaveButtonState createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  bool _isSaved = false;

  void _toggleSave() async {
    setState(() {
      _isSaved = !_isSaved;
    });
    await http.patch(Uri.parse('${dotenv.env['IP_ADDRESS']}/save/${widget._postId}'),body: {
      'id' : FirebaseAuth.instance.currentUser.uid,
    });
  }
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(

        //backgroundColor: _isSaved ? Colors.yellow.shade300 :  Colors.yellow.shade100,
        padding: EdgeInsets.symmetric(horizontal: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      child: Icon(
        _isSaved ? Icons.bookmark : Icons.bookmark_border,
        color: Colors.black,
      ),
      onPressed: _toggleSave,
    );
  }
}
