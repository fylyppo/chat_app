import 'package:chat_app/providers/members_provider.dart';
import 'package:chat_app/providers/search_provider.dart';
import 'package:chat_app/providers/users_provider.dart';
import 'package:chat_app/screens/auth_page.dart';
import 'package:chat_app/screens/chats_page.dart';
import 'package:chat_app/screens/create_group_page.dart';
import 'package:chat_app/screens/messages_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Users(),
        ),
      ],
      child: MaterialApp(
          title: 'Messages App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          routes: {
            '/mainGroup': (context) => MessagesPage(),
            '/createGroup': (context) => MultiProvider(
                  providers: [
                    ChangeNotifierProvider(
                        create: (context) => Members(context)),
                    ChangeNotifierProvider(create: (context) => Users())
                  ],
                  child: const CreateGroupPage(),
                ),
          },
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, userSnapshot) {
              if (userSnapshot.hasData) {
                return ChangeNotifierProvider(
                  create: (context) => Search(),
                  child: ChatsPage(),
                );
              } else {
                return ChangeNotifierProvider(
                  create: (context) => Auth(),
                  child: const AuthPage(),
                );
              }
            },
          )),
    );
  }
}
