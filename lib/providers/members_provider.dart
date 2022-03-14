import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class Members with ChangeNotifier{
  Members(BuildContext context){
    _members.add({'id': FirebaseAuth.instance.currentUser!.uid,
      'username': FirebaseAuth.instance.currentUser!.displayName});
    _membersIds.add(FirebaseAuth.instance.currentUser!.uid);
  }
  
  final List<Map<String, dynamic>> _members = [];
  final List<String> _membersIds = [];
  
  List<Map<String, dynamic>> get membersList { 
    return _members;
  }

  List<String> get membersIdsList { 
    return _membersIds;
  }
  
  void addMember(String id, String username){
    _members.add({
      'id': id,
      'username': username,
    });
    _membersIds.add(id);
    notifyListeners();
  }

  void removeMember(String id){
    _members.removeWhere((element) => element['id'] == id);
    _membersIds.removeWhere((element) => element == id);
    notifyListeners();
  }
}