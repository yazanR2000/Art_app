import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../widgets/favorite_artist.dart';
import '../widgets/popular_arts.dart';
import '../widgets/best_artist_and_art_types.dart';
import '../widgets/arts_of_selected_type.dart';
import '../widgets/show_all_arts.dart';
import 'package:provider/provider.dart';
import '../providers/server/posts.dart';
import 'package:provider/provider.dart';
import '../providers/navigator_tab.dart';
import '../providers/state_management/is_post_center.dart';
import 'dart:math';
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final userId = FirebaseAuth.instance.currentUser.uid;
  ScrollController _scrollController;
  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if(_scrollController.position.atEdge){
        if(_scrollController.position.pixels != 0){
          Future.delayed(Duration(seconds: 0)).then((value){
            final length = Provider.of<Posts>(context,listen: false).posts.length;
            if((length / 10).ceil() ==  (length / 10)){

            }
          });
        }
      }
      //print(_scrollController.position.userScrollDirection);
      if(_scrollController.position.userScrollDirection == ScrollDirection.reverse){
        Future.delayed(Duration(seconds: 0)).then((value){
          Provider.of<Nav>(context,listen: false).changeScroll('bottom');
        });
      }else if(_scrollController.position.userScrollDirection == ScrollDirection.forward) {
        Future.delayed(Duration(seconds: 0)).then((value){
          Provider.of<Nav>(context,listen: false).changeScroll('top');
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => Provider.of<Posts>(context, listen: false).refresh(),
      child: LayoutBuilder(
        builder: (ctx, constraints) => CustomScrollView(
          controller: _scrollController,
          slivers: [
            FavoriteArtist(constraints),
            PopularArts(constraints),
            BestArtistAndArtTypes(constraints),
            ShowAllArts(),
            ArtsOfSelectedType(constraints)
          ],
        ),
      ),
    );
  }
}
