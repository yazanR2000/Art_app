import 'package:artwork_app/widgets/profile_widgets/recent_work.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/profile_widgets/profile_app_bar.dart';
import '../widgets/profile_widgets/gallery.dart';
import 'package:provider/provider.dart';
import '../providers/server/profile_data.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = 'ProfileScreen';

  

  @override
  Widget build(BuildContext context) {
    var userId = ModalRoute.of(context).settings.arguments as String;
    final profileData = Provider.of<ProfileData>(context, listen: false);
    return LayoutBuilder(
      builder: (ctx, constraints) => Scaffold(
        backgroundColor: Colors.white,
        body: FutureBuilder(
            future: profileData.profileData(userId),
            builder: (ctx, snapShot) {
              if (snapShot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.blue,
                  ),
                );
              }
              return CustomScrollView(
                slivers: [
                  ProfileAppBar(constraints,profileData.data,userId),
                  Gallery(constraints,userId,profileData.data['full_name'].toString().split(' ')[0]),
                  SliverToBoxAdapter(
                    child: Divider(),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.only(
                      left: constraints.maxWidth / 15,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          TextButton(
                            style: TextButton.styleFrom(
                              primary: Colors.black,
                            ),
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Recent work'),
                                Icon(Icons.keyboard_arrow_right),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ), //Recent Work
                  RecentWork(constraints,userId),
                ],
              );
            }),
      ),
    );
  }
}
