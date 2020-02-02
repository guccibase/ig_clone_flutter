import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/Models/user_data.dart';
import 'package:flutter_instagram_clone/Models/user_model.dart';
import 'package:flutter_instagram_clone/edit_profile.dart';
import 'package:flutter_instagram_clone/services/database_service.dart';
import 'package:provider/provider.dart';

import 'Utilities/constant.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;
  final String currentUserId;

  ProfileScreen({this.currentUserId, this.userId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isFollowing = false;
  int followingCount = 0;
  int followerCount = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setUpIsFollowing();
    _setupFollowing();
    _setupFollowers();

  }

  _setUpIsFollowing()async{
    bool isFollowingUser = await DatabaseService.isFollowingUser(
      currentUserId: widget.currentUserId,
      userId: widget.userId,
    );

    setState(() {
      isFollowing = isFollowingUser;
    });
  }


  _setupFollowers()async{
    int userFollowerCount = await DatabaseService.numFollowers(widget.userId);
    setState(() {
      followerCount = userFollowerCount;
    });
  }


  _setupFollowing()async{
    int userFollowingCount = await DatabaseService.numFollowing(widget.userId);
    setState(() {
      followingCount = userFollowingCount;
    });
  }


  _followOrUnfollow(){
    if(isFollowing){
      _unFollowUser();
    }else{
      _followUser();
    }
  }


  _unFollowUser() {
    DatabaseService.unFollowUser(currentUserId: widget.currentUserId, userId: widget.userId);
    setState(() {
      isFollowing = false;
      followerCount--;
    });
  }


  _followUser() {
    DatabaseService.followUser(currentUserId: widget.currentUserId, userId: widget.userId);
    setState(() {
      isFollowing = true;
      followerCount++;
    });
  }




  _displayButton(User user) {
    return user.id == Provider.of<UserData>(context).currentUserId ?
    Container(
      width: 230.0,
      child: FlatButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EditProfile(user: user),
              ));
        },
        color: Colors.blue,
        textColor: Colors.white,
        child: Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    ) :
    Container(
      width: 230.0,
      child: FlatButton(
        onPressed: () => _followOrUnfollow(),
        color: isFollowing ? Colors.grey : Colors.blue,
        textColor: Colors.white,
        child: Text( isFollowing ?
          'UnFollow'
        :
            'Follow',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );

  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: usersRef.document(widget.userId).get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          User user = User.fromDoc(snapshot.data);

          return ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 50.0,
                      backgroundImage: user.profileImageUrl.isEmpty
                          ? AssetImage('assets/images/image1.jpg')
                          : CachedNetworkImageProvider(user.profileImageUrl),
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text(
                                    '20',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'Posts',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    followerCount.toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'Followers',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    followingCount.toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'Following',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                          _displayButton(user),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        user.name == null ?
                            ''
                        :
                        user.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 80.0,
                        child: Text(
                          user.bio == null ?
                          ''
                          : user.bio,
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(),
              Container(
                height: 5,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: FlatButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.table_chart),
                          label: Text('')),
                    ),
                    Expanded(
                      child: FlatButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.perm_identity),
                          label: Text('')),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
