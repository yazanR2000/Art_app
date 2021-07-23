import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import './profile_screen.dart';
import '../providers/state_management/search_users.dart';

class ArtistSearchScreen extends StatefulWidget {
  static const routeName = 'ArtistSearchScreen';

  @override
  _ArtistSearchScreenState createState() => _ArtistSearchScreenState();
}

class _ArtistSearchScreenState extends State<ArtistSearchScreen> {
  //final _controller = TextEditingController(text: 'Initial text');


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.west_outlined),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.white,
                        border: Border.all(color: Colors.grey[300]),
                      ),
                      child: TextField(
                        //controller: _controller,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: 'Search',
                          hintStyle: GoogleFonts.getFont('Raleway',
                              color: Colors.grey, fontSize: 15.5),
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.search),
                        ),
                        onChanged: (value) {
                          if(value.isNotEmpty)
                            Provider.of<SearchUsers>(context,listen: false).fetchUsers(value);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Consumer<SearchUsers>(
                builder: (ctx, user, _) {
                  if (user.isLoading)
                    return Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  return Expanded(
                    child: ListView.builder(
                      itemCount: user.users.length,
                      itemBuilder: (ctx, index) => Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            Navigator.of(context).pushNamed(
                              ProfileScreen.routeName,
                              arguments: user.users[index]['id'],
                            );
                          },
                          title: Text(user.users[index]['full_name']),
                          leading: CircleAvatar(
                            child: Image.network(
                              user.users[index]['profileImage'],
                              fit: BoxFit.cover,
                            ),
                            radius: 20,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
