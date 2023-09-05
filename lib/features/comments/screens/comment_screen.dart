import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:instagram_clone/features/comments/services/comment_services.dart';
import 'package:instagram_clone/utils/app_layout.dart';
import 'package:instagram_clone/utils/app_styles.dart';
import 'package:instagram_clone/widgets/loader.dart';
import 'package:instagram_clone/widgets/text_field_input.dart';
import 'package:provider/provider.dart';

import '../../../models/user.dart';
import '../../../providers/user_provider.dart';
import '../widgets/comment_card.dart';

class CommentScreen extends StatefulWidget {
  static const String routeName = '/comment';
  final snap;
  const CommentScreen({super.key, this.snap});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  TextEditingController _commentController = TextEditingController();

  CommentService commentService = CommentService();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Styles.mobileBackgroundColor,
        title: Text('Comments'),
        centerTitle: false,
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          padding: EdgeInsets.only(
            left: AppLayout.getWidth(16),
            right: AppLayout.getWidth(8),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: user.photoUrl != null
                    ? NetworkImage(user.photoUrl!)
                    : AssetImage('assets/images/default_profile.png')
                        as ImageProvider<Object>,
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      left: AppLayout.getWidth(16),
                      right: AppLayout.getWidth(8)),
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Comment as ${user.username}',
                      border: InputBorder.none, // remove underline
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  await commentService.postComment(
                      widget.snap['postId'] as String,
                      _commentController.text,
                      user.uid,
                      user.username,
                      user.photoUrl);

                  setState(() {
                    _commentController.text = '';
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppLayout.getWidth(8),
                    vertical: AppLayout.getHeight(8),
                  ),
                  child: Text(
                    'Post',
                    style: TextStyle(color: Styles.blueColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .doc(widget.snap['postId'])
              .collection('comments')
              .orderBy(
                'datePublished',
                descending: true,
              )
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loader();
            }
            return ListView.builder(
                itemCount: (snapshot.data! as dynamic).docs.length,
                itemBuilder: (context, index) {
                  return CommentCard(
                    snap: (snapshot.data! as dynamic).docs[index].data(),
                  );
                });
          }),
    );
  }
}
