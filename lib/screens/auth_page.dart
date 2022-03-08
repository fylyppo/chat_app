import 'dart:io';

import 'package:chat_app/widgets/pickers/user_image_picker_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  var isLogin = true;

  var _userEmail = '';

  var _userName = '';

  var _userPassword = '';

  File? _userImageFile;

  void _pickedImage(File file) {
    _userImageFile = file;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (_userImageFile == null && !isLogin) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Pick a profile image.')));
      return;
    }
    if (isValid) {
      _formKey.currentState!.save();
      _submitAuthForm();
    }
  }

  bool isLoading = false;

  Future<void> _submitAuthForm() async {
    final _auth = FirebaseAuth.instance;
    UserCredential _userCredential;

    try {
      setState(() {
        isLoading = true;
      });
      if (isLogin) {
        _userCredential = await _auth.signInWithEmailAndPassword(
            email: _userEmail, password: _userPassword);
      } else {
        _userCredential = await _auth.createUserWithEmailAndPassword(
            email: _userEmail, password: _userPassword);

        final ref = FirebaseStorage.instance
            .ref()
            .child(_userCredential.user!.uid)
            .child('avatar');
        await ref.putFile(_userImageFile!);
        final _avatarUrl = await ref.getDownloadURL();

        FirebaseFirestore.instance
            .collection('users')
            .doc(_userCredential.user!.uid)
            .set({
          'username': _userName,
          'email': _userEmail,
        });
      }
    } on PlatformException catch (e) {
      var message = 'An error occurred, please check your credentials!';
      if (e.message != null) {
        message = e.message!;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text('Messages App'),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 40,
                        ),
                        if (!isLogin)
                          UserImagePickerWidget(pickProfileImage: _pickedImage),
                        TextFormField(
                          key: ValueKey('email'),
                          initialValue: '',
                          decoration:
                              InputDecoration(hintText: 'Email address'),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty || !value.contains('@')) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _userEmail = value!;
                          },
                        ),
                        if (!isLogin)
                          TextFormField(
                            key: ValueKey('username'),
                            decoration: InputDecoration(hintText: 'Username'),
                            validator: (value) {
                              if (value!.isEmpty || value.length < 4) {
                                return 'Please enter at least 4 characters';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _userName = value!;
                            },
                          ),
                        TextFormField(
                          controller: _pass,
                          key: ValueKey('password'),
                          decoration: InputDecoration(hintText: 'Password'),
                          obscureText: true,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 7) {
                              return 'Password must be at least 7 characters long.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _userPassword = value!;
                          },
                        ),
                        if (!isLogin)
                          TextFormField(
                            controller: _confirmPass,
                            key: ValueKey('repeatPassword'),
                            decoration:
                                InputDecoration(hintText: 'Repeat password'),
                            obscureText: true,
                            validator: (value) {
                              print(value);
                              print(_userPassword);
                              if (value!.isEmpty) {
                                return 'Password must be at least 7 characters long.';
                              }
                              if (value != _pass.text)
                                return 'Passwords does not match.';
                              return null;
                            },
                          ),
                        isLoading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : TextButton.icon(
                                onPressed: _trySubmit,
                                icon: Icon(Icons.login),
                                label: Text(isLogin ? 'Login' : 'Register')),
                        TextButton(
                            onPressed: () {
                              setState(() {
                                isLogin = !isLogin;
                              });
                            },
                            child: Text(isLogin ? 'Sign Up' : 'Sign In')),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
