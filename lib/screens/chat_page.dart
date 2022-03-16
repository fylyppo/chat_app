import 'package:chat_app/providers/chat_provider.dart';
import 'package:chat_app/widgets/chat/messages_widget.dart';
import 'package:chat_app/widgets/chat/new_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Chat>(
      builder: ((context, _chat, _) => Scaffold(
        appBar: AppBar(title: Text(_chat.groupName)),
        body: Column(children: [
          Expanded(child: MessagesWidget(chatId: _chat.chatId,)),
          NewMessageWidget(chatId: _chat.chatId,),
        ],
        )
      )),
    );
  }
}