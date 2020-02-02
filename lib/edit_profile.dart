
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/Models/user_model.dart';
import 'package:flutter_instagram_clone/services/database_service.dart';
import 'package:flutter_instagram_clone/services/storage_services.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  static final String id = 'editProfile';
  final User user;

  EditProfile({this.user});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();

  File _profileImage;
  String _name = '';
  String _bio = '';
  bool _isLoading = false;


  _handleImageFromGallery() async{
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(imageFile != null){
      setState(() {
        _profileImage = imageFile;
      });
    }
  }

  _displayProfileImage(){
    //new image
    if(_profileImage != null){
      return FileImage(_profileImage);
    }else {
      // no new image

      if(widget.user.profileImageUrl.isEmpty){
        //no existing profile image
        return AssetImage('assets/images/image1.jpg');
      }else{
        // existing profile image
        return CachedNetworkImageProvider(widget.user.profileImageUrl);
      }
    }
  }

  _submit() async {
    if (_formKey.currentState.validate() && !_isLoading) {
      _formKey.currentState.save();

      setState(() {
        _isLoading = true;
      });

      //update user data in database
      String _profileImageUrl = '';

      if(_profileImageUrl == null){
        _profileImageUrl = widget.user.profileImageUrl;
      }else{
        _profileImageUrl = await StorageService.uploadUserProfileImage(
            widget.user.profileImageUrl, _profileImage);
      }


      User user = User(
          id: widget.user.id,
          name: _name,
          bio: _bio,
          profileImageUrl: _profileImageUrl);
      //database update
      DatabaseService.updateUser(user);

      Navigator.pop(context);
    }
  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();

    _name = widget.user.name;
    _bio = widget.user.bio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.all(90.0),
          child: Text(
            'Edit Profile',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          children: <Widget>[
            _isLoading ?
                LinearProgressIndicator(
                  backgroundColor: Colors.blue[200],
                  valueColor: AlwaysStoppedAnimation(Colors.blue),
                )
                : SizedBox.shrink(),
           Padding(
            padding: EdgeInsets.all(30),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    radius: 60.0,
                    backgroundImage: _displayProfileImage()
                  ),
                  FlatButton(
                    onPressed: _handleImageFromGallery,
                    child: Text(
                      'Change Profile Image',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    height: 200.0,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            initialValue: _name,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                            decoration: InputDecoration(
                              icon: Icon(
                                Icons.person,
                                size: 30,
                              ),
                              labelText: 'Name',
                            ),
                            validator: (input) => input.trim().length < 1
                                ? 'Please enter a valid name'
                                : null,
                            onSaved: (input) => _name = input,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            initialValue: _bio,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                            decoration: InputDecoration(
                              icon: Icon(
                                Icons.description,
                                size: 30,
                              ),
                              labelText: 'Bio',
                            ),
                            validator: (input) => input.trim().length > 250
                                ? 'Please enter less than 250 characters'
                                : null,
                            onSaved: (input) => _bio = input,
                          ),
                        ],
                      ),
                    ),
                  ),
                  FlatButton(
                    onPressed: _submit,
                    color: Colors.blue,
                    child: Text(
                      'Save Changes',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
      ],
        ),
      ),
    );
  }
}
