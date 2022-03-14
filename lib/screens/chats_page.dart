import 'package:chat_app/providers/users_provider.dart';
import 'package:chat_app/widgets/search_list_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../providers/search_provider.dart';
import '../widgets/search_bar_widget.dart';

class ChatsPage extends StatelessWidget {
  ChatsPage({Key? key}) : super(key: key);

  final _userId = FirebaseAuth.instance.currentUser!.uid;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Messages App'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/createGroup');
              },
              tooltip: 'New group',
              icon: const Icon(Icons.group_add_outlined))
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              TextButton.icon(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'))
            ],
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          const SearchBarWidget(),
          Consumer<Search>(
              builder: (context, _search, _) => _search.searchedText != ''
                  ? ChangeNotifierProvider(
                      create: (context) => Users(),
                      child: SearchListWidget(),
                    )
                  : StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('groups')
                          .where(('members'),
                              arrayContains: _userId)
                          .orderBy('modifiedAt', descending: true)
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot> chatsSnapshot) {
                        if (chatsSnapshot.data?.docs == null) {
                          return const SliverAppBar(
                              automaticallyImplyLeading: false,
                              title: Center(
                                  child: CircularProgressIndicator(
                                color: Colors.white,
                              )));
                        }
                        final _chatDocs = chatsSnapshot.data!.docs;
                        if (chatsSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SliverAppBar(
                              automaticallyImplyLeading: false,
                              title: Center(
                                  child: CircularProgressIndicator(
                                color: Colors.white,
                              )));
                        }
                        if (_chatDocs.isEmpty){
                          return const SliverAppBar(
                              automaticallyImplyLeading: false,
                              backgroundColor: Colors.white,
                              title: Center(
                                  child: Text('No messages yet.', style: TextStyle(color: Colors.black),)));
                        }
                        return SliverList(
                          delegate:
                              SliverChildBuilderDelegate((context, index) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context, '/mainGroup');
                                },
                                child: Container(
                                  height: 75,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.grey[200],
                                  ),
                                  child: Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: CircleAvatar(
                                          radius: 25,
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _chatDocs[index]['groupName'],
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              _chatDocs[index]['recentMessage']
                                                      ['username'] +
                                                  ': ' +
                                                  _chatDocs[index]
                                                      ['recentMessage']['text'],
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 15.0),
                                        child: Text(
                                            timeago.format(DateTime
                                                .fromMicrosecondsSinceEpoch(
                                                    _chatDocs[index]
                                                            ['modifiedAt']
                                                        .microsecondsSinceEpoch)),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }, childCount: _chatDocs.length),
                        );
                      },
                    )),
        ],
      ),
    );
  }
}
