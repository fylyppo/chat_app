import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class Members with ChangeNotifier{
  Members(BuildContext context){
    _members.add({'id': FirebaseAuth.instance.currentUser!.uid,
      'username': FirebaseAuth.instance.currentUser!.displayName});
  }
  
  final List<Map<String, dynamic>> _members = [];
  
  List<Map<String, dynamic>> get membersList { 
    return _members;
  }
  
  void addMember(String id, String username){
    _members.add({
      'id': id,
      'username': username,
    });
    notifyListeners();
  }

  void removeMember(String id){
    _members.removeWhere((element) => element['id'] == id);
    notifyListeners();
  }
}