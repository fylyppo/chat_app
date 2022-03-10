import 'package:chat_app/widgets/chat/messages_widget.dart';
import 'package:chat_app/widgets/chat/new_message_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Main Group')),
      body: Column(children: [
        Expanded(child: MessagesWidget()),
        NewMessageWidget(),
      ],
      )
    );
  }
}