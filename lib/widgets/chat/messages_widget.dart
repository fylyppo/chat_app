import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'message_bubble_widget.dart';

class MessagesWidget extends StatelessWidget {
  MessagesWidget({Key? key}) : super(key: key);

  final _userId = FirebaseAuth.instance.currentUser!.uid;
  String _avatarLink = '';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .asyncMap((event) async {
        await Future.wait(event.docChanges.map((change) {
          if (change.type == DocumentChangeType.added) {
            final userId = change.doc.data()!['userId'];
            _avatarLink = 'gs://chat-app-c6eac.appspot.com/$userId/avatar';
            return FirebaseImage(_avatarLink).preCache();
          }
          return Future.value(null);
        }));
        return event;
      }),
      builder: (context, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
        if (chatSnapshot.data?.docs == null) {
          return Container();
        }
        final _chatDocs = chatSnapshot.data!.docs;
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
            reverse: true,
            itemCount: _chatDocs.length,
            itemBuilder: (context, index) {
              return MessageBubbleWidget(
                message: _chatDocs[index]['text'],
                isMe: _chatDocs[index]['userId'] == _userId,
                username: _chatDocs[index]['username'],
                avatar:
                    'gs://chat-app-c6eac.appspot.com/${_chatDocs[index]["userId"]}/avatar',
                key: ValueKey(_chatDocs[index].id),
              );
            });
      },
    );
  }
}
