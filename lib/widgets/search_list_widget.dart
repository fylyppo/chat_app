import 'package:chat_app/providers/search_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/users_provider.dart';

class SearchListWidget extends StatelessWidget {
  const SearchListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final usersProvider = Provider.of<Users>(context);
    return FutureBuilder(
        future: usersProvider.fetchMatchingUsers(Provider.of<Search>(context, listen: false).searchedText),
        builder: (context, AsyncSnapshot<QuerySnapshot> users) {
          if(users.connectionState == ConnectionState.waiting) {
            return const SliverAppBar(
              automaticallyImplyLeading: false,
              title: Center(child: CircularProgressIndicator(color: Colors.white,)));
          }
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Container(
                  height: 75,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey[200],
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.transparent,
                          child: ClipRRect(
                            borderRadius:BorderRadius.circular(50),
                            child: Image(image: FirebaseImage('gs://chat-app-c6eac.appspot.com/${users.data!.docs[index].id}/avatar'),fit: BoxFit.fill,)),
                        ),
                      ),
                      Text(
                        users.data!.docs[index]['username'],
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                );
              },
              childCount: users.data!.size,
            ),
          );
        });
  }
}
