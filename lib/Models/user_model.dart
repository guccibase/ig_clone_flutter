import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  final String id;
  final String name;
  final String email;
  final String bio;
  final String profileImageUrl;


  User({this.id, this.name, this.email, this.bio, this.profileImageUrl});

  factory User.fromDoc(DocumentSnapshot doc){
    return User(
      id: doc.documentID,
      email: doc['email'],
      profileImageUrl: doc['profileImageUrl'],
      name: doc['name'],
      bio: doc['bio'],
    );
  }

}