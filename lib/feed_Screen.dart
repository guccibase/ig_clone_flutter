import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/profileScreen.dart';
import 'package:flutter_instagram_clone/services/auth_services.dart';
import 'package:flutter_instagram_clone/services/database_service.dart';

import 'Models/post_model.dart';
import 'Models/user_model.dart';

class feedScreen extends StatefulWidget {
  static final String id = "feedScreen";
  final String currentUserId;

  feedScreen({this.currentUserId});

  @override
  _feedScreenState createState() => _feedScreenState();
}

class _feedScreenState extends State<feedScreen> {
  List<Post> _posts = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _setupFeed();
  }

  _setupFeed() async {
    List<Post> posts = await DatabaseService.getFeedPosts(widget.currentUserId);

    setState(() {
      _posts = posts;
    });
  }

  _buildPost(Post post, User author){
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(
            builder: (_) => ProfileScreen(
              currentUserId: widget.currentUserId,
              userId: post.authoId,
            ),
          ),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 25.0,
                  backgroundColor: Colors.grey,
                  backgroundImage: author.profileImageUrl.isEmpty ?
                  AssetImage('assets/images/image1.jpg') :
                      CachedNetworkImageProvider(author.profileImageUrl)
                ),
                SizedBox(width: 8.0,),
                Text(
                  author.name,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600
                  ),
                )
              ],
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(post.imageUrl),
               fit: BoxFit.cover,
            )
          ),
        ),
        Padding(
          padding:  EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.favorite_border
                    ),
                    iconSize: 30.0,
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.comment
                    ),
                    iconSize: 30.0,
                    onPressed: ()  {},
                  )
                ],
              ),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  '0 claps',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0
                  ),
                ),
              ),
              SizedBox(height: 4.0,),
              Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                      left: 12.0,
                      right: 6.0
                    ),
                    child: Text(
                      author.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      post.caption,
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
              SizedBox(height: 12.0,)
            ],
          ),
        )
      ],
    );
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Icon(
                    Icons.camera_alt,
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    child: Text(
                  'Instagram',
                  style: TextStyle(
                    fontSize: 34,
                    fontFamily: 'Billabong',
                    color: Colors.black,
                  ),
                ))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  child: Icon(
                    Icons.send,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: _posts.length > 0 ? RefreshIndicator(
        onRefresh: () => _setupFeed(),
        child: ListView.builder(
            itemCount: _posts.length,
            itemBuilder: (BuildContext context, int index){
              Post post = _posts[index];
              return FutureBuilder(
                future: DatabaseService.getUserWithId(post.authoId),
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  if(!snapshot.hasData){
                    return SizedBox.shrink();
                  }
                  User author = snapshot.data;
                  return _buildPost(post, author);
                },
              );
            }
        ),
      ) :
      Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
