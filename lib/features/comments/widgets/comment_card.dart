import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/app_layout.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../models/user.dart';
import '../../../providers/user_provider.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({super.key, this.snap});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppLayout.getHeight(18),
        horizontal: AppLayout.getHeight(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: widget.snap['profilePic'] != null
                ? NetworkImage(widget.snap['profilePic'])
                : AssetImage('assets/images/default_profile.png')
                    as ImageProvider<Object>,
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: AppLayout.getWidth(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: widget.snap['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' ${widget.snap['text']}',
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: AppLayout.getHeight(4),
                    ),
                    child: Text(
                      DateFormat.yMMMd().format(
                        widget.snap['datePublished'].toDate(),
                      ),
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: Icon(
              Icons.favorite,
              size: AppLayout.getWidth(16),
            ),
          )
        ],
      ),
    );
  }
}
