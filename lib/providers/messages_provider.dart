import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';

class Messages with ChangeNotifier {
  Stream<QuerySnapshot<Map<String, dynamic>>> messagesStream(
      String chatId, String userId) {
    return FirebaseFirestore.instance
        .collection('messages')
        .doc(chatId)
        .collection('groupMessages')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .asyncMap((event) async {
      await Future.wait(event.docChanges.map((change) {
        if (change.type == DocumentChangeType.added) {
          final userId = change.doc.data()!['userId'];
          final String _avatarLink =
              'gs://chat-app-c6eac.appspot.com/$userId/avatar';
          return FirebaseImage(_avatarLink).preCache();
        }
        return Future.value(null);
      }));
      return event;
    });
  }
}
