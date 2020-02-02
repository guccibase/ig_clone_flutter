import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/Models/user_model.dart';
import 'package:flutter_instagram_clone/profileScreen.dart';
import 'package:flutter_instagram_clone/services/database_service.dart';
import 'package:provider/provider.dart';

import 'Models/user_data.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _textEditingController = TextEditingController();
  Future<QuerySnapshot> _users;

  _buildUserTile(User user){
    return ListTile(
      leading: CircleAvatar(
        radius: 15,
        backgroundImage: user.profileImageUrl.isEmpty ?
        AssetImage('assets/images/image1.jpg')
            : CachedNetworkImageProvider(user.profileImageUrl)
      ),
      title: Text(user.name),
      
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) =>
                  ProfileScreen(
                    currentUserId: Provider.of<UserData>(context).currentUserId,
                    userId: user.id,))
      ),
    );
  }

  _clearSearch(){

    WidgetsBinding.instance.addPostFrameCallback((_) => _textEditingController.clear());

    setState(() {
     _users = null;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TextField(
          controller: _textEditingController,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 20),
            border: InputBorder.none,
            hintText: 'Search',
            prefixIcon: Icon(
              Icons.search,
              size: 30.0,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                Icons.clear,
                size: 20.0,
              ),
              onPressed: () => _clearSearch(),
            ),
            filled: true,
          ),
          onSubmitted: (input) {
            print(input);
            if(input.isNotEmpty) {
              setState(() {
                _users = DatabaseService.searchUsers(input);
              });
            }
          }
        ),
      ),
      body: _users == null ?

      Center(
        child: Text('Search for a user'),
      )
          :

      FutureBuilder(
      future: _users,
        builder: (context, snapshot){
        if(!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        
        if(snapshot.data.documents.length == 0){
          return Center(
            child: Text('No users found! Please try again'),
          // ignore: missing_return, missing_return
          );
        }
        
        return ListView.builder(
            itemCount: snapshot.data.documents.length,
        itemBuilder: (BuildContext context, int index){
              User user = User.fromDoc(snapshot.data.documents[index]);
              return _buildUserTile(user);
        },
        );
        },
    ),);
  }
}
