import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './home_screen.dart';
import '../screens/add_post.dart';
import './add_post.dart';
import 'package:provider/provider.dart';
import '../providers/server/posts.dart';
import './profile_screen.dart';
import './loved_items.dart';
import '../providers/navigator_tab.dart';

class NavigatorScreen extends StatefulWidget {
  static const routeName = 'NavigatorScreen';
  @override
  _NavigatorScreenState createState() => _NavigatorScreenState();
}

class _NavigatorScreenState extends State<NavigatorScreen> {
  int _selectedIndex = 0;
  List<Widget> _navScreens = <Widget>[
    HomeScreen(),
    LovedItems(),
    Center(
      child: Text('Notification Screen'),
    ),
    Center(
      child: Text('Profile Screen'),
    ),
  ];

  void _changeScreen(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
        resizeToAvoidBottomInset: false,
          backgroundColor: Colors.grey.shade200,
          body: Stack(
            children: [
              Container(
                //height: constraints.maxHeight,
                child: _navScreens.elementAt(_selectedIndex),
              ),
              Consumer<Nav>(
                builder: (ctx, nav, _) {
                  return Positioned(
                    bottom: 20,
                    left: 60,
                    right: 60,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 150),
                      padding: EdgeInsets.all(10),
                      height: (!nav.scrolls['top'] && nav.scrolls['bottom'])
                          ? 0
                          : 80,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (!(!nav.scrolls['top'] && nav.scrolls['bottom']))
                            IconButton(
                              onPressed: () => _changeScreen(0),
                              color: _selectedIndex == 0
                                  ? Colors.black
                                  : Colors.grey,
                              icon: Icon(Icons.home),
                            ),
                          if (!(!nav.scrolls['top'] && nav.scrolls['bottom']))
                            IconButton(
                              onPressed: () => _changeScreen(1),
                              color: _selectedIndex == 1
                                  ? Colors.black
                                  : Colors.grey,
                              icon: Icon(Icons.bookmark),
                            ),
                          if (!(!nav.scrolls['top'] && nav.scrolls['bottom']))
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: IconButton(
                                color: Colors.white,
                                onPressed: () => Navigator.of(context)
                                    .pushNamed(AddPostScreen.routeName),
                                //color: _selectedIndex == 2 ? Colors.black : Colors.grey,
                                icon: Icon(Icons.add),
                              ),
                            ),
                          if (!(!nav.scrolls['top'] && nav.scrolls['bottom']))
                            IconButton(
                              onPressed: () => _changeScreen(2),
                              color: _selectedIndex == 2
                                  ? Colors.black
                                  : Colors.grey,
                              icon: Icon(Icons.message),
                            ),
                          if (!(!nav.scrolls['top'] && nav.scrolls['bottom']))
                            IconButton(
                              onPressed: () => Navigator.of(context).pushNamed(
                                ProfileScreen.routeName,
                                arguments:
                                    FirebaseAuth.instance.currentUser.uid,
                              ),
                              color: _selectedIndex == 3
                                  ? Colors.black
                                  : Colors.grey,
                              icon: Icon(Icons.person),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          )
//      body: _navScreens.elementAt(_selectedIndex),
//        bottomNavigationBar: ClipRRect(
//          borderRadius: BorderRadius.only(
//            topLeft: Radius.circular(constraints.maxWidth / 15),
//            topRight: Radius.circular(constraints.maxWidth / 15),
//          ),
//          child: BottomNavigationBar(
//            currentIndex: _selectedIndex,
//            onTap: _changeScreen,
//            elevation: 0,
//            //backgroundColor: Colors.white,
//            unselectedItemColor: Color(0xff2D4059),
//            selectedItemColor: Colors.black,
//            items: [
//              BottomNavigationBarItem(
//                icon: Icon(Icons.widgets_outlined),
//                label: 'Home',
//              ),
//              BottomNavigationBarItem(
//                icon: Icon(Icons.bookmark),
//                label: 'Saved',
//              ),
//              BottomNavigationBarItem(
//                icon: Icon(Icons.add),
//                label: 'Add Post',
//              ),
//              BottomNavigationBarItem(
//                icon: Icon(Icons.messenger),
//                label: 'Notifications',
//              ),
//              BottomNavigationBarItem(
//                icon: Icon(Icons.person),
//                label: 'Profile',
//              ),
//            ],
//          ),
//        ),
    );
  }
}
