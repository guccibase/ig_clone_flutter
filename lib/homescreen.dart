import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/createPostScreen.dart';
import 'package:flutter_instagram_clone/feed_Screen.dart';
import 'package:flutter_instagram_clone/notificationScreen.dart';
import 'package:flutter_instagram_clone/profileScreen.dart';
import 'package:flutter_instagram_clone/searchScreen.dart';
import 'package:provider/provider.dart';

import 'Models/user_data.dart';

class HomeScreen extends StatefulWidget {


  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _currentTab = 0;
  PageController _pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController();
  }



  @override
  Widget build(BuildContext context) {
    final String currentUserId = Provider.of<UserData>(context).currentUserId;

    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          feedScreen(currentUserId: currentUserId,),
          SearchScreen(),
          CreatePostScreen(),
          NotificationScreen(),
          ProfileScreen(currentUserId: currentUserId, userId: currentUserId),
        ],
        onPageChanged: (int index){
          setState(() {
            _currentTab = index;
          });
        },
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: _currentTab,
        onTap: (int index){
          setState(() {
            _currentTab = index;
          });
          _pageController.animateToPage(
              index,
              duration: Duration(microseconds: 200),
              curve: Curves.easeIn,
          );
        },
        activeColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 32.0,
            ),
          ),

          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              size: 32.0,
            ),
          ),

          BottomNavigationBarItem(
            icon: Icon(
              Icons.camera_alt,
              size: 32.0,
            ),
          ),

          BottomNavigationBarItem(
            icon: Icon(
              Icons.notification_important,
              size: 32.0,
            ),
          ),

          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
              size: 32.0,
            ),
          ),
        ],
        ),
    );
  }
}
