import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_instagram_clone/Models/post_model.dart';
import 'package:flutter_instagram_clone/Models/user_model.dart';
import 'package:flutter_instagram_clone/Utilities/constant.dart';

class DatabaseService {
  static void updateUser(User user) {
    usersRef.document(user.id).updateData({
      'name': user.name,
      'profileImageUrl': user.profileImageUrl,
      'bio': user.bio,
    });
  }

  static Future<QuerySnapshot> searchUsers(String name) {
    Future<QuerySnapshot> users =
        usersRef.where('name', isGreaterThanOrEqualTo: name).getDocuments();
    return users;
  }

  static void createPost(Post post) {
    postRef.document(post.authoId).collection('usersPosts').add({
      'imageUrl': post.imageUrl,
      'caption': post.caption,
      'likes': post.likes,
      'authoId': post.authoId,
      'timestamp': post.timestamp,
    });
  }

  static void followUser({String currentUserId, String userId}) {
    // Add user to current user's following collection

    followingRef
        .document(currentUserId)
        .collection('userFollowing')
        .document(userId)
        .setData({});

    // Add currentUser to user's followers collection
    followersRef
        .document(userId)
        .collection('userFollowers')
        .document(currentUserId)
        .setData({});
  }

  static void unFollowUser({String currentUserId, String userId}) {
    // remove user from current user's following collection

    followingRef
        .document(currentUserId)
        .collection('userFollowing')
        .document(userId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    // remove currentUser from user's followers collection
    followersRef
        .document(userId)
        .collection('userFollowers')
        .document(currentUserId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }


  static Future<bool> isFollowingUser({String currentUserId, String userId}) async{
    DocumentSnapshot followingDoc = await followersRef
        .document(userId)
        .collection('userFollowers')
        .document(currentUserId)
        .get();

    return followingDoc.exists;
  }


  static Future<int> numFollowers(String userId) async{
    QuerySnapshot followersSnapshot = await followersRef
        .document(userId)
        .collection('userFollowers')
        .getDocuments();

    return followersSnapshot.documents.length;
  }

  static Future<int> numFollowing(String userId) async{
    QuerySnapshot followingSnapshot = await followingRef
        .document(userId)
        .collection('userFollowing')
        .getDocuments();

    return followingSnapshot.documents.length;
  }



  static Future<List<Post>> getFeedPosts(String userId) async{
    QuerySnapshot feedSnapshot = await feedsRef
        .document(userId)
        .collection('userFeed')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    List<Post> posts = feedSnapshot.documents.map((doc) => Post.fromDoc(doc)).toList();
    return posts;
  }



  static Future<List<Post>> getUserPosts(String userId) async{
    QuerySnapshot userPostsSnapshot = await postRef
        .document(userId)
        .collection('userPost')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    List<Post> posts = userPostsSnapshot.documents.map((doc) => Post.fromDoc(doc)).toList();
    return posts;
  }




  static Future<User> getUserWithId(String userId) async{
    DocumentSnapshot userDocSnapshot = await usersRef.document(userId).get();
    if(userDocSnapshot.exists){
      return User.fromDoc(userDocSnapshot);
    }

    return User();
  }
}
