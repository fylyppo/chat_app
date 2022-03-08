import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessageWidget extends StatefulWidget {
  NewMessageWidget({Key? key}) : super(key: key);

  @override
  State<NewMessageWidget> createState() => _NewMessageWidgetState();
}

class _NewMessageWidgetState extends State<NewMessageWidget> {
  var _message = '';
  final _controller = TextEditingController();
  

  void _sendMessage() async {
    final _userId = FirebaseAuth.instance.currentUser!.uid;
    final _userData = await FirebaseFirestore.instance.collection('users').doc(_userId).get();
    FirebaseFirestore.instance.collection('chat').add({
      'text' : _message,
      'createdAt' : Timestamp.now(),
      'userId' : _userId,
      'username' : _userData['username'],
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
