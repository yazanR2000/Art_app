import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../providers/server/posts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
class MessageAndFollow extends StatefulWidget {
  final String _userId;

  MessageAndFollow(this._userId);

  @override
  _MessageAndFollowState createState() => _MessageAndFollowState();
}

class _MessageAndFollowState extends State<MessageAndFollow> {
  bool _isLoading = false;
  String _isFollow = '';
  final currentUserId = FirebaseAuth.instance.currentUser.uid;

  Future _checkFollow(String userId) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['IP_ADDRESS']}/check/follow/$currentUserId/$userId'),
    );
    print(response.body);
    _isFollow = response.body.toString();
    print(_isFollow);
  }

  Future _follow(String userId) async {
    final response = await http.patch(
      Uri.parse('${dotenv.env['IP_ADDRESS']}/follow'),
      body: {
        'currentUser' : currentUserId,
        'userId' : userId,
        'follow' : _isFollow,
      }
    );

    setState(() {});
    Provider.of<Posts>(context,listen: false).refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            //primary: Colors.white,
            onPrimary: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: EdgeInsets.symmetric(
              horizontal: 40,
              vertical: 10,
            ),
            elevation: 0,
          ),
          onPressed: () {},
          label: Text('Message'),
          icon: Icon(Icons.messenger_outline),
        ),
        SizedBox(
          width: 25,
        ),
        FutureBuilder(
          future: _checkFollow(widget._userId),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Expanded(
                child: Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            }
            return OutlinedButton(
              style: OutlinedButton.styleFrom(
                primary: Color(0xaaF07B3F),
                //onPrimary: Colors.white,
                side: BorderSide(
                  color: Colors.grey[300],
                  style: BorderStyle.solid,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 13,
                ),
                elevation: 0,
              ),
              onPressed: () => _follow(widget._userId),
              child: Text(_isFollow == 'true' ? 'Following!' : 'Follow'),
            );
          },
        ),
      ],
    );
  }
}
