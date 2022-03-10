import 'package:chat_app/widgets/search_list_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/search_provider.dart';
import '../widgets/search_bar_widget.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({Key? key}) : super(key: key);

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
                ? const SearchListWidget()
                : SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(
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
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'Main Group',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Recent message',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
          ),
        ],
      ),
    );
  }
}
