import 'package:chat_app/providers/messages_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'message_bubble_widget.dart';

class MessagesWidget extends StatelessWidget {
  MessagesWidget({
    Key? key,
    required this.chatId,
  }) : super(key: key);

  final String chatId;
  final _userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Consumer<Messages>(
      builder: (context, messages, _) {
        return StreamBuilder(
          stream: messages.messagesStream(chatId, _userId),
          builder: (context, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
            if (chatSnapshot.data?.docs == null) {
              return Container();
            }
            final _chatDocs = chatSnapshot.data!.docs;
            if (chatSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
                reverse: true,
                itemCount: _chatDocs.length,
                itemBuilder: (context, index) {
                  FirebaseFirestore.instance
                      .collection('groups')
                      .doc(chatId)
                      .set({
                    'lastSeenMessage': {
                      FirebaseAuth.instance.currentUser!.uid: _chatDocs[0].id
                    },
                  }, SetOptions(merge: true));
                  return MessageBubbleWidget(
                    message: _chatDocs[index]['text'],
                    isMe: _chatDocs[index]['userId'] == _userId,
                    userId: _userId,
                    username: _chatDocs[index]['username'],
                    messageId: _chatDocs[index].id,
                    chatId: chatId,
                    avatar: 'gs://chat-app-c6eac.appspot.com/${_chatDocs[index]["userId"]}/avatar',
                    key: ValueKey(_chatDocs[index].id),
                  );
                });
          },
        );
      }
    );
  }
}
