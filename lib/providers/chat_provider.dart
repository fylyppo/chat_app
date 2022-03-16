import 'package:flutter/cupertino.dart';

class Chat with ChangeNotifier{
  Chat({required this.chatId, required this.groupName});
  
  String chatId;
  String groupName;
}