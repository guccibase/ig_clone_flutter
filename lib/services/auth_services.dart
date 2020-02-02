

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_instagram_clone/Models/user_data.dart';
import 'package:flutter_instagram_clone/feed_Screen.dart';
import 'package:flutter_instagram_clone/homescreen.dart';
import 'package:flutter_instagram_clone/login_screen.dart';
import 'package:flutter_instagram_clone/main.dart';
import 'package:provider/provider.dart';

class AuthService{
  static final _auth = FirebaseAuth.instance;
  static final _firestore = Firestore.instance;

  static void signUpUser(
      BuildContext context, String username, String email, String password) async{
    try{
      AuthResult authResult = await _auth.createUserWithEmailAndPassword
      (
          email: email, password: password
      );

      FirebaseUser signedInUser = authResult.user;
      if( signedInUser != null) {
        _firestore.collection('users').document(signedInUser.uid).setData({
          'name': username,
          'email': email,
          'profileImageUrl': '',

        });
        Provider.of<UserData>(context, listen: false).currentUserId = signedInUser.uid;
        Navigator.pushReplacementNamed(context, feedScreen.id);
      }

    }catch(e){
      print(e);
    }
  }


  static void login( String email, String password) async{
    _auth.signInWithEmailAndPassword(email: email, password: password);

  }

  static void logOut(BuildContext context){
    _auth.signOut();
    Navigator.pushReplacementNamed(context, loginScreen.id);
  }



}