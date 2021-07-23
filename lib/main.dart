import 'package:artwork_app/providers/oauth/google.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import './screens/navigator_screen.dart';
import './screens/home_screen.dart';
import './screens/profile_screen.dart';
import './screens/art_info.dart';
import './screens/artist_search_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './screens/auth_screen.dart';
import 'package:provider/provider.dart';
import './providers/oauth/facebook.dart';
import './providers/server/profile_data.dart';
import './screens/add_post.dart';
import './providers/state_management/post.dart';
import './providers/server/posts.dart';
import './screens/loved_items.dart';
import './providers/server/saved_items.dart';
import './providers/navigator_tab.dart';
import './providers/state_management/is_post_center.dart';
import './providers/server/post_comments.dart';
import './screens/comments_screen.dart';
import './providers/state_management/search_users.dart';
import './providers/state_management/post_like.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: FacebookOAuth(),),
        ChangeNotifierProvider.value(value: GoogleOAuth(),),
        ChangeNotifierProvider.value(value: ProfileData(),),
        ChangeNotifierProvider.value(value: Post(),),
        ChangeNotifierProvider.value(value: Posts(),),
        ChangeNotifierProvider.value(value: SavedItems(),),
        ChangeNotifierProvider.value(value: Nav(),),
        ChangeNotifierProvider.value(value: PostCenter(),),
        ChangeNotifierProvider.value(value: PostComments(),),
        ChangeNotifierProvider.value(value: SearchUsers(),),
        ChangeNotifierProvider.value(value: PostLike(),),
        ],
      child: MaterialApp(

        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          //primaryColor: Color.fromRGBO(255, 192, 116,0),
          primaryColor: Colors.white,
          accentColor: Color(0xff125D98),
          fontFamily: 'Raleway',
          buttonTheme: ButtonThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (userSnapshot.hasData) {
              return NavigatorScreen();
            }
            return AuthScreen();
          },
        ),
        routes: {
          'HomeScreen': (ctx) => HomeScreen(),
          'ProfileScreen': (ctx) => ProfileScreen(),
          'ArtInfo': (ctx) => ArtInfo(),
          'ArtistSearchScreen': (ctx) => ArtistSearchScreen(),
          'AuthScreen': (ctx) => AuthScreen(),
          'AddPostScreen' : (ctx) => AddPostScreen(),
          'LovedItems' : (ctx) => LovedItems(),
          'CommentsScreen' : (ctx) => CommentsScreen(),
          'NavigatorScreen' : (ctx) => NavigatorScreen()
        },
      ),
    );
  }
}
