import 'package:chat_app/providers/messages_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageBubbleWidget extends StatelessWidget {
  const MessageBubbleWidget(
      {Key? key,
      required this.message,
      required this.isMe,
      required this.username,
      required this.avatar,
      required this.userId,
      required this.chatId,
      required this.messageId})
      : super(key: key);

  final String message;
  final bool isMe;
  final String userId;
  final String username;
  final String avatar;
  final String messageId;
  final String chatId;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            !isMe
                ? Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: CircleAvatar(
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image(
                              image: FirebaseImage(avatar),
                              fit: BoxFit.fill,
                            ))),
                  )
                : Container(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: isMe
                      ? Container()
                      : Text(
                          username,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                ),
                Container(
                  constraints: BoxConstraints(maxWidth: 240),
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: isMe ? Colors.blue : Colors.grey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(message, style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            isMe
                ? Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: CircleAvatar(
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image(
                              image: FirebaseImage(avatar),
                              fit: BoxFit.fill,
                            ))),
                  )
                : Container(),
          ],
        ),
        StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('groups')
                .doc(chatId)
                .snapshots(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> seenSnapshot) {
              if (seenSnapshot == null) {
                return CircularProgressIndicator();
              }
              if (seenSnapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              final _chatDoc = seenSnapshot.data!;
              final _seen = _chatDoc['lastSeenMessage'] as Map;
              final List<String> seenBy = [];
              _seen.forEach((key, value) {
                if (value == messageId) {
                  seenBy.add(key);
                }
              });
              if (!(seenBy.isEmpty ||
                  seenBy.every((element) => element == userId))) {
                return Container(
                  constraints: BoxConstraints(maxHeight: 10),
                  margin: EdgeInsets.all(5),
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: seenBy.length,
                      itemBuilder: (context, index) {
                        if (seenBy[index] == userId) return Container();
                        return CircleAvatar(
                            radius: 7,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image(
                                  image: FirebaseImage(
                                      'gs://chat-app-c6eac.appspot.com/${seenBy[index]}/avatar'),
                                  fit: BoxFit.fill,
                                )));
                      }),
                );
              }
              return Container();
            }),
      ],
    );
  }
}
