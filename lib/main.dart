import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/Models/user_data.dart';
import 'package:flutter_instagram_clone/edit_profile.dart';
import 'package:flutter_instagram_clone/feed_Screen.dart';
import 'package:flutter_instagram_clone/homescreen.dart';
import 'package:provider/provider.dart';

import 'edit_profile.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

void main() => runApp(myApp());

class myApp extends StatelessWidget {
  Widget _getScreenId() {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          Provider.of<UserData>(context).currentUserId = snapshot.data.uid;
          return HomeScreen();
        } else {
          return loginScreen();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserData(),
      child: MaterialApp(
        home: myApp()._getScreenId(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryIconTheme: Theme.of(context)
                .primaryIconTheme
                .copyWith(color: Colors.black)),
        routes: {
          loginScreen.id: (context) => loginScreen(),
          signupScreen.id: (context) => signupScreen(),
          feedScreen.id: (context) => feedScreen(),
          EditProfile.id: (context) => EditProfile(),
        },
      ),
    );
  }
}
