import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/features/feeds/services/feed_services.dart';
import 'package:instagram_clone/features/feeds/widgets/like_animations.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/utils/app_constant.dart';
import 'package:instagram_clone/utils/app_layout.dart';
import 'package:instagram_clone/utils/app_styles.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../models/user.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({super.key, this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  FeedService feedServices = FeedService();
  bool isLikeAnimating = false;
  int commentLen = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCommentLen();
  }

  fetchCommentLen() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      commentLen = snap.docs.length;
    } catch (err) {
      Constant.instance.showSnackbar(
        context,
        err.toString(),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      color: Styles.mobileBackgroundColor,
      padding: EdgeInsets.symmetric(
        vertical: AppLayout.getHeight(10),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: AppLayout.getWidth(4),
              horizontal: AppLayout.getHeight(16),
            ).copyWith(
              right: AppLayout.getWidth(0),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: AppLayout.getWidth(16),
                  backgroundImage: widget.snap['profileImage'] != null
                      ? NetworkImage(widget.snap['profileImage'])
                      : AssetImage('assets/images/default_profile.png')
                          as ImageProvider<Object>,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: AppLayout.getWidth(8),
                    ),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.snap['username'],
                            style: TextStyle(color: Colors.white),
                          )
                        ]),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            child: ListView(
                              padding: EdgeInsets.symmetric(
                                vertical: AppLayout.getHeight(16),
                              ),
                              shrinkWrap: true,
                              children: [
                                'Delete',
                              ]
                                  .map((e) => InkWell(
                                        onTap: () async {
                                          if (e == 'Delete') {
                                            await feedServices.deletePost(
                                                widget.snap['postId']);
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            vertical: AppLayout.getHeight(12),
                                            horizontal: AppLayout.getWidth(16),
                                          ),
                                          child: Text(e),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          );
                        });
                  },
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: () async {
              feedServices.likePost(
                widget.snap['postId'],
                user.uid,
                widget.snap['likes'],
              );
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(alignment: Alignment.center, children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                width: double.infinity,
                child: Image.network(
                  widget.snap['postUrl'].toString(),
                  fit: BoxFit.cover,
                ),
              ),
              AnimatedOpacity(
                opacity: isLikeAnimating ? 1 : 0,
                duration: Duration(milliseconds: 200),
                child: LikeAnimation(
                  isAnimating: isLikeAnimating,
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 120,
                  ),
                  duration: Duration(milliseconds: 400),
                  onEnd: () {
                    setState(() {
                      isLikeAnimating = false;
                    });
                  },
                ),
              )
            ]),
          ),
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user.uid),
                smallLike: true,
                child: IconButton(
                  onPressed: () => feedServices.likePost(
                    widget.snap['postId'],
                    user.uid,
                    widget.snap['likes'],
                  ),
                  icon: widget.snap['likes'].contains(user.uid)
                      ? Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : Icon(
                          Icons.favorite_border,
                        ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pushNamed(
                  context,
                  '/comment',
                  arguments: widget.snap,
                ),
                icon: Icon(
                  Icons.comment_outlined,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.send,
                ),
              ),
              Expanded(
                  child: Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  icon: Icon(
                    Icons.bookmark_border,
                  ),
                  onPressed: () {},
                ),
              )),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppLayout.getWidth(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                  child: Text(
                    '${widget.snap['likes'].length} likes',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    top: AppLayout.getHeight(8),
                  ),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: widget.snap['username'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text:
                              '  ${widget.snap['caption'] != null ? widget.snap['caption'] : ''}',
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: AppLayout.getHeight(4)),
                    child: Text(
                      'View all $commentLen comments',
                      style: TextStyle(
                          fontSize: AppLayout.getFontSize(14),
                          color: Styles.secondaryColor),
                    ),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: AppLayout.getHeight(4)),
                  child: Text(
                    DateFormat.yMMMd()
                        .format(DateTime.parse(widget.snap['datePublished'])),
                    style: TextStyle(
                        fontSize: AppLayout.getFontSize(12),
                        color: Styles.secondaryColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
