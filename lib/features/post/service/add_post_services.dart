import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/features/auth/services/auth_services.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/utils/firebase_methods.dart';
import 'package:uuid/uuid.dart';

class AddPostServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMethods firebaseMethods = FirebaseMethods();

  Future<String> uploadPost(
    String caption,
    Uint8List file,
    String uid,
    String username,
    String? profileImage,
  ) async {
    String res = 'Some error occured!';

    try {
      String photoUrl = await firebaseMethods.uploadImage('posts', file, true);

      String postId = const Uuid().v1();

      Post post = Post(
        caption: caption,
        uid: uid,
        username: username,
        postId: postId,
        postUrl: photoUrl,
        datePublished: DateTime.now().toString(),
        profileImage: profileImage,
        likes: [],
      );

      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = 'success';
    } on FirebaseException catch (e) {
      if (e is FirebaseException) {
        switch (e.code) {
          case 'permission-denied':
            res =
                'Permission denied. You do not have access to perform this operation.';
            break;
          case 'not-found':
            res = 'The requested document or resource was not found.';
            break;
          case 'unavailable':
            res =
                'The service is currently unavailable. Please try again later.';
            break;
          default:
            res = 'An error occurred while performing the operation: ${e.code}';
            break;
        }
      } else {
        res = 'An unexpected error occurred: $e';
      }
    }
    return res;
  }
}
