import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String caption;
  final String uid;
  final String username;
  final String postId;
  final String postUrl;
  final datePublished;
  final String? profileImage;
  final likes;

  const Post({
    required this.caption,
    required this.uid,
    required this.username,
    required this.postId,
    required this.postUrl,
    required this.datePublished,
    this.profileImage,
    this.likes,
  });

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      caption: snapshot['caption'],
      uid: snapshot['uid'],
      username: snapshot['username'],
      postId: snapshot['postId'],
      postUrl: snapshot['postUrl'],
      datePublished: snapshot['datePublished'],
      profileImage: snapshot['profileImage'],
      likes: snapshot['likes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'caption': caption,
      'uid': uid,
      'username': username,
      'postId': postId,
      'postUrl': postUrl,
      'datePublished': datePublished,
      'profileImage': profileImage,
      'likes': likes,
    };
  }
}
