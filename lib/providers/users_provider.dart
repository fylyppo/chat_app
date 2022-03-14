import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Users with ChangeNotifier {
  Future<QuerySnapshot<Map<String, dynamic>>> fetchMatchingUsers(
      String username) {
    return FirebaseFirestore.instance
        .collection("users")
        .where("username", isGreaterThanOrEqualTo: username)
        .where("username", isLessThanOrEqualTo: "$username\uf7ff")
        .get();
  }
}
