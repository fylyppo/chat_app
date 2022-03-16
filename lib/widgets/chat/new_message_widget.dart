import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessageWidget extends StatefulWidget {
  NewMessageWidget({
    Key? key,
    required this.chatId,
  }) : super(key: key);

  final String chatId;

  @override
  State<NewMessageWidget> createState() => _NewMessageWidgetState();
}

class _NewMessageWidgetState extends State<NewMessageWidget> {
  var _message = '';
  final _controller = TextEditingController();

  void _sendMessage() async {
    final _userId = FirebaseAuth.instance.currentUser!.uid;
    final _userName = FirebaseAuth.instance.currentUser!.displayName;
    final _messageData = await FirebaseFirestore.instance
        .collection('messages')
        .doc(widget.chatId)
        .collection('groupMessages')
        .add({
      'text': _message,
      'createdAt': Timestamp.now(),
      'userId': _userId,
      'username': _userName,
    });
    await FirebaseFirestore.instance.collection('groups').doc(widget.chatId).update({
      'recentMessage': {'id': _messageData.id, 'text': _message, 'username': _userName},
      'modifiedAt': Timestamp.now()
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(color: Colors.blue[400]),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              cursorColor: Colors.white,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  labelText: 'Enter a message',
                  labelStyle: TextStyle(color: Colors.white)),
              onChanged: (value) {
                setState(() {
                  _message = value;
                });
              },
            ),
          ),
          IconButton(
              onPressed: _message.trim().isEmpty ? null : _sendMessage,
              color: Colors.white,
              icon: Icon(
                Icons.send,
              ))
        ],
      ),
    );
  }
}
