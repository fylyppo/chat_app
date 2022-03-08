import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';

class MessageBubbleWidget extends StatelessWidget { 

  const MessageBubbleWidget({ required this.message, required this.isMe, required this.key, required this.username, required this.avatar }) : super(key: key);

  final String message;
  final bool isMe;
  final String username;
  final String avatar;
  final Key key;
  
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        !isMe ? Padding(
          padding: const EdgeInsets.only(left: 5),
          child: CircleAvatar(
            child: ClipRRect(
              borderRadius:BorderRadius.circular(50),
              child: Image(image: FirebaseImage(avatar),fit: BoxFit.fill,))),
        ) : Container(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Padding(padding: EdgeInsets.only(left: 15), child: isMe ? Container() : Text(username, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),) ,
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
        isMe ? Padding(
          padding: const EdgeInsets.only(right: 5.0),
          child: CircleAvatar(
            child: ClipRRect(
              borderRadius:BorderRadius.circular(50),
              child: Image(image: FirebaseImage(avatar),fit: BoxFit.fill,))),
        ) : Container(),
      ],
    );
  }
}