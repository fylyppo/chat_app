import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Auth with ChangeNotifier{
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  
  var isLogin = true;

  var _userEmail = '';

  var _userName = '';

  var _userPassword = '';

  File? _userImageFile;

  GlobalKey<FormState> get formkey{
    return _formKey;
  }

  bool get isLoading{
    return _isLoading;
  }
  
  set userEmail(val){
    _userEmail = val;
  }

  set userName(val){
    _userName = val;
  }

  set userPassword(val){
    _userPassword = val;
  }

  void pickedImage(File file) {
    _userImageFile = file;
  }
  
  TextEditingController get pass{
    return _pass;
  }

  TextEditingController get confirmPass{
    return _confirmPass;
  }

  void trySubmit(BuildContext context) {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (_userImageFile == null && !isLogin) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Pick a profile image.')));
          notifyListeners();
      return;
    }
    if (isValid) {
      _formKey.currentState!.save();
      _submitAuthForm(context);
      notifyListeners();
    }
  }

  Future<void> _submitAuthForm(BuildContext context) async {
    final _auth = FirebaseAuth.instance;
    UserCredential _userCredential;

    try {
        _isLoading = true;
      if (isLogin) {
        _userCredential = await _auth.signInWithEmailAndPassword(
            email: _userEmail, password: _userPassword);
      } else {
        _userCredential = await _auth.createUserWithEmailAndPassword(
            email: _userEmail, password: _userPassword);
        User? user = _userCredential.user;
        user!.updateDisplayName(_userName);
        final ref = FirebaseStorage.instance
            .ref()
            .child(_userCredential.user!.uid)
            .child('avatar');
        await ref.putFile(_userImageFile!);
        final _avatarUrl = await ref.getDownloadURL();
        user.updatePhotoURL(_avatarUrl);

        FirebaseFirestore.instance
            .collection('users')
            .doc(_userCredential.user!.uid)
            .set({
          'username': _userName,
          'email': _userEmail,
        });
      }
      notifyListeners();
    } on PlatformException catch (e) {
      var message = 'An error occurred, please check your credentials!';
      if (e.message != null) {
        message = e.message!;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
        _isLoading = false;
        notifyListeners();
    } catch (e) {
        _isLoading = false;
        notifyListeners();
    }
  }
}