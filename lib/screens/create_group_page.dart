import 'package:chat_app/providers/members_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/users_provider.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({Key? key}) : super(key: key);

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final _controller = TextEditingController();

  final _nameController = TextEditingController();

  final List<String> _members = [];

  final _userId = FirebaseAuth.instance.currentUser!.uid;
  Future<void> _createGroup() async {
    FirebaseFirestore.instance.collection('groups').add({
      'createdAt': Timestamp.now(),
      'createdBy': _userId,
      'members': Provider.of<Members>(context, listen: false).membersList,
      'modifiedAt': Timestamp.now(),
      'groupName': _nameController.text,
      'recentMessage': {},
      'type': 2,
    });
  }

  AsyncSnapshot<QuerySnapshot> _usersSnapshot = AsyncSnapshot.nothing();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Create a group'),
        actions: [
          IconButton(
            onPressed: () {
              _createGroup();
            },
            icon: Icon(Icons.mark_chat_read_outlined),
            tooltip: 'Create a group',
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.black,
                      Colors.blue,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        offset: Offset(5, 5),
                        blurRadius: 5)
                  ]),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.image,
                        size: 30,
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                        child: TextField(
                      controller: _nameController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        label: Center(
                            child: const Text('Name of the group...')),
                        labelStyle: TextStyle(color: Colors.grey[200]),
                      ),
                    ))
                  ],
                ),
              ),
            ),
          ),
          Consumer<Members>(builder: (context, members, _) {
            if (members.membersList.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.only(left: 15, bottom: 15),
                child: Container(
                  height: 40,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: members.membersList.length,
                      itemBuilder: (context, index) {
                        final isMe =
                            FirebaseAuth.instance.currentUser!.uid ==
                                members.membersList[index]['id'];
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.blue,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Row(
                                children: [
                                  Text(members.membersList[index]
                                      ['username']),
                                  isMe
                                      ? SizedBox(
                                          width: 15,
                                        )
                                      : IconButton(
                                          onPressed: () {
                                            members.removeMember(members
                                                .membersList[index]['id']);
                                          },
                                          icon: Icon(
                                            Icons.cancel,
                                            size: 20,
                                          ))
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              );
            } else {
              return Container();
            }
          }),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[200]),
                child: Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey[200]),
                    child: TextField(
                      controller: _controller,
                      onChanged: (val) {
                        Provider.of<Users>(context, listen: false)
                            .notifyListeners();
                      },
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                          labelStyle: const TextStyle(color: Colors.white),
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.search),
                          hintText:
                              'Add users to your group by username...',
                          hintStyle: TextStyle(color: Colors.grey[700])),
                    ))),
          ),
          const SizedBox(
            height: 15,
          ),
          Expanded(
            child: Consumer<Users>(builder: (context, usersProvider, _) {
              return Builder(builder: (context) {
                final change = _controller.text;
                return FutureBuilder(
                    future: usersProvider.fetchMatchingUsers(change),
                    builder: (context, AsyncSnapshot<QuerySnapshot> users) {
                      _usersSnapshot = users;
                      if (_controller.text == '') {
                        return Container();
                      }
                      if (users.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator(
                          color: Colors.blue,
                        ));
                      }
                      return ListView.builder(
                        itemCount: users.data!.size,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.0),
                            child: Container(
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
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: Image(
                                            image: FirebaseImage(
                                                'gs://chat-app-c6eac.appspot.com/${users.data!.docs[index].id}/avatar'),
                                            fit: BoxFit.fill,
                                          )),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      users.data!.docs[index]['username'],
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  AddUserIcon(
                                    users: _usersSnapshot,
                                    index: index,
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    });
              });
            }),
          ),
        ],
      ),
    );
  }
}

class AddUserIcon extends StatefulWidget {
  AddUserIcon({Key? key, required this.users, required this.index})
      : super(key: key);

  AsyncSnapshot<QuerySnapshot> users;
  int index;

  @override
  State<AddUserIcon> createState() => _AddUserIconState();
}

class _AddUserIconState extends State<AddUserIcon>
    with SingleTickerProviderStateMixin {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    members = Provider.of<Members>(context);
    _user = widget.users.data!.docs[widget.index];
  }

  var members;
  var _user;

  void toggleMembership() {
    if (members.membersList.any((item) => item['id'] == _user.id)) {
      members.removeMember(_user.id);
    } else {
      members.addMember(_user.id, _user['username']);
    }
  }

  Widget build(BuildContext context) {
    final isMe = _user.id == FirebaseAuth.instance.currentUser!.uid;
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: IconButton(
          onPressed: isMe ? null : toggleMembership,
          icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 100),
              transitionBuilder: (Widget child, Animation<double> animation) =>
                  ScaleTransition(child: child, scale: animation),
              child: members.membersList.any((item) => item['id'] == _user.id)
                  ? const Icon(
                      Icons.done,
                      color: Colors.blue,
                      key: ValueKey(1),
                    )
                  : const Icon(
                      Icons.person_add,
                      key: ValueKey(2),
                    )),
        ));
  }
}
