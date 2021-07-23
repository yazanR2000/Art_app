import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import './artist_pic_name.dart';
import 'package:http/http.dart' as http;
import './video.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BestArtistAndArtTypes extends StatefulWidget {
  final BoxConstraints _constraints;

  BestArtistAndArtTypes(this._constraints);

  @override
  _BestArtistAndArtTypesState createState() => _BestArtistAndArtTypesState();
}

class _BestArtistAndArtTypesState extends State<BestArtistAndArtTypes> {
  final textColor = const TextStyle(color: Colors.black);

  int _selectedType = 0;

  void _changeType(int index) {
    setState(() {
      _selectedType = index;
    });
  }

  var _bestArtist;

  Future _mostPopularArtist() async {
    final response =
        await http.get(Uri.parse('${dotenv.env['IP_ADDRESS']}/popular/artist'));
    print(jsonDecode(response.body));
    _bestArtist = jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(
        left: widget._constraints.maxWidth / 15,
      ),
      sliver: FutureBuilder(
        future: _mostPopularArtist(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SliverToBoxAdapter(
              child: Container(
                height: widget._constraints.maxHeight * 0.2,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }
          return SliverList(
            delegate: SliverChildListDelegate(
              [
                Text(
                  'Best Artist of',
                  style: textColor,
                ),
                Text(
                  'the Week',
                  style: textColor,
                ),
                SizedBox(
                  height: widget._constraints.maxHeight * 0.015,
                ),
                ArtistPicName(
                  widget._constraints,
                  _bestArtist['id'],
                  _bestArtist['profileImage'],
                  _bestArtist['full_name'],
                ),
                SizedBox(
                  height: widget._constraints.maxHeight * 0.015,
                ),
                Container(
                  height: _bestArtist['posts'].length == 0
                      ? 0
                      : widget._constraints.maxHeight * 0.2,
                  child: _bestArtist['posts'].length == 0
                      ? Container()
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _bestArtist['posts'].length,
                          itemBuilder: (ctx, index) {
                            bool isVideo = _bestArtist['posts'][index]
                                    ['postImage']['img']
                                .toString()
                                .contains('.mp4');
                            return Container(
                              width: widget._constraints.maxWidth * 0.4,
                              margin: EdgeInsets.only(right: 10),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: isVideo
                                    ? Video(_bestArtist['posts'][index]
                                            ['postImage']['img']
                                        .toString()
                                        .replaceAll('\\', '/'))
                                    : Image.network(
                                        '${dotenv.env['IP_ADDRESS']}/${_bestArtist['posts'][index]['postImage']['img'].toString().replaceAll('\\', '/')}',
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            );
                          },
                        ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
