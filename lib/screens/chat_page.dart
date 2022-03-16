import 'package:chat_app/widgets/chat/messages_widget.dart';
import 'package:chat_app/widgets/chat/new_message_widget.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _chat = ModalRoute.of(context)!.settings.arguments as Map;
    
    return Scaffold(
      appBar: AppBar(title: Text(_chat['groupName'])),
      body: Column(children: [
        Expanded(child: MessagesWidget(chat: _chat,)),
        NewMessageWidget(chatId: _chat['chatId'],),
      ],
      )
    );
  }
}